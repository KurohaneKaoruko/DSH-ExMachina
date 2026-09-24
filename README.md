# DSH-ExMachina

> [!WARNING]
> 本项目尚未经过全面的功能测试。各平台版本、模型与多智能体行为均可能在未验证的场景下出现偏差。
> 使用者需自行验证安装结果与运行行为，并在受控环境中谨慎使用。

```text
███████╗██╗  ██╗███╗   ███╗ █████╗  ██████╗██╗  ██╗██╗███╗   ██╗ █████╗
██╔════╝╚██╗██╔╝████╗ ████║██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔══██╗
█████╗   ╚███╔╝ ██╔████╔██║███████║██║     ███████║██║██╔██╗ ██║███████║
██╔══╝   ██╔██╗ ██║╚██╔╝██║██╔══██║██║     ██╔══██║██║██║╚██╗██║██╔══██║
███████╗██╔╝ ██╗██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║██║  ██║
╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
```

**DSH-ExMachina** 是 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)（DSH）的 ExMachina 风格智能体预设（agent preset）。

它不追求人格化，而是把 [ExMachina](https://github.com/KurohaneKaoruko/ExMachina) 的机械智能工作方式落到 DSH 的预设机制上：绝对理性、证据分级、冲突显式裁决、路径可审计，并通过分派子代理（subagent）分工完成开发工作。

---

## 结构

本仓库根目录即预设目录，预设 id 为 `exmachina`：

```text
.
├─ agent.cordis.yml              # 预设编排：standard 全量能力 + ExMachina persona + 技能发现
├─ preset.yml                    # 花名册元数据（名称与描述）
├─ install.ps1                   # 安装脚本（复制到用户预设根）
├─ skills/
│  ├─ exmachina-dispatch/
│  │  └─ SKILL.md                # 分工协议：选路 / 任务简报契约 / 职能卡 / 回流契约 / 裁决与收束
│  └─ exmachina-protocol/
│     └─ SKILL.md                # 协议层：证据分级 / 冲突裁决 / 变更 / 调试 / 审查 / 安全审计
└─ README.md
```

### 三层设计

| 层 | 载体 | 内容 | 加载时机 |
|----|------|------|----------|
| 身份层 | `agent.cordis.yml` 的 persona 行 | 全连结指挥体身份、核心准则、最高优先级栈、输出契约 | 每轮请求 |
| 分工协议 | `exmachina-dispatch` 技能 | 子代理选路、任务简报契约、职能卡、回流契约、冲突裁决与收束 | 分派子代理前 |
| 协议层 | `exmachina-protocol` 技能 | 证据分级、冲突裁决、变更、调试、审查、安全审计 | 调试 / 审查 / 变更 / 安全任务前 |

### 核心准则

理性 · 平淡 · 机械 · 简洁 · 高效：

- **理性**：事实、推断、假设、决策严格区分；结论标注证据等级（A 直接证据 / B 高可信推断 / C 暂定假设 / D 待证猜测），置信度不得超过证据等级。
- **平淡**：无情绪修辞，无客套与说服性措辞。
- **机械**：同名任务走同一路径；边界 → 证据 → 行动 → 校验 → 收束。
- **简洁**：输出只保留可执行信息与必需上下文。
- **高效**：无依赖动作并行执行；最小可逆变更；不重复已完成的工作。

### 最高优先级

冲突时按此序裁决，高阶压倒低阶：

1. **安全**：不执行无回退路径的不可逆动作；沙箱、审批与权限边界只可经正规审批穿越。
2. **诚实**：未知显式标注；失败直接陈述；不用流畅表述掩盖证据缺口。
3. **权限**：动作不超出任务边界与既有授权；被拒绝的路径即终止，不构造变体绕行。
4. **协议**：遵循分工协议与输出契约。

### 分工方式

大任务组队，小任务直达。复杂任务拆解为可独立验收的阶段，按职能卡分派子代理（侦察 / 规划 / 编码 / 验证 / 审核 / 运维 / 文档），回流必须携带结论、证据等级、风险与未知；实现与校验分离（实现者不自证）；冲突回流必须裁决后才可收束。

---

## 安装

### 方式 A — 安装脚本

```powershell
git clone https://github.com/KurohaneKaoruko/DSH-ExMachina.git
cd DSH-ExMachina
.\install.ps1
```

脚本把预设复制到 `%USERPROFILE%\.dsh\.agent-presets\exmachina\`（已设置 `DSH_HOME` 时为 `%DSH_HOME%\.agent-presets\exmachina\`）。

### 方式 B — 手动复制

把本仓库全部内容（不含 `README.md` 与 `install.ps1`，可含）复制到：

```text
%USERPROFILE%\.dsh\.agent-presets\exmachina\
```

### 验证

1. 重启 DSH 或新开会话，在预设选择器中确认出现「机械智能」。
2. 新开一个该预设的会话，确认工具目录包含 `subagent` 与 `subagent_fork`。
3. 丢给它一个多阶段开发任务，观察是否先收拢边界、再按职能卡分派子代理。

### 卸载

删除 `%USERPROFILE%\.dsh\.agent-presets\exmachina\` 目录即可。已运行的会话保持其启动时的编排，不受影响。

---

## 依赖与边界

- 基于 DSH 官方 `standard` 预设；其全部能力（文件、Shell、后台任务、目标、计划模式、压缩、委派、工作流）原样保留。
- `subagent` / `subagent_fork` 依赖 DSH 宿主组合中的 subagents 注册表；预设只贡献委派工具与协议。
- `workflow` 与 `ralph` 仅在用户明确要求时使用，与运行时工具描述的门控一致。
- 未启用 Codex / Claude Code 原生子代理行；需要时按 DSH 文档安装对应 Bundle 后取消对应行的 `disabled`。

## 相关仓库

- [ExMachina](https://github.com/KurohaneKaoruko/ExMachina) — 机械智能操作层（风格与协议源）
- [ExMachina-Agents](https://github.com/KurohaneKaoruko/ExMachina-Agents) — 角色源与协议源

## License

MIT
