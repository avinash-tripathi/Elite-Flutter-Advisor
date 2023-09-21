import 'package:flutter/material.dart';

class PopupMenuCell extends StatelessWidget {
  final String item;

  const PopupMenuCell(this.item);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<String>(
        onSelected: (value) {
          // Handle menu item selection here
          if (value == 'edit') {
            // Perform edit action
          } else if (value == 'delete') {
            // Perform delete action
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
            ),
          ),
        ],
        child: const Icon(Icons.more_horiz),
      ),
    );
  }
}
