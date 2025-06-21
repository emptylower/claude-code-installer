# Claude Code 一键安装脚本

适用于 macOS 和 Linux 系统的 Claude Code 自动化安装脚本。

## 功能特点

- 🚀 自动检测系统环境（macOS/Linux）
- 📦 智能检查 Node.js 版本（≥18.19.0）
- 🔧 自动安装 NVM（使用国内镜像）
- ⚡ 通过 NVM 安装 Node.js 并配置 NPM 镜像
- 🎯 卸载旧版本并安装最新 Claude Code
- 🌐 使用国内镜像加速下载
- 🔄 自动检测 shell 类型（bash/zsh）
- ✅ 完善的错误处理和版本验证

## 使用方法

1. 下载脚本：
```bash
curl -O https://raw.githubusercontent.com/jianjieli/claude-code-installer/main/install-claude.sh
```

2. 添加执行权限：
```bash
chmod +x install-claude.sh
```

3. 运行安装：
```bash
./install-claude.sh
```

4. 安装完成后，重新加载环境变量：
```bash
# bash 用户
source ~/.bashrc

# zsh 用户（macOS 默认）
source ~/.zshrc
```

5. 开始使用：
```bash
claude-code
```

## 安装步骤

脚本会按以下步骤执行：

1. **检查 Node.js 版本**：如果版本 ≥ 18.19.0 则跳过安装
2. **检查 NVM**：如果未安装则自动安装并配置国内镜像
3. **安装 Node.js**：通过 NVM 安装指定版本并配置 NPM 镜像
4. **安装 Claude Code**：卸载旧版本并安装最新版本

## 系统要求

- 操作系统：macOS 或 Linux
- 网络工具：curl 或 wget
- Shell：bash 或 zsh

## 故障排除

如果安装过程中遇到问题，请检查：

1. 网络连接是否正常
2. 是否有足够的磁盘空间
3. 是否有相应的权限

## 许可证

MIT License