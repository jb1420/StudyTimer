// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SwipableList extends StatefulWidget {
  const SwipableList({super.key});

  @override
  _SwipableListState createState() => _SwipableListState();
}

class _SwipableListState extends State<SwipableList> {

  final List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10'
  ];
  final Set<int> _selectedItems = <int>{};

  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Scaffold(
        body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            final isSelected = _selectedItems.contains(index);
            return Dismissible(
              key: Key(item),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                /// 삭제
                if (direction == DismissDirection.endToStart) {
                  setState(() {
                    _items.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item $item deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          setState(() {
                            _items.insert(index, item);
                          });
                        },
                      ),
                    ),
                  );
                }
                /// 완료
                else if (direction == DismissDirection.startToEnd) {
                  setState(() {
                    if (isSelected) {
                      _selectedItems.remove(index);
                    } else {
                      _selectedItems.add(index);
                    }
                  });
                }
              },
              background: Container(
                color: isSelected ? Colors.green : Colors.grey,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                alignment: Alignment.centerLeft,
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                alignment: Alignment.centerRight,
              ),
              child: ListTile(
                title: Text(item),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Add Item'),
                  content: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: 'Item name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _items.add(_textFieldController.text);
                          _textFieldController.clear();
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Add'),
                    ),
                    TextButton(
                      onPressed: () {
                        _textFieldController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
