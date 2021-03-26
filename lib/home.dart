import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:pratikum7/DbHelper.dart';
import 'package:pratikum7/EntryForm.dart';
import 'models/item.dart'; //pendukung program asinkron
// import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Item> itemList;
  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Item>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Item'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 20),
          child: SizedBox(
            width: 250,
            height: 50,
            child: RaisedButton(
              color: Colors.black38,
              onPressed: () async {
                var item = await navigateToEntryForm(context, null);
                if (item != null) {
                  //TODO 2 Panggil Fungsi untuk Insert ke DB
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    "tambahkan Item",
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: Column(
            children: [
              Container(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    child: Icon(Icons.ad_units),
                  ),
                  title: Text(this.itemList[index].name,
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    "Rp : " + this.itemList[index].price.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        color: Colors.black),
                  ),
                  trailing: GestureDetector(
                    child: Icon(
                      Icons.delete,
                      size: 37,
                      color: Colors.redAccent,
                    ),
                    onTap: () async {
                      // //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                      dbHelper.delete(this.itemList[index].id);
                      updateListView();
                    },
                  ),
                  onTap: () async {
                    var item = await navigateToEntryForm(
                        context, this.itemList[index]);
                    //TODO 4 Panggil Fungsi untuk Edit data
                    dbHelper.update(item);
                    updateListView();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                margin: EdgeInsets.only(right: 85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Stok : " + this.itemList[index].stok.toString(),
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                    ),
                    Text(
                      "Kode Barang : " + this.itemList[index].kdbrg.toString(),
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //TODO 1 Select data dari DB
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
