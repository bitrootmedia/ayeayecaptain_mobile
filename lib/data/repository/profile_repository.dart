import 'dart:convert';

import 'package:ayeayecaptain_mobile/app/utils/failure_codes.dart';
import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/profile_dto.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/profile/interface/profile_repository.dart' as domain;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _profilesKey = 'profiles';

class ProfileRepository implements domain.ProfileRepository {
  final Dio _client;
  final FlutterSecureStorage _storage;

  ProfileRepository(
    this._client,
    this._storage,
  );

  @override
  Future<FailureOrResult<String>> login(Profile profile) async {
    try {
      final response = await _client.post(
        '${profile.backendUrl}/api/auth/login/',
        data: {
          'username': profile.name,
          'password': profile.password,
        },
      );

      final token = (response.data as Map<String, dynamic>)['key'];
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('backend', profile.backendUrl);
      await sharedPreferences.setString('token', token);
      return FailureOrResult.success(token);
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response?.data is Map &&
          e.response!.data['non_field_errors'] != null &&
          e.response!.data['non_field_errors'] is List) {
        return FailureOrResult.failure(
          code: FailureCodes.nonFieldErrors,
          message: (e.response!.data['non_field_errors'] as List).join(', '),
        );
      } else if (e.response?.statusMessage != null) {
        return FailureOrResult.failure(
          code: FailureCodes.unknownError,
          message: 'Error: ${e.response!.statusMessage}\nResponse status code: ${e.response!.statusCode}',
        );
      } else if (e.message != null) {
        return FailureOrResult.failure(
          code: FailureCodes.unknownError,
          message: 'Error: ${e.message}',
        );
      } else if (e.error != null) {
        return FailureOrResult.failure(
          code: FailureCodes.unknownError,
          message: 'Error: ${e.error}',
        );
      }
      return FailureOrResult.failure(
        code: FailureCodes.unknownError,
        message: 'An error has occurred.',
      );
    }
  }

  @override
  Future<FailureOrResult<List<Profile>>> getProfiles() async {
    final profilesString = await _storage.read(key: _profilesKey);
    if (profilesString == null) {
      return FailureOrResult.success([]);
    }
    final profiles = (jsonDecode(profilesString) as List).map((e) => ProfileDto.fromJson(e).toDomain()).toList();
    return FailureOrResult.success(profiles);
  }

  @override
  Future<FailureOrResult<void>> saveProfiles(List<Profile> profiles) async {
    var profilesString = jsonEncode(profiles.map((e) => ProfileDto.fromDomain(e)).map((e) => e.toJson()).toList());
    await _storage.write(key: _profilesKey, value: profilesString);
    return FailureOrResult.success(null);
  }

  @override
  Future<bool> hasProfile() async {
    return (await _storage.read(key: _profilesKey)) != null;
  }
}
