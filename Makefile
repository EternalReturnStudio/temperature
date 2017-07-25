default: build run

clean:
	$(RM) temperature.love

build:
	# zip -r temperature.love *
	7z a -r -tzip temperature.love *

run:
	love temperature.love
