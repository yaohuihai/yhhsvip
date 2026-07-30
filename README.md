# 班主任班级管理工作台 · iOS IPA

## 🚀 一键构建（无需 Mac）

本项目已配置 **GitHub Actions**，推送代码即可自动编译生成 IPA！

### 第 1 步：推送到 GitHub

```bash
git init
git add .
git commit -m "班主任工作台 iOS App"
git remote add origin https://github.com/你的用户名/ClassWorkbench.git
git push -u origin main
```

推送后，GitHub Actions 会自动运行，约 5-8 分钟完成。

### 第 2 步：下载 IPA

1. 打开你的 GitHub 仓库页面
2. 点击顶部 **Actions** 标签
3. 找到最新一次运行（绿色 ✅）
4. 点击进入，拉到页面底部 **Artifacts**
5. 下载 **ClassWorkbench-unsigned**

> 也可以手动触发：Actions → Build iOS IPA → Run workflow

---

## 📱 安装到 iPhone（3 种方式）

### 方式一：爱思助手（最简单 ✅）

1. 电脑下载 [爱思助手](https://www.i4.cn/)
2. iPhone 用数据线连接电脑
3. 爱思助手 → 应用游戏 → 导入安装 → 选择 `ClassWorkbench.ipa`
4. 输入你的 Apple ID 和密码（仅用于签名，不上传）
5. 等待安装完成

> ⚠️ 免费 Apple ID 签名有效期 **7 天**，到期需重新安装

### 方式二：AltStore

1. 电脑下载 [AltServer](https://altstore.io/)
2. iPhone 连接电脑，安装 AltStore 到手机
3. 将 IPA 通过 AirDrop/文件传到手机
4. 在 AltStore 中打开 IPA → 输入 Apple ID 签名安装

### 方式三：Sideloadly

1. 下载 [Sideloadly](https://sideloadly.io/)
2. iPhone 连接电脑
3. 拖入 IPA → 输入 Apple ID → Start

---

## 🔄 7 天到期后续签

免费签名每 7 天过期。续签方法：

- **爱思助手**：重新导入 IPA 安装即可
- **AltStore**：连接电脑，AltServer 会自动刷新签名
- 数据不会丢失（localStorage 在 App 沙盒内）

---

## 📁 项目结构

```
ClassWorkbench/
├── .github/workflows/build.yml   # GitHub Actions 自动构建
├── ClassWorkbench/
│   ├── index.html                # 工作台主页面
│   ├── AppDelegate.swift         # App 入口
│   ├── ViewController.swift      # WKWebView 容器
│   ├── Info.plist                # App 配置
│   ├── LaunchScreen.storyboard   # 启动画面
│   └── Assets.xcassets/          # 图标资源
├── project.yml                   # XcodeGen 配置
└── README.md
```

---

## ⚙️ 本地构建（有 Mac 时）

```bash
brew install xcodegen
xcodegen generate
xcodebuild -project ClassWorkbench.xcodeproj \
  -scheme ClassWorkbench \
  -sdk iphoneos \
  -configuration Release \
  -archivePath build/ClassWorkbench.xcarchive \
  CODE_SIGNING_ALLOWED=NO \
  archive
# 然后手动签名导出
```

---

## 🛠 技术栈

- **前端**：纯 HTML/CSS/JS（Chart.js + SheetJS）
- **iOS 容器**：Swift + WKWebView
- **构建工具**：XcodeGen + xcodebuild
- **CI/CD**：GitHub Actions (macOS runner)
- **数据存储**：localStorage（离线可用）
