import 'package:dio/dio.dart';
import 'package:ayeayecaptain_mobile/domain/user/interface/auth_repository.dart'
    as domain;

class AuthRepository implements domain.AuthRepository {
  final Dio _client;

  AuthRepository(this._client);
}
