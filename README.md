# 📘 ICPC Handbook

This repository contains a **competitive programming handbook** designed for ICPC-style contests.

## 🎯 Purpose

The goal of this handbook is to provide a **quick reference during contests**, including:

* Common algorithms and data structures
* Code templates and snippets
* Useful formulas and tricks
* Notes for fast problem solving under pressure

It is meant to be:

* **Concise** → no long explanations
* **Practical** → ready-to-use code
* **Reliable** → tested during practice and contests

---

# ⚙️ 1. SETUP (install everything)

## 🐧 Linux (Ubuntu / WSL)

Copy and paste:

```bash
sudo apt update
sudo apt install -y git make texlive-full
```

(optional, only if you want auto-rebuild)

```bash
sudo apt install -y entr
```

---

## 🪟 Windows

1. Install Git:
   https://git-scm.com/download/win

2. Install LaTeX (MiKTeX):
   https://miktex.org/download

During installation, enable:

> ✅ Install missing packages automatically

Then open **Git Bash**.

---

## 🍎 macOS

Copy and paste:

```bash
/ bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git
brew install --cask mactex
```

---

# 📥 2. DOWNLOAD (git)

Copy and paste:

```bash
git clone https://github.com/Felipe-Focil/Handbook.git
cd Handbook
```

---

# 🛠️ 3. COMPILE (make)

## Full build (recommended)

```bash
make
```

## Fast build

```bash
make once
```

## Auto rebuild (optional)

```bash
make watch
```

## Open PDF

```bash
make open
```

Output file:

```
main.pdf
```

---

# 🧹 Notes (important)

* All build files go into:

```
.build/
```

* Extra cache (safe to ignore):

```
_markdown_cache/
```

These are ignored by Git, so you don’t need to worry about them.

