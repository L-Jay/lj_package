
import 'package:flutter/material.dart';
import 'package:lj_package/utils/lj_network.dart';
import 'lj_debug_network_history_detail_page.dart';

class DebugNetworkHistoryPage extends StatefulWidget {
  @override
  _DebugNetworkHistoryPageState createState() =>
      _DebugNetworkHistoryPageState();
}

class _DebugNetworkHistoryPageState extends State<DebugNetworkHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F9),
      appBar: AppBar(
        title: Text('网络请求列表'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                setState(() {
                  LJNetwork.historyList.clear();
                });
              }),
        ],
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: LJNetwork.historyList.length,
      itemBuilder: (BuildContext context, int index) {
        NetworkHistoryModel model = LJNetwork.historyList[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DebugNetworkHistoryDetailPage(
                    historyModel: model,
                  ),
                ));
          },
          child: Container(
            height: 55,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    model.title,
                    style: TextStyle(
                      color: Color(0xFF1BA3FF),
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
                Text(
                  model.method,
                  style: TextStyle(
                    color: Color(0xFF1BA3FF),
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.navigate_next,
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
}
