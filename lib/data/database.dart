import 'package:hive_flutter/hive_flutter.dart';

class RmttyaDatabase {
  List noteList = [];
  List todoList = [];
  List todoGroupList = [];

  final rmttyanotes = Hive.box('rmttyanotes');

  void createInitialData() {
    noteList = [
      ["(Swipe down to switch)", false, "(Date)", false, "20231027183456"],
      ["(Tap to show options)", false, "(Date)", false, "20230927183456"]
    ];
    todoList = [
      [
        "(Swipe down to switch again)",
        false,
        "20231027183456",
        false,
        "",
        false
      ],
      [
        "(<<< Tap here to mark as Done)",
        false,
        "20230927183456",
        false,
        "",
        false
      ],
      ["(Tap to show options)", false, "20230827183456", false, "", true],
      [
        "(Grab and Drag To-Dos between groups)",
        false,
        "20230727183456",
        false,
        "Group Name",
        true
      ]
    ];
    todoGroupList = [
      ["", "20230928183456", false],
      ["Group Name", "20230926183456", false],
      ["Empty", "20230826183456", false]
    ];
  }

  void loadData() {
    noteList = rmttyanotes.get("RMTTYANOTES");
    todoList = rmttyanotes.get("RMTTYATODOLIST");
    todoGroupList = rmttyanotes.get("RMTTYATODOGROUPLIST");
  }

  void updateNotesDatabase() {
    rmttyanotes.put("RMTTYATODOLIST", todoList);
    rmttyanotes.put("RMTTYANOTES", noteList);
    rmttyanotes.put("RMTTYATODOGROUPLIST", todoGroupList);
  }

  void updateTodoDatabase() {
    rmttyanotes.put("RMTTYANOTES", noteList);
    rmttyanotes.put("RMTTYATODOLIST", todoList);
    rmttyanotes.put("RMTTYATODOGROUPLIST", todoGroupList);
  }
}
