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