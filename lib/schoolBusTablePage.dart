import 'package:flutter/material.dart';
import 'generated/l10n.dart';

class SchoolBusTablePage extends StatefulWidget {
  final List<int> workdaysMTU;
  final List<int> weekendsMTU;
  final List<int> workdaysUTM;
  final List<int> weekendsUTM;

  const SchoolBusTablePage({
    Key? key,
    required this.workdaysMTU,
    required this.weekendsMTU,
    required this.workdaysUTM,
    required this.weekendsUTM,
  }) : super(key: key);

  @override
  State<SchoolBusTablePage> createState() => _SchoolBusTablePageState();
}

class _SchoolBusTablePageState extends State<SchoolBusTablePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int maxWorkdayLength = widget.workdaysMTU.length > widget.workdaysUTM.length ? widget.workdaysMTU.length : widget.workdaysUTM.length;
    int maxWeekendsLength = widget.weekendsMTU.length > widget.weekendsUTM.length ? widget.weekendsMTU.length : widget.weekendsUTM.length;

  String secToTime(int sec){
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;

    String hoursStr = hours > 9 ? '$hours' : '0$hours';
    String minutesStr = minutes > 9 ? '$minutes' : '0$minutes';

    return '$hoursStr:$minutesStr';
  }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).schoolBusTimeTable),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.green,
          tabs: <Widget>[
            Tab(
              text: S.of(context).workday,
            ),
            Tab(
              text: S.of(context).weekend,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text('${S.of(context).location1}->${S.of(context).location2}')),
                DataColumn(label: Text('${S.of(context).location2}->${S.of(context).location1}')),
              ],
              rows: List<DataRow>.generate(
                maxWorkdayLength,
                    (index) => DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(
                        index < widget.workdaysMTU.length
                            ? secToTime(widget.workdaysMTU[index])
                            : '-',
                      ),
                    ),
                    DataCell(
                      Text(
                        index < widget.workdaysUTM.length
                            ? secToTime(widget.workdaysUTM[index])
                            : '-',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text('${S.of(context).location1}->${S.of(context).location2}')),
                DataColumn(label: Text('${S.of(context).location2}->${S.of(context).location1}')),
              ],
              rows: List<DataRow>.generate(
                maxWeekendsLength,
                    (index) => DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(
                        index < widget.weekendsMTU.length
                            ? secToTime(widget.weekendsMTU[index])
                            : '-',
                      ),
                    ),
                    DataCell(
                      Text(
                        index < widget.weekendsUTM.length
                            ? secToTime(widget.weekendsUTM[index])
                            : '-',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
