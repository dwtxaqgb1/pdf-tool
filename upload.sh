#!/bin/bash

echo "=========================================="
echo "📄 PDF省墨打印工具 - 一键部署脚本"
echo "=========================================="

# 设置颜色
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 配置
PROJECT_DIR="/vol1/1000/docker/pdf_tool"
GITHUB_REPO="https://github.dwtxaqgb.eu.org/https://github.com/dwtxaqgb1/pdf-tool.git"
PORT="5200"

echo ""
echo "📁 项目目录: $PROJECT_DIR"
echo "🔗 GitHub地址: $GITHUB_REPO"
echo "🌐 访问端口: $PORT"
echo ""

# 1. 停止并删除旧容器
echo "🔍 检查旧容器..."
if docker ps -a --format '{{.Names}}' | grep -q "^pdf-tool$"; then
    echo "🛑 停止旧容器 pdf-tool..."
    docker stop pdf-tool 2>/dev/null
    echo "🗑 删除旧容器 pdf-tool..."
    docker rm pdf-tool 2>/dev/null
    echo -e "${GREEN}✅ 旧容器已删除${NC}"
else
    echo -e "${GREEN}✅ 没有旧容器${NC}"
fi
echo ""

# 2. 删除旧镜像（可选）
echo "🔍 检查旧镜像..."
if docker images --format '{{.Repository}}' | grep -q "^pdf-tool$"; then
    echo "🗑 删除旧镜像 pdf-tool:latest..."
    docker rmi pdf-tool:latest 2>/dev/null
    echo -e "${GREEN}✅ 旧镜像已删除${NC}"
else
    echo -e "${GREEN}✅ 没有旧镜像${NC}"
fi
echo ""

# 3. 删除旧目录（如果存在）
if [ -d "$PROJECT_DIR" ]; then
    echo "🗑 删除旧目录..."
    rm -rf "$PROJECT_DIR"
    echo -e "${GREEN}✅ 旧目录已删除${NC}"
fi
echo ""

# 4. 克隆最新代码
echo "📥 克隆代码从 GitHub..."
git clone "$GITHUB_REPO" "$PROJECT_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 克隆失败，请检查网络和GitHub地址${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 代码克隆成功${NC}"
echo ""

# 5. 进入项目目录
cd "$PROJECT_DIR"

# 6. 确认文件存在
echo "📁 检查项目文件..."
if [ -f "app.py" ]; then
    echo -e "${GREEN}✅ app.py 存在${NC}"
else
    echo -e "${RED}❌ app.py 不存在${NC}"
    exit 1
fi

if [ -f "requirements.txt" ]; then
    echo -e "${GREEN}✅ requirements.txt 存在${NC}"
else
    echo -e "${RED}❌ requirements.txt 不存在${NC}"
    exit 1
fi

if [ -f "Dockerfile" ]; then
    echo -e "${GREEN}✅ Dockerfile 存在${NC}"
else
    echo -e "${RED}❌ Dockerfile 不存在${NC}"
    exit 1
fi

if [ -d "templates" ]; then
    echo -e "${GREEN}✅ templates 目录存在${NC}"
else
    echo -e "${RED}❌ templates 目录不存在${NC}"
    exit 1
fi
echo ""

# 7. 构建 Docker 镜像
echo "🐳 构建 Docker 镜像..."
docker build -t pdf-tool:latest .
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 镜像构建失败${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 镜像构建成功${NC}"
echo ""

# 8. 创建数据目录
mkdir -p "$PROJECT_DIR/data"
echo -e "${GREEN}✅ 数据目录创建成功${NC}"
echo ""

# 9. 运行新容器
echo "🚀 启动新容器..."
docker run -d \
    --name pdf-tool \
    --restart unless-stopped \
    -p ${PORT}:8080 \
    -v ${PROJECT_DIR}/data:/tmp/pdf_tool \
    pdf-tool:latest

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 容器启动失败${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 容器启动成功${NC}"
echo ""

# 10. 等待容器启动
echo "⏳ 等待容器启动..."
sleep 3

# 11. 查看容器状态
echo ""
echo "📊 容器状态:"
docker ps --filter "name=pdf-tool" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 12. 查看日志
echo ""
echo "📋 容器日志:"
docker logs --tail 20 pdf-tool

# 13. 获取 NAS IP
NAS_IP=$(ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)

echo ""
echo "=========================================="
echo -e "${GREEN}🎉 部署完成！${NC}"
echo "=========================================="
echo ""
echo "🌐 访问地址: http://${NAS_IP}:${PORT}"
echo "📁 项目目录: $PROJECT_DIR"
echo "📋 查看日志: docker logs pdf-tool"
echo "🛑 停止容器: docker stop pdf-tool"
echo "🚀 启动容器: docker start pdf-tool"
echo "🔄 重启容器: docker restart pdf-tool"
echo "🗑 删除容器: docker rm -f pdf-tool"
echo ""
echo "=========================================="