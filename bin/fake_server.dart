import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

extension RouterExtensions on Router {
  Future<HttpServer> toServer() {
    final ip = InternetAddress.anyIPv4;
    final handler = Pipeline().addMiddleware(logRequests()).addHandler(this);
    final port = int.parse(Platform.environment['PORT'] ?? '8080');
    return serve(handler, ip, port);
  }

  void addGet<T>(
    String route,
    T Function(Request request, dynamic args) body,
    Map<String, dynamic> Function(T) toJson,
  ) =>
      get(
          route,
          (request, login) => _handle(
                request,
                body(request, login),
                toJson,
              ));

  void addPost<T>(
    String route,
    T Function(Request request, dynamic args) body,
    Map<String, dynamic> Function(T) toJson,
  ) =>
      post(
          route,
          (request, args) => _handle(
                request,
                body(request, args),
                toJson,
              ));

  Response _handle<T>(
    Request request,
    T body,
    Map<String, dynamic> Function(T) toJson,
  ) =>
      Response.ok(jsonEncode(toJson(body)));
}
