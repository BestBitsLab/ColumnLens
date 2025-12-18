# ColumnLens

[![Gem Version](https://badge.fury.io/rb/columnlens.svg)](https://badge.fury.io/rb/columnlens)

**columnlens** is a CLI tool to analyze your Ruby on Rails database schema. It helps detect unused, read-only, and orphaned columns, providing insight into schema hygiene and technical debt.

---

## ✨ Features

- Scan your full Rails database schema
- Detect actively used, write-only, read-only, and orphaned columns
- Respect system tables and configurable ignore rules

---

## 🧰 Installation

Add this line to your application's Gemfile:

```ruby
gem 'columnlens'
```

Then execute:

```sh
$ bundle install
```

Or install it globally:

```sh
$ gem install columnlens
```

---

## 🚀 Usage

From any Rails project:

```sh
$ bundle exec columnlens scan
```

Output example:

```
🔍 ColumnLens Scan Mode
Scanning full schema...

posts.title          read_write
users.email          read_write
users.last_seen_at   orphaned
...
```

---

## ⚙️ Configuration

ColumnLens uses a .columnlens.yml in your project root:

```yaml
system_tables:
  - "^active_storage_"
  - "^schema_migrations$"
  - "^ar_internal_metadata$"

ignore:
  scan:
    orphaned:
      - "posts"
      - "users.created_at"
      - "users.updated_at"
  deep:
    orphaned: []
```

Defaults are provided in lib/config/default.yml and merged with the project config.

---

## 🔧 Development

To set up the project locally:

```sh
$ git clone https://github.com/BestBitsLab/columnlens.git
$ cd columnlens
$ bin/setup
```

You can experiment with the code via:

```sh
$ bin/console
```

To build and install the gem locally:

```sh
$ bundle exec rake install
```

To release a new version:

1. Update the version in `lib/columnlens/version.rb`
2. Run:

```sh
$ bundle exec rake release
```

This will tag, push, and publish to [RubyGems.org](https://rubygems.org).

---

## 🤝 Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/BestBitsLab/columnlens). This project is intended to be a safe, welcoming space for collaboration. Please read and follow the [code of conduct](https://github.com/BestBitsLab/columnlens/blob/main/CODE_OF_CONDUCT.md).

---

## 🪪 License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

## 📜 Code of Conduct

Everyone interacting in the ColumnLens project's codebase, issue trackers, and other community spaces is expected to follow the [Code of Conduct](https://github.com/BestBitsLab/columnlens/blob/main/CODE_OF_CONDUCT.md).

---