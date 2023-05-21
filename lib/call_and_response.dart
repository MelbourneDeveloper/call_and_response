import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

extension RouterExtensions on Router {
  Future<HttpServer> toServer([int port = 8080]) {
    final ip = InternetAddress.anyIPv4;
    final handler = const Pipeline().addHandler(this);
    return serve(handler, ip, port);
  }

  void addGet<T>(
    String route,
    Future<T> Function(Request request, args) body,
    Map<String, dynamic> Function(T) toJson,
  ) =>
      get(
        route,
        (request, login) async => _handle<T>(
          request,
          await body(request, login),
          toJson,
        ),
      );

  void addPost<T>(
    String route,
    Future<T> Function(Request request, args) body,
    Map<String, dynamic> Function(T) toJson,
  ) =>
      post(
        route,
        (request, args) async => _handle<T>(
          request,
          await body(request, args),
          toJson,
        ),
      );

  void addPut<T>(
    String route,
    Future<T> Function(Request request, args) body,
    Map<String, dynamic> Function(T) toJson,
  ) =>
      put(
        route,
        (request, args) async => _handle<T>(
          request,
          await body(request, args),
          toJson,
        ),
      );

  void addPatch<T>(
    String route,
    Future<T> Function(Request request, args) body,
    Map<String, dynamic> Function(T) toJson,
  ) =>
      patch(
        route,
        (request, args) async => await _handle<T>(
          request,
          await body(request, args),
          toJson,
        ),
      );

  void addDelete<T>(
    String route,
    Future<T> Function(Request request, args) body,
    Map<String, dynamic> Function(T) toJson,
  ) =>
      delete(
        route,
        (request, args) async => await _handle<T>(
          request,
          await body(request, args),
          toJson,
        ),
      );

  void addHead(
    String route,
  ) =>
      head(
        route,
        (request, args) async => Response.ok(null),
      );

  Future<Response> _handle<T>(
    Request request, [
    T? body,
    Map<String, dynamic> Function(T)? toJson,
  ]) async =>
      Response.ok(body != null ? jsonEncode(toJson!(body)) : null);
}
