import 'package:flutter/material.dart';
import 'package:therapistapp/state/authState.dart';
import 'package:therapistapp/state/feedState.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:therapistapp/widgets/customWidgets.dart';
import 'package:therapistapp/ui/page/progressChart.dart';
import 'package:provider/provider.dart';

class Improvement extends StatelessWidget {
  const Improvement(
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
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              // refresh home page feed
              var feedState = Provider.of<FeedState>(context, listen: false);
              feedState.getDataFromDatabase();
              return Future.value(true);
            },
            child: _Improvement(
              refreshIndicatorKey: refreshIndicatorKey,
              scaffoldKey: scaffoldKey,
            ),
          )
        ),
      ),
    );
  }
}

class _Improvement extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  const _Improvement(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  @override
  __ImprovementState createState() => __ImprovementState();
}

class __ImprovementState extends State<_Improvement> {
  bool english = true;

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
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
            child: ProgressChart(
              progressData: [
                ProgressData(
                  date: DateTime(2024, 12, 1),
                  stressLevel: 7.0,
                  negativeThoughtsReduction: 1.0,
                  positiveThoughtsIncrease: 1.0,
                ),
                ProgressData(
                  date: DateTime(2024, 12, 2),
                  stressLevel: 6.5,
                  negativeThoughtsReduction: 3.5,
                  positiveThoughtsIncrease: 3.5,
                ),
                ProgressData(
                  date: DateTime(2024, 12, 3),
                  stressLevel: 5.0,
                  negativeThoughtsReduction: 5.0,
                  positiveThoughtsIncrease: 5.0,
                ),
                ProgressData(
                  date: DateTime(2024, 12, 4),
                  stressLevel: 5.5,
                  negativeThoughtsReduction: 5.5,
                  positiveThoughtsIncrease: 5.5,
                ),
                ProgressData(
                  date: DateTime(2024, 12, 5),
                  stressLevel: 4.0,
                  negativeThoughtsReduction: 7.0,
                  positiveThoughtsIncrease: 6.0,
                ),
                ProgressData(
                  date: DateTime(2024, 12, 6),
                  stressLevel: 1.5,
                  negativeThoughtsReduction: 8.2,
                  positiveThoughtsIncrease: 8.5,
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}
