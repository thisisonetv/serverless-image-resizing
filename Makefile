.PHONY: all image package dist clean

all: | package dist

image:
	docker build --tag amazonlinux:nodejs .

package: image
	docker run --rm --volume ${PWD}/lambda:/build amazonlinux:nodejs bash -c "yum install -y make && npm install --production"

dist: package
	cd lambda && zip -FS -q -r ../dist/function.zip *

clean:
	rm -rf lambda/node_modules
	docker rmi --force amazonlinux:nodejs
