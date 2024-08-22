import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DraggableWidget extends StatelessWidget {
  final String data;
  final void Function() onDragStart;
  final Widget child;

  const DraggableWidget({
    	super.key,
      required this.data,
      required this.onDragStart,
      required this.child
    });

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(dragItemProvider: (DragItemRequest request) {
      onDragStart();
      final item = DragItem(
        localData: data,
      );
      return item;
    },
    dragBuilder: (context, child) => Opacity(opacity: 0.8, child: child),
    allowedOperations: () => [DropOperation.copy],
    child: DraggableWidget(onDragStart: onDragStart, data: data, child: child),
    );
  }
}
