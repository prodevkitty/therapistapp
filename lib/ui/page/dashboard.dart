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
import 'package:infinite_carousel/infinite_carousel.dart';

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
      backgroundColor: Colors.white,
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

class _Dashboard extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  const _Dashboard(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<_Dashboard> {
  ScrollController slickController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    slickController.dispose();
  }

  List<Map<String, String>> carousels = [
    {
      'imgPath': 'assets/images/slider4.jpg',
      'title': 'Your Journey to Mental Wellness Starts Here!',
      'value':
          "Discover personalized therapy sessions and wellness tools that empower your growth. With Therapist Chatbot, you'll find guidance to achieve balance and clarity."
    },
    {
      'imgPath': 'assets/images/slider5.jpg',
      'title': 'Compassionate Therapy, Always at Your Fingertips!',
      'value':
          "Let Therapist Chatbot support your mental health with expert care and insightful sessions designed just for you. Find comfort and understanding whenever you need it."
    },
    {
      'imgPath': 'assets/images/slider6.jpg',
      'title': 'Empower Your Mind, Elevate Your Life!',
      'value':
          "Experience tailored therapy sessions and emotional wellness tools that help you thrive. Therapist Chatbot is here to support your healing journey every step of the way."
    }
  ];
  List<Map<String, dynamic>> cards = [
    {
      "title": "Chronic Anxiety: The Silent Saboteur of Your Peace",
      "value":
          "Unchecked anxiety not only affects your mental state but also leads to severe physical symptoms like headaches, heart palpitations, and weakened immunity. Learn how to break free from the grip of constant worry and reclaim control over your life.",
      "icons": Icons.home
    },
    {
      "title": "Depression: A Hidden Burden that Drains Your Vitality",
      "value":
          "Depression can slowly erode your motivation, energy, and willpower, leaving you feeling isolated and empty. Take the first step towards healing by understanding its deep impact and how professional support can help you recover your zest for life.",
      "icons": Icons.home
    },
    {
      "title": "Stress-Induced Hypertension: The Hidden Risk in Daily Stress",
      "value":
          "Chronic stress can elevate your blood pressure, leading to serious health risks like heart disease and stroke. Learn how to manage stress effectively and protect your physical and mental well-being with tailored therapy sessions.",
      "icons": Icons.home
    },
  ];

  List<Map<String, dynamic>> plans = [
    {
      'icon': Icons.note,
      'planName': 'Basic',
      'price': 29,
      'benefits': [
        {'text': 'Voice Mood Analysis', 'available': true},
        {'text': 'Mood & Health Analysis', 'available': false},
        {'text': 'Voice Mood Analysis', 'available': true},
        {'text': 'Voice Mood Analysis', 'available': true},
      ]
    }
  ];
  List<IconData> icons = [Icons.home, Icons.emoji_emotions, Icons.heart_broken];
  bool english = true;
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Consumer<FeedState>(
      builder: (context, state, child) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              elevation: 4,
              shadowColor: Colors.grey,
             
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
                  color: Colors.white,
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
                    children: [
                      SizedBox(height: 36),
                      SizedBox(
                        height: 240,
                        child: InfiniteCarousel.builder(
                          controller: slickController,
                          itemBuilder: (context, index, realIndex) =>
                              _carouselItem(carousels[index]),
                          itemCount: 3,
                          itemExtent: 360,
                          axisDirection: Axis.horizontal,
                          loop: true,
                          center: true,

                          // infiniteScroll: true,
                        ),
                      ),
                      SizedBox(height: 32),
                      ...cards.map((data) => _card(data)).toList(),
                      SizedBox(height: 32),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Text(
                                'Find peace and strength with personalized tools that support you whenever you need them.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Image.asset(
                                'assets/images/section-img.png',
                                fit: BoxFit.cover,
                              ),
                              Text(
                                'Access personalized wellness tools like gratitude journals, breathing exercises, and meditations to support your mental health anytime.',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              ...[
                                {
                                  'icon': Icons.home,
                                  'title': 'Gratitude Journal',
                                  'desc':
                                      'Reflect on and record moments of gratitude to foster a positive mindset between sessions.'
                                },
                                {
                                  'icon': Icons.home,
                                  'title': 'Calm Breathing',
                                  'desc':
                                      'Engage in guided breathing exercises designed to reduce stress and promote relaxation.'
                                },
                                {
                                  'icon': Icons.home,
                                  'title': 'Guided Meditations',
                                  'desc':
                                      'Experience peace through meditations tailored to your emotional state and well-being.'
                                },
                                {
                                  'icon': Icons.home,
                                  'title': 'Thought Exercises',
                                  'desc':
                                      'Challenge negative thinking with exercises to reframe and strengthen mental resilience.'
                                },
                              ]
                                  .map((e) => Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              e['icon'] as IconData,
                                              size: 80,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(height: 18),
                                            Text(
                                              e['title'].toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              e['desc'].toString(),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ],
                          )),
                      ...[
                        {
                          'icon': Icons.people,
                          'number': 10,
                          'text': 'Years of Combined Experience'
                        },
                        {
                          'icon': Icons.message,
                          'number': 10,
                          'text': 'Years of Combined Experience'
                        },
                        {
                          'icon': Icons.emoji_emotions_outlined,
                          'number': 10,
                          'text': 'Years of Combined Experience'
                        },
                        {
                          'icon': Icons.calendar_month,
                          'number': 10,
                          'text': 'Years of Combined Experience'
                        },
                        {
                          'icon': Icons.question_mark,
                          'number': 10,
                          'text': 'Years of Combined Experience'
                        },
                        {
                          'icon': Icons.thumb_up,
                          'number': 10,
                          'text': 'Years of Combined Experience'
                        },
                      ]
                          .map((e) => Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 24),
                                color: Colors.blue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      e['icon'] as IconData,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 18),
                                    Text(
                                      e['number'].toString(),
                                      style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      e['text'].toString(),
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Column(
                          children: [
                            Text(
                              'Advanced AI-Powered Support for Your Mental Wellness',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Image.asset(
                              'assets/images/section-img.png',
                              fit: BoxFit.cover,
                            ),
                            Text(
                              'Our platform offers personalized, real-time insights and tools—from mood detection to wellness monitoring—to support and enhance your mental health journey at every step.',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            ...[
                              {
                                'icon': Icons.mic,
                                'title': 'Gratitude Journal',
                                'desc':
                                    'Reflect on and record moments of gratitude to foster a positive mindset between sessions.'
                              },
                              {
                                'icon': Icons.remove_red_eye,
                                'title': 'Calm Breathing',
                                'desc':
                                    'Engage in guided breathing exercises designed to reduce stress and promote relaxation.'
                              },
                              {
                                'icon': Icons.cloud,
                                'title': 'Guided Meditations',
                                'desc':
                                    'Experience peace through meditations tailored to your emotional state and well-being.'
                              },
                              {
                                'icon': Icons.home,
                                'title': 'Thought Exercises',
                                'desc':
                                    'Challenge negative thinking with exercises to reframe and strengthen mental resilience.'
                              },
                            ]
                                .map((e) => Container(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            e['icon'] as IconData,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 18),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e['title'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  e['desc'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                            Text(
                              'Our Services',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Image.asset(
                              'assets/images/section-img.png',
                              fit: BoxFit.cover,
                            ),
                            Text(
                              'Choose a plan that fits your needs and enjoy personalized therapy sessions.',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      ...plans.map((e) => _membershipCard(e)).toList()
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _carouselItem(Map<String, String> data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          ClipRRect(
            child: Image.asset(
              data['imgPath'] ?? '',
              fit: BoxFit.cover,
              height: 240,
              width: 360,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              children: [
                Text(
                  data['title'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  data['value'] ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _card(Map<String, dynamic> data) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
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
                data['title'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                data['value'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            data['icon'],
            color: Colors.lightBlue,
          ),
        ),
      ],
    );
  }

  Widget _membershipCard(Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            data['icon'],
            size: 60,
            color: Colors.blue,
          ),
          SizedBox(width: 16),
          Text(
            data['planName'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '\$ ${data['price']}',
            style: TextStyle(fontSize: 36, color: Colors.blue),
          ),
          SizedBox(height: 16),
          ...data['benefits'].map<Widget>((benefit) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  benefit['text'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  benefit['available'] ? Icons.check_circle : Icons.close_sharp,
                  color: benefit['available'] ? Colors.blue : Colors.grey,
                ),
              ],
            );
          }).toList(),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle subscription logic here
            },
            child: Text(
              'Get Started',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
