# Nova Craft Launcher (NCL)

<img src="./Other_resources/NCL-ICO.png" alt="Logo" align="right" width="200">

**下一代 Minecraft 启动器与运行时管理器**

**🇨🇳 简体中文** | [🇬🇧 English](Other_resources/README_EN.md) | [🇭🇰 繁體中文](Other_resources/README_TC.md)

[![License](https://img.shields.io/github/license/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square&color=blue)](LICENSE)
[![Issues](https://img.shields.io/github/issues/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher/issues)
[![Commit Activity](https://img.shields.io/github/commit-activity/w/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square&color=green)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher)  
[![PRs](https://img.shields.io/github/issues-pr/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher)
[![Forks](https://img.shields.io/github/forks/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher)
[![Contributors](https://img.shields.io/github/contributors/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher/graphs/contributors)  
[![Release](https://img.shields.io/github/v/release/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher/releases)

 ## ⚠️ 当前状态 (Status)

> 项目处于 **前期强初始化开发阶段 (Pre-development)**。
>
> - ❌ 暂无任何可编译 / 可运行的代码
> - ❌ 暂无 Release 版本与 CI 流水线
> - ✅ 正在敲定底层架构与适配器规范
>
> **请勿期待现在就能下载使用。** 欢迎 Watch / Star 关注进展。

## 📖 项目定位 (Overview)

NCL 并非又一个修补外壳的 Minecraft 启动器，而是**从零构建的模块化、高性能运行时管理与内容调度平台**。我们致力于解决当前生态中普遍存在的性能瓶颈、文件管理混乱与安全性缺失问题。

## 🏗️ 技术架构 (Architecture)

拒绝单体巨无霸，采用 **纯 C# / .NET + Avalonia** 的模块化分层架构，在同一套技术栈内兼顾性能与安全：

- **表现层 (C# / Avalonia)**：负责跨平台 UI 渲染，采用 MVVM 与编译时绑定，保证复杂数据下的界面流畅。
- **核心引擎 (C# / .NET 类库)**：以独立类库承载下载调度、底层文件 I/O、哈希校验与本地索引，基于 `async/await` 与 `Channel` 构建高并发流水线，可脱离 UI 单独测试。
- **模块边界**：UI 与引擎仅通过抽象接口（依赖注入）通信，保持单向依赖与松耦合，便于后续拆分、替换或扩展。

## ✨ 架构目标 (Goals)

*(注：以下为底层设计目标，具体实现将在开发中持续验证)*

- **性能调度**：计划采用 DAG 启动流水线与分层校验（时间戳->哈希），尝试实现大目录与多任务的高效并发。
- **无限生态**：设计声明式适配器（配置驱动），预留 Java/基岩版、客户端/服务端统一抽象，专项适配光影与蓝图等特殊目录。
- **安全基线**：强制哈希校验、防路径穿越（Zip Slip），采用事务化安装与失败回滚，保障文件安全。

## 🗺️ 开发路线图 (Roadmap)

- **#0** — 仓库初始化、接口定义与规范确立 *(当前目标)*
- **#1** — 核心框架与 GUI 骨架（Avalonia 外壳、C# 引擎内核、模块分层与依赖注入）
- **#2** — Java 客户端 MVP（启动流水线、下载/校验内核、Java 管理）
- **#3** — Java 服务端生命周期管理（控制台、RCON、进程守护）
- **#4** — 内容管理系统与全端拓展（整合包、基岩版、插件生态）

### 💬 讨论与反馈 (Contact)

欢迎在 [Discussions](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher/discussions) 参与架构讨论，或提交高质量的 Issue。

[![Discord](https://img.shields.io/badge/Discord-加入服务器-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/EwbaT4uYcw)
[![交流群](https://img.shields.io/badge/交流群-NCL用户交流群-EA1B25?style=flat-square&logo=tencentqq&logoColor=white)](https://qm.qq.com/q/FKTqjgBKIC)

## 📄 开源协议 (License)

本项目采用 [GPLv3](LICENSE) 协议（含生态标记补充条款）。详见 [许可证通俗解释](Other_resources/LICENSE-EXPLAINED.md)。

--- 

<p align="center">
  <i>Nova Craft Launcher - 星光指引，探索无限可能</i>
</p>
<p align="center">
  <i>Nova Craft Launcher (NCL) 是一个完全独立且开源的第三方软件项目。本项目与 Mojang Studios、Microsoft 及其任何子公司或关联公司没有任何关联、授权、赞助或背书关系。本软件不包含任何受版权保护的官方游戏本体文件。所有在游戏中使用的相关商标及版权均归其各自所有者所有。</i>
</p>