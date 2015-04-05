
COFFEE=coffeebar
COFFEEARGS=--minify -o js

all: zip

coffee: cybozu.js

cybozu.js: coffee/cybozu.coffee
	$(COFFEE) $(COFFEEARGS) coffee/cybozu.coffee

clean:
	rm js/cybozu.js
	rm cybozu.zip

zip: coffee
	zip -r cybozu.zip css js options res templates manifest.json
