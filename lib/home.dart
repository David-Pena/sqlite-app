import 'package:flutter/material.dart';
import "person.dart";
import "db.dart";

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Person>> data;
  Future<List<Person>> filter;
  var dbHelper;

  refreshList(int method) {
    switch (method) {
      case 1:
        {
          setState(() {
            data = dbHelper.getData();
            filter = data;
          });
          break;
        }
      case 2:
        {
          break;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DB();
    refreshList(1);
  }

  buildTile(Person person, BuildContext context) {
    return ExpansionTile(
      title: Text(person.name, 
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
      subtitle: Text(person.document, 
        style: TextStyle(color: Colors.grey, fontSize: MediaQuery.of(context).size.width * 0.045)),
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
                      Text("Is Atended in: ${person.place}",
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
                        onTap: () {},
                        child: Icon(Icons.edit_rounded, color: Colors.yellow),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Warning"),
                              content: Text(
                                  "Are you sure you want to delete this medicament?"),
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
                                    refreshList(1);
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
                ]
              ),
        )
      ],
    );
  }

  ListView buildList(List<Person> list) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, position) {
          return buildTile(list[position], context);
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Covid Patient's Information"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    return buildList(snapshot.data);
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
            )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        highlightElevation: 0,
        elevation: 0,
        onPressed: () {
          dbHelper.save(new Person("122012012", "Sebastian Matute", "Calle 73 # 8-12", "Home", "2002-03-14"), context);
          refreshList(1);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
