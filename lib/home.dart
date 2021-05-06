import 'package:flutter/material.dart';
import "person.dart";
import "db.dart";
import 'validation.dart';
import 'update.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Person>> data;
  List<Person> filter;
  List<Person> filterCopy;
  String place;
  bool activeFilter = true;
  bool activeDrop = false;
  var dbHelper;
  Validation validation = new Validation();

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String name, id, address, placeCreate, date;
  List placesCreate = ['Home', 'Hospitalization', 'UCI'];
  List places = ['None', 'Home', 'Hospitalization', 'UCI'];
  DateTime currentDate = DateTime.now();

  refreshList() {
    setState(() {
      data = dbHelper.getData();
      filtered();
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DB();
    data = dbHelper.getData();
    refreshList();
  }

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
        dateController.text = date;
      });
    }
  }

  createAlertDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                  child: SingleChildScrollView(
                      child: Column(children: [
                Text("Register",
                    style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: idController,
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
                      hintText: "Cl. 45 #91-10",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: size.height * 0.03),
                //   child: TextFormField(
                //     controller: placeController,
                //     decoration: InputDecoration(
                //       labelText: "Place",
                //       floatingLabelBehavior: FloatingLabelBehavior.always,
                //       hintText: "Home / Hospitalization / UCI",
                //       hintStyle: TextStyle(color: Colors.grey),
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.03),
                  child: DropdownButton(
                    hint: Text("Select an Item"),
                    value: placeCreate,
                    onChanged: (value) {
                      setState(() {
                        placeCreate = value;
                      });
                    },
                    items: placesCreate.map((snap) {
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
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: "Contagion Date",
                        hintText: "2020-05-10",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          id = idController.text.trim();
                          name = nameController.text.trim();
                          address = addressController.text.trim();
                          date = dateController.text.trim();
                        });
                        if (validation.isEmpty(id) ||
                            validation.isEmpty(name) ||
                            validation.isEmpty(address) ||
                            validation.isEmpty(placeCreate) ||
                            validation.isEmpty(date)) {
                          validation.showToastText();
                        } else {
                          dbHelper.save(
                              new Person(id, name, address, placeCreate, date),
                              context);
                          setState(() {
                            idController.text = "";
                            nameController.text = "";
                            addressController.text = "";
                            dateController.text = "";
                            placeCreate = null;
                          });
                          refreshList();
                        }
                      },
                      child: Text("Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                          ))),
                )
              ]))),
            );
          });
        });
  }

  void filtered() async {
    final List<Person> lista = await dbHelper.getData();
    setState(() {
      filter = lista;
      filterCopy = lista;
    });
  }

  buildTile(Person person, BuildContext context) {
    return ExpansionTile(
      title: Text(person.name,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
      subtitle: Text(person.document,
          style: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.width * 0.045)),
      trailing: Icon(Icons.arrow_drop_down_rounded),
      children: [
        Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address: ${person.address}",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        )),
                    Text("Is attended at: ${person.place}",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        )),
                    Text("Contagion Date: ${person.date}",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        )),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => Update(person)))
                            .then((value) => refreshList());
                      },
                      child: Icon(Icons.edit_rounded, color: Colors.yellow),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Warning"),
                            content: Text(
                                "Are you sure you want to delete this person?"),
                            actions: <Widget>[
                              TextButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  dbHelper.delete(person.document, context);
                                  Navigator.of(context).pop();
                                  refreshList();
                                },
                              )
                            ],
                          ),
                        );
                      },
                      child: Icon(Icons.delete_rounded, color: Colors.red),
                    ),
                  ],
                )
              ]),
        )
      ],
    );
  }

  ListView buildList(List<Person> filter) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: filter.length,
        itemBuilder: (context, position) {
          return buildTile(filter[position], context);
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Covid Patient's Information"),
      ),
      body: SingleChildScrollView(
        // height: double.infinity,
        // width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: size.width * 0.50,
                  height: size.height * 0.06,
                  child: TextField(
                    enabled: activeFilter,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Enter Name or ID',
                    ),
                    onChanged: (string) {
                      if (string.isNotEmpty) {
                        setState(() {
                          activeDrop = true;
                        });
                      } else {
                        setState(() {
                          activeDrop = false;
                        });
                      }

                      setState(() {
                        filter = filterCopy
                            .where((u) =>
                                (u.document
                                    .toLowerCase()
                                    .contains(string.toLowerCase())) ||
                                u.name
                                    .toLowerCase()
                                    .contains(string.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Container(
                    child: IgnorePointer(
                  ignoring: activeDrop,
                  child: DropdownButton(
                    hint: Text("Select an Item"),
                    value: place,
                    onChanged: (newValue) {
                      setState(() {
                        if (newValue == 'None') {
                          activeFilter = true;
                          place = newValue;
                          filter = filterCopy;
                        } else {
                          activeFilter = false;
                          place = newValue;
                          filter = filterCopy
                              .where((u) => (u.place
                                  .toLowerCase()
                                  .contains(newValue.toLowerCase())))
                              .toList();
                        }
                      });
                    },
                    items: places.map((snap) {
                      return DropdownMenuItem(
                        value: snap,
                        child: Text(snap),
                      );
                    }).toList(),
                  ),
                ))
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
                decoration: BoxDecoration(
                    /*border: Border.all(color: Colors.blueAccent)*/),
                height: size.height * 0.70,
                child: FutureBuilder(
                  future: data,
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Center(
                            child: Text("No information to display",
                                style: TextStyle(fontSize: size.width * 0.05)));
                      } else {
                        //filter = snapshot.data;
                        return buildList(filter);
                      }
                    }
                    if (snapshot.data == null ||
                        snapshot.data == 0 ||
                        snapshot.data.legnth == 0) {
                      return Center(
                          child: Text("No data found",
                              style: TextStyle(fontSize: size.width * 0.05)));
                    }
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          createAlertDialog(context);
          refreshList();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
