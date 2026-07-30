#!/bin/bash
set -e

echo "========================================"
echo "  班主任班级管理工作台 - 一键推送+构建"
echo "========================================"
echo ""

# 检查 git
if ! command -v git &>/dev/null; then
    echo "[错误] 未找到 Git，请先安装: apt install git / brew install git"
    exit 1
fi

# 检查是否已解压
if [ ! -f "project.yml" ]; then
    echo "[错误] 请先解压 ClassWorkbench-iOS.zip，在此目录运行本脚本"
    exit 1
fi

# 初始化 git
git init
git add .
git commit -m "班主任班级管理工作台 v1.0"

# 询问用户名
read -p "请输入你的 GitHub 用户名: " GITHUB_USER
if [ -z "$GITHUB_USER" ]; then
    echo "[错误] 用户名不能为空"
    exit 1
fi

echo ""
echo "正在推送代码到 GitHub..."

# 尝试用 gh 或 git 推送
if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
    gh repo create ClassWorkbench --public --source=. --remote=origin --push
else
    git remote add origin "https://github.com/${GITHUB_USER}/ClassWorkbench.git"
    git push -u origin main || git push -u origin master
fi

echo ""
echo "========================================"
echo "  ✅ 推送成功！"
echo "========================================"
echo ""
echo "  📱 接下来："
echo "  1. 打开 https://github.com/${GITHUB_USER}/ClassWorkbench/actions"
echo "  2. 等待构建完成（约5-8分钟）"
echo "  3. 下载 IPA artifact"
echo "  4. 用爱思助手安装到 iPhone"
echo ""
