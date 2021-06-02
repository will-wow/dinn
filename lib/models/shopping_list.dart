class ShoppingListItem {
  ShoppingListItem({
    required this.product,
    required this.category,
    this.done = false,
  });

  ShoppingListItem.fromJson(Map<String, Object?> json)
      : this(
          product: (json['product']! as String),
          category: json['category']! as String,
          done: json['done']! as bool,
        );

  String product;
  String category;
  bool done;

  Map<String, Object?> toJson() {
    return {
      'product': product,
      'category': category,
      'done': done,
    };
  }
}

class ShoppingList {
  ShoppingList({
    this.title = '',
    this.owners = const [],
    this.items = const [],
  });
  ShoppingList.fromJson(Map<String, Object?> json)
      : this(
          owners: (json['owners']! as List).cast<String>(),
          title: json['title']! as String,
          items: (json['items'] as List).cast<ShoppingListItem>(),
        );

  List<String> owners;
  String title;
  List<ShoppingListItem> items;

  Map<String, Object?> toJson() {
    return {'title': title, 'owners': owners, 'items': items};
  }
}
