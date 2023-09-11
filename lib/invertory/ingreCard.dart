import 'package:flutter/material.dart';

class ingredientCard extends StatefulWidget {
  final Icon icon;
  final String type;
  const ingredientCard({
    super.key,
    required this.type,
    required this.icon,
  });

  @override
  State<ingredientCard> createState() => _ingredientCardState();
}

class _ingredientCardState extends State<ingredientCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: Color(0xFFFFE2DC),
      elevation: 0,
      child: ListTile(
          leading: widget.icon,
          title: Text(
            widget.type,
            style: Theme.of(context).textTheme.headlineSmall,
          )),
      // trailing: Row(
      //   children: [
      //     MaterialButton(
      //       onPressed: () {},
      //     )
      //   ],
      // ),
    );
  }
}
