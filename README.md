# init-gcz

init git commitlint env — 基于 Conventional Commits 规范的 commit message 校验与发版环境。

包含：

- **commitlint** + **husky** —— 提交时通过 `commit-msg` 钩子校验 commit message 是否符合规范。
- **commitizen** —— 交互式引导书写规范的 commit message（可选，`npx cz`）。
- **commit-and-tag-version** —— 本地手动发版：自动升版本号、生成 CHANGELOG、打 git tag。

## 一键配置

在需要配置的 git 项目根目录下执行：

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/edwardchoijc/init-gcz/HEAD/install.sh)"
```

脚本会临时 clone 本仓库，把 `package.json`、`commitlint.config.js`、`.husky/` 复制到当前项目，合并 `.gitignore` 条目，安装依赖并启用 husky 钩子，最后自动清理临时目录。

## 日常使用

- 正常 `git commit`，不符合 Conventional Commits 规范的 message 会被 `commit-msg` 钩子拦下。
- 也可用 `npx cz` 交互式书写规范的 commit message。

## 发版

积累若干 `feat:` / `fix:` 等规范提交后，需要发版时执行：

```shell
npm run release
```

它会根据 commit 类型自动升版本号、生成/追加 `CHANGELOG.md` 并打好 git tag，随后推送：

```shell
git push --follow-tags
```
