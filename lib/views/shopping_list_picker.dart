import 'package:dinn/models/shopping_list.dart';
import 'package:dinn/views/shopping_list_editor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: use lexorank: https://medium.com/whisperarts/lexorank-what-are-they-and-how-to-use-them-for-efficient-list-sorting-a48fc4e7849f

final shoppingListsRef = FirebaseFirestore.instance
    .collection('shopping-lists')
    .withConverter<ShoppingList>(
      fromFirestore: (snapshots, _) => ShoppingList.fromJson(snapshots.data()!),
      toFirestore: (shoppingList, _) => shoppingList.toJson(),
    );

class ShoppingListPicker extends StatefulWidget {
  const ShoppingListPicker({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _ShoppingListPickerState createState() => _ShoppingListPickerState();
}

class _ShoppingListPickerState extends State<ShoppingListPicker> {
  late Stream<QuerySnapshot<ShoppingList>> _shoppingLists;

  @override
  void initState() {
    super.initState();

    final query =
        shoppingListsRef.where("owners", arrayContains: widget.user.uid);

    setState(() {
      _shoppingLists = query.snapshots();
    });
  }

  void _pushShoppingListForm(
      [ShoppingList? shoppingList,
      DocumentReference<ShoppingList>? reference]) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return ShoppingListEditor(
        userId: widget.user.uid,
        shoppingList: shoppingList,
        onShoppingList: (ShoppingList shoppingList) {
          if (reference == null) {
            // Create
            shoppingListsRef.doc().set(shoppingList);
          } else {
            // Update
            reference.set(shoppingList);
          }
        },
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Startup Name Generator'), actions: [
        IconButton(icon: Icon(Icons.plus_one), onPressed: _pushShoppingListForm)
      ]),
      body: StreamBuilder<QuerySnapshot<ShoppingList>>(
        stream: _shoppingLists,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          final tiles = data.docs.map((doc) {
            final data = doc.data();
            print(data);
            return ListTile(
              title: Text(data.title),
              onTap: () {
                _pushShoppingListForm(doc.data(), doc.reference);
              },
            );
          });

          print(tiles);

          return ListView(
              children: ListTile.divideTiles(context: context, tiles: tiles)
                  .toList());
        },
      ),
    );
  }
}

// class _ShoppingList extends StatelessWidget {
//   _ShoppingList(this.list, this.reference);

//   final ShoppingList list;
//   final DocumentReference<ShoppingList> reference;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4, top: 4),
//       child: Row(
//         children: [
//           poster,
//           Flexible(child: details),
//         ],
//       ),
//     );
//   }
// }

// class _ShoppingListItem extends StatelessWidget {
//   _ShoppingListItem(this.item, this.reference);

//   final ShoppingListItem item;
//   final DocumentReference<ShoppingListItem> reference;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4, top: 4),
//       child: Row(
//         children: [
//           poster,
//           Flexible(child: details),
//         ],
//       ),
//     );
//   }
// }
