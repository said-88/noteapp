import 'package:flutter/material.dart';
import 'package:myapp/components/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String title;
  final String content;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final void Function()? onTap;

  const NoteTile({
    super.key,
    required this.title,
    required this.content,
    this.onTap,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
        child: ListTile(
          title: Text(title),
          onTap: onTap,
          subtitle: Text(content),
              trailing: Builder(builder: (context) =>  IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => showPopover(context: context,
              width: 100,
              height: 100, 
              backgroundColor: Theme.of(context).colorScheme.surface,
              bodyBuilder: (context) => NoteSettings(
                onEditTap: onEditPressed,
                onDeleteTap: onDeletePressed,
              )
            ),
          )
        )
      )
    );
  }
}
