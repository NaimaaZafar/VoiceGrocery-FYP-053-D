import 'package:flutter/material.dart';
import 'package:fyp/utils/colors.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;

  const MySliverAppBar({
    super.key,
    required this.child,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      collapsedHeight: 120,
      floating: false,
      pinned: true,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart, color: Colors.white,),),
      ],
      backgroundColor: bg_dark,
      title: Text('Welcome', style: TextStyle(color: Colors.white),),
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FlexibleSpaceBar(
          background: child,
          title: title,
          centerTitle: true,
          titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
          expandedTitleScale: 1,
        ),
      ),
    );
  }
}