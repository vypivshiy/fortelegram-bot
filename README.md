# ftg-bot - fortelegram-bot

A simple telegram bot implementation, written in fortran

## Installation

1. Clone repo 
```shell
git clone https://github.com/vypivshiy/ftg-bot
```

2. Compile the package using fpm: 
```shell
cd ftg-bot
fpm build
fpm run
```

## Commands

- hello - send **hi!** message
- !echo <string> - send passed <string> (eg: !echo test123 > `test123`, !echo a b c > `a b c`)
- !cat - send cat picture �
- other text - show available commands

## Used libs:

- [fortran-lang/http-client](https://github.com/fortran-lang/http-client)
- [jacobwilliams/json-fortran](https://github.com/jacobwilliams/json-fortran)
