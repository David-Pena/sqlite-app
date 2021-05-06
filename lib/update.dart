import 'package:flutter/material.dart';
import 'db.dart';
import 'person.dart';
import 'validation.dart';

class Update extends StatefulWidget {
  final person;
  const Update(this.person);
  @override
  _UpdateState createState() => _UpdateState(person);
}

class _UpdateState extends State<Update> {
  Person person;
  _UpdateState(this.person);
  var dbHelper;

  Validation validation = new Validation();

  //VARIABLES OF INPUTS
  TextEditingController documentController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController placeController = new TextEditingController();
  TextEditingController dateTextController = new TextEditingController();

  var date;
  String document, name, address, place, dateText;

  @override
  void initState() {
    super.initState();
    dbHelper = DB();
    setState(() {
      documentController.text = person.document;
      nameController.text = person.name;
      addressController.text = person.address;
      dateTextController.text = person.date;
      place = person.place;
    });
  }

  List places = ['Home', 'Hospitalization', 'UCI'];
  DateTime currentDate = DateTime.now();

  Future<void> pickDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2036));
    if (pickedDate != null) {
      setState(() {
        currentDate = pickedDate;
        date = "${currentDate.toLocal()}".split(' ')[0];
        dateTextController.text = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: size.height * 0.01),
                child: Text(
                  "Update",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: size.width * 0.15),
                ),
              ),
              Text(
                "Change information of a medicament",
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.07),
                child: TextFormField(
                  enabled: false,
                  style: TextStyle(color: Colors.grey),
                  controller: documentController,
                  decoration: InputDecoration(
                    labelText: "Document",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "10002923",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.03),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Mario Casas",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.03),
                child: TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: "Address",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Clle. 45 #91-10",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.03),
                child: DropdownButton(
                  hint: Text("Select an Item"),
                  value: place,
                  onChanged: (newValue) {
                    setState(() {
                      place = newValue;
                    });
                  },
                  items: places.map((snap) {
                    return DropdownMenuItem(
                      value: snap,
                      child: Text(snap),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.03),
                child: TextFormField(
                    controller: dateTextController,
                    decoration: InputDecoration(
                      labelText: "Contagion Date",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "2020-02-30",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      pickDate(context);
                    }),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.03),
                width: size.width * 0.4,
                height: size.height * 0.05,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        document = documentController.text.trim();
                        name = nameController.text.trim();
                        address = addressController.text.trim();
                        dateText = dateTextController.text.trim();
                      });
                      if (validation.isEmpty(document) ||
                          validation.isEmpty(name) ||
                          validation.isEmpty(address) ||
                          validation.isEmpty(place) ||
                          validation.isEmpty(dateText)) {
                        validation.showToastText();
                      } else {
                        Person p = new Person(
                            document, name, address, place, dateText);
                        dbHelper.update(p, context);
                      }
                    },
                    child: Text("Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.04,
                        ))),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
