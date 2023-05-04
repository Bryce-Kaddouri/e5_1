import 'package:flutter/material.dart';
import 'package:muscuappwithfire/services/firebase.dart';

class HistoriquePage extends StatefulWidget {
  String idUser;
  HistoriquePage({super.key, required this.idUser});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  List<DataRow> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                Text('Trier par :'),
                DropdownButton<String>(
                  value: 'Date',
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue == 'Date') {
                      setState(() {
                        list.sort((a, b) => a.cells[1].child
                            .toString()
                            .compareTo(b.cells[1].child.toString()));
                      });
                    } else {
                      setState(() {
                        list.sort((a, b) => a.cells[0].child
                            .toString()
                            .compareTo(b.cells[0].child.toString()));
                      });
                    }
                  },
                  items: <String>['Date', 'Séance']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // tableau avec un streambuilder et un en-tête pour filtrer les séances par date, par séance

          Container(
            margin: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height - 220,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: DBFirebase().getHistoriqueByIdUser(widget.idUser),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data);
                  for (var i = 0; i < snapshot.data.length; i++) {
                    print(snapshot.data[i]['titre']);
                    print(snapshot.data[i]['startedAt']);
                    print(snapshot.data[i]['finishedAt']);
                    list.add(
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(snapshot.data[i]['titre'])),
                          DataCell(Text(snapshot.data[i]['startedAt'])),
                          DataCell(Text(snapshot.data[i]['finishedAt'])),
                          DataCell(
                            Icon(
                                snapshot.data[i]['finishedAt'] != "Non terminé"
                                    ? Icons.check
                                    : Icons.close,
                                color: snapshot.data[i]['finishedAt'] !=
                                        "Non terminé"
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  return DataTable(
                    sortColumnIndex: 1,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Séance',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Debut',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Fin',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Icon',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                    rows: list,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}
