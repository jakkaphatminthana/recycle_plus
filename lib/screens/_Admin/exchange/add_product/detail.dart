import 'package:flutter/material.dart';

// class AddProcut_detail {
//   final String name;
//   final String description;
//   final String category;

//   AddProcut_detail({
//     required this.name,
//     required this.description,
//     required this.category,
//   });
// }

class AddProduct_detail extends StatelessWidget {
  AddProduct_detail({
    Key? key,
    required this.name,
    // required this.description,
    // required this.category,
  }) : super(key: key);

  TextEditingController name = TextEditingController();
  // TextEditingController description = TextEditingController();
  // TextEditingController category = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: name,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Enter name",
          ),
        ),
      ],
    );
  }
}
