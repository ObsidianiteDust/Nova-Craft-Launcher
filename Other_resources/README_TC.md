# Nova Craft Launcher (NCL)

<img src="./NCL-ICO.png" alt="Logo" align="right" width="200">

**新世代 Minecraft 啟動器與執行環境管理器**

[🇨🇳 简体中文](../README.md) | [🇬🇧 English](README_EN.md) | **🇭🇰 繁體中文**

[![License](https://img.shields.io/github/license/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square&color=blue)](../LICENSE)
[![Issues](https://img.shields.io/github/issues/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher/issues)
[![Commit Activity](https://img.shields.io/github/commit-activity/w/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square&color=green)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher)  
[![PRs](https://img.shields.io/github/issues-pr/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher)
[![Forks](https://img.shields.io/github/forks/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher)
[![Contributors](https://img.shields.io/github/contributors/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher/graphs/contributors)  
[![Release](https://img.shields.io/github/v/release/ZhangXaohan-awa/Nova-Craft-Launcher?style=flat-square)](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher/releases)

 ## ⚠️ 當前狀態 (Status)

> 專案處於 **前期強初始化開發階段 (Pre-development)**。
>
> - ❌ 暫無任何可編譯 / 可執行的程式碼
> - ❌ 暫無 Release 版本與 CI 流水線
> - ✅ 正在敲定底層架構與適配器規範
>
> **請勿期待現在就能下載使用。** 歡迎 Watch / Star 關注進展。

## 📖 專案定位 (Overview)

NCL 並非又一個修補外殼的 Minecraft 啟動器，而是**從零構建的模組化、高效能執行環境管理與內容調度平台**。我們致力於解決當前生態中普遍存在的效能瓶頸、檔案管理混亂與安全性缺失問題。

## 🏗️ 技術架構 (Architecture)

拒絕單體巨無霸，採用 **.NET + Go** 混合架構實現效能與安全的雙贏：

- **表現層 (C# / Avalonia)**：負責跨平台 UI 渲染，採用 MVVM 與編譯時綁定，保證複雜資料下的介面流暢。
- **核心引擎 (Go)**：作為獨立守護進程，專職處理高併發下載、底層檔案 I/O、雜湊校驗與本地索引。
- **IPC 通訊**：UI 與引擎透過本地 Socket 通訊，實現**崩潰隔離**（引擎異常不導致軟體閃退），並支援未來使用任意語言的插件透過 JSON-RPC 接入。

## ✨ 架構目標 (Goals)

*(註：以下為底層設計目標，具體實現將在開發中持續驗證)*

- **效能調度**：計畫採用 DAG 啟動流水線與分層校驗（時間戳->雜湊），嘗試實現大目錄與多任務的高效併發。
- **無限生態**：設計宣告式適配器（配置驅動），預留 Java/基岩版、客戶端/服務端統一抽象，專項適配光影與藍圖等特殊目錄。
- **安全基線**：強制雜湊校驗、防路徑穿越（Zip Slip），採用事務化安裝與失敗回滾，保障檔案安全。

## 🗺️ 開發路線圖 (Roadmap)

- **#0** — 儲存庫初始化、介面定義與規範確立 *(當前目標)*
- **#1** — 核心框架與 GUI 骨架（Avalonia 外殼、Go 引擎、IPC 通訊）
- **#2** — Java 客戶端 MVP（啟動流水線、下載/校驗內核、Java 管理）
- **#3** — Java 服務端生命週期管理（控制台、RCON、進程守護）
- **#4** — 內容管理系統與全端拓展（整合包、基岩版、插件生態）

### 💬 討論與反饋 (Contact)

歡迎在 [Discussions](https://github.com/ZhangXaohan-awa/Nova-Craft-Launcher/discussions) 參與架構討論，或提交高質量的 Issue。

[![Discord](https://img.shields.io/badge/Discord-加入伺服器-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/EwbaT4uYcw)
[![交流群](https://img.shields.io/badge/交流群-NCL用戶交流群-EA1B25?style=flat-square&logo=tencentqq&logoColor=white)](https://qm.qq.com/q/FKTqjgBKIC)

## 📄 開源協議 (License)

本專案採用 [GPLv3](../LICENSE) 協議（含生態標記補充條款）。詳見 [許可證通俗解釋](LICENSE-EXPLAINED.md)。

---

<p align="center">
  <i>Nova Craft Launcher - 星光指引，探索無限可能</i>
</p>
<p align="center">
  <i>Nova Craft Launcher (NCL) 是一個完全獨立且開源的第三方軟體專案。本專案與 Mojang Studios、Microsoft 及其任何子公司或關聯公司沒有任何關聯、授權、贊助或背書關係。本軟體不包含任何受版權保護的官方遊戲本體檔案。所有在遊戲中使用的相關商標及版權均歸其各自所有者所有。</i>
</p>