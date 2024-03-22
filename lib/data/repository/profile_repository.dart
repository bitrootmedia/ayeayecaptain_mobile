import 'dart:convert';
import 'dart:developer';

import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/profile_dto.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/profile/interface/profile_repository.dart'
    as domain;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
      return FailureOrResult.success(token);
    } on DioException catch (e) {
      log(e.toString());
      return FailureOrResult.failure();
    }
  }

  @override
  Future<FailureOrResult<List<Profile>>> getProfiles() async {
    final profilesString = await _storage.read(key: _profilesKey);
    if (profilesString == null) {
      return FailureOrResult.success([]);
    }
    final profiles = (jsonDecode(profilesString) as List)
        .map((e) => ProfileDto.fromJson(e).toDomain())
        .toList();
    return FailureOrResult.success(profiles);
  }

  @override
  Future<FailureOrResult<void>> saveProfiles(List<Profile> profiles) async {
    var profilesString = jsonEncode(profiles
        .map((e) => ProfileDto.fromDomain(e))
        .map((e) => e.toJson())
        .toList());
    await _storage.write(key: _profilesKey, value: profilesString);
    return FailureOrResult.success(null);
  }

  @override
  Future<bool> hasProfile() async {
    return (await _storage.read(key: _profilesKey)) != null;
  }
}
