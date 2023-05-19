import 'dart:convert';
import 'dart:io';

import '../models/animal.dart';
import '../models/person.dart';
import '../models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;
  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final cachedThings = _extractThingsUsingSearchTerm(searchTerm);
    if (cachedThings != null) {
      return Future.value(cachedThings);
    }
    // we don't have cached things, so we need to fetch them from the api
    else {
      return _getJson('http://127.0.0.1:5500/apis/persons.json')
          .then((json) => json.map((e) => Person.fromJson(e)).toList())
          .then((persons) {
        _persons = persons;
        return _getJson('http://127.0.0.1:5500/apis/animals.json')
            .then((json) => json.map((e) => Animal.fromJson(e)).toList())
            .then((animals) {
          _animals = animals;
          return _extractThingsUsingSearchTerm(searchTerm) ?? [];
        });
      });
    }
  }

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm searchTerm) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;

    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];
      //go through animals
      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContains(searchTerm) ||
            animal.type.name.trimmedContains(searchTerm)) {
          result.add(animal);
        }
      }
      //go through persons
      for (final person in cachedPersons) {
        if (person.name.trimmedContains(searchTerm) ||
            person.age.toString().trimmedContains(searchTerm)) {
          result.add(person);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((request) => request.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContains(String other) => trim().toLowerCase().contains(
        other.trim().toLowerCase(),
      );
}
