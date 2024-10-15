// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:bubblebalance/feature/aspects/models/user.dart';

class UserAnalytics extends Equatable {
  final User user;
  final String date;

  UserAnalytics({
    required this.user,
    required this.date,
  });

  @override
  List<Object> get props => [user, date];

  String toJson() => json.encode(toMap());

  factory UserAnalytics.fromJson(String source) =>
      UserAnalytics.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'date': date,
    };
  }

  factory UserAnalytics.fromMap(Map<String, dynamic> map) {
    return UserAnalytics(
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      date: map['date'] as String,
    );
  }
}
