/*
 *
 * Copyright 2015 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

var PROTO_PATH = '/golang/example.com/proto/service.proto';

//var parseArgs = require('minimist');
var grpc = require('@grpc/grpc-js');
var protoLoader = require('@grpc/proto-loader');
var packageDefinition = protoLoader.loadSync(PROTO_PATH,
	{
		keepCase: true,
		longs: String,
		enums: String,
		defaults: true,
		oneofs: true
	});
var proto = grpc.loadPackageDefinition(packageDefinition).proto;

function main() {

	var argv = process.argv.slice(2)

	if (argv.length !== 3) {
		console.error('Usage: node math_client.js <add|mult> <firstNumber> <secondNumber>') 
		console.error('Example: node math_client.js add 5 10')
		return
	}

	var host = 'localhost:4040';
	var client = new proto.AddService(host, grpc.credentials.createInsecure());
	var a = argv[1]
	var b = argv[2]

	if (argv[0] === 'add') {
		client.add({a, b}, function(err, response) {
			console.log('Result:', response.result);
		});
	} else if (argv[0] === 'mult') {
		client.multiply({a, b}, function(err, response) {
			console.log('Result:', response.result);
		});
	} else {
		console.error("Invalid command.  Available commands add, mult")
		return
	}
}

main();
