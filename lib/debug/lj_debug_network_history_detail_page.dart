import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lj_package/utils/lj_network.dart';

import 'lj_json_widget.dart';

class DebugNetworkHistoryDetailPage extends StatefulWidget {
  final NetworkHistoryModel historyModel;

  const DebugNetworkHistoryDetailPage({Key? key, required this.historyModel})
      : super(key: key);

  @override
  _DebugNetworkHistoryDetailPageState createState() =>
      _DebugNetworkHistoryDetailPageState();
}

class _DebugNetworkHistoryDetailPageState
    extends State<DebugNetworkHistoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F9),
      appBar: AppBar(
        title: Text(widget.historyModel.title ?? ''),
        actions: [
          IconButton(
              icon: Icon(
                Icons.file_copy,
              ),
              onPressed: () {
                setState(() {
                  String value = widget.historyModel.toString();
                  Clipboard.setData(ClipboardData(text: value));
                });
              }),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.historyModel.url ?? '',
                  style: TextStyle(
                    color: Color(0xFF1BA3FF),
                    fontSize: 15,
                  ),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color(0xFF717171),
                ),
                Text(
                  widget.historyModel.method ?? '',
                  style: TextStyle(
                    color: Color(0xFF1BA3FF),
                    fontSize: 15,
                  ),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color(0xFF717171),
                ),
                ...mapWidget(widget.historyModel.headers ?? {}),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color(0xFF717171),
                ),
                ...mapWidget(widget.historyModel.params ?? {}),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color(0xFF717171),
                ),
                ...mapWidget(widget.historyModel.responseHeaders ?? {}),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color(0xFF717171),
                ),
                if (widget.historyModel.errorCode == null)
                  LJJsonViewerWidget(
                      jsonDecode(widget.historyModel.jsonResult ?? '')),
                if (widget.historyModel.errorCode != null)
                  Text(
                    (widget.historyModel.errorCode ?? '') +
                        '   ' +
                        (widget.historyModel.errorMsg ?? ''),
                    style: TextStyle(
                      color: Color(0xFF1BA3FF),
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> mapWidget(Map map) {
    List<Widget> headerWidget = [];
    map.forEach((key, value) {
      headerWidget.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '$key : $value',
            style: TextStyle(
              color: Color(0xFF1BA3FF),
              fontSize: 15,
            ),
          ),
        ),
      );
    });

    return headerWidget;
  }
}
