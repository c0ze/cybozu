
COFFEE=coffeebar
COFFEEARGS=--minify -o js

all: zip

coffee: cybozu.js background.js

cybozu.js: coffee/cybozu.coffee
	$(COFFEE) $(COFFEEARGS) coffee/cybozu.coffee

background.js: coffee/background.coffee
	$(COFFEE) $(COFFEEARGS) coffee/background.coffee

clean:
	rm js/cybozu.js
	rm js/background.js
	rm cybozu.zip

zip: coffee
	zip -r cybozu.zip css js options res templates manifest.json
