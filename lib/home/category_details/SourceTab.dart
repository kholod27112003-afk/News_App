import 'package:flutter/material.dart';
import 'package:news_app/models/SourceResponse.dart';

class SourceTab extends StatelessWidget {
  SourceTab({super.key, required this.source, required this.isSelected});
  Sources source;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Text(
      source.name ?? "",
      style: isSelected
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.labelMedium,
    );
  }
}
