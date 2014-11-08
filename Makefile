js:
	coffee --compile --output lib/ src/

.PHONY: test
test: js
	mocha  --compilers coffee:coffee-script/register -t 5s

all: js
