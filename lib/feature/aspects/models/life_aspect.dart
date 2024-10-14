// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:plinko/feature/aspects/models/task.dart';

class LifeAspect extends Equatable {
  final String name;
  final double optimalScore;
  final double currentScore;


  LifeAspect({
    required this.name,
    required this.optimalScore,
    required this.currentScore,

  });

  @override
  List<Object?> get props => [name, optimalScore, currentScore];

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'optimalScore': optimalScore,
      'currentScore': currentScore,
    };
  }

  factory LifeAspect.fromMap(Map<String, dynamic> map) {
    return LifeAspect(
      name: map['name'] as String,
      optimalScore: map['optimalScore'] as double,
      currentScore: map['currentScore'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory LifeAspect.fromJson(String source) => LifeAspect.fromMap(json.decode(source) as Map<String, dynamic>);
}
