# 📄 PDF省墨打印工具

一个运行在飞牛NAS上的Web版PDF处理工具，支持二值化、反色、拖拽裁剪等功能，帮助打印时大幅节省墨水/碳粉。

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/dwtxaqgb1/pdf-tool?style=flat-square)](https://github.com/dwtxaqgb1/pdf-tool/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/dwtxaqgb1/pdf-tool?style=flat-square)](https://github.com/dwtxaqgb1/pdf-tool/network)
[![GitHub license](https://img.shields.io/github/license/dwtxaqgb1/pdf-tool?style=flat-square)](https://github.com/dwtxaqgb1/pdf-tool/blob/main/LICENSE)
[![Docker Pulls](https://img.shields.io/badge/docker-ready-blue?style=flat-square&logo=docker)](https://hub.docker.com/)

</div>

---

## 📸 界面截图

| 处理PDF页面 | 处理图片页面 | 裁剪功能 |
|------------|------------|----------|
| ![PDF页面](images/screenshot_20260518_125328_com.huawei.hmos.browser.png) | ![图片页面](images/screenshot_20260518_125337_com.huawei.hmos.browser.png) | ![裁剪](images/screenshot_crop.png) |

---

## 🚀 功能特性

### 📄 处理PDF
| 功能 | 说明 |
|------|------|
| 二值化处理 | 将PDF中的图片转为纯黑白，大幅省墨 |
| 反色处理 | 适合黑底白字的图片（如老照片、扫描件） |
| 阈值调节 | 80-180可调，数值越小底色越白，越省墨 |
| 去噪点 | 去除图片中的小斑点，让页面更干净 |
| 锐化 | 让文字边缘更清晰 |
| 进度条+计时 | 实时显示处理进度和等待时间 |

### 🖼️ 处理图片
| 功能 | 说明 |
|------|------|
| 批量添加 | 支持 jpg/png/bmp/gif 格式，可多选 |
| 两种视图 | 列表模式 / 缩略图模式自由切换 |
| 拖拽裁剪 | 手指/鼠标拖拽选择裁剪区域，可调整大小 |
| 图片排序 | 上移/下移调整图片顺序 |
| 合成PDF | 支持A4/A3/Letter/自适应页面大小 |

---

## ⚙️ 参数说明

| 参数 | 说明 | 推荐值 |
|------|------|--------|
| 反色处理 | 黑底白字时勾选，白底黑字不勾选 | 视图片而定 |
| 二值化阈值 | 越小底色越白，越省墨 | 100-130 |
| 去噪点 | 去除斑点，让图片更干净 | 开启 ✅ |
| 锐化 | 让文字更清晰 | 开启 ✅ |
| 页面大小 | 输出PDF的页面尺寸 | A4 |

---

## 🐳 一键部署

### 方法一：使用一键部署脚本（推荐）

```bash
# 1. 克隆项目（使用加速地址，国内用户推荐）
git clone https://github.dwtxaqgb.eu.org/https://github.com/dwtxaqgb1/pdf-tool.git
cd pdf-tool

# 2. 给脚本执行权限
chmod +x upload.sh

# 3. 一键部署
./upload.sh

