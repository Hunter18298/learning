import 'package:flutter/foundation.dart';

import 'person.dart';

const persons1Url = 'http://127.0.0.1:5500/person1.json';
const persons2Url = 'http://127.0.0.1:5500/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadActions {
  const LoadActions();
}

@immutable
class LoadPersonsAction implements LoadActions {
  final String url;
  final PersonsLoader loader;
  const LoadPersonsAction({required this.url, required this.loader}) : super();
}
