# NCL Issues 系统说明

> 本文件说明 Nova Craft Launcher 仓库的 Issue 标签体系、提交模板与维护流程。
> 维护者新增/修改标签或模板后，请回到这里同步更新。

## 1. 标签体系（唯一事实源：`.github/labels.json`）

GitHub 新建仓库自带的 8 个英文默认标签（`documentation` / `duplicate` / `enhancement` /
`good first issue` / `help wanted` / `invalid` / `question` / `wontfix`）**已全部删除**，
避免与中文类型标签混淆。

当前仓库仅有以下 4 个**类型标签**：

| 标签 | 颜色 | 含义 | 谁能用 |
|---|---|---|---|
| `BUG` | `#d73a4a` 🟥 | 启动器本身的功能异常、崩溃或报错 | 所有用户 |
| `新功能` | `#a2eeef` 🟦 | 全新的模块或机制建议 | 所有用户 |
| `优化` | `#1d76db` 🔵 | 现有功能的交互、性能或 UI 改进 | 所有用户 |
| `任务` | `#5319e7` 🟪 | 开发、文档、CI、发布等内部任务 | **仅维护者** |

## 2. 提交模板（`.github/ISSUE_TEMPLATE/`）

| 模板文件 | 显示名称 | 自动打上的标签 | 面向对象 |
|---|---|---|---|
| `bug_report.md` | 🐞 综合 BUG 反馈 | `BUG` | 所有用户 |
| `feature_request.md` | 💡 新功能建议 | `新功能` | 所有用户 |
| `optimization.md` | ⚡ 体验优化建议 | `优化` | 所有用户 |
| `task.md` | 🧩 维护任务 | `任务` | 仅维护者 |

## 3. 用户如何"申请类型"

`config.yml` 中设置了 `blank_issues_enabled: false`，因此**空白 Issue 入口被关闭**：

1. 用户点击「New issue」后只能看到模板选择页；
2. 用户按性质选择一个模板 = 提交时确认了类型；
3. GitHub 依据模板头部的 `labels:` 字段**自动打上对应类型标签**，无需用户手动选择。

`config.yml` 还会在模板选择页下方展示三条联系渠道（讨论区 / QQ 群 / README），
把"游戏崩溃、Mod 冲突、求助类"流量从 Issue 分流出去。

## 4. 维护者流程（Triage）

1. **确认类型**：若用户通过其他入口建了 Issue 且类型错误，直接改标签（四选一）。
2. **回复与分流**：属实的问题进入排期；功能建议按「差异化优势」评估；优化建议按设计规范取舍。
3. **关联与关闭**：在 PR 描述里写 `Closes #编号`，合并后自动关闭。

## 5. 维护操作

### 同步标签（推荐，幂等）

```powershell
$env:GITHUB_TOKEN = '你的 Token'          # 需 repo 权限
pwsh ./.github/scripts/sync-labels.ps1 -DryRun              # 先预览
pwsh ./.github/scripts/sync-labels.ps1                     # 执行同步
pwsh ./.github/scripts/sync-labels.ps1 -RemoveDefaultLabels # 一并清理默认标签（如再次出现）
```

脚本会自动校验"模板引用的标签是否都已在 labels.json 中定义"——因为 GitHub 会**静默忽略**
引用了不存在标签的模板，这是最隐蔽的配置错误。

### 新增一个类型标签

1. 在 `.github/labels.json` 追加一条（`name` / `color` / `description`）；
2. 新建对应模板，并在头部写 `labels: '标签名'`（必须与 `name` **完全一致**）；
3. 跑一次 `sync-labels.ps1`；
4. 更新本文件的表格。

### 可选辅助标签（按需在 labels.json 追加）

若后续需要更细的流程管理，可再追加（当前不启用，避免过早复杂化）：
`待确认` / `无法复现` / `需要日志` / `重复` / `不予实现`。
