# falling-blocks-ruby

A falling blocks in Ruby with Qt.

# Prerequisite

- Qt4
    - On OSX
        - [homebrew-qt4](https://github.com/cartr/homebrew-qt4)
- [qtbindings](https://github.com/ryanmelt/qtbindings)
    - Compile Ruby
        > Ruby (Ruby must be compiled with --enable-shared on all platforms and with --with-gcc=clang on OSX)
    - Install gem with suitable version for your environment

# Tested Environments

- macOS 10.13.6 (High Sierra)
- Xcode 9.4.1
- Homebrew
    - qt@4 4.8.7_5
- Cmake 3.12.0
- Ruby 2.3.1p112
    - Compiled with `RUBY_CONFIGURE_OPTIONS="--enable-shared --with-gcc=clang" asdf install ruby 2.3.1`
- Gem
    - qtbindings 4.8.6.4

# Run

`ruby qt_app/main.rb`

# Inspired by

https://github.com/eed3si9n/tetrix.scala
