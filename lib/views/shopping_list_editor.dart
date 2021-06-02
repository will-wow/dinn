import 'package:dinn/models/shopping_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: use lexorank: https://medium.com/whisperarts/lexorank-what-are-they-and-how-to-use-them-for-efficient-list-sorting-a48fc4e7849f

class ShoppingListEditor extends StatefulWidget {
  const ShoppingListEditor(
      {Key? key,
      required this.userId,
      required this.onShoppingList,
      this.shoppingList})
      : super(key: key);

  final String userId;
  final ShoppingList? shoppingList;
  final Function onShoppingList;

  @override
  _ShoppingListEditorState createState() => _ShoppingListEditorState();
}

class _ShoppingListEditorState extends State<ShoppingListEditor> {
  final _formKey = GlobalKey<FormState>();

  late ShoppingList _shoppingList;

  @override
  void initState() {
    setState(() {
      _shoppingList = widget.shoppingList != null
          ? widget.shoppingList!
          : ShoppingList(owners: [widget.userId]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(title: Text("Shopping List")),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    initialValue: _shoppingList.title,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please add a name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _shoppingList.title = value;
                    },
                  )),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));

                    widget.onShoppingList(_shoppingList);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ));
  }
}
