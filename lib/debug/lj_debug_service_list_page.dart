import 'package:flutter/material.dart';
import 'package:lj_package/utils/lj_define.dart';
import 'package:lj_package/utils/lj_util.dart';

import 'lj_debug_config.dart';

class DebugServiceListPage extends StatefulWidget {
  @override
  _DebugServiceListPageState createState() => _DebugServiceListPageState();
}

class _DebugServiceListPageState extends State<DebugServiceListPage> {
  int _index = LJUtil.preferences.getInt('LJDebugIndex') ?? 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F9),
      appBar: AppBar(
        title: Text('服务器列表'),
      ),
      body: ListView.separated(
        itemCount: LJDebugConfig.configList.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, String> service = LJDebugConfig.configList[index];

          return GestureDetector(
            onTap: () {
              LJDebugConfig.serviceChangeCallback(service);
              LJUtil.preferences.setInt('LJDebugIndex', index);
              setState(() {
                _index = index;
              });
            },
            child: Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: service
                          .map((key, value) => MapEntry(
                              key,
                              Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: quickRichText([
                                    key,
                                    '：',
                                    value,
                                  ], [
                                    TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    TextStyle(
                                        color: Color(0xFF666666), fontSize: 14)
                                  ]))))
                          .values
                          .toList(),
                    ),
                  ),
                  if (index == _index)
                    Icon(
                      Icons.done,
                      color: Color(0xFF1BA3FF),
                    ),
                ],
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
