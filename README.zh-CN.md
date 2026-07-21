<p align="center"><img src="Assets/Features/Plugin%20UI%20v1.2.png" width="80%" alt="插件完整界面" /></p>

# MAD-a-Sample

[![WIP](https://img.shields.io/badge/status-WIP-orange)](https://github.com/BOBONA/Just-a-Sample)

[English](README.md) | [中文](README.zh-CN.md)

> **为 音MAD 而造的采样器。**

[查看上游的发布版本](https://github.com/BOBONA/Just-a-Sample/releases)

支持 Windows、Mac、Linux，提供 VST3/AU 格式。

## 概述

**MAD-a-Sample** 是一款调制优先的开源采样合成器，专为音MAD、YTPMV、人声切片以及基于采样的声音设计而打造。

本插件为  [Just-a-Sample](https://github.com/BOBONA/Just-a-Sample) 的分支。与 Just-a-Sample 面向大众不同的是，MAD-a-Sample 服务于明确的创作社群。

旨在解决的痛点并不是传统采样器功能少，而是大多都缺失将采样乐器化的能力，可合成器里已经有很好的标杆，所以我就这么做了。本插件交互理念受 Vital 等现代合成器的"调制优先"工作流启发。

> 以下内容大多为 AI 编写，不确保正确性。

### MAD-a-Sample 是什么

> **加载任意一个声音，在一分钟内把它变成可演奏、可调制、可保存的合成器音色。**

- 一个**采样合成器**——波形就是你的振荡器，采样器就是你的合成引擎。
- 一个让调制关系**可见、直接、可拖放**的工具。
- 一件每个 voice 都拥有独立 LFO 相位、包络状态、滤波器和随机值的乐器。

### MAD-a-Sample 不是什么

- **不是 Kontakt 的竞争者**——不做多采样映射、Round Robin、磁盘流式加载和音色库管理。
- **不是效果器合集**——复杂的混响、延迟、压缩、母带处理留给已有的插件链。
- **不是采样编辑器**——不做裁剪、归一化、批量处理音频文件。

## 设计主旨：架构边界主义

MAD-a-Sample 遵循一条清晰的判断原则：

> **凡是外部插件能等效完成的功能，尽量留在外部；凡是依赖 voice 生命周期的能力，必须在内部实现。**

边界画在 **voice 边界** 上。任何需要理解单个 voice 状态的能力——播放位置、包络阶段、LFO 角度、音符力度——都必须进入采样器内部。仅处理最终混合音频的能力，则可以留在外部。

### 留在内部（Voice 依赖）

| 类别 | 具体内容 |
|---|---|
| **振幅塑形** | Amp ADSR、调制包络 |
| **每声部调制** | 每声部 LFO、力度、键位追踪、音符随机 |
| **每声部滤波** | 状态变量滤波器（每音符独立包络） |
| **采样播放** | 起始/循环/释放区域、倒放、乒乓、One-shot、Gate |
| **时间与音高** | 每声部变调与共振峰保留（计划中）、播放速度调制 |
| **声部管理** | 单音、Legato、Glide、Voice Stealing、Unison（计划中） |
| **调制成形** | 拖放调制、16 槽调制矩阵、Macro 旋钮 |

### 留在外部（全局处理）

混响、延迟、压缩器、多段 EQ、高级失真、合唱、镶边、移相、频谱处理、母带——这些全部由 DAW 原生插件或专门的第三方效果器代劳即可。

**这不是妥协，而是设计选择。** 通过收窄范围，MAD-a-Sample 能在只有采样器才能做好的事情上走得更深。

## 功能特性

### 当前功能（继承自 Just-a-Sample v1.3）

- 流畅的波形可视化，支持缩放到单个采样点级别
- 集成 [Bungee 时间伸缩算法](https://github.com/kupix/bungee)——独立的时间与音高调制（0.01x–5x）
- Basic 重采样模式，Lanczos 插值与抗混叠
- 等功率循环交叉淡化，独立的 Attack、Loop、Release 采样区域
- Waveform Mode——将极小范围循环播放，如同波表合成器
- 起音与释音包络，可调节曲线
- 可自由排列顺序的效果链（混响、合唱、失真、EQ）
- 直接在插件内录制采样
- 采样嵌入插件状态（可关闭）
- 音高检测与自动调谐（实验性）
- MTS-ESP 微分音支持
- REAPER 深度集成（撤销/重做、ReaScript 文件加载）

### 开发路线图（MAD-a-Sample 计划）

**第一阶段——稳定性与基础**
- 离线渲染、不同 block size、采样率切换的测试覆盖
- 修复 Linux 和 macOS 上的已知崩溃
- 将播放状态机与 Amp Envelope 解耦（为真正的 ADSR 铺路）

**第二阶段——调制引擎**
- 每声部调制架构（ENV / LFO / Velocity / Keytrack / Random）
- 16 槽调制矩阵
- 每声部 2 个 LFO
- 每声部 1 个调制 ADSR
- 4 个可分配 Macro 旋钮

**第三阶段——每声部滤波器与声音塑形**
- 每声部状态变量滤波器（LP/BP/HP）
- 滤波器包络与键位追踪
- 每声部的声像、增益和音高调制目标

**第四阶段——Vital 式调制 UI**
- 将 LFO 图标拖到任意旋钮即可建立调制连接
- 每个被调制的旋钮外圈显示调制范围与方向
- 点击调制环直接拖拽调整调制量
- 波形与滤波器响应的实时可视化预览

**第五阶段——扩展播放模式与高级功能**
- 倒放、乒乓、随机起点、Release Loop
- Unison 声部扩展
- 保留共振峰的变调
- MSEG（多段包络发生器）

## 快速对比

| | RS5K (ReaSamplOmatic5000) | MAD-a-Sample | Kontakt |
|---|---|---|---|
| **设计哲学** | 简单、模块化的积木 | 把采样当作合成器 | 多采样工作站 |
| **调制能力** | 仅宿主级参数调制 | 每声部 LFO、ENV、力度、键位追踪、拖放调制 | 深度但复杂，依赖脚本 |
| **Voice 独立性** | 无（插件全局调制） | 每个 voice 独立持有状态 | 是 |
| **采样映射** | 每个实例一个采样 | 单个采样、深度声音设计 | 多采样、力度分层、Round Robin |
| **学习曲线** | 极低 | 入门平缓，渐进深入 | 陡峭 |
| **目标用户** | 一般 DAW 用户 | 音MAD / YTPMV / 声音设计师 | 专业作曲家、音色库制作者 |

## 安装

### 预构建

预构建二进制文件可从原版 Just-a-Sample 项目获取：
- [itch.io](https://binyaminf.itch.io/just-a-sample)
- [GitHub Releases](https://github.com/BOBONA/Just-a-Sample/releases)

MAD-a-Sample 将随 Fork 分化后单独发布构建版本。

### 从源码构建

```bash
# 克隆仓库
git clone --recurse-submodules https://github.com/BOBONA/Just-a-Sample/.git

# 进入项目根目录
cd Just-a-Sample

# 配置插件（将 <platform> 替换为 windows、mac 或 linux）
cmake --preset=<platform>

# 构建插件
cmake --build --preset=release-<platform>
```

首次配置项目时，CMake 会下载 JUCE 及其他依赖，可能需要一些时间。

构建产物位于 `out/build/<platform>/<configuration>/JustASample_artefacts/<Configuration>/<format>/`，其中 `<platform>` 为 windows、mac 或 linux，`<configuration>` 为 debug 或 release，`<format>` 为 VST3 或 AU（仅 Mac）。

#### 构建选项

可在 CMake 配置阶段通过 `-D<option>=<value>` 设置以下选项：

- `JAS_DARKMODE_DEFAULT`：默认启用暗色主题（默认：OFF）
- `JAS_VST3_REAPER_INTEGRATION`：启用 REAPER 专用 VST3 扩展（仅 Windows，默认：OFF）

#### 环境要求

**所有平台：**
- Git
- CMake 3.22 或更高
- 平台对应的构建工具

**Windows：**
- Ninja 构建系统
- Visual Studio 2019 或更高

**macOS：**
- Xcode 12 或更高

**Linux：**
- GCC 9+
- Ninja 构建系统
- JUCE 依赖（通过提供的脚本安装，或自行安装）：
  ```bash
  ./Releases/Linux/install-dependencies.sh
  ```

## 依赖与许可证

MAD-a-Sample 继承并将在未来扩展 Just-a-Sample 的依赖栈。对长期开源项目而言，许可证意识至关重要。

| 依赖 | 用途 | 许可证 |
|---|---|---|
| [JUCE 8](https://juce.com/) | 插件框架与 UI | AGPLv3 / 商业许可 |
| [Bungee](https://bungee.parabolaresearch.com/) | 时间伸缩与变调 | MPL-2.0 |
| [Melatonin Blur](https://melatonin.dev/manuals/melatonin-blur/) | 快速阴影合成 | MIT |
| [LEAF](https://github.com/spiricom/LEAF) | 音高检测 | MIT |
| [readerwriterqueue](https://github.com/cameron314/readerwriterqueue) | 无锁队列 | Simplified BSD |
| [Gin](https://github.com/FigBug/Gin) | 失真与混响算法 | MIT |
| [MTS-ESP](https://github.com/ODDSound/MTS-ESP/tree/main/Client) | 微分音支持 | Permissive（厂商） |
| [reaper-sdk](https://github.com/justinfrankel/reaper-sdk) | REAPER VST3 扩展 | Permissive |

**MAD-a-Sample 本身保持 MIT 许可证**，沿袭原版 Just-a-Sample。各依赖有其独立许可证——特别需要注意 JUCE 8 使用 AGPLv3，可能影响闭源分发。商业 JUCE 许可证适用于闭源使用场景。

## 致谢

MAD-a-Sample Fork 自 [Binyamin Friedman](https://github.com/BOBONA) 的 **Just-a-Sample**。原作者以干净的架构、现代化的 JUCE 实践和深思熟虑的设计，奠定了坚实的基础。这个项目之所以成立，是因为一个本已优秀的采样器，恰好拥有成长为更专精工具的正确基因。

感谢 JUCE 和 The Audio Programmer 社区提供的资源和指导。
