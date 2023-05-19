import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'package:rxdarttemp/bloc/api.dart';

import './search_result.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose(){
    search.close(); // you always have to close the Sinks
  }

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();

    final Stream<SearchResult?> results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String searchTerm) {
      if (searchTerm.isEmpty) {
        // search is empty
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(searchTerm))
            .delay(const Duration(seconds: 1))
            .map((results) => results.isEmpty
                ? const SearchResultNoResults()
                : SearchResultWithResults(results))
            .startWith(const SearchResultLoading())
            .onErrorReturnWith((error, _) => SearchResultHasError(error));
      }
    });

    return SearchBloc._(
      search: textChanges.sink,
      results: results,
    );
  }

  const SearchBloc._({
    required this.search,
    required this.results,
  });
}
