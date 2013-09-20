library bitcoind_client;

import 'dart:async';
import 'dart:io';
import 'dart:json' as JSON;

class BitcoindClient {
  
  Uri uri;
  HttpClient _http_client = new HttpClient();
  
  BitcoindClient(String url) {
    this.uri = Uri.parse(url);
  }
  
  Future call(String method, { params: const []}) {
    
    final payload = JSON.stringify({
      'jsonrpc': '1.0',
      'method': method,
      'params': params,
      'id': new DateTime.now().millisecondsSinceEpoch
    });

    final completer = new Completer();
    
    _http_client
    .postUrl(uri)
    .then((HttpClientRequest request) {
      request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
      request.contentLength = payload.length;
      request.write(payload);
      return request.close();
    })
    .then((HttpClientResponse response) {
      response.listen(
          (raw_data) {
            final _data = JSON.parse(new String.fromCharCodes(raw_data));
            if(_data['result'] != null) {
              completer.complete(_data['result']);
            } else if (_data['error'] != null) {
              completer.completeError(_data['error']);
            }
          },
          onError: (e) => completer.completeError(e),
          onDone: () => _http_client.close(),
          cancelOnError: true
          );
    });
    
    return completer.future;
  }
  
  
}

