<?php
// To generate the necessary proto classes:
// $ protoc --proto_path=../protos --php_out=. --grpc_out=.
//   --plugin=protoc-gen-grpc=../../bins/opt/grpc_php_plugin
//   ../protos/helloworld.proto

require dirname(__FILE__).'/vendor/autoload.php';

function greet($hostname, $func, $a, $b)
{
    $client = new Proto\AddServiceClient($hostname, [
        'credentials' => Grpc\ChannelCredentials::createInsecure(),
    ]);
    $request = new Proto\Request();
    $request->setA($a);
    $request->setB($b);

    if($func === 'add') {
	    list($response, $status) = $client->Add($request)->wait();
    } else if($func === 'mult') {
	    list($response, $status) = $client->Multiply($request)->wait();
    } else {
	    echo "ERROR: invalid command.  Available command: add, mult\n";
	    exit;
    }
    if ($status->code !== Grpc\STATUS_OK) {
        echo "ERROR: " . $status->code . ", " . $status->details . PHP_EOL;
        exit(1);
    }

    echo $response->getResult() . PHP_EOL;
}

$func = !empty($argv[1]) ? $argv[1] : 'add';
$a = !empty($argv[2]) ? $argv[2] : 10;
$b = !empty($argv[3]) ? $argv[3] : 10;
$hostname = !empty($argv[4]) ? $argv[4] : 'localhost:4040';
greet($hostname, $func, $a, $b);
