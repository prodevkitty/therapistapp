import 'package:flutter/material.dart';

class TopAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  TopAppBar({required this.scaffoldKey});

  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  @override
  void initState() {
    super.initState();
  }

  bool english = true;

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              widget.scaffoldKey.currentState!.openDrawer();
            },
          );
        },
      ),
      title: Image.asset('assets/images/icon-480.png', height: 40),
      centerTitle: true,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      bottom: PreferredSize(
        child: Container(
          color: Colors.grey.shade200,
          height: 1.0,
        ),
        preferredSize: const Size.fromHeight(0.0),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                english = !english;
              });
            },
            icon: Image.asset(
                english
                    ? 'assets/images/en.png'
                    : 'assets/images/es.png',
                width: 24))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSliverAppBar(context);
  }
}