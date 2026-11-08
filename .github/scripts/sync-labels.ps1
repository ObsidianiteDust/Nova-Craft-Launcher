#Requires -Version 5.1
<#
.SYNOPSIS
    将 .github/labels.json 中定义的标签同步到 GitHub 仓库，并可清理 GitHub 默认标签。

.DESCRIPTION
    以 .github/labels.json 为唯一事实源（Single Source of Truth）：
      * 标签已存在 -> 更新颜色与描述
      * 标签不存在 -> 创建
      * 传 -RemoveDefaultLabels -> 先删除 GitHub 新建仓库时自带的 8 个英文默认标签
    幂等：可反复执行，不会产生重复标签。

.PARAMETER Token
    GitHub Token（需对该仓库有 repo/push 权限）。默认为环境变量 GITHUB_TOKEN。

.PARAMETER Repo
    仓库全名，默认 ZhangXaohan-awa/Nova-Craft-Launcher。

.PARAMETER DryRun
    只打印将要执行的动作，不调用任何写接口。

.PARAMETER RemoveDefaultLabels
    删除 GitHub 默认标签：documentation、duplicate、enhancement、
    good first issue、help wanted、invalid、question、wontfix。

.EXAMPLE
    $env:GITHUB_TOKEN = 'ghp_xxx'
    ./sync-labels.ps1 -DryRun

.EXAMPLE
    $env:GITHUB_TOKEN = 'ghp_xxx'
    ./sync-labels.ps1 -RemoveDefaultLabels
#>
[CmdletBinding()]
param(
    [string]$Token = $env:GITHUB_TOKEN,
    [string]$Repo  = 'ZhangXaohan-awa/Nova-Craft-Launcher',
    [switch]$DryRun,
    [switch]$RemoveDefaultLabels
)

$ErrorActionPreference = 'Stop'

$DefaultLabels = @(
    'documentation', 'duplicate', 'enhancement', 'good first issue',
    'help wanted', 'invalid', 'question', 'wontfix'
)

# ---------- 读取标签定义（脚本位于 .github/scripts/ 下） ----------
$defFile = Join-Path $PSScriptRoot '..\labels.json'
if (-not (Test-Path -LiteralPath $defFile)) {
    throw "找不到标签定义文件: $defFile"
}
$defs = Get-Content -LiteralPath $defFile -Raw -Encoding UTF8 | ConvertFrom-Json
if (-not $defs) { throw "标签定义文件为空: $defFile" }

if (-not $DryRun -and [string]::IsNullOrWhiteSpace($Token)) {
    throw "缺少 Token。请设置环境变量 GITHUB_TOKEN，或用 -Token 传入。"
}

$headers = @{
    'User-Agent'           = 'ncl-label-sync'
    'Accept'               = 'application/vnd.github+json'
    'X-GitHub-Api-Version' = '2022-11-28'
}
if (-not $DryRun) { $headers['Authorization'] = "Bearer $Token" }

$api = "https://api.github.com/repos/$Repo"

function Invoke-GitHub {
    param(
        [Parameter(Mandatory)][string]$Method,
        [Parameter(Mandatory)][string]$Uri,
        [string]$Body
    )
    # DryRun 只拦截写操作；GET 是只读的，照常执行以便给出准确预览
    if ($DryRun -and $Method -ne 'Get') {
        Write-Host "  [DryRun] $Method $Uri"
        return $null
    }
    if ($Body) {
        return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers `
            -Body $Body -ContentType 'application/json; charset=utf-8'
    }
    return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers
}

# ---------- 1. 可选：清理默认标签 ----------
if ($RemoveDefaultLabels) {
    Write-Host '== 清理 GitHub 默认标签 ==' -ForegroundColor Cyan
    foreach ($name in $DefaultLabels) {
        $uri = "$api/labels/$([uri]::EscapeDataString($name))"
        try {
            Invoke-GitHub -Method Delete -Uri $uri | Out-Null
            Write-Host "  已删除: $name"
        }
        catch {
            $code = $_.Exception.Response.StatusCode.value__
            if ($code -eq 404) {
                Write-Host "  已不存在: $name" -ForegroundColor DarkGray
            }
            else {
                Write-Warning "  删除失败($code): $name -> $($_.Exception.Message)"
            }
        }
    }
}

# ---------- 2. 读取现有标签 ----------
Write-Host '== 读取现有标签 ==' -ForegroundColor Cyan
$existing = @()
try {
    # 注意：PowerShell 5.1 的 Invoke-RestMethod 会把顶层 JSON 数组整体当成单个对象返回，
    # 必须显式判断类型再展开，否则后续 Where-Object 匹配会把整个数组当成一个元素而误判。
    $raw = Invoke-GitHub -Method Get -Uri "$api/labels?per_page=100"
    if ($null -ne $raw) {
        if ($raw -is [System.Array]) { $existing = $raw } else { $existing = @($raw) }
    }
}
catch {
    if (-not $DryRun) { throw }
    Write-Warning "读取现有标签失败，DryRun 将按全部新建预览: $($_.Exception.Message)"
}
Write-Host "  当前共 $($existing.Count) 个标签"

# ---------- 3. 同步定义中的标签 ----------
Write-Host '== 同步类型标签 ==' -ForegroundColor Cyan
$created = 0; $updated = 0; $skipped = 0

foreach ($d in $defs) {
    if ([string]::IsNullOrWhiteSpace($d.name)) { continue }

    $current = $existing | Where-Object { $_.name -eq $d.name } | Select-Object -First 1
    $body = @{
        name        = $d.name
        color       = ([string]$d.color).Trim('#')
        description = [string]$d.description
    } | ConvertTo-Json -Compress

    if ($current) {
        $sameColor = $current.color -eq ([string]$d.color).Trim('#')
        $sameDesc  = $current.description -eq [string]$d.description
        if ($sameColor -and $sameDesc) {
            Write-Host "  未变化: $($d.name)" -ForegroundColor DarkGray
            $skipped++
            continue
        }
        Invoke-GitHub -Method Patch -Body $body -Uri "$api/labels/$([uri]::EscapeDataString($d.name))" | Out-Null
        Write-Host "  已更新: $($d.name)" -ForegroundColor Yellow
        $updated++
    }
    else {
        Invoke-GitHub -Method Post -Body $body -Uri "$api/labels" | Out-Null
        Write-Host "  已创建: $($d.name)" -ForegroundColor Green
        $created++
    }
}

# ---------- 4. 汇总 ----------
Write-Host ''
Write-Host ("完成：新建 {0} 个，更新 {1} 个，未变化 {2} 个。" -f $created, $updated, $skipped) -ForegroundColor Cyan
if ($DryRun) { Write-Host '（DryRun 模式，以上均为预览，未做任何修改）' -ForegroundColor Magenta }

# ---------- 5. 提示：模板引用了未定义的标签 ----------
$templateDir = Join-Path $PSScriptRoot '..\ISSUE_TEMPLATE'
if (Test-Path -LiteralPath $templateDir) {
    $defined = @($defs | ForEach-Object { $_.name })
    $missing = @()
    Get-ChildItem -LiteralPath $templateDir -Filter '*.md' | ForEach-Object {
        $text = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
        if ($text -match '(?m)^labels:\s*[''"]?([^''"\r\n]+)[''"]?\s*$') {
            $label = $Matches[1].Trim()
            if ($label -and ($defined -notcontains $label)) {
                $missing += "$($_.Name) -> $label"
            }
        }
    }
    if ($missing.Count -gt 0) {
        Write-Warning '以下模板引用了未在 labels.json 中定义的标签，GitHub 会静默忽略它们：'
        $missing | ForEach-Object { Write-Warning "  $_" }
    }
    else {
        Write-Host '模板标签检查：全部与 labels.json 一致。' -ForegroundColor Green
    }
}
