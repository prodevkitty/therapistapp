import 'package:flutter/material.dart';
import 'package:therapistapp/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:therapistapp/ui/theme/theme.dart';
import 'package:therapistapp/widgets/customAppBar.dart';
import 'package:therapistapp/widgets/customWidgets.dart';

class ProxyPage extends StatelessWidget {
  const ProxyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Proxy',
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const <Widget>[
          SettingRowWidget(
            "Enable HTTP Proxy",
            showCheckBox: false,
            vPadding: 15,
            showDivider: true,
            subtitle:
                'Configure HTTP proxy for network request (note: this does not apply to browser).',
          ),
          SettingRowWidget(
            "Proxy Host",
            subtitle: 'Configure your proxy\'s hostname.',
            showDivider: true,
          ),
          SettingRowWidget(
            "Proxy Port",
            subtitle: 'Configure your proxy\'s port number.',
          ),
        ],
      ),
    );
  }
}
