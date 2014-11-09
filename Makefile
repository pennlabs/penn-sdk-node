js:
	coffee --compile --output lib/ src/

.PHONY: test
test: js
	mocha  --compilers coffee:coffee-script/register -t 10s

all: js

watch:
	coffee --watch --output lib/ src/ &
	mocha --compilers coffee:coffee-script/register -t 10s -w -R min
