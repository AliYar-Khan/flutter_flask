import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class RemoteDataSource {
  Future<String> login(String email, String password);
  Future<void> register(
      String name, String email, String password, String phone, String address);
  Future<List<UserModel>> getUsers(String token);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl(this.client);

  static const baseUrl = "http://192.168.0.105:9000";

  @override
  Future<String> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['access_token'];
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> register(String name, String email, String password,
      String phone, String address) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fullname': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address
      }),
    );

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getUsers(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("data ${json.decode(response.body)['data']}");
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }
}
