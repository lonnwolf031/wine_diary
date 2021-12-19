import 'dart:ui';

class Wine {
  String? name;
  String? description;
  int? year;
  String? review;
  Image? img;

  Wine(this.name, this.description, this.year, this.review, this.img);

  Wine.fromMap(Map map) {
    name = map[name];
    description = map[description] ;
    year = map[year];
    review = map[review];
    img = map[img];
  }
}
