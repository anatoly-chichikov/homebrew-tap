# Anatoly-chichikov Tap

Personal Homebrew tap for Anatoly's command-line tools.

## How do I install these formulae?

```sh
brew install anatoly-chichikov/tap/kamishibai
```

Or tap once and then install by formula name:

```sh
brew tap anatoly-chichikov/tap
brew install kamishibai
```

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "anatoly-chichikov/tap"
brew "kamishibai"
```

## Formulae

### kamishibai

Kamishibai turns vocabulary into illustrated Anki decks and PDF reports.

Set `GEMINI_API_KEY` before running it, or enter the key in the welcome screen. The first OCR-backed run downloads PP-OCRv5 model files into the application cache.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
