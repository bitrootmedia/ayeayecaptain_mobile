import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';

abstract class ProfileRepository {
  Future<FailureOrResult<List<Profile>>> getProfiles();
  Future<FailureOrResult<void>> saveProfiles(List<Profile> profiles);
  Future<FailureOrResult<String>> login(Profile profile);
}
