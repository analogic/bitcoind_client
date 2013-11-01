library bitcoind_client;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

typedef void BitcoindClientLog(String message);

class BitcoindClient {
  
  Uri uri;
  BitcoindClientLog log;
  bool debug = false;
  HttpClient _http_client = new HttpClient();
  
  BitcoindClient(String url, [BitcoindClientLog this.log]) {
    this.uri = Uri.parse(url);
    debug = this.log != null;
  }
  
  Future call(String method, { params: const []}) {
    
    final payload = JSON.encode({
      'jsonrpc': '1.0',
      'method': method,
      'params': params,
      'id': new DateTime.now().millisecondsSinceEpoch
    });
    if(debug) { this.log('bitcoind request: ' + payload); }

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
            var string_data = new String.fromCharCodes(raw_data);
            if(debug) { this.log('bitcoind response: ' + string_data.trim()); }
            
            final _data = JSON.decode(string_data);
            if(_data['result'] != null) {
              completer.complete(_data['result']);
            } else if (_data['error'] != null) {
              completer.completeError(_data['error']);
            }
          },
          onError: completer.completeError,
          onDone: _http_client.close,
          cancelOnError: true
          );
    }).catchError((e) {
      if(debug) { this.log('bitcoind error: ' + e.toString()); }
      completer.completeError(e);
    });
    
    return completer.future;
  } 
}

