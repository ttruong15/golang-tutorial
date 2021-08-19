#PACKAGE=packages.go
#BINARY_NAME=packages.out

all: run

build:
	protoc --proto_path=proto --proto_path=/golang/pkg/mod --go_out=proto --go-grpc_out=proto service.proto

test:
	go test -v ${PACKAGE}

run:
	go build -o ${BINARY_NAME} ${PACKAGE}
	./${BINARY_NAME}

clean:
	go clean
	rm ${BINARY_NAME}
