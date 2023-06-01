// Data Model
class TodoModel {
  final int? id;
  final String? title;
  final String? desc;
  final String? dateAndTime;

  TodoModel({this.id, this.title, this.desc, this.dateAndTime});

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        desc = res['desc'],
        dateAndTime = res['dateAndTime'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "desc": desc,
      "dateAndTime": dateAndTime,
    };
  }
}
