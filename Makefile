all: image

image:
	docker build -t blinzlerone/ocsinventory-docker-image:latest . 2>&1 | tee build.log

cleanup:
	-docker rmi blinzlerone/ocsinventory-docker-image:latest

