js:
	coffee --compile --output lib/ src/

.PHONY: test
test:
	mocha  --compilers coffee:coffee-script/register

all: js
