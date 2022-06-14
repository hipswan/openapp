import 'package:flutter/material.dart';

class ShopOfferTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const ShopOfferTile({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all(
          Colors.black,
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 22,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: Colors.grey.shade300,
              width: 2,
            ),
          ),
        ),
        elevation: MaterialStateProperty.all(
          0.5,
        ),
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
