import 'dart:convert';


class ScheduleHandle{
  String json;
  List<int> workdaysMTU = [];
  List<int> workdaysUTM = [];
  List<int> weekendsMTU = [];
  List<int> weekendsUTM = [];

  ScheduleHandle(this.json){
    initJSON();
  }

  void initJSON(){
    Map<String, dynamic> data = jsonDecode(json);
    for (var time in data['WorkDays'][0]['MTU']) {
      workdaysMTU.add(parseTime(time['Time']));
    }
    for (var time in data['WorkDays'][0]['UTM']) {
      workdaysUTM.add(parseTime(time['Time']));
    }
    for (var time in data['Weekends'][0]['MTU']) {
      weekendsMTU.add(parseTime(time['Time']));
    }
    for (var time in data['Weekends'][0]['UTM']) {
      weekendsUTM.add(parseTime(time['Time']));
    }
  }

  int parseTime(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours * 3600 + minutes * 60;
  }
}