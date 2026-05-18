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

\`\`\`bash
docker build -t pdf-tool:latest .
docker run -d --name pdf-tool --restart unless-stopped -p 5200:8080 -v $(pwd)/data:/tmp/pdf_tool pdf-tool:latest
\`\`\`

访问: \`http://你的IP:5200\`

## 📄 许可证

MIT License

## 📸 界面截图

### 处理PDF页面
![处理PDF页面](images/screenshot_20260518_125328_com.huawei.hmos.browser.png)

### 处理图片页面
![处理图片页面](images/screenshot_20260518_125337_com.huawei.hmos.browser.png)

### 功能展示
更多功能请访问项目主页体验。
