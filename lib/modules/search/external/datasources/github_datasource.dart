import 'package:cleanflutter/modules/search/domain/errors/errors.dart';
import 'package:dio/dio.dart';
import 'package:cleanflutter/modules/search/infra/datasources/search_datasource.dart';
import 'package:cleanflutter/modules/search/infra/models/result_search_model.dart';

extension on String {
  normalize() {
    return this.trim().replaceAll(' ', '+');
  }
}

class GithubDatasource implements SearchDatasource {
  final Dio dio;

  GithubDatasource(this.dio);

  @override
  Future<List<ResultSearchModel>> getSearch(String searchText) async {
    final response = await dio
        .get("https://api.github.com/search/users?q=${searchText.normalize()}");

    if (response.statusCode == 200) {
      final list = (response.data['items'] as List)
          .map((item) => ResultSearchModel(
              title: item['login'],
              content: item['id'].toString(),
              image: item['avatar_url']))
          .toList();

      return list;
    } else {
      throw DatasourceError();
    }
  }
}
