
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'og_debug_network_history_page.dart';
import 'og_debug_service_list_page.dart';

class OGDebugPage extends StatefulWidget {
  @override
  _OGDebugPageState createState() => _OGDebugPageState();
}

class _OGDebugPageState extends State<OGDebugPage> {
  List<String> _titles = [
    '服务器地址',
    '网络请求历史',
  ];

  List<WidgetBuilder> _builder = [
    (context) => DebugServiceListPage(),
    (context) => DebugNetworkHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('调试工具'),
      ),
      body: ListView.separated(
        itemCount: _titles.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: _builder[index]));
            },
            child: Container(
              height: 55,
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                _titles[index],
                style: TextStyle(
                  color: Color(0xFF1BA3FF),
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            indent: 15,
          );
        },
      ),
    );
  }
}
