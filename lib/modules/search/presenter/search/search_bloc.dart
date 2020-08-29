import 'package:bloc/bloc.dart';
import 'package:cleanflutter/modules/search/domain/usecases/search_by_text.dart';
import 'package:cleanflutter/modules/search/presenter/search/states/state.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<String, SearchState> {
  final SearchByText usecase;

  SearchBloc(this.usecase) : super(SearchStart());

  @override
  Stream<SearchState> mapEventToState(String searchText) async* {
    if (searchText.isEmpty) {
      yield SearchStart();
      return;
    }
    yield SearchLoading();
    final result = await usecase(searchText);
    yield result.fold(
        (failure) => SearchError(failure), (success) => SearchSuccess(success));
  }

  @override
  Stream<Transition<String, SearchState>> transformEvents(
      Stream<String> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 2000)), transitionFn);
  }
}
