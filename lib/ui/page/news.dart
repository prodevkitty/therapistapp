import 'package:flutter/material.dart';
import 'package:therapistapp/state/feedState.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:therapistapp/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class News extends StatelessWidget {
  const News({Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
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
          child: _NewsPageBody(
            refreshIndicatorKey: refreshIndicatorKey,
            scaffoldKey: scaffoldKey,
          ),
        ),
      ),
    );
  }
}

class _NewsPageBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;
  _NewsPageBody(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  @override
  __NewsPageBodyState createState() => __NewsPageBodyState();
}

class __NewsPageBodyState extends State<_NewsPageBody> {
  bool english = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedState>(
      builder: (context, state, child) {
        return CustomScrollView(
          slivers: <Widget>[
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Container(
                height: context.height - 135,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildNewsSection(
                        context,
                        title: 'Track Your Mental Health Progress with Our New Graph Feature',
                        imagePath: 'assets/images/news1.jpeg',
                        description:
                            "We're excited to introduce an interactive graph feature to our app, designed to help you track and visualize your mental health progress over time. This feature offers an insightful view into your emotional trends, daily reflections, and goal achievements, so you can better understand your journey and celebrate improvements along the way.",
                        detailImages: [
                          'assets/images/news1-detail1.jpg',
                          'assets/images/news1-detail2.jpg',
                        ],
                        footerText:
                            "Tracking progress can be a powerful tool for mental wellness. Our new graph feature makes this process easy and insightful.",
                      ),
                      _buildNewsSection(
                        context,
                        title: 'Introducing Personalized Wellness Notifications',
                        imagePath: 'assets/images/news2.jpeg',
                        description:
                            "We understand that staying motivated is an important part of mental health care. Our new personalized notifications feature delivers reminders and encouragement tailored to your needs and progress. Each notification is designed to support your journey, with positive affirmations, gentle reminders, and prompts for reflection.",
                        detailImages: [
                          'assets/images/news2-detail1.jpg',
                          'assets/images/news2-detail2.jpg',
                        ],
                        footerText:
                            "From daily check-ins to gentle nudges, our notifications help keep you engaged with your goals. You will receive motivational messages based on your progress, making it easier to stay positive and focused on your mental wellness journey.",
                      ),
                      _buildNewsSection(
                        context,
                        title: 'Subscription Plans Now Include Unlimited Chat Options',
                        imagePath: 'assets/images/news3.jpeg',
                        description:
                            "We're thrilled to announce that our subscription plans now include unlimited chat options. Whether you choose the Pack of 4 Monthly Sessions or the Unlimited Sessions Pack, you can reach out whenever you need support. Our goal is to provide you with flexible and accessible resources to maintain your mental well-being.",
                        detailImages: [
                          'assets/images/news3-detail1.jpg',
                          'assets/images/news3-detail2.jpg',
                        ],
                        footerText:
                            "Tracking progress can be a powerful tool for mental wellness. Our new graph feature makes this process easy and insightful.",
                      ),
                    ],
                  ),
                ),
              ) 
            ),
          ],
        );
      },
    );
  }

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

  Widget _buildNewsSection(
    BuildContext context, {
    required String title,
    required String imagePath,
    required String description,
    required String footerText,
    required List<String> detailImages,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5),
          Divider(color: Colors.grey),
          SizedBox(height: 5),
          Container(
            height: 200,
            child: Center(
              child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Divider(color: Colors.grey),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5),
          Divider(color: Colors.grey),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: detailImages
                .map((image) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 5),
          Divider(color: Colors.grey),
          SizedBox(height: 5),
          Text(
            footerText,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
