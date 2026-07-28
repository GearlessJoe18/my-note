# 前端开发知识库迁移 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将现有笔记无损迁移为以技术知识为主干、工作实践可快速查阅的 Obsidian 知识库。

**Architecture:** 使用一次性的 PowerShell 迁移清单将原始目录移动到目标领域；三份 MOC 导航页提供浏览、学习和工作检索入口。图片附件集中在 `90-资源与附件/图片`，迁移时把 Markdown 相对图片引用转换为完整的 Obsidian 嵌入链接；校验脚本在变更后报告断开的 Wiki 链接和嵌入资源。

**Tech Stack:** Obsidian Markdown、Wiki 链接、PowerShell、Git。

## Global Constraints

- 保留所有现有 Markdown 正文和二进制附件；不得删除用户内容。
- 不修改 `.obsidian/`、`.claudian/`、`.git/`、`.trash/` 及既有 `docs/` 内容。
- 仅使用相对于 vault 根目录的路径；目录层级不超过四层。
- 移动或重命名后，Wiki 链接与 Markdown 图片嵌入必须可解析。
- 根目录只保留 vault 配置、`.gitignore` 与 `docs/`；已分类笔记不可留在根目录。
- React 只在学习路线中预留入口，不新建 React 空目录。
- 用户已明确授权在当前 `main` 分支的真实 vault 中执行；不得创建或切换到 worktree。

---

## File Structure

| 路径 | 责任 |
| --- | --- |
| `00-收件箱/` | 新笔记的唯一临时入口，迁移完成时为空。 |
| `01-导航/前端知识地图.md` | 所有知识领域的阅读入口和掌握状态。 |
| `01-导航/当前学习路线.md` | 当前学习阶段和下一步笔记链接。 |
| `01-导航/工作问题索引.md` | 按工作场景定位实践复盘。 |
| `10-计算机与Web基础/` | CSS、JavaScript、TypeScript、网络、算法与浏览器基础。 |
| `20-Vue生态/` | Vue 2 现有知识与 Element UI。 |
| `30-Node与服务端/` | Node.js、HTTP 模块、Express、中间件与包管理。 |
| `40-工程化与工具链/` | Vite、Webpack、Git、nvm、缓存和开发工具。 |
| `50-工作实践/` | 项目上下文、问题排查与可复用方案。 |
| `60-学习记录/每日笔记/` | 保留每日原始记录，使用 ISO 日期文件名。 |
| `70-职业发展/` | 面试与技术成长内容。 |
| `80-个人项目/` | 毕业设计笔记。 |
| `90-资源与附件/图片/` | 迁移后的 PNG 附件。 |
| `99-归档/` | 空白笔记、未命名 canvas 和不可确认归属的旧资源。 |
| `99-归档/迁移工具/reorganize-vault.ps1` | 一次性、可预演的目录/文件移动与 Markdown 图片链接重写工具。 |
| `99-归档/迁移工具/verify-vault-links.ps1` | 报告 Markdown 中失效 Wiki 链接、嵌入链接与文件系统残留的校验工具。 |

### Task 1: 创建可预演的迁移与校验工具

**Files:**
- Create: `99-归档/迁移工具/reorganize-vault.ps1`
- Create: `99-归档/迁移工具/verify-vault-links.ps1`
- Modify: none
- Test: 在 `-WhatIf` 下不产生文件系统变化；在真实运行后校验退出码为 `0`。

**Interfaces:**
- Consumes: vault 根目录的旧目录、`-WhatIf` PowerShell common parameter。
- Produces: 目标目录、移动后的文件，以及 `verify-vault-links.ps1` 的退出码（`0` 为无断链，`1` 为发现断链）。

- [ ] **Step 1: 记录迁移前基线**

```powershell
$files = Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notmatch '\\(\.git|\.obsidian|\.claudian|\.trash|docs)\\' }
$baselinePath = Join-Path $env:TEMP 'my-note-migration-baseline.txt'
"files=$($files.Count); bytes=$(($files | Measure-Object Length -Sum).Sum)" | Set-Content $baselinePath -Encoding utf8
git status --short
```

Expected: 系统临时目录中的基线文件记录文件数和总字节数；现有 `.claudian/`、`.obsidian/` 未提交变更仍只显示为未暂存变更。

- [ ] **Step 2: 实现 `99-归档/迁移工具/reorganize-vault.ps1` 的目录移动清单**

脚本须以 `Move-Item -LiteralPath ... -Destination ... -WhatIf:$WhatIfPreference` 执行以下重命名或移动；先用 `New-Item -ItemType Directory -Force` 创建每个目标父目录。每个源路径在移动前必须 `Test-Path`，缺失即 `throw`，以避免半完成迁移。

```powershell
$moves = @(
  @{ From='css'; To='10-计算机与Web基础/CSS' },
  @{ From='TypeScript'; To='10-计算机与Web基础/TypeScript' },
  @{ From='网络'; To='10-计算机与Web基础/网络与HTTP/同源与跨域' },
  @{ From='算法和hot100总结'; To='10-计算机与Web基础/数据结构与算法' },
  @{ From='vue2'; To='20-Vue生态/Vue 2' },
  @{ From='element'; To='20-Vue生态/UI组件库/Element UI' },
  @{ From='promise'; To='10-计算机与Web基础/JavaScript/异步与性能/Promise' },
  @{ From='防抖与节流'; To='10-计算机与Web基础/JavaScript/异步与性能/防抖与节流' },
  @{ From='每日笔记（前端）'; To='60-学习记录/每日笔记' },
  @{ From='面试'; To='70-职业发展/面试' },
  @{ From='毕设论文'; To='80-个人项目/毕业设计-服装风格识别' },
  @{ From='picsum'; To='90-资源与附件/外部资料/Picsum图片服务' }
)
```

- [ ] **Step 3: 实现文件级移动清单与命名**

脚本须以同一方法移动：`对象方法`、`数组方法`、`字符串方法` 到 `10-计算机与Web基础/JavaScript/内置对象与方法/`；`ES6` 和 `剩余参数...arg.md` 到 `10-计算机与Web基础/JavaScript/语法与函数/`；`数据结构map.md`、`数据结构set.md` 到 `10-计算机与Web基础/JavaScript/内置对象与方法/`；`重学前端/number/符号位 指数位 尾数位.md` 到 `10-计算机与Web基础/JavaScript/数值与二进制/IEEE-754-符号位指数位尾数位.md`；`前端网页显示元素的术语` 到 `10-计算机与Web基础/HTML与浏览器/界面元素术语/`；`http/请求` 和 `http/响应` 到 `10-计算机与Web基础/网络与HTTP/HTTP报文/`；`http/http模块.md` 到 `30-Node与服务端/Node.js/HTTP模块.md`；`http/express.md` 与 `http/路由` 到 `30-Node与服务端/Express与中间件/`；`nodejs/npm`、`nodejs/path`、`nodejs/process全局对象.md`、`nodejs/require`、`nodejs/bodyparser/未命名.md` 到对应 Node 子目录，后者重命名为 `body-parser-中间件.md`；`vite`、`webpack`、`git使用`、`nvm命令`、`静态资源更新策略` 到 `40-工程化与工具链/` 对应子目录；根目录的快捷键与 Codex 笔记到 `40-工程化与工具链/开发工具/`；根目录 `钥无忧的登录.md` 到 `50-工作实践/项目复盘/钥无忧-登录流程.md`；`skills` 到 `40-工程化与工具链/开发工具/AI与技能/`；根目录 `笔记注意事项！！！！.md` 重命名并移动到 `01-导航/笔记写作规范.md`。

- [ ] **Step 4: 实现图片迁移和嵌入重写**

脚本须在移动笔记之后遍历所有 vault Markdown（排除内部目录和 `docs/`），匹配 `![](<relative-path>)`。对每一个解析得到的存在 `.png` 文件：移动到 `90-资源与附件/图片/<原文件名>`；如果同名文件已存在且 SHA-256 相同则复用，否则以 `<原父目录>-<原文件名>` 命名。把原嵌入改为 `![[90-资源与附件/图片/<目标文件名>]]`。无正文引用的 `assets/try catch debugger/file-20251224132825303.png` 移到 `99-归档/未归类资源/`；Excalidraw 文件 `assets/js/file-20260310115618900.md` 移到 `99-归档/待确认内容/JavaScript-Excalidraw图.md`。

- [ ] **Step 5: 实现校验脚本**

`verify-vault-links.ps1` 须递归读取所有非内部 Markdown：对 `[[目标]]` 和 `![[目标]]` 提取路径，去掉 `#标题` 与 `|别名` 后检查目标；对于不带路径的链接按 vault 内唯一同名文件解析。打印每个无法解析项并以 `exit 1` 结束；无错误时输出 `Vault link check passed.` 并以 `exit 0` 结束。

- [ ] **Step 6: 预演脚本**

Run: `./99-归档/迁移工具/reorganize-vault.ps1 -WhatIf`

Expected: 输出每个目标移动操作；`Get-ChildItem -Directory` 仍显示旧目录，且 `git status --short` 没有知识笔记移动记录。

- [ ] **Step 7: Commit**

```powershell
git add 99-归档/迁移工具/reorganize-vault.ps1 99-归档/迁移工具/verify-vault-links.ps1
git commit -m 'chore: add vault migration tools'
```

### Task 2: 创建目录骨架与三份导航页

**Files:**
- Create: `00-收件箱/.gitkeep`
- Create: `01-导航/前端知识地图.md`
- Create: `01-导航/当前学习路线.md`
- Create: `01-导航/工作问题索引.md`
- Create: 所有 File Structure 中列出的空目录（以 `.gitkeep` 保留）。
- Test: 三份 MOC 中的内部链接在移动完成后均由校验脚本解析。

**Interfaces:**
- Consumes: Task 1 的目标路径约定。
- Produces: 后续迁移使用的稳定目标目录和 MOC 入口。

- [ ] **Step 1: 创建目录骨架**

```powershell
'00-收件箱','01-导航','10-计算机与Web基础','20-Vue生态','30-Node与服务端','40-工程化与工具链','50-工作实践','60-学习记录','70-职业发展','80-个人项目','90-资源与附件/图片','99-归档' |
  ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
```

- [ ] **Step 2: 写入前端知识地图**

内容必须以 `# 前端知识地图` 开头，包含“学习状态：未开始 / 学习中 / 可工作使用 / 需复习”图例，并链接：`[[10-计算机与Web基础/JavaScript/异步与性能/Promise/promise]]`、`[[10-计算机与Web基础/CSS/布局/flex/flex]]`、`[[10-计算机与Web基础/网络与HTTP/HTTP报文/请求/请求报文]]`、`[[20-Vue生态/Vue 2/创建项目]]`、`[[30-Node与服务端/Node.js/process全局对象]]`、`[[40-工程化与工具链/Vite/vite是什么]]`、`[[50-工作实践/项目复盘/钥无忧-登录流程]]`、`[[70-职业发展/面试/es6]]`。

- [ ] **Step 3: 写入当前学习路线**

使用六个顺序阶段：基础夯实、Vue 2 项目维护、Vue 3 + TypeScript、工程化、Node.js、React 入门；React 阶段只有“开始时再建立专题笔记”的说明，不能创建空 React 目录。

- [ ] **Step 4: 写入工作问题索引**

建立“登录认证”“路由”“静态资源与缓存”“接口与错误排查”四节；登录认证链接 `[[50-工作实践/项目复盘/钥无忧-登录流程]]`，缓存链接 `[[40-工程化与工具链/静态资源与缓存/图片 URL 加随机 query 做缓存穿透]]`，其余两节在对应实践笔记出现前标为“暂无复盘”。

- [ ] **Step 5: Commit**

```powershell
git add 00-收件箱 01-导航
git commit -m 'feat: add vault navigation maps'
```

### Task 3: 迁移基础知识、Vue、Node 和工程化笔记

**Files:**
- Modify: 所有 Task 1 第 2、3 步列出的源笔记与目录（通过移动或重命名）。
- Create: `10-计算机与Web基础/JavaScript/{语法与函数,内置对象与方法,异步与性能,数值与二进制}/`
- Create: `30-Node与服务端/{Node.js,Express与中间件,npm与包管理,文件与路径}/`
- Test: 所有非空基础、Vue、Node、工具链 Markdown 都位于其目标领域；源目录不存在。

**Interfaces:**
- Consumes: Task 1 的迁移清单、Task 2 的目录骨架。
- Produces: 可被 MOC 和实践笔记链接的技术知识树。

- [ ] **Step 1: 执行真实迁移**

Run: `./99-归档/迁移工具/reorganize-vault.ps1`

Expected: `css`、`vue2`、`nodejs`、`http`、`vite`、`webpack` 等源目录被清空或删除；所有目标文件存在。

- [ ] **Step 2: 整理空白技术笔记**

把 `absolute.md`、`浮动.md`、`appendfile.md`、`一般配置.md`、Vue 2 的空白路由/构造/VueX/API 笔记、`跨域问题.md`、Hot100 两数相加笔记移入 `99-归档/空白笔记/`，保留其原文件名；不创建空主题笔记。

- [ ] **Step 3: 验收文件数量与正文保留**

```powershell
$baseline = Get-Content (Join-Path $env:TEMP 'my-note-migration-baseline.txt')
$files = Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notmatch '\\(\.git|\.obsidian|\.claudian|\.trash|docs|scripts)\\' }
"files=$($files.Count); bytes=$(($files | Measure-Object Length -Sum).Sum)"
$baseline
```

Expected: Markdown 与附件总字节数不少于迁移前基线；新增的 MOC、`.gitkeep` 和脚本不计入比较。

- [ ] **Step 4: Commit**

```powershell
git add -A -- ':!.obsidian' ':!.claudian' ':!.trash'
git commit -m 'refactor: organize technical knowledge notes'
```

### Task 4: 迁移工作、学习、职业和个人项目内容

**Files:**
- Modify: `50-工作实践/项目复盘/钥无忧-登录流程.md`
- Modify: `60-学习记录/每日笔记/*.md`
- Modify: `70-职业发展/面试/*.md`
- Modify: `80-个人项目/毕业设计-服装风格识别/*.md`
- Create: `99-归档/空白笔记/`、`99-归档/待确认内容/`、`99-归档/未归类资源/`
- Test: 每日笔记命名一致；工作复盘和项目笔记均可从导航页到达。

**Interfaces:**
- Consumes: Task 2 的导航页、Task 3 完成后的技术知识路径。
- Produces: 基于场景浏览的实践层与保留的历史记录。

- [ ] **Step 1: 标准化每日笔记文件名**

在 `60-学习记录/每日笔记/` 将 `12月21日.md` 至 `12月24日.md` 改为 `2025-12-21.md` 至 `2025-12-24.md`；其他已采用 ISO 名称的日记不重命名。保持正文原样，不为现有日记批量添加空模板段落。

- [ ] **Step 2: 为工作复盘添加最少关联**

在 `钥无忧-登录流程.md` 的开头添加一级标题 `# 钥无忧-登录流程`；在文末添加 `## 关联知识`，并链接 `[[20-Vue生态/Vue 2/Vue Router/生成路由实例]]`、`[[20-Vue生态/Vue 2/VueX/mapState]]`、`[[10-计算机与Web基础/网络与HTTP/HTTP报文/请求/请求报文]]`。原有流程正文不改写。

- [ ] **Step 3: 归档空白和未命名文件**

移动根目录 `未命名.md`、`未命名 1.canvas`；`网络/未命名.md`、`面试/css3.md`、`面试/html5.md` 和 Task 3 所列空白技术笔记到 `99-归档/空白笔记/`。保留 `修复格式错误.md` 并移动到 `40-工程化与工具链/开发工具/ESLint-自动修复格式.md`。

- [ ] **Step 4: Commit**

```powershell
git add -A -- ':!.obsidian' ':!.claudian' ':!.trash'
git commit -m 'refactor: organize practice and learning records'
```

### Task 5: 校验、清理空目录和完成验收

**Files:**
- Modify: `01-导航/*.md`（仅在校验发现路径不一致时修正）
- Modify: `99-归档/迁移工具/verify-vault-links.ps1`（仅在真实链接形式未覆盖时修正）
- Test: `99-归档/迁移工具/verify-vault-links.ps1` 退出码为 `0`；根目录无遗留知识笔记。

**Interfaces:**
- Consumes: Tasks 1–4 的最终 vault 结构。
- Produces: 经验证的可浏览知识库。

- [ ] **Step 1: 执行链接与嵌入校验**

Run: `./99-归档/迁移工具/verify-vault-links.ps1`

Expected: 输出 `Vault link check passed.` 并返回 `0`。若有失败，修正实际路径或链接文本后重复运行至通过。

- [ ] **Step 2: 检查根目录与旧目录残留**

```powershell
Get-ChildItem -File -Filter *.md
'css','TypeScript','网络','算法和hot100总结','vue2','element','promise','防抖与节流','每日笔记（前端）','面试','毕设论文','nodejs','http','vite','webpack','git使用','nvm命令' |
  ForEach-Object { "$_ : $(Test-Path -LiteralPath $_)" }
```

Expected: 根目录不返回 Markdown；每个旧目录均返回 `False`。

- [ ] **Step 3: 复核 Git 改动范围**

Run: `git status --short; git diff --check HEAD`

Expected: 只有知识库目录、`99-归档/迁移工具/` 和文档计划相关的提交；既有 `.obsidian/`、`.claudian/` 用户改动仍未被暂存或提交。

- [ ] **Step 4: 最终 Commit**

```powershell
git add 01-导航 scripts
git commit -m 'chore: verify organized knowledge vault'
```

## Plan Self-Review

- **Spec coverage:** 目录、迁移映射、命名、三类笔记、三份导航页、链接修复、附件处理、归档和验收均分别由 Tasks 1–5 覆盖。
- **Placeholder scan:** 计划没有未决条目或泛化实现说明；每项移动、命名和验证均给出具体路径或规则。
- **Consistency:** 所有导航、迁移和验证任务使用相同的 `10/20/30/40/50/60/70/80/90/99` 目录命名；校验脚本的输入范围与迁移脚本的排除范围一致。

