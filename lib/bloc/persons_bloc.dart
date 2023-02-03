import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'bloc_action.dart';
import 'person.dart';

///to have ordering and comparing length of two Iterable and of they have equal length
///it will check the intersection in them to get order
/// + we need to put it inside FetchResult to compare old to new State of this extension
/// I mean Oparator == and hashcode

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrivedFromCache;

  const FetchResult({required this.persons, required this.isRetrivedFromCache});
  @override
  String toString() =>
      'FetchResult(isRetrivedFromCache=$isRetrivedFromCache, persons=$persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringoringOrdering(other.persons);

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(persons, isRetrivedFromCache);
}

class PersonsBloc extends Bloc<LoadActions, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedPerson = _cache[url];
        final result = FetchResult(
          persons: cachedPerson!,
          isRetrivedFromCache: true,
        );
        emit(result);
      } else {
        final loader = event.loader;
        final persons = await loader(url);
        _cache[url] = persons;
        final result = FetchResult(
          persons: persons,
          isRetrivedFromCache: true,
        );
        emit(result);
      }
    });
  }
}
