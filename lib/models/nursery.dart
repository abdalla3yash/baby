import 'package:flutter/material.dart';

class Nursery {
  final String id;
  final String title;
  final String description;
  final String age;
  final String code;
  final String nationalID;
  final String bloodType;
  final String gander;
  final String image;
  final String userEmail;
  final String userId;
  final bool isFavorite;

  Nursery(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.age,
      @required this.code,
      @required this.nationalID,
      @required this.bloodType,
      @required this.gander,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      this.isFavorite = false});
}
