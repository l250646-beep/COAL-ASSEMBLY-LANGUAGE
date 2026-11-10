# COAL-ASSEMBLY-LANGUAGE
8086 Assembly Language assignments using NASM and DOSBox
# COAL — 8086 Assembly Language Programs

## Student Information
- **Name:** Amna Hasan
- **Roll Number:** l250646
- **Course:** Computer Organization and Assembly Language (COAL)
- **University:** FAST-NUCES, Lahore Campus
- **Semester:** Fall 2026
- **Section:** bcs-3h

## About This Repository
This repository contains my COAL assignments implemented using 16-bit 8086 Assembly Language.

## Tools Used
- NASM Assembler
- DOSBox 0.74-3
- Visual Studio Code
- Git and GitHub

## Assignment 3 — Text Viewport Manager

The program implements a text viewport using direct video memory access at segment `B800h`.

### Features
- 80 × 25 screen initialization
- Double-line bordered window
- Multi-line text display
- Bounded scrolling using `MOVSW`
- Keyword searching using `SCASB` and `REPE CMPSB`
- Highlighting of matching keywords
- Live match counter and status bar
- Keyboard controls for scrolling and exiting

### How to Run

Assemble the source file:

```bash
nasm -f bin 1250646_a3.asm -o 1250646_a3.com
```

Open DOSBox, mount the directory containing the compiled program, and execute:

```text
1250646_a3.com
```

### Keyboard Controls
- **S:** Scroll upward by two lines
- **Esc:** Exit the program

## Folder Structure

```text
COAL-Assembly-Programs/
├── README.md
└── Assignment3/
    ├── 1250646_a3.asm
    └── screenshots/
        └── viewport-output.png

## Notes
The program uses stack-based subroutine parameters, BP-relative addressing, and 8086 string instructions.
