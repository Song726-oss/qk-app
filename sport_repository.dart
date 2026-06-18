import 'package:qk/models/sport.dart';
import 'package:qk/services/http_util.dart';
import 'package:qk/config/constants.dart';
import 'package:qk/data/mock_data.dart';

class SportRepository {
  final HttpUtil _httpUtil = HttpUtil();

  Future<List<Sport>> getSportList() async {
    try {
      final data = await _httpUtil.getList(AppConstants.sportsUrl);
      if (data.isEmpty) {
        return MockData.sports;
      }
      return data.map((json) => Sport.fromJson(json)).toList();
    } catch (e) {
      return MockData.sports;
    }
  }
}