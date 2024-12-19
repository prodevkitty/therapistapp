import 'package:flutter/material.dart';
import 'package:therapistapp/state/authState.dart';
import 'package:therapistapp/state/feedState.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:therapistapp/widgets/customWidgets.dart';
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
          "Discover personalized therapy sessions and wellness tools that empower your growth"
    },
    {
      'imgPath': 'assets/images/slider5.jpg',
      'title': 'Compassionate Therapy, Always at Your Fingertips!',
      'value':
          "Let Therapist Chatbot support your mental health with expert care and insightful sessions designed just for you"
    },
    {
      'imgPath': 'assets/images/slider6.jpg',
      'title': 'Empower Your Mind',
      'value':
          "Experience tailored therapy sessions and emotional wellness tools that help you thrive"
    }
  ];
  List<Map<String, dynamic>> cards = [
    {
      "title": "Chronic Anxiety: The Silent Saboteur of Your Peace",
      "value":
          "Unchecked anxiety not only affects your mental state but also leads to severe physical symptoms like headaches, heart palpitations, and weakened immunity. Learn how to break free from the grip of constant worry and reclaim control over your life.",
      "icons": Icons.psychology
    },
    {
      "title": "Depression: A Hidden Burden that Drains Your Vitality",
      "value":
          "Depression can slowly erode your motivation, energy, and willpower, leaving you feeling isolated and empty. Take the first step towards healing by understanding its deep impact and how professional support can help you recover your zest for life.",
      "icons": Icons.mood_bad
    },
    {
      "title": "Stress-Induced Hypertension: The Hidden Risk in Daily Stress",
      "value":
          "Chronic stress can elevate your blood pressure, leading to serious health risks like heart disease and stroke. Learn how to manage stress effectively and protect your physical and mental well-being with tailored therapy sessions.",
      "icons": Icons.heart_broken
    },
  ];

  List<Map<String, dynamic>> plans = [
    {
      'icon': Icons.star_border,
      'planName': 'Basic',
      'price': 29,
      'benefits': [
        {'text': 'Voice Mood Analysis', 'available': true},
        {'text': 'Mood & Health Analysis', 'available': false},
        {'text': 'Sentiment Analysis', 'available': true},
        {'text': 'Contextual Memory', 'available': false},
        {'text': 'Wellness Monitoring', 'available': false},
        {'text': 'Group Therapy Sessions', 'available': false},
        {'text': 'Gratitude Journals', 'available': true},
        {'text': 'Calm Breathing Techniques', 'available': true},
        {'text': 'Guided Meditations', 'available': false},
        {'text': 'Thought Exercises', 'available': false},
      ]
    },
    {
      'icon': Icons.upgrade,
      'planName': 'Enhanced Plan',
      'price': 29,
      'benefits': [
        {'text': 'Voice Mood Analysis', 'available': true},
        {'text': 'Mood & Health Analysis', 'available': false},
        {'text': 'Sentiment Analysis', 'available': true},
        {'text': 'Contextual Memory', 'available': true},
        {'text': 'Wellness Monitoring', 'available': false},
        {'text': 'Group Therapy Sessions', 'available': false},
        {'text': 'Gratitude Journals', 'available': true},
        {'text': 'Calm Breathing Techniques', 'available': true},
        {'text': 'Guided Meditations', 'available': true},
        {'text': 'Thought Exercises', 'available': true},
      ]
    },
    {
      'icon': Icons.all_inclusive,
      'planName': 'Basic',
      'price': 29,
      'benefits': [
        {'text': 'Voice Mood Analysis', 'available': true},
        {'text': 'Mood & Health Analysis', 'available': true},
        {'text': 'Sentiment Analysis', 'available': true},
        {'text': 'Contextual Memory', 'available': true},
        {'text': 'Wellness Monitoring', 'available': true},
        {'text': 'Group Therapy Sessions', 'available': true},
        {'text': 'Gratitude Journals', 'available': true},
        {'text': 'Calm Breathing Techniques', 'available': true},
        {'text': 'Guided Meditations', 'available': true},
        {'text': 'Thought Exercises', 'available': true},
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Image.asset(
                                'assets/images/section-img.png',
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Access personalized wellness tools like gratitude journals, breathing exercises, and meditations to support your mental health anytime.',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              ...[
                                {
                                  'icon': Icons.edit_note,
                                  'title': 'Gratitude Journal',
                                  'desc':
                                      'Reflect on and record moments of gratitude to foster a positive mindset between sessions.'
                                },
                                {
                                  'icon': Icons.medical_services,
                                  'title': 'Calm Breathing',
                                  'desc':
                                      'Engage in guided breathing exercises designed to reduce stress and promote relaxation.'
                                },
                                {
                                  'icon': Icons.spa,
                                  'title': 'Guided Meditations',
                                  'desc':
                                      'Experience peace through meditations tailored to your emotional state and well-being.'
                                },
                                {
                                  'icon': Icons.insights,
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
                                          size: 60,
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
                                              fontSize: 14,
                                              color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                            ],
                          )),
                        SizedBox(height: 20),
                      ...[
                        {
                          'icon': Icons.people,
                          'number': 5000,
                          'text': 'Total Users'
                        },
                        {
                          'icon': Icons.message,
                          'number': 12000,
                          'text': 'Therapy Sessions Conducted'
                        },
                        {
                          'icon': Icons.emoji_emotions_outlined,
                          'number': 4500,
                          'text': 'Happy Clients'
                        },
                        {
                          'icon': Icons.calendar_month,
                          'number': 10,
                          'text': 'Years of Combined Experience'
                        },
                        {
                          'icon': Icons.question_mark,
                          'number': 24,
                          'text': '7/24 Availability'
                        },
                        {
                          'icon': Icons.thumb_up,
                          'number': 90,
                          'text': 'User Satisfaction Rate'
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
                                  size: 70,
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
                      SizedBox(height: 10),
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
                            SizedBox(height: 10),
                            Image.asset(
                              'assets/images/section-img.png',
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Our platform provides real-time insights and tools, from mood detection to wellness monitoring, to support your mental health journey.',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            ...[
                              {
                                'icon': Icons.mic,
                                'title': 'Voice Mood Analysis',
                                'desc':
                                    'Using advanced voice analysis, the bot detects subtle emotional cues in your speech to provide tailored support and insights.'
                              },
                              {
                                'icon': Icons.remove_red_eye,
                                'title': 'Mood & Health Analysis',
                                'desc':
                                    'Using facial recognition, the bot assesses emotional cues and mood indicators to provide tailored mental health support and recommend therapies.'
                              },
                              {
                                'icon': Icons.lightbulb,
                                'title': 'Sentiment Analysis',
                                'desc':
                                    'The bot analyzes the tone of your messages to gauge mood and deliver personalized, real-time support.'
                              },
                              {
                                'icon': Icons.psychology,
                                'title': 'Contextual Memory',
                                'desc':
                                    'The bot remembers previous sessions and adapts to your unique needs over time, providing more relevant support.'
                              },
                              {
                                'icon': Icons.watch,
                                'title': 'Wellness Monitoring',
                                'desc':
                                    'The bot connects with your wearable devices to monitor wellness indicators and provide feedback on managing stress and improving health.'
                              },
                              {
                                'icon': Icons.groups,
                                'title': 'Group Therapy Sessions',
                                'desc':
                                    'Join community support groups to share experiences and connect with others facing similar challenges.'
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
                                        size: 40,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 20),
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
                                            SizedBox(height: 10),
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
                            SizedBox(height: 20),
                            Text(
                              'Our Services',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Image.asset(
                              'assets/images/section-img.png',
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10),
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
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                  data['title'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(right: 70.0),
                  child: Text(
                  data['value'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
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
          padding: EdgeInsets.all(24),
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
              SizedBox(height: 8),
              TextButton(
              onPressed: () {
                // Handle link button press
              },
              child: Text(
                'Read More',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dotted,
                  decorationThickness: 2,
                  decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 15,
          child: Icon(
            data['icons'],
            color: const Color.fromARGB(255, 144, 208, 238),
            size: 60,
          ),
        ),
      ],
    );
  }

  Widget _membershipCard(Map<String, dynamic> data) {
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '\$ ${data['price']}',
            style: TextStyle(fontSize: 30, color: Colors.blue),
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
                SizedBox(width: 10),
                Icon(
                  benefit['available'] ? Icons.check_circle : Icons.close,
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
