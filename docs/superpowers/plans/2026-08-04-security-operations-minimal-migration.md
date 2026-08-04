# 安全运营知识区最小化迁移 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 建立最小化的安全运营攻击分类入口，并无损迁移信息探测知识记录。

**Architecture:** `45-安全运营` 作为独立知识区；攻击分类索引只链接“信息探测”这一已具备内容的分类。原始收件箱笔记移动为正式攻击特征分析笔记，主体内容不重写。

**Tech Stack:** Obsidian Markdown、Wiki 链接、PowerShell、Git。

## Global Constraints

- 仅创建 `45-安全运营/攻击分类/信息探测/`，不创建其他安全运营分类目录。
- 保留原始笔记正文、表格、研判模板与示例。
- 使用 UTF-8 读取和写入 Markdown，避免中文乱码。
- 移动后，`00-收件箱` 不保留同名副本。
- 在当前 `main` 分支执行；不修改 `.obsidian/`、`.claudian/`。

---

### Task 1: 创建索引并迁移信息探测笔记

**Files:**
- Create: `45-安全运营/攻击分类/攻击分类索引.md`
- Create: `45-安全运营/攻击分类/信息探测/信息探测-攻击特征分析.md`（由移动产生）
- Delete by move: `00-收件箱/2026-08-04-信息探测知识-会话记录.md`
- Test: 索引和目标笔记的双向 Wiki 链接存在且目标文件 UTF-8 可读。

**Interfaces:**
- Consumes: 已整理的收件箱笔记。
- Produces: 信息探测攻击特征分析的正式入口与攻击分类索引。

- [ ] **Step 1: 创建最小目录与索引**

```powershell
New-Item -ItemType Directory -Force -Path '45-安全运营/攻击分类/信息探测' | Out-Null
```

索引以 `# 攻击分类索引` 开头，只包含：

```md
## 信息探测
- [[信息探测/信息探测-攻击特征分析]]
```

- [ ] **Step 2: 无损移动并轻整理笔记**

使用 `Move-Item -LiteralPath` 将源笔记移至目标路径。以 UTF-8 读取目标文件；若尚无一级标题，在首行补 `# 信息探测-攻击特征分析`，并在标题下添加 `> 所属：[[攻击分类索引]]`。不得改写其余正文。

- [ ] **Step 3: 验证文件、编码与链接**

```powershell
$target = '45-安全运营/攻击分类/信息探测/信息探测-攻击特征分析.md'
if (-not (Test-Path -LiteralPath $target)) { throw 'Target note is missing.' }
if (Test-Path -LiteralPath '00-收件箱/2026-08-04-信息探测知识-会话记录.md') { throw 'Source note was not moved.' }
Get-Content -LiteralPath $target -Encoding utf8 -TotalCount 3
```

Expected: 首行是 `# 信息探测-攻击特征分析`，第二个非空块链接到 `[[攻击分类索引]]`；源文件不存在。

- [ ] **Step 4: Commit**

```powershell
git add '45-安全运营' '00-收件箱'
git commit -m 'feat: add information reconnaissance security notes'
```

### Task 2: 最终链接与范围校验

**Files:**
- Verify: `45-安全运营/攻击分类/攻击分类索引.md`
- Verify: `45-安全运营/攻击分类/信息探测/信息探测-攻击特征分析.md`
- Test: 仅存在设计指定的安全运营分类目录。

**Interfaces:**
- Consumes: Task 1 的最终文件。
- Produces: 可从攻击分类索引打开的安全运营知识区。

- [ ] **Step 1: 检查 Wiki 链接**

```powershell
$index = Get-Content -LiteralPath '45-安全运营/攻击分类/攻击分类索引.md' -Encoding utf8 -Raw
if ($index -notmatch '\[\[信息探测/信息探测-攻击特征分析\]\]') { throw 'Index link is missing.' }
```

- [ ] **Step 2: 检查未预建分类**

```powershell
Get-ChildItem -LiteralPath '45-安全运营/攻击分类' -Directory | Select-Object -ExpandProperty Name
```

Expected: 只返回 `信息探测`。

- [ ] **Step 3: Commit**

```powershell
git status --short
git diff --check HEAD
```

Expected: 工作区无未提交知识笔记改动，且不包含 `.obsidian/` 或 `.claudian/` 配置变更。

## Plan Self-Review

- **Spec coverage:** 目录范围、单篇笔记迁移、正文保留、UTF-8、索引链接和不预建分类均有明确步骤。
- **Placeholder scan:** 每一步含具体路径、内容或验证命令。
- **Consistency:** 所有路径均使用 `45-安全运营/攻击分类/信息探测`，索引链接与目标文件名一致。
