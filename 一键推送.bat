@echo off
chcp 65001 >nul
echo ========================================
echo   班主任班级管理工作台 - 一键推送+构建
echo ========================================
echo.

:: 检查 git
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未找到 Git，请先安装：https://git-scm.com/download/win
    pause
    exit /b 1
)

:: 检查是否已解压项目
if not exist "project.yml" (
    echo [错误] 请先解压 ClassWorkbench-iOS.zip，在此目录运行本脚本
    pause
    exit /b 1
)

:: 初始化 git
git init
git add .
git commit -m "班主任班级管理工作台 v1.0"

:: 询问 GitHub 用户名
set /p GITHUB_USER="请输入你的 GitHub 用户名: "
if "%GITHUB_USER%"=="" (
    echo [错误] 用户名不能为空
    pause
    exit /b 1
)

:: 创建仓库并推送
echo.
echo 正在创建 GitHub 仓库并推送代码...
gh repo create ClassWorkbench --public --source=. --remote=origin --push

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   ✅ 推送成功！
    echo ========================================
    echo.
    echo  📱 接下来：
    echo   1. 打开 https://github.com/%GITHUB_USER%/ClassWorkbench/actions
    echo   2. 等待构建完成（约5-8分钟）
    echo   3. 下载 IPA artifact
    echo   4. 用爱思助手安装到 iPhone
    echo.
    start https://github.com/%GITHUB_USER%/ClassWorkbench/actions
) else (
    echo.
    echo [提示] gh 命令失败，尝试直接用 git 推送...
    git remote add origin https://github.com/%GITHUB_USER%/ClassWorkbench.git
    git push -u origin main
    echo.
    echo 如果推送失败，请先在 GitHub 网页上创建仓库：
    echo https://github.com/new
    echo 仓库名填: ClassWorkbench
    echo 然后重新运行本脚本
)

pause
