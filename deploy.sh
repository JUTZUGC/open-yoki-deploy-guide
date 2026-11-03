#!/usr/bin/env bash
set -euo pipefail
# open-yoki 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/jacke-pp/open-yoki#readme
# 更新日期：2026-11-03
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/jacke-pp/open-yoki.git
cd open-yoki
sudo bash deploy/install.sh
echo "先填 /etc/livehost/livehost.env 里的 Key，再 systemctl start livehost"

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://127.0.0.1:4370"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://127.0.0.1:4370" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://127.0.0.1:4370，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://127.0.0.1:4370 确认"
fi
echo "部署完成，浏览器访问 http://127.0.0.1:4370"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/jacke-pp/open-yoki#readme"
