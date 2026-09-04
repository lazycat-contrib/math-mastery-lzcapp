#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
source_dir="$repo_root/upstream"
build_dir="$repo_root/dist/web"

case "$build_dir" in
  "$repo_root/dist/web") ;;
  *)
    echo "Refusing to clean unexpected build directory: $build_dir" >&2
    exit 1
    ;;
esac

git -C "$repo_root" submodule sync -- upstream
git -C "$repo_root" submodule update --init --recursive -- upstream

expected_commit=$(git -C "$repo_root" ls-files --stage -- upstream | awk '$1 == "160000" { print $2 }')
actual_commit=$(git -C "$source_dir" rev-parse HEAD)
if [ -z "$expected_commit" ] || [ "$actual_commit" != "$expected_commit" ]; then
  echo "Upstream submodule is not at the pinned commit" >&2
  exit 1
fi

for source_file in index.html styles.css js/data.js js/animations.js js/figures.js js/qgen.js js/qgen_junior.js js/qgen_high.js js/related-projects.js js/app.js; do
  if [ ! -f "$source_dir/$source_file" ]; then
    echo "Missing required upstream source file: $source_file" >&2
    exit 1
  fi
done

rm -rf -- "$build_dir"
mkdir -p "$build_dir/js" "$repo_root/.lazycat-build"
cp "$source_dir/index.html" "$source_dir/styles.css" "$build_dir/"
cp "$source_dir/js/data.js" "$source_dir/js/animations.js" "$source_dir/js/figures.js" "$build_dir/js/"
cp "$source_dir/js/qgen.js" "$source_dir/js/qgen_junior.js" "$source_dir/js/qgen_high.js" "$build_dir/js/"
cp "$source_dir/js/related-projects.js" "$source_dir/js/app.js" "$build_dir/js/"
cp "$repo_root/icon.png" "$build_dir/favicon.ico"

echo "Static application built from upstream $actual_commit at $build_dir"
