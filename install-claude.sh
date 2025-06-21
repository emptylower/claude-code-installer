#!/bin/bash

set -e

echo "开始安装 Claude Code 环境..."

# 检查操作系统
OS="$(uname)"
if [[ "$OS" != "Darwin" && "$OS" != "Linux" ]]; then
    echo "错误：仅支持 macOS 和 Linux 系统"
    exit 1
fi

# 函数：检查版本号是否大于等于要求的版本
version_compare() {
    printf '%s\n%s' "$1" "$2" | sort -V | head -n1
}

# 函数：检查 Node.js 版本
check_nodejs_version() {
    if command -v node >/dev/null 2>&1; then
        current_version=$(node --version | sed 's/v//')
        required_version="18.19.0"
        
        if [[ "$(version_compare "$current_version" "$required_version")" == "$required_version" ]]; then
            echo "Node.js 版本 $current_version 满足要求 (>= $required_version)"
            return 0
        else
            echo "Node.js 版本 $current_version 不满足要求 (>= $required_version)"
            return 1
        fi
    else
        echo "未检测到 Node.js"
        return 1
    fi
}

# 函数：安装 NVM
install_nvm() {
    echo "正在安装 NVM..."
    
    # 尝试使用 curl，失败则使用 wget
    if command -v curl >/dev/null 2>&1; then
        curl -o- https://gitee.com/mirrors/nvm/raw/v0.39.0/install.sh | bash
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- https://gitee.com/mirrors/nvm/raw/v0.39.0/install.sh | bash
    else
        echo "错误：需要 curl 或 wget 来下载 NVM"
        exit 1
    fi
    
    # 重新加载环境变量
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    # 检测 shell 类型并配置
    if [[ "$SHELL" == *"zsh"* ]]; then
        PROFILE="$HOME/.zshrc"
    else
        PROFILE="$HOME/.bashrc"
    fi
    
    # 配置 NVM 国内镜像
    echo "正在配置 NVM 国内镜像..."
    export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/
    export NVM_NPM_MIRROR=https://npmmirror.com/mirrors/npm/
    
    # 永久保存配置
    echo 'export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/' >> "$PROFILE"
    echo 'export NVM_NPM_MIRROR=https://npmmirror.com/mirrors/npm/' >> "$PROFILE"
    
    source "$PROFILE" 2>/dev/null || true
}

# 函数：通过 NVM 安装 Node.js
install_nodejs_via_nvm() {
    echo "正在通过 NVM 安装 Node.js..."
    
    # 确保 NVM 已加载
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # 安装 Node.js 18.19.0
    nvm install 18.19.0
    nvm use 18.19.0
    nvm alias default 18.19.0
    
    # 配置 NPM 镜像
    echo "正在配置 NPM 镜像..."
    npm config set registry https://registry.npmmirror.com
    
    # 验证安装
    echo "Node.js 版本: $(node --version)"
    echo "NPM 版本: $(npm --version)"
    echo "NPM 镜像: $(npm config get registry)"
}

# 函数：安装 Claude Code
install_claude_code() {
    echo "正在检查已安装的 Claude Code..."
    
    # 检查是否已安装 Claude Code
    if npm list -g @anthropic-ai/claude-code >/dev/null 2>&1; then
        echo "检测到已安装的 Claude Code，正在卸载..."
        npm uninstall -g @anthropic-ai/claude-code
    fi
    
    echo "正在安装 Claude Code..."
    npm install -g https://aicodewith.com/claudecode/install --registry=https://registry.npmmirror.com
    
    echo "Claude Code 安装完成！"
}

# 主流程
echo "第一步：检查 Node.js 版本..."
if ! check_nodejs_version; then
    echo "检查 NVM 是否可用..."
    if ! command -v nvm >/dev/null 2>&1; then
        # 尝试加载 NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        if ! command -v nvm >/dev/null 2>&1; then
            echo "NVM 未安装，正在安装 NVM..."
            install_nvm
        fi
    fi
    
    echo "第二步：安装 Node.js..."
    install_nodejs_via_nvm
    
    # 再次检查 Node.js 版本
    if ! check_nodejs_version; then
        echo "错误：Node.js 安装失败"
        exit 1
    fi
else
    echo "Node.js 版本检查通过"
fi

echo "第三步：安装 Claude Code..."
install_claude_code

echo ""
echo "🎉 安装完成！"
echo ""
echo "请运行以下命令重新加载环境变量："
if [[ "$SHELL" == *"zsh"* ]]; then
    echo "source ~/.zshrc"
else
    echo "source ~/.bashrc"
fi
echo ""
echo "或者重新打开终端，然后运行 'claude-code' 命令开始使用。"