
CONTAINER=univalence/tout-spark-notebook

build:
	docker build -t $(CONTAINER) .

login:
	docker login

release: build login
	docker push $(CONTAINER):latest

run-local:
	docker run -it --rm -p 8888:8888 -p 4040:4040 --cpus=2.0 --memory=2000M -v "$$PWD":/home/jovyan/work $(CONTAINER)

run:
	docker run -it --rm -p 8888:8888 -p 4040:4040 --cpus=2.0 --memory=2000M $(CONTAINER)
