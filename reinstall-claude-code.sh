#!/bin/bash

# Claude Code 重装脚本
# 适用于 macOS 和 Linux

echo "========================================="
echo "Claude Code 一键重装脚本"
echo "========================================="
echo ""

# 检查 npm 是否已安装
if ! command -v npm &> /dev/null; then
    echo "错误: npm 未安装，请先安装 Node.js 和 npm"
    exit 1
fi

echo "步骤 1: 卸载现有的 Claude Code..."
npm uninstall -g @anthropic-ai/claude-code

if [ $? -eq 0 ]; then
    echo "✓ 卸载成功"
else
    echo "⚠ 卸载过程中出现问题，继续安装..."
fi

echo ""
echo "步骤 2: 安装新版本的 Claude Code..."
npm install -g https://aicodewith.com/claudecode/install --registry=https://registry.npmmirror.com

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Claude Code 安装成功！"
    echo ""
    echo "您可以通过以下命令启动 Claude Code:"
    echo "  claude"
else
    echo ""
    echo "✗ 安装失败，请检查网络连接或权限设置"
    echo "提示: 如果遇到权限问题，请尝试使用 sudo 运行此脚本"
    exit 1
fi

echo ""
echo "========================================="
echo "重装完成"
echo "========================================="