# ftg-bot - fortelegram-bot

A simple telegram bot implementation, written in fortran

https://github.com/vypivshiy/ftg-bot/assets/59173419/96699867-beb3-4501-b03d-1a95f2e78f18

## Prerequisites

- Fortran compiler
- On Ubuntu, you need to install the curl development headers. Use the following command:

`sudo apt install -y libcurl4-openssl-dev`

## Installation

1. Clone repo 
```shell
git clone https://github.com/vypivshiy/ftg-bot
```
2. Add bot token variable

bash
```shell
export BOT_TOKEN="YOUR_BOT_TOKEN"
```

fish
```
set BOT_TOKEN "YOUR_BOT_TOKEN"
```
3. Compile the package using fpm: 
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
