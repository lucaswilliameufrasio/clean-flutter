import 'package:cleanflutter/modules/search/domain/entities/result_search.dart';
import 'package:cleanflutter/modules/search/domain/errors/errors.dart';
import 'package:cleanflutter/modules/search/infra/datasources/search_datasource.dart';
import 'package:cleanflutter/modules/search/infra/models/result_search_model.dart';
import 'package:cleanflutter/modules/search/infra/repositories/search_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class SearchDatasourceMock extends Mock implements SearchDatasource {}

main() {
  final datasource = SearchDatasourceMock();
  final repository = SearchRepositoryImpl(datasource);

  test('Deve retornar uma lista de ResultSearch', () async {
    when(datasource.getSearch(any))
        .thenAnswer((_) async => <ResultSearchModel>[]);

    final result = await repository.search("lucas");

    expect(result | null, isA<List<ResultSearch>>());
  });

  test('Deve retornar um DatasourceError se o datasource falhar', () async {
    when(datasource.getSearch(any)).thenThrow(Exception());

    final result = await repository.search("lucas");

    expect(result.fold(id, id), isA<DatasourceError>());
  });
}
