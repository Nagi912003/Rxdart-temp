import 'package:flutter/material.dart' show immutable;
import 'package:rxdarttemp/models/thing.dart';

@immutable
class Person extends Thing {
  final int age;
  const Person({required String name, required this.age}) : super(name: name);

  @override
  String toString() => 'Animal(name: $name, type: $age)';

  Person.fromJson(Map<String, dynamic> json)
      : age = json['age'] as int,
        super(name: json['name'] as String);
}
