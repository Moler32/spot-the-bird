import 'dart:io';

class BirdModel {
  int? id;
  final String? birdName;
  final String? birdDescription;
  final double latitude;
  final double longitude;
  final File image;

  BirdModel({
    this.id,
    required this.birdName,
    required this.birdDescription,
    required this.latitude,
    required this.longitude,
    required this.image,
  });
}
