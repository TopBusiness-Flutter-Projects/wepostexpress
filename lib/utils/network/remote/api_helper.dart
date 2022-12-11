import 'dart:async';
import 'dart:convert' hide utf8;
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';

import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:wepostexpress/utils/constants/constants.dart';
import 'package:wepostexpress/utils/errors/server_exception.dart';

abstract class ApiHelper {
  Future<String> getData(
    String baseUrl,
    String url, {
    String token,
    String queries,
    bool typeJSON = false,
  });

  Future<String> deleteData(
    String baseUrl,
    String url, {
    String token,
  });

  Future<dynamic> postData(
    String baseUrl,
    String url, {
    String token,
    String authToken,
    Map<String, dynamic> data,
    Map<String, String> headers,
    bool typeJSON = false,
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}

class ApiImpl extends ApiHelper {
  Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);

  @override
  Future<String> getData(
    String baseUrl,
    String url, {
    String token,
    String queries = '',
    bool typeJSON = false,
  }) async {
    return await _request(() async {
      String req = '$baseUrl$url$queries';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      printFullText('req is $req');
      return await client.get(Uri.parse(req), headers: {
        if (token != null && token.isNotEmpty) 'token': '$token',
        if (typeJSON) HttpHeaders.contentTypeHeader: 'application/json',
      });
    }, () {
      String req = '$baseUrl$url$queries';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      return req;
    }());
  }

  @override
  Future<String> deleteData(
    String baseUrl,
    String url, {
    String token,
  }) async {
    return await _request(() async {
      String req = '$baseUrl$url';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      printFullText('req is $req');
      return await client.delete(Uri.parse(req), headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      });
    }, () {
      String req = '$baseUrl$url';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      return req;
    }());
  }

  @override
  Future<dynamic> postData(
    String baseUrl,
    String url, {
    String token,
    String authToken,
    Map<String, dynamic> data = const {},
    Map<String, String> headers = const {},
    bool typeJSON = false,
  }) async {
    return await _request(() async {
      String req = '$baseUrl$url';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      printFullText('req is $req and data : $data');
      return await client.post(
        Uri.parse(req),
        headers: {
          ...headers,
          if (token != null && token.isNotEmpty) 'token': '$token',
          if (authToken != null && authToken.isNotEmpty) 'auth-token': '$authToken',
          if (typeJSON) HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: data,
      );
    }, () {
      String req = '$baseUrl$url';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      return '$req and data : $data';
    }());
  }
}

extension on ApiHelper {
  Future _request(Future<Response> request(), String url) async {
    try {
      var r = await request.call();
      return r.body;
    } catch (e,s) {
      print('eorroroorro : ${e.toString()} in $url');
      print(s);
      throw ServerException(e.response?.data??'server exception');
    }
  }
}

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    printFullText('Call Headers => ${data.headers}');
    print('Call Params => ${data.params}');
    print('Call Base Url => ${data.baseUrl}');
    print('Call Full Url => ${data.toHttpRequest().url}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Response URL => ${data.url}');
    print('Response Method => ${data.method}');
    print('Response Code => ${data.statusCode}');
    print('Response Headers => ${data.headers}');
    // printFullText('Response Body => ${jsonDecode(data.body)}');
    return data;
  }
}
