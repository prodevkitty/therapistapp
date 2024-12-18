import 'package:flutter/material.dart';
import 'package:therapistapp/helper/enum.dart';
import 'package:therapistapp/model/feedModel.dart';
import 'package:therapistapp/state/authState.dart';
import 'package:therapistapp/state/feedState.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:therapistapp/widgets/customWidgets.dart';
import 'package:therapistapp/widgets/newWidget/customLoader.dart';
import 'package:therapistapp/widgets/newWidget/emptyList.dart';
import 'package:therapistapp/widgets/tweet/tweet.dart';
import 'package:therapistapp/widgets/tweet/widgets/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

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
      backgroundColor: TwitterColor.mystic,
      body: SafeArea(
        child: SizedBox(
          height: context.height,
          width: context.width,
          child: _Dashboard(
            refreshIndicatorKey: refreshIndicatorKey,
            scaffoldKey: scaffoldKey,
          ),
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  const _Dashboard(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
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
                      scaffoldKey.currentState!.openDrawer();
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
            ),
            const SliverToBoxAdapter(
              child: EmptyList(
                'No Tweet added yet',
                subTitle:
                    'When new Tweet added, they\'ll show up here \n Tap tweet button to add new',
              ),
            )
          ],
        );
      },
    );
  }
}
