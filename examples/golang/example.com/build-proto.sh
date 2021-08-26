#!/bin/bash

#protoc --proto_path=proto --go_out=plugins=grpc:../ service.proto
protoc --proto_path=proto --go_out=../  --go-grpc_out=../ service.proto
