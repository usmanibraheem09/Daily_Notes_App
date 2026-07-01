import 'package:daily_notes_app/constants/constants.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.title,
    required this.description,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String description;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12), // also fixed EdgeInsetsGeometry -> EdgeInsets
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    titleCase(title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuButton<int>(
                  iconColor: Colors.white,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      onTap: onEdit,
                      child: const ListTile(
                        title: Text('Edit'),
                        leading: Icon(Icons.edit),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      onTap: onDelete,
                      child: const ListTile(
                        title: Text('Delete'),
                        leading: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              capitalize(description),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}