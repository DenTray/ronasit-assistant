import 'package:flutter/material.dart';
import 'package:ronas_assistant/src/support/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Avatar extends StatefulWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  String _gravatarLink = 'https://www.gravatar.com/avatar/initial';

  @override
  void initState() {
    super.initState();

    _generateGravatarLink();
  }

  _generateGravatarLink() async {
    final preferences = await SharedPreferences.getInstance();

    String userName = preferences.getString('user.username') ?? '';
    String email = '$userName@ronasit.com';

    setState(() {
      _gravatarLink = 'https://www.gravatar.com/avatar/${Helpers.generateMd5(email)}?s=2000';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.network(
        _gravatarLink,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center
      )
    );
  }
}
