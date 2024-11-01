import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(),
        ),
      ),
    );
  }
}

class DraggableIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;

  const DraggableIconButton({Key? key, required this.icon, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<IconData>(
      data: icon,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 20)),
      ),
      feedback: Material(
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 30)),
        ),
      ),
      childWhenDragging: Container(), // Placeholder while dragging
    );
  }
}

class Dock extends StatefulWidget {
  @override
  _DockState createState() => _DockState();
}

class _DockState extends State<Dock> {
  List<IconData> items = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  int? draggedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          IconData icon = entry.value;

          return DragTarget<IconData>(
            onWillAccept: (data) {
              return data != null && data != icon; // Prevent accepting itself
            },
            onAccept: (data) {
              setState(() {
                int oldIndex = items.indexOf(data);
                items.removeAt(oldIndex);
                items.insert(index, data);
              });
            },
            builder: (context, candidateData, rejectedData) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeOut,
                // Maintain a consistent spacing
                margin: index == 0
                    ? EdgeInsets.only(left: 30,right: 20)
                    : index == items.length - 1
                        ? EdgeInsets.only(right: 10)
                        : EdgeInsets.symmetric(horizontal: 5),
                child: DraggableIconButton(icon: icon, color: Colors.blue),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
