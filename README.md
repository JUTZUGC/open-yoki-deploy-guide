# open-yoki 一键部署指南

> 第三方部署指南 · 非 open-yoki 官方仓库。官方项目：[jacke-pp/open-yoki](https://github.com/jacke-pp/open-yoki)
> 内容来自官方文档（2026-11-03）。项目迭代快，请以[官方文档](https://github.com/jacke-pp/open-yoki#readme)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 直播间里那个一直在说话的人，可以是一台服务器。

⚠️ 只支持 Ubuntu 22.04/24.04 x86_64，安装脚本要 root，会装 ffmpeg、Chrome、Node 22、Claude Code 与 Caddy。没有 API Key 时大脑与声音关闭，形象是静态图。网页直播间只监听 127.0.0.1，对外必须用 Caddy 加域名。推流要在币安广场直播后台开播，并填入每场的推流密钥。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/open-yoki-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会在一台 Ubuntu 服务器上跑安装脚本，装好 Chrome、Node、Caddy 与 systemd 服务，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:4370](http://127.0.0.1:4370)，按官方引导完成初始化配置。

## open-yoki 是什么？

open-yoki 是开源的一台 Ubuntu 服务器撑起一个会说话、会看弹幕、会道谢的虚拟主播（协议：MIT，<img src="https://img.shields.io/github/stars/jacke-pp/open-yoki?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

单机运行的 AI 直播主播：无头 Chrome 绘制 16:9 画面，ffmpeg 推 RTMP，快模型回弹幕，语音合成与形象驱动，配合弹幕、礼物与关注事件做回应。

- 一台 Ubuntu 服务器跑完整直播
- 弹幕、礼物与关注都有回应
- 无头 Chrome 出画面，ffmpeg 推流
- 声音与形象可换供应商
- 直播间只监听本机，Caddy 对外
- MIT，脚本可审

（来源：[官方仓库](https://github.com/jacke-pp/open-yoki)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 855 stars | 名称搜索仅 1 条结果 |
| 一台服务器跑完整直播链路 | — |
| 弹幕、礼物、关注都能回应 | — |
| 安装脚本自带 systemd 与 Caddy 模板 | — |
| 直播间默认只监听本机 | — |
| MIT | 脚本可自行审阅 |

| 需要注意 | 说明 |
|---|---|
| 只支持 Ubuntu x86_64 | — |
| 需要 root 与 systemd | — |
| 必须自备模型与语音 Key | — |
| 推流依赖币安广场后台 | — |
| 内容合规责任在使用者 | — |

> 以上基于官方文档与社区反馈整理（2026-11-03），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/jacke-pp/open-yoki.git
cd open-yoki
sudo bash deploy/install.sh
echo "先填 /etc/livehost/livehost.env 里的 Key，再 systemctl start livehost"
```

启动后浏览器访问 [http://127.0.0.1:4370](http://127.0.0.1:4370)（管理面板）。（来源：[https://github.com/jacke-pp/open-yoki#在自己电脑上试](https://github.com/jacke-pp/open-yoki#在自己电脑上试)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 与 install.sh 确认 Ubuntu x86_64、root 与依赖清单 | 已核对 2026-11-03 |
| 确认 4370 仅监听本机、Caddy 对外与 systemd 服务名 | 已核对 2026-11-03 |
| 未实测安装与推流 | 说明 2026-11-03 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-03 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-03 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供安装步骤、端口与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-03）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\open-yoki-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 服务器要求

| 项目 | 要求 |
|---|---|
| 系统 | Ubuntu 22.04 / 24.04，x86_64 |
| 权限 | root 执行安装脚本 |
| 依赖 | ffmpeg、Chrome、Node 22、Claude Code、Caddy |
| 端口 | 网页直播间 `4370`，默认只监听本机 |

## 安装后

1. 编辑 `/etc/livehost/livehost.env`，填入模型与语音 Key
2. 需要域名与 HTTPS 时，安装时带 `DOMAIN=example.com`
3. `systemctl start livehost` 启动服务
4. 打开 `http://127.0.0.1:4370` 检查画面与配置

## Key 对照

| Key | 用途 |
|---|---|
| `OPENROUTER_API_KEY` | 弹幕回复的快模型 |
| `VOLC_API_KEY` + `DOUBAO_VOICE_ID` | 语音合成 |
| `ANTHROPIC_API_KEY` / DeepSeek | 可选，负责「心」 |
| X API | 可选，发推与回复 |

没有 Key 也能启动，但只能确认配置加载，听不到声音。

## 推流

在币安广场直播后台开播，用 `deploy/set-square.sh` 填入本场推流地址与密钥，或调 `POST /api/square/push`。

## 注意

- Windows 无法部署，脚本依赖 apt 与 systemd
- 不要把 4370 直接暴露公网，用 Caddy
- 模型与语音按量计费，先估算成本
- 直播平台规则与内容合规由使用者负责
- MIT，可自用可二开

## 常见坑

- 脚本报错：确认是 Ubuntu 22.04/24.04 x86_64 且用 root 执行
- 服务起不来：先填 `/etc/livehost/livehost.env`，脚本只 enable 不 start
- 没有声音：检查 VOLC Key 与音色 ID
- 画面空白：确认 Chrome 无头模式能启动，ffmpeg 在 PATH
- 推流失败：推流密钥每场都不同，重新执行 `set-square.sh`
- 外部访问不了：默认只监听 127.0.0.1，用 `DOMAIN=` 让 Caddy 接管
- 成本超预期：先只开模型与语音，关掉可选 X API

## 免责声明

本仓库为第三方指南，与 open-yoki 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-03），项目迭代快，请以[官方文档](https://github.com/jacke-pp/open-yoki#readme)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
