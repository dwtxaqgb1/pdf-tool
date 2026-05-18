# PDF省墨打印工具

一个运行在飞牛NAS上的Web版PDF处理工具，支持二值化、反色、拖拽裁剪等功能。

## 🚀 功能特性

### 📄 处理PDF
- 上传PDF文件进行二值化处理
- 支持反色处理（适合黑底白字图片）
- 可调节二值化阈值（80-180，越小越省墨）
- 去噪点、锐化增强
- 实时进度条 + 计时显示

### 🖼️ 处理图片
- 批量添加图片
- 列表/缩略图两种视图模式
- 拖拽裁剪功能
- 合成PDF（A4/A3/Letter/自适应）

## 🐳 Docker 部署

Text

126
    exit 1
127
fi
128
echo -e "${GREEN}✅ 容器启动成功${NC}"
129
echo ""
130
​
131
# 10. 等待容器启动
132
echo "⏳ 等待容器启动..."
133
sleep 3
134
​
135
# 11. 查看容器状态
136
echo ""
137
echo "📊 容器状态:"
138
docker ps --filter "name=pdf-tool" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
139
​
140
# 12. 查看日志
141
echo ""
142
echo "📋 容器日志:"
143
docker logs --tail 20 pdf-tool
144
​
145
# 13. 获取 NAS IP
146
NAS_IP=$(ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)
147
​
148
echo ""
149
echo "=========================================="
150
echo -e "${GREEN}🎉 部署完成！${NC}"
151
echo "=========================================="
152
echo ""
153
echo "🌐 访问地址: http://${NAS_IP}:${PORT}"
154
echo "📁 项目目录: $PROJECT_DIR"
155
echo "📋 查看日志: docker logs pdf-tool"
156
echo "🛑 停止容器: docker stop pdf-tool"
157
echo "🚀 启动容器: docker start pdf-tool"
158
echo "🔄 重启容器: docker restart pdf-tool"
159
echo "🗑 删除容器: docker rm -f pdf-tool"
160
echo ""
161
echo "=========================================="


## 📄 许可证

MIT License

## 📸 界面截图

### 处理PDF页面
![处理PDF页面](images/screenshot_20260518_125328_com.huawei.hmos.browser.png)

### 处理图片页面
![处理图片页面](images/screenshot_20260518_125337_com.huawei.hmos.browser.png)

### 功能展示
更多功能请访问项目主页体验。

## 🔄 重新部署（更新代码后）

当项目有更新时，按以下步骤重新部署：

### 方法一：快速重新部署

```bash
# 进入项目目录
cd /vol1/1000/docker/pdf_tool_web

# 拉取最新代码
git pull

# 重新构建镜像
docker build -t pdf-tool:latest .

# 停止并删除旧容器
docker stop pdf-tool
docker rm pdf-tool

# 运行新容器
docker run -d \
  --name pdf-tool \
  --restart unless-stopped \
  -p 5200:8080 \
  -v $(pwd)/data:/tmp/pdf_tool \
  pdf-tool:latest

# 查看日志确认运行正常
docker logs pdf-tool
