class Person {
  String name, document, address, date, place;

  Person(this.document,this.name,  this.address, this.place, this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'document': document,
      'name': name,
      'address': address,
      'place': place,
      'date': date,
    };
    return map;
  }

  Person.fromMap(Map<String, dynamic> map) {
    document = map['document'];
    name = map['name'];
    address = map['address'];
    place = map['place'];
    date = map['date'];
  }
}
