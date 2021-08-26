#!/bin/bash

protoc --proto_path=/golang/example.com/proto --php_out=/php/code --grpc_out=/php/code --plugin=protoc-gen-grpc=/php/plugins/grpc_php_plugin service.proto
