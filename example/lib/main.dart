import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_freshchat/flutter_freshchat.dart';
import 'package:localstorage/localstorage.dart';

import 'update_userinfo_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Item> items = <Item>[
    Item(
        text: 'Update User Info',
        onTap: (BuildContext context) {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => UpdateUserInfoScreen()),
          );
        }),
    Item(
        text: 'Identify User',
        onTap: (BuildContext context) async {
          final LocalStorage storage = LocalStorage('example_storage');
          //Navigate to update email ID and name screen
          final String? uid = await storage.getItem('uid') as String?;
          final String? restoreId =
              await storage.getItem('restoreId') as String?;

          if (uid == null) {
            Scaffold.of(context).showSnackBar(
              const SnackBar(content: Text('Please update the user info')),
            );
          } else if (restoreId == null) {
            final String? newRestoreId =
                await FlutterFreshchat.identifyUser(externalID: uid);
            await storage.setItem('restoreId', newRestoreId);
          } else {
            await FlutterFreshchat.identifyUser(
                externalID: uid, restoreID: restoreId);
          }
        }),
    Item(
        text: 'Show Conversation',
        onTap: (BuildContext context) async {
          await FlutterFreshchat.showConversations();
        }),
    Item(
        text: 'Show FAQs',
        onTap: (BuildContext context) async {
          await FlutterFreshchat.showFAQs();
        }),
    Item(
        text: 'Get Unread Message Count',
        onTap: (BuildContext context) async {
          final int? val = await FlutterFreshchat.getUnreadMsgCount();
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Message count $val')));
        }),
    Item(
        text: 'Setup Notifications',
        onTap: (_) {
          // Navigate to update email ID and name screen
        }),
    Item(
        text: 'Reset User',
        onTap: (BuildContext context) async {
          await FlutterFreshchat.resetUser();
        }),
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await FlutterFreshchat.init(
      appID: 'YOUR_API_KEY_HERE',
      appKey: 'YOUR_APP_KEY_HERE',
      domain: 'YOUR_APP_DOMAIN_HERE',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Flutter Freshchat Example App'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (BuildContext context, int i) {
            return ListItem(
              item: items[i].text,
              onTap: () => items[i].onTap(context),
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({required this.item, required this.onTap});

  final String item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              const CircleAvatar(child: Text('A')),
              const Padding(padding: EdgeInsets.only(right: 10.0)),
              Text(item)
            ],
          ),
        ),
      ),
    );
  }
}

class Item {
  Item({required this.text, required this.onTap});

  String text;
  Function(BuildContext context) onTap;
}
