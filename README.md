# 中小学数学方法融会贯通 · LazyCat

本仓库是 [math-mastery](https://github.com/kenowong/math-mastery) 的懒猫微服 LPK 包装项目，不直接复制或维护上游源码。

## 源码与构建

上游源码以 `upstream/` Git submodule 的形式锁定到具体 commit。`scripts/build.sh` 会先初始化 submodule，再将运行所需的 HTML、CSS 和 JavaScript 构建到 `dist/web/`。

```bash
git clone --recurse-submodules https://github.com/lazycat-contrib/math-mastery-lzcapp.git
cd math-mastery-lzcapp
./scripts/build.sh
lzc-cli project release -o .lazycat-build/math-mastery.lpk
```

## 上游更新

`.github/workflows/update-upstream.yml` 每日检查上游 `master`，也可手动运行。发现新 commit 时，工作流会：

1. 更新 `upstream/` submodule 指针。
2. 将 `package.yml` 的补丁版本加一。
3. 创建一个待审查的更新 PR。

合并 PR 后，推送与 `package.yml` 版本匹配的 `vX.Y.Z` 标签。发布工作流会从已锁定的 submodule 源码构建版本化 LPK、创建 GitHub Release，并且仅发布到喵喵商店。

## 发布凭据

GitHub 组织或仓库需向本仓库授权以下 Actions Secrets：

- `APPSTORE_URL`
- `APPSTORE_TOKEN`
- `APP_ID`（首次发布创建应用后，将返回的数字 ID 写入此 Secret，用于锁定后续发布目标）
