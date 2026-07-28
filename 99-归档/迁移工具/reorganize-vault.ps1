[CmdletBinding()]
param(
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
$vaultRoot = (Get-Location).Path

function Invoke-VaultMove {
    param(
        [Parameter(Mandatory)][string]$From,
        [Parameter(Mandatory)][string]$To
    )

    $source = Join-Path $vaultRoot $From
    $destination = Join-Path $vaultRoot $To
    if (-not (Test-Path -LiteralPath $source)) {
        throw "Missing expected source: $From"
    }
    if (Test-Path -LiteralPath $destination) {
        $sourceItem = Get-Item -LiteralPath $source
        $destinationItem = Get-Item -LiteralPath $destination
        $destinationChildren = Get-ChildItem -LiteralPath $destination -Force
        if (-not $sourceItem.PSIsContainer -or -not $destinationItem.PSIsContainer -or $destinationChildren.Count -ne 0) {
            throw "Destination already exists and cannot be merged safely: $To"
        }
        if ($WhatIf) {
            Write-Output "What if: merge $From contents -> $To"
            return
        }
        Get-ChildItem -LiteralPath $source -Force | ForEach-Object {
            Move-Item -LiteralPath $_.FullName -Destination (Join-Path $destination $_.Name)
        }
        Remove-Item -LiteralPath $source
        return
    }
    if ($WhatIf) {
        Write-Output "What if: move $From -> $To"
        return
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
    Move-Item -LiteralPath $source -Destination $destination
}

$directoryMoves = @(
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
    @{ From='picsum'; To='90-资源与附件/外部资料/Picsum图片服务' },
    @{ From='对象方法'; To='10-计算机与Web基础/JavaScript/内置对象与方法/对象方法' },
    @{ From='数组方法'; To='10-计算机与Web基础/JavaScript/内置对象与方法/数组方法' },
    @{ From='字符串方法'; To='10-计算机与Web基础/JavaScript/内置对象与方法/字符串方法' },
    @{ From='ES6'; To='10-计算机与Web基础/JavaScript/语法与函数/ES6' },
    @{ From='前端网页显示元素的术语'; To='10-计算机与Web基础/HTML与浏览器/界面元素术语' },
    @{ From='vite'; To='40-工程化与工具链/Vite' },
    @{ From='webpack'; To='40-工程化与工具链/Webpack' },
    @{ From='git使用'; To='40-工程化与工具链/Git' },
    @{ From='nvm命令'; To='40-工程化与工具链/开发环境/nvm' },
    @{ From='静态资源更新策略'; To='40-工程化与工具链/静态资源与缓存' },
    @{ From='skills'; To='40-工程化与工具链/开发工具/AI与技能' }
)

$fileMoves = @(
    @{ From='剩余参数...arg.md'; To='10-计算机与Web基础/JavaScript/语法与函数/剩余参数.md' },
    @{ From='数据结构map.md'; To='10-计算机与Web基础/JavaScript/内置对象与方法/Map.md' },
    @{ From='数据结构set.md'; To='10-计算机与Web基础/JavaScript/内置对象与方法/Set.md' },
    @{ From='重学前端/number/符号位 指数位 尾数位.md'; To='10-计算机与Web基础/JavaScript/数值与二进制/IEEE-754-符号位指数位尾数位.md' },
    @{ From='http/请求'; To='10-计算机与Web基础/网络与HTTP/HTTP报文/请求' },
    @{ From='http/响应'; To='10-计算机与Web基础/网络与HTTP/HTTP报文/响应' },
    @{ From='http/http模块.md'; To='30-Node与服务端/Node.js/HTTP模块.md' },
    @{ From='http/express.md'; To='30-Node与服务端/Express与中间件/Express.md' },
    @{ From='http/路由'; To='30-Node与服务端/Express与中间件/路由' },
    @{ From='nodejs/npm'; To='30-Node与服务端/npm与包管理/npm' },
    @{ From='nodejs/path'; To='30-Node与服务端/文件与路径/path' },
    @{ From='nodejs/process全局对象.md'; To='30-Node与服务端/Node.js/process全局对象.md' },
    @{ From='nodejs/require'; To='30-Node与服务端/Node.js/CommonJS' },
    @{ From='nodejs/bodyparser/未命名.md'; To='30-Node与服务端/Express与中间件/body-parser-中间件.md' },
    @{ From='钥无忧的登录.md'; To='50-工作实践/项目复盘/钥无忧-登录流程.md' },
    @{ From='快捷键.md'; To='40-工程化与工具链/开发工具/常用快捷键.md' },
    @{ From='codex的重连问题（通解）.md'; To='40-工程化与工具链/开发工具/Codex-重连问题通解.md' },
    @{ From='修复格式错误.md'; To='40-工程化与工具链/开发工具/ESLint-自动修复格式.md' },
    @{ From='笔记注意事项！！！！.md'; To='01-导航/笔记写作规范.md' },
    @{ From='未命名.md'; To='99-归档/空白笔记/未命名.md' },
    @{ From='未命名 1.canvas'; To='99-归档/空白笔记/未命名 1.canvas' },
    @{ From='assets/js/file-20260310115618900.md'; To='99-归档/待确认内容/JavaScript-Excalidraw图.md' },
    @{ From='assets/try catch debugger/file-20251224132825303.png'; To='99-归档/未归类资源/file-20251224132825303.png' }
)

foreach ($move in $directoryMoves) { Invoke-VaultMove @move }
foreach ($move in $fileMoves) { Invoke-VaultMove @move }

if (-not $WhatIf) {
    Invoke-VaultMove -From 'nodejs/fs/appendfile.md' -To '99-归档/空白笔记/appendfile.md'
    Invoke-VaultMove -From '10-计算机与Web基础/CSS/定位position/absolute.md' -To '99-归档/空白笔记/absolute.md'
    Invoke-VaultMove -From '10-计算机与Web基础/CSS/布局/浮动.md' -To '99-归档/空白笔记/浮动.md'
    Invoke-VaultMove -From '40-工程化与工具链/Vite/vite.config.js/一般配置.md' -To '99-归档/空白笔记/vite.config.js-一般配置.md'
    Invoke-VaultMove -From '20-Vue生态/Vue 2/Vue Router/子路由.md' -To '99-归档/空白笔记/Vue Router-子路由.md'
    Invoke-VaultMove -From '20-Vue生态/Vue 2/VueX/index.js.md' -To '99-归档/空白笔记/VueX-index.js.md'
    Invoke-VaultMove -From '20-Vue生态/Vue 2/Vue构造/vue.md' -To '99-归档/空白笔记/Vue构造-vue.md'
    Invoke-VaultMove -From '20-Vue生态/Vue 2/Vue构造/VueRouter.md' -To '99-归档/空白笔记/Vue构造-VueRouter.md'
    Invoke-VaultMove -From '20-Vue生态/Vue 2/Vue的api/vue.use.md' -To '99-归档/空白笔记/Vue API-vue.use.md'
    Invoke-VaultMove -From '10-计算机与Web基础/数据结构与算法/hot100/哈希/ID 1 两数相加.md' -To '99-归档/空白笔记/Hot100-ID-1-两数相加.md'
    Invoke-VaultMove -From '10-计算机与Web基础/网络与HTTP/同源与跨域/未命名.md' -To '99-归档/空白笔记/网络-未命名.md'
    Invoke-VaultMove -From '10-计算机与Web基础/网络与HTTP/同源与跨域/跨域问题.md' -To '99-归档/空白笔记/跨域问题.md'
    Invoke-VaultMove -From '70-职业发展/面试/css3.md' -To '99-归档/空白笔记/面试-css3.md'
    Invoke-VaultMove -From '70-职业发展/面试/html5.md' -To '99-归档/空白笔记/面试-html5.md'

    $markdown = Get-ChildItem -Path $vaultRoot -Recurse -File -Filter '*.md' | Where-Object {
        $_.FullName -notmatch '\\(\.git|\.obsidian|\.claudian|\.trash|docs)\\'
    }
    foreach ($note in $markdown) {
        $content = Get-Content -LiteralPath $note.FullName -Raw
        if ($null -eq $content) { continue }
        $changed = $false
        [regex]::Matches($content, '!\[[^\]]*\]\(([^)]+)\)') | ForEach-Object {
            $embed = $_.Value
            $relativePath = $_.Groups[1].Value.Trim()
            if ($relativePath -match '^(https?:|data:)') { return }
            $sourceImage = Join-Path $note.DirectoryName ($relativePath -replace '/', '\\')
            if (-not (Test-Path -LiteralPath $sourceImage -PathType Leaf)) {
                $fileName = Split-Path -Leaf $relativePath
                $candidates = Get-ChildItem -Path $vaultRoot -Recurse -File -Filter $fileName | Where-Object {
                    $_.FullName -notmatch '\\(90-资源与附件|99-归档|\.git|\.obsidian|\.claudian|\.trash|docs)\\'
                }
                if ($candidates.Count -ne 1) { return }
                $sourceImage = $candidates[0].FullName
            }
            if ([IO.Path]::GetExtension($sourceImage).ToLowerInvariant() -ne '.png') { return }
            $targetDirectory = Join-Path $vaultRoot '90-资源与附件/图片'
            New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
            $targetName = Split-Path -Leaf $sourceImage
            $targetImage = Join-Path $targetDirectory $targetName
            if (Test-Path -LiteralPath $targetImage) {
                if ((Get-FileHash -LiteralPath $sourceImage).Hash -ne (Get-FileHash -LiteralPath $targetImage).Hash) {
                    $targetName = "$(Split-Path -Leaf $note.DirectoryName)-$targetName"
                    $targetImage = Join-Path $targetDirectory $targetName
                }
            }
            if (-not (Test-Path -LiteralPath $targetImage)) {
                Move-Item -LiteralPath $sourceImage -Destination $targetImage
            }
            $replacement = "![[90-资源与附件/图片/$targetName]]"
            $content = $content.Replace($embed, $replacement)
            $changed = $true
        }
        if ($changed) { Set-Content -LiteralPath $note.FullName -Value $content -Encoding utf8 }
    }
}

$global:LASTEXITCODE = 0



