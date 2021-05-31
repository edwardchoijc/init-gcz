# init-gcz
init git commitlint env



## 初始化流程

1. 安装 **nodejs** + **npm**

2. 安装 commit message 的标准化工具 —— **commitizen**

   ```shell
   npm install -g commitizen
   ```

3. 安装 git tag 标准化工具 —— **standard-version**

   ```shell
   npm install -g standard-version
   ```

4. 把所有文件复制至目标文件夹，包括：`.husky/`，`commitlint.config.js`，`package.json`

5. 初始化 node modules 环境

   ```shell
   npm install  # 安装所有依赖包
   # npm run prepare  # 开启husky
   echo '## npm\n# package.json\npackage-lock.json\nnode_modules/\n# commitlint.config.js' >> .gitignore
   ```

