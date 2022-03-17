import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final title;
  final image;

  const CategoryTile({Key? key, this.title, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 35,
            child: FlutterLogo(),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
