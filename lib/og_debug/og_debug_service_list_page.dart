import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oralingo_package/og_debug/og_debug_config.dart';
import 'package:oralingo_package/og_utils/og_define.dart';

class DebugServiceListPage extends StatefulWidget {
  @override
  _DebugServiceListPageState createState() => _DebugServiceListPageState();
}

class _DebugServiceListPageState extends State<DebugServiceListPage> {
  String debug_host = 'debug_host';
  final TextEditingController _textEditingController = TextEditingController();

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
      body: Column(
        children: [
          Expanded(
            child: _buildListView(),
          ),
          // _inputItem(),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: OGDebugConfig.configList?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        Map service = OGDebugConfig.configList[index];

        return GestureDetector(
          onTap: () {
            OGDebugConfig.debugIndex = index;
            if (OGDebugConfig.debugServiceChangeCallback != null)
              OGDebugConfig.debugServiceChangeCallback(index, service);
            setState(() {});
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
                                  key ?? '',
                                  '：',
                                  value ?? '',
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
                if (OGDebugConfig.debugIndex == index)
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
    );
  }

  Widget _inputItem() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xFFF3F4F5),
              ),
              child: TextField(
                controller: _textEditingController,
                // focusNode: _focusNode,
                textAlign: TextAlign.start,
                scrollPadding: EdgeInsets.zero,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  // fillColor: Colors.orange,
                  // filled: true,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 5),
                  border: InputBorder.none,
                  hintText: '请输入服务器地址',
                ),
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Container(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              if (_textEditingController.text.isEmpty) return;

              // _list.add(_textEditingController.text);

              // OGNetwork.baseUrl = _textEditingController.text;
              // OGNetwork.dio.options.baseUrl = OGNetwork.baseUrl;
              // // AppConfigManager.sharedPreferences
              // //     .setString(debug_host, DDNetwork.baseUrl);
              // OGUtil.preferences.setString(debug_host, OGNetwork.baseUrl);
              setState(() {});
            },
            child: Container(
              width: 75,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF1BA3FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '添加',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
