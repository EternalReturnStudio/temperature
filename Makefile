default: build run

clean:
	rm temperature.love

build:
	zip -r temperature.love *

run:
	love temperature.love
