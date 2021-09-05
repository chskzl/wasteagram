import 'package:flutter/material.dart';
import 'package:wasteagram/models/post.dart';

class DetailScreen extends StatelessWidget {

  Post? post;

  DetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          leading: Semantics(child: IconButton(onPressed: () { Navigator.of(context).pop(); }, icon: const Icon(Icons.arrow_back)), button: true, enabled: true, onTapHint: 'Back',),
          title: Text("Wasteagram"),
          centerTitle: true,
        ),
        body: Column(children: [
          Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20), child: Text('${post!.printWeekDay(true)}, ${post!.printDate()}', style: Theme.of(context).textTheme.headline5))),
          Center(child: Image.network(post!.imageURL, height: 250,loadingBuilder: (context, child, progress) {return progress == null ? child : Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0), child: CircularProgressIndicator());})),
          Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0), child: Text('Items: ${post!.quantity}', style: Theme.of(context).textTheme.headline5))),
          Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0), child: Text('(${post!.latitude}, ${post!.longitude})', style: Theme.of(context).textTheme.headline5)))
        ],)
    );
  }
}
