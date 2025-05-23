# 📱 PlusOne

一个极简的计数器 App，用于记录你每完成一次小任务或行为时的次数。

---

## 📱 环境要求 · Requirements

- iOS 17.0 或更高版本  
- Xcode 14 或更新版本  
- 支持 SwiftUI 的真机或模拟器

---

## ✨ 功能介绍

- 🧮 添加自定义计数项  
- ➕ 每次点击「+」按钮，数字就加一  ➖ 支持减少计数  
- 📝 左滑重命名或删除计数项  
- 📲点击进入详细页
- 🧼 清爽简洁、没有花里胡哨

---

## 🛠 技术栈

- Swift  
- SwiftUI  
- Xcode  

---

## 💡 设计理念

> 我们总是在做一些日复一日的小事，  
> PlusOne 想陪你默默记录每一次坚持的瞬间。

---

## 📦 使用说明

1. 打开 App  
2. 添加一个你想要记录的事件（比如：喝水、做俯卧撑、背单词）  
3. 每完成一次，就点一次「+」  
4. 看着数字慢慢增长，你会越来越有动力！
5. 截图预览
<img src="https://github.com/Neosamzzz/PlusOne/blob/main/images/Snapshot.png?raw=true" width="300"/>

---

## 🧸 项目状态

目前为测试版，功能简洁。  
后续可能会加入历史记录、多主题、数据导出等功能～🎉

---

## 📲 如何安装到自己的 iPhone（无需上架 App Store）

你可以使用 **Xcode** 将这个 App 安装到自己的 iPhone 上，无需开发者付费账号，仅供自己使用或测试。

---

### ✅ 前提条件

- 一台安装了 **Xcode** 的 Mac（推荐最新版本）
- 一个 Apple ID（普通账号即可）
- 一部通过数据线连接的 iPhone

---

### 🚀 安装步骤

#### 1️⃣ 打开项目

- 克隆或下载本项目到本地
- 用 Xcode 打开 `.xcodeproj` 文件

#### 2️⃣ 信任你的设备

- 用数据线连接 iPhone 到 Mac
- iPhone 上选择“信任此设备”
- Mac 上也选择信任（如有提示）

#### 3️⃣ 配置开发账号

- 打开 Xcode → 菜单栏点击 **Xcode → Settings**
- 切换到 **Accounts** 标签页
- 点击左下角 `+` → 选择 **Apple ID**
- 登录你的 Apple ID（非开发者账号也可以）

#### 4️⃣ 配置签名信息（Signing）

- 点击 Xcode 左侧导航栏中的项目名
- 选择 `Targets` → 你的 App 名字 → `Signing & Capabilities`
- 勾选 **Automatically manage signing**
- Team 选择你的 Apple ID 所属的 Team（一般就是你自己）
- 如提示 Bundle Identifier 已被占用，可改为com.yourname.plusone

#### 5️⃣ 选择设备并构建

- 在**手机**中：打开 **设置 → 隐私与安全性 → 开发者模式** 选择打开，然后自动重启手机

- 回到**Xcode** 点击左上角设备栏，选择你的 iPhone（不是模拟器）
- 点击运行 ▶️（或按下 `Cmd + R`）

#### 6️⃣ 信任开发者并打开 App

- 如果 iPhone 提示“未受信任的开发者”
- 打开手机 **设置 → 通用 → 设备管理**
- 找到你的 Apple ID → 点击“信任”

---

### 🍬 小贴士

- 免费账号签名有效期为 **7 天**，过期后可以重新打包安装
- 此方法仅适用于**你自己的设备**
- 无需付费，也无需上架 App Store
- 本项目完全由ChatGPT和Cursor的使用下完成，如有问题可以询问ChatGPT

---

## 📜 License

本项目仅供学习与交流使用，未经许可请勿商用或转载。

---
