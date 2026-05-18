#!/bin/bash

# 配置信息 - 请修改为你的信息
GITHUB_USERNAME="DWTXAQGB1"
REPO_NAME="pdf-tool"
REPO_DESC="PDF省墨打印工具 - 二值化处理 | 反色处理 | 拖拽裁剪 | 省墨打印"

echo "🚀 开始上传项目到 GitHub..."

# 初始化 Git
git init

# 创建 .gitignore
cat > .gitignore << 'EOF'
__pycache__/
*.py[cod]
*.tar
data/
tmp/
.env
.DS_Store
Thumbs.db
*.log
EOF

# 创建 README.md
cat > README.md << EOF
# PDF省墨打印工具

一个运行在飞牛NAS上的Web版PDF处理工具，支持二值化、反色、拖拽裁剪等功能。

## 🚀 功能特性

- 📄 处理PDF：二值化、反色、阈值调节
- 🖼️ 处理图片：批量添加、拖拽裁剪、合成PDF
- ⏱️ 进度条+计时反馈

## 🐳 Docker 部署

\`\`\`bash
docker build -t pdf-tool:latest .
docker run -d --name pdf-tool -p 5200:8080 pdf-tool:latest
\`\`\`

访问 \`http://你的IP:5200\`

## 📄 许可证

MIT License
EOF

# 添加并提交
git add .
git commit -m "Initial commit: PDF省墨打印工具"

# 创建 GitHub 仓库（需要安装 gh CLI 或手动创建）
echo "请先在 GitHub 上创建仓库: https://github.com/new"
echo "仓库名: $REPO_NAME"
echo ""

# 添加远程仓库
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git

# 推送
git branch -M main
git push -u origin main

echo "✅ 上传完成！"
echo "访问: https://github.com/$GITHUB_USERNAME/$REPO_NAME"