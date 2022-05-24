
import 'package:flutter/material.dart';

import 'lj_debug_network_history_page.dart';
import 'lj_debug_service_list_page.dart';

class LJDebugPage extends StatefulWidget {
  @override
  _LJDebugPageState createState() => _LJDebugPageState();
}

class _LJDebugPageState extends State<LJDebugPage> {
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
