<p align="center"><img src="Assets/Features/Plugin%20UI%20v1.2.png" width="80%" alt="View of full plugin" /></p>

# MAD-a-Sample

[![WIP](https://img.shields.io/badge/status-WIP-orange)](https://github.com/BOBONA/Just-a-Sample)

[English](README.md) | [中文](README.zh-CN.md)

> **Make any sample playable. Make it MAD.**

[See upstream releases](https://github.com/BOBONA/Just-a-Sample/releases)

Available for Windows, Mac, and Linux in VST3/AU.

## Overview

**MAD-a-Sample** is a modulation-first open-source sampler synthesizer designed for 音MAD, YTPMV, vocal chopping, and sample-based sound design.

This plugin is a fork of [Just-a-Sample](https://github.com/BOBONA/Just-a-Sample). Unlike Just-a-Sample, which targets general users, MAD-a-Sample serves a specific creative community.

The pain point it addresses is not that traditional samplers lack features, but that most lack the ability to turn a sample into a genuine instrument — yet synthesizers already have excellent benchmarks, so I built one. The interaction philosophy is inspired by the modulation-first workflow of modern synthesizers such as Vital.

> Most of the content below is AI-generated and its accuracy is not guaranteed.

### What MAD-a-Sample Is

> **Load any sound, and within a minute turn it into a playable, modulatable, saveable synth patch.**

- A **sample synthesizer** — the waveform is your oscillator, the sampler is your synth engine.
- A tool that makes modulation **visible, direct, and drag-and-drop**.
- An instrument where every voice has its own independent LFO phase, envelope state, filter, and randomization.

### What MAD-a-Sample Is Not

- **Not a Kontakt competitor** — no multi-sample mapping, round robin, disk streaming, or library management.
- **Not an effect suite** — complex reverb, delay, compression, and mastering are left to your existing plugin chain.
- **Not a sample editor** — it does not crop, normalize, or batch-process audio files.

## Design Philosophy: Architecture Boundaries

MAD-a-Sample follows a clear principle:

> **If a feature can be done equally well by an external plugin, leave it out. If it depends on the voice lifecycle, it must be built in.**

The line is drawn at the **voice boundary**. Everything that needs to understand individual voice state — its playback position, its envelope phase, its LFO angle, its note velocity — belongs inside the sampler. Everything that only processes the final mixed audio can stay outside.

### Stays Inside (Voice-Dependent)

| Category | Examples |
|---|---|
| **Amplitude shaping** | Amp ADSR, modulation envelopes |
| **Per-voice modulation** | LFO per voice, velocity, key tracking, note random |
| **Per-voice filtering** | State-variable filter with per-note envelope |
| **Sample playback** | Start/loop/release regions, reverse, ping-pong, one-shot, gate |
| **Time & pitch** | Per-voice pitch shifting with formant preservation (planned), playback speed modulation |
| **Voice management** | Mono, legato, glide, voice stealing, unison (planned) |
| **Modulation routing** | Drag-and-drop modulation, 16-slot matrix, macros |

### Stays Outside (Global Processing)

Reverb, delay, compression, multi-band EQ, advanced distortion, chorus, flanger, phaser, spectral processing, and mastering — all better served by your DAW's native plugins or dedicated third-party effects.

**This is not a compromise. It is a design decision.** By narrowing scope, MAD-a-Sample can go deeper on the things only a sampler can do.

## Features

### Current (inherited from Just-a-Sample v1.3)

- Smooth waveform visualization with sample-level zoom
- Integrated [Bungee time stretcher](https://github.com/kupix/bungee) — independent time and pitch modulation (0.01x–5x)
- Basic resampling with Lanczos interpolation and anti-aliasing
- Loop crossfading with separate attack, loop, and release sample regions
- Waveform Mode — loop tiny bounds like a wavetable synth
- Attack and release envelope with adjustable curves
- Routable FX chain (reverb, chorus, distortion, EQ)
- Direct recording into the plugin
- Sample embedding in plugin state
- Pitch detection and auto-tune (experimental)
- MTS-ESP microtuning support
- REAPER-specific integration (undo/redo, ReaScript file loading)

### Planned (MAD-a-Sample Roadmap)

**Phase 1 — Stability & Foundation**
- Test coverage for offline rendering, block sizes, sample rate switching
- Fix known crashes on Linux and macOS export
- Separate playback state machine from amp envelope (enable true ADSR)

**Phase 2 — Modulation Engine**
- Per-voice modulation architecture (ENV / LFO / Velocity / Keytrack / Random)
- 16-slot modulation matrix
- 2 LFOs per voice
- 1 modulation ADSR per voice
- 4 assignable macros

**Phase 3 — Per-Voice Filter & Sound Shaping**
- State-variable filter per voice (LP/BP/HP)
- Filter envelope and key tracking
- Per-voice pan, gain, and pitch modulation targets

**Phase 4 — Vital-Style Modulation UI**
- Drag LFO icon onto any knob to assign modulation
- Visual modulation rings on every modulated parameter
- Click-and-drag to adjust modulation amount directly on the knob
- Real-time waveform and filter response preview

**Phase 5 — Extended Playback & Advanced**
- Reverse, ping-pong, random start, release loop
- Unison with voice spread
- Formant-preserved pitch shifting
- MSEG (multi-segment envelope generator)

## Quick Comparison

| | RS5K (ReaSamplOmatic5000) | MAD-a-Sample | Kontakt |
|---|---|---|---|
| **Philosophy** | Simple, modular building block | Sample as synthesizer | Multi-sample workstation |
| **Modulation** | Host-level parameter modulation only | Per-voice LFO, ENV, velocity, keytrack, drag-and-drop | Deep but complex, script-based |
| **Voice independence** | None (plugin-global modulation) | Every voice carries its own state | Yes |
| **Sample mapping** | One sample per instance | One sample, deep sound design | Multi-sample, velocity layers, round robin |
| **Learning curve** | Minimal | Shallow start, progressive depth | Steep |
| **Target user** | General DAW users | 音MAD / YTPMV / sound designers | Professional composers, sound libraries |

## Installation

### Pre-built

Pre-built binaries are available from the original Just-a-Sample project:
- [itch.io](https://binyaminf.itch.io/just-a-sample)
- [GitHub Releases](https://github.com/BOBONA/Just-a-Sample/releases)

MAD-a-Sample builds will be published separately as the fork diverges.

### Build from Source

```bash
# Clone the repository
git clone --recurse-submodules https://github.com/BOBONA/Just-a-Sample/.git

# Go to the project root
cd Just-a-Sample

# Configure the plugin (replace <platform> with windows, mac, or linux)
cmake --preset=<platform>

# Build the plugin
cmake --build --preset=release-<platform>
```

Note that the first time you configure the project, CMake will download JUCE and other dependencies, which may take a while.

Your built plugin will be located in `out/build/<platform>/<configuration>/JustASample_artefacts/<Configuration>/<format>/` where `<platform>` is windows, mac, or linux, `<configuration>` is either debug or release, and `<format>` is either VST3 or AU (Mac only).

#### Build Options

You can set the following CMake options by passing `-D<option>=<value>` to the CMake configure step.

- `JAS_DARKMODE_DEFAULT`: Set the default theme to dark mode (default: OFF)
- `JAS_VST3_REAPER_INTEGRATION`: Enable Reaper-specific VST3 extensions (Windows only, default: OFF)

#### Requirements

**All Platforms:**
- Git
- CMake 3.22 or higher
- Platform-specific build tools

**Windows:**
- Ninja build system
- Visual Studio 2019 or later

**macOS:**
- Xcode 12 or later

**Linux:**
- GCC 9+
- Ninja build system
- JUCE dependencies (install via the provided script, or do it yourself):
  ```bash
  ./Releases/Linux/install-dependencies.sh
  ```

## Dependencies & Licenses

MAD-a-Sample inherits and will extend the dependency stack of Just-a-Sample. License awareness is critical for a long-term open-source project.

| Dependency | Purpose | License |
|---|---|---|
| [JUCE 8](https://juce.com/) | Plugin framework & UI | AGPLv3 / Commercial |
| [Bungee](https://bungee.parabolaresearch.com/) | Time-stretching & pitch-shifting | MPL-2.0 |
| [Melatonin Blur](https://melatonin.dev/manuals/melatonin-blur/) | Fast shadow compositing | MIT |
| [LEAF](https://github.com/spiricom/LEAF) | Pitch detection | MIT |
| [readerwriterqueue](https://github.com/cameron314/readerwriterqueue) | Lock-free queue | Simplified BSD |
| [Gin](https://github.com/FigBug/Gin) | Distortion & reverb algorithms | MIT |
| [MTS-ESP](https://github.com/ODDSound/MTS-ESP/tree/main/Client) | Microtuning | Permissive (vendor) |
| [reaper-sdk](https://github.com/justinfrankel/reaper-sdk) | REAPER VST3 extensions | Permissive |

**MAD-a-Sample itself remains MIT**, following the original Just-a-Sample license. Dependencies carry their own licenses — notably JUCE 8 under AGPLv3, which may affect closed-source distribution. Commercial JUCE licensing is available for proprietary use.

## Credits

MAD-a-Sample is a fork of **Just-a-Sample** by [Binyamin Friedman](https://github.com/BOBONA), who built an excellent foundation with clean architecture, modern JUCE practices, and thoughtful design. This project exists because an already-great sampler had the right DNA to become something more specialized.

Special thanks to JUCE and The Audio Programmer community for resources and guidance.
