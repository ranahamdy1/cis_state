import 'package:cis_state/constants/strings.dart';
import 'package:dio/dio.dart';

class CharacterWebServec {
  late Dio dio;

  CharacterWebServec() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
    );
    dio = Dio(options);
  }
  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('characters');
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getAllCharactersQuotes(String quoteName) async {
    try {
      Response response =
          await dio.get('quote', queryParameters: {'author': quoteName});
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
