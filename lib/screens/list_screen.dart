import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/models/post.dart';
import 'package:wasteagram/screens/detail_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  State createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  num? totalQuantity;

  num newTotalQuantity = 0;

  @override
  void initState() {
    getTotalQuantity();
    totalQuantity = newTotalQuantity;
    super.initState();
  }

  void getTotalQuantity() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((QuerySnapshot querySnapshot) {
          newTotalQuantity = 0;
      querySnapshot.docs.forEach((doc) {
        newTotalQuantity += doc["quantity"];
      });
    });
    if (newTotalQuantity != totalQuantity) {
      setState(() {
        totalQuantity = newTotalQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wasteagram - $totalQuantity"),
        centerTitle: true,
      ),
      floatingActionButton: Semantics(
        child: addEntryFAB(context),
        button: true,
        enabled: true,
        onTapHint: 'Add new post',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          getTotalQuantity();
          if (snapshot.hasError) {
            return Text(':(');
          }
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.length == 0) return const Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

              Post post = Post(date: DateTime.fromMillisecondsSinceEpoch(data['date'].seconds * 1000), imageURL: data['imageURL'], quantity: data['quantity'], latitude: data['latitude'], longitude: data['longitude']);

              return ListTile(
                title: Text('${post.printWeekDay(false)}, ${post.printDate()}', style: Theme.of(context).textTheme.headline6),
                trailing: Text('${post.quantity}', style: Theme.of(context).textTheme.headline5),
                onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailScreen(post: post))); }
              );
            }).toList(),
          );
        },
      )
    );
  }
}

Widget addEntryFAB(context) {
  return FloatingActionButton(
    child: Icon(Icons.camera_alt),
    onPressed: () { Navigator.of(context).pushNamed('new_entry'); },
  );
}