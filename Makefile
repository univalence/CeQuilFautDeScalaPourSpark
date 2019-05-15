
CONTAINER=univalence/tout-spark-notebook
TARGET_TAR=CeQuilFautDeScalaPourSpark.tar.gz

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

save:
	docker save $(CONTAINER):latest -o $(TARGET_TAR)

load: $(TARGET_TAR)
	docker load -i $(TARGET_TAR)
