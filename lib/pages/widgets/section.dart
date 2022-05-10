import 'package:flutter/material.dart';

import '../../constant.dart';

class Section extends StatelessWidget {
  final String? tagName;
  final Color? tagColor;
  final String sectionName;
  final VoidCallback onPressed;
  Section({
    Key? key,
    this.tagName,
    this.tagColor,
    required this.sectionName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          sectionName,
          style: homePageTextStyle,
        ),
        const SizedBox(
          width: 5,
        ),
        tagName == null
            ? Container()
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: tagColor!,
                ),
                child: Text(
                  tagName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
        const Spacer(),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).primaryColor,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
      ],
    );
  }
}
