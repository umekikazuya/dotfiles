# My Dotfiles

This is my dotfiles!!

## Installation

### 1. **Clone this repository:**

```bash
ghq get https://github.com/umekikazuya/dotfiles.git
# git clone https://github.com/umekikazuya/dotfiles.git ~/src/github.com/umekikazuya/dotfiles
```

### 2. Set up

```bash
cd <リポジトリルート>
./scripts/bootstrap.sh
```

### 3. Restart terminal

```bash
source ~/.zshrc
```

## Fonts (optional)

Alacritty では [yuru7/mint-mono](https://github.com/yuru7/mint-mono) に Nerd Fonts のグリフをパッチしたものを使用。

```bash
./scripts/build-mintmono-nf.sh
```

依存: `docker` (colima などで起動済み), `gh`, `unzip`。
デフォルトで通常版と 35 版の両方をインストール。片方だけ欲しい場合は `--variant normal` / `--variant 35` を指定。

