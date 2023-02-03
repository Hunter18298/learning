import 'package:flutter_application_1/bloc/bloc_action.dart';
import 'package:flutter_application_1/bloc/person.dart';
import 'package:flutter_application_1/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

//any data for testing
const mockedPersons1 = [
  Person(name: 'aland', age: 24),
  Person(name: 'bana', age: 19),
];
const mockedPersons2 = [
  Person(name: 'aland', age: 25),
  Person(name: 'bana', age: 20),
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);
void main() {
  group(
    'Testing bloc',
    () {
      //Write Our Test

      late PersonsBloc bloc;

      setUp(() {
        //this function runs before the test
        //we have to get acces to fresh PersonsBloc
        //we need it for every test
        bloc = PersonsBloc();
      });
      //test covarage needed for test some x% of the code
      blocTest<PersonsBloc, FetchResult?>(
        'Test initial state',
        build: () => bloc,
        //bloc state should be null to start with
        verify: (bloc) => expect(bloc.state, null),
      );
      //fetch mock data (persons1) and compare it with Fetch Result
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retriving persons1 from first Iterable',
        build: () => bloc,
        act: (bloc) {
          //first to be cache and the second showing id its cached or not if its working or not
          bloc.add(
            //dont care about url
            const LoadPersonsAction(
                url: 'dummy_url_1', loader: mockGetPersons1),
          );
          bloc.add(
            //dont care about url
            const LoadPersonsAction(
                url: 'dummy_url_1', loader: mockGetPersons1),
          );
        },
        expect: () => [
          //this part for expecting the result
          //first one for the first bloc.add
          //secnd one is for seconf bloc.add
          const FetchResult(
              persons: mockedPersons1, isRetrivedFromCache: false),
          const FetchResult(persons: mockedPersons1, isRetrivedFromCache: true),
        ],
      );
      //mockedPersons2
      blocTest<PersonsBloc, FetchResult?>(
        'Test initial state',
        build: () => bloc,
        //bloc state should be null to start with
        verify: (bloc) => bloc.state == null,
      );
      //fetch mock data (persons2) and compare it with Fetch Result
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retriving persons1 from first Iterable',
        build: () => bloc,
        act: (bloc) {
          //first to be cache and the second showing id its cached or not if its working or not
          bloc.add(
            //dont care about url
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
          bloc.add(
            //dont care about url
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
        },
        expect: () => [
          //this part for expecting the result
          //first one for the first bloc.add
          //secnd one is for seconf bloc.add
          const FetchResult(
            persons: mockedPersons2,
            isRetrivedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons2,
            isRetrivedFromCache: true,
          ),
        ],
      );
    },
  );
}
