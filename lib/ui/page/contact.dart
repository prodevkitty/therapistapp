import 'package:flutter/material.dart';
import 'package:therapistapp/state/feedState.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:therapistapp/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class Contact extends StatelessWidget {
  const Contact(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})  
      : super(key: key);

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  final GlobalKey<ScaffoldState> scaffoldKey;

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/ChatScreenPage');
      },
      child: customIcon(
        context,
        icon: Icons.chat,
        isTwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(context),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: context.height,
          width: context.width,
          child: _ContactPageBody(
            refreshIndicatorKey: refreshIndicatorKey,
            scaffoldKey: scaffoldKey,
          ),
        ),
      ),
    );
  }
}

class _ContactPageBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  _ContactPageBody(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  @override
  __ContactPageBodyState createState() => __ContactPageBodyState();
}

class __ContactPageBodyState extends State<_ContactPageBody> {
  bool english = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedState>(
      builder: (context, state, child) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
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
            ),
            SliverToBoxAdapter(
              child: Container(
                height: context.height - 135,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: EdgeInsets.all(12), 
                        child: Center(
                          child: Text(
                            'Contact Us',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Container(
                        padding: EdgeInsets.all(12),
                        height: 300,
                        child: Image.asset(
                          'assets/images/contact.png',
                          fit: BoxFit.cover,
                        ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        padding: EdgeInsets.all(6), 
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        padding: EdgeInsets.all(6), 
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        padding: EdgeInsets.all(6), 
                        child: TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        padding: EdgeInsets.all(6), 
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2.0),
                              elevation: 0, // Set elevation to 0
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.blue,
                              minimumSize:
                                  Size(double.infinity, 50), // Increase width
                            ),
                            onPressed: () {
                              // Handle sign in
                              // Navigator.of(context).pushReplacementNamed('/home');
                            },
                            child: Text(
                              'Send',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
