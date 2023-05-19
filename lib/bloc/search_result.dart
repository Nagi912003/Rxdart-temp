import 'package:flutter/foundation.dart' show immutable;

import 'package:rxdarttemp/models/thing.dart';

@immutable
abstract class SearchResult{
  const SearchResult();
}

@immutable
class SearchResultLoading extends SearchResult{
  const SearchResultLoading();
}

@immutable
class SearchResultNoResults extends SearchResult{
  const SearchResultNoResults();
}

@immutable
class SearchResultHasError extends SearchResult{
  final Object error;
  const SearchResultHasError(this.error);
}

@immutable
class SearchResultWithResults extends SearchResult{
  final List<Thing> results;
  const SearchResultWithResults(this.results);
}