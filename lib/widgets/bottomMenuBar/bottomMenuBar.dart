import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:therapistapp/state/appState.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:therapistapp/widgets/bottomMenuBar/tabItem.dart';
import 'package:provider/provider.dart';

import '../customWidgets.dart';

class BottomMenubar extends StatefulWidget {
  const BottomMenubar({
    Key? key,
  });
  @override
  _BottomMenubarState createState() => _BottomMenubarState();
}

class _BottomMenubarState extends State<BottomMenubar> {
  @override
  void initState() {
    super.initState();
  }

  Widget _iconRow() {
    var state = Provider.of<AppState>(context);
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarTheme.color,
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, -.1), blurRadius: 0),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _icon(index: 0, icon: FontAwesomeIcons.home),
          _icon(index: 1, icon: FontAwesomeIcons.chartLine),
          _icon(index: 2, icon: FontAwesomeIcons.newspaper),
          _icon(index: 3, icon: FontAwesomeIcons.phone),
        ],
      ),
    );
  }

  Widget _icon({
    required int index,
    required IconData icon,
  }) {
    var state = Provider.of<AppState>(context);
    bool isActive = index == state.pageIndex;

    return Expanded(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: AnimatedAlign(
          duration: const Duration(milliseconds: ANIM_DURATION),
          curve: Curves.easeIn,
          alignment: const Alignment(0, ICON_ON),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: ANIM_DURATION),
            opacity: ALPHA_ON,
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              alignment: const Alignment(0, 0),
              icon: FaIcon(
                icon,
                size: isActive ? 26 : 22, // Larger size for active icon
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodySmall!.color,
              ),
              onPressed: () {
                setState(() {
                  state.setPageIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _iconRow();
  }
}
