BitcoindClient
==============

A simpliest Bitcoind client

Example
-------

```Dart
import 'package:bitcoind_client/bitcoind_client.dart';

var client = new BitcoindClient('http://bitcoinrpc:password@localhost:8332');
client.call('getbalance', params: ['accountname', 0]).then((balance) => print(balance));
```

Logging
-------

You can do request/response/error logging with log callback in constructor

```Dart
import 'package:logging/logging.dart';
import 'package:bitcoind_client/bitcoind_client.dart';

var log = new Logger('testlog');
log.onRecord.listen((record) => print(new DateTime.now().toString() + ' ' +record.message));

var client = new BitcoindClient('http://bitcoinrpc:password@localhost:8332', log.info);

... or without dependencies ...

var client = new BitcoindClient('http://bitcoinrpc:password@localhost:8332', (String message) => print(message));
```