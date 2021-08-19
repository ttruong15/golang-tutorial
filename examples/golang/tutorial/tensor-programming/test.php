<?php

require dirname(__FILE__).'/vendor/autoload.php';

$hostname = "localhost:4040";

$client = new Helloworld\GreeterClient($hostname, [
	'credentials' => Grpc\ChannelCredentials::createInsecure(),
]);

echo "YES";
