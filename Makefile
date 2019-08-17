HOSTNAME=$(shell hostname)

default:
	@hugo serve . --bind 0.0.0.0 --baseURL $(HOSTNAME)

build:
	@hugo

clean:
	@rm -rf .dist/
