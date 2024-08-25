import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rmttya/components/background_card.dart';
import 'package:rmttya/components/create_note.dart';
import 'package:rmttya/components/create_todo.dart';
import 'package:rmttya/components/create_todo_group.dart';
import 'package:rmttya/components/delete_todo_group.dart';
import 'package:rmttya/components/edit_note.dart';
import 'package:rmttya/components/edit_todo.dart';
import 'package:rmttya/components/rmttya_card.dart';

import 'package:intl/intl.dart';
import 'package:rmttya/components/rmttya_todo_card.dart';
import 'package:rmttya/components/rmttya_todo_grouping_card.dart';
import 'package:rmttya/data/database.dart';
import 'package:rmttya/theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final rmttyaNotes = Hive.box('rmttyanotes');

  @override
  void initState() {
    if (rmttyaNotes.get("RMTTYANOTES") == null) {
      db.createInitialData();
    } else {
      db.loadData();
      setState(() {
        for (var element in db.noteList) {
          element[3] = false;
        }

        for (var element in db.todoList) {
          element[3] = false;
        }
      });
    }
    super.initState();
  }

  RmttyaDatabase db = RmttyaDatabase();

  double scrollOffset = 0;
  double draggedItemPosition = 0.0;
  double scrollThreshold = 100.0;
  double spacing = 0;
  double topTitle = 0;
  double titleOpacity = 1;
  double topBg1 = 0;
  double topBg3 = 0;
  double topBg2 = 0;
  double spaceFromTop = 180;
  double curveStrMax1 = 50;
  double curveStr1 = 50;
  double curveStrMax2 = 25;
  double curveStr2 = 25;
  double cardSpacingVertical = 25;
  double cardSpacingVerticalMax = 25;
  double cardHeightVertical = 90;
  double cardHeightVerticalMax = 90;
  double throwCard = 0;
  int animDuration = 300;
  int animDelay = 0;
  String cardSwitch = 'notes';
  double settingsOpacity = 0;
  bool toggleTouch = true;
  String todoGroupName = "";
  bool dragStart = false;
  bool dragUpdate = false;
  int rowIndex = -1;
  int columnIndex = -1;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _createNoteController = TextEditingController();

  final _editNoteController = TextEditingController();

  final _createTodoController = TextEditingController();

  final _createTodoGroupController = TextEditingController();

  final _editTodoController = TextEditingController();

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter1 = DateFormat('dd/MM/yyyy');
    var formatter2 = DateFormat('yyyyMMddHHmmss');
    String formateDateTime = formatter2.format(now);
    String formattedDate = formatter1.format(now);

    if (dragUpdate) {
      if (draggedItemPosition <= scrollThreshold && dragUpdate) {
        // Scroll up
        if (_scrollController.offset >= 0) {
          _scrollController.animateTo(_scrollController.offset - 60,
              duration: Duration(milliseconds: 100), curve: Curves.linear);
        }
      } else if (draggedItemPosition >=
              MediaQuery.of(context).size.height - scrollThreshold &&
          dragUpdate) {
        // Scroll down
        _scrollController.animateTo(_scrollController.offset + 60,
            duration: Duration(milliseconds: 100), curve: Curves.linear);
      }
      ;
    } else {
      setState(() {
        draggedItemPosition = 0;
      });
    }

    db.noteList.sort((a, b) {
      // Prioritize items with true at index 1
      if (a[1] && !b[1]) {
        return -1; // a comes before b
      } else if (!a[1] && b[1]) {
        return 1; // b comes before a
      } else {
        // If both have the same boolean value, sort based on the date string at index 4
        return b[4].compareTo(a[4]);
      }
    });

    void deleteNote(int index) {
      setState(() {
        db.noteList.removeAt(index);
      });
      db.updateNotesDatabase();
      _scrollController.animateTo(_scrollController.offset + 5,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
    }

    void deleteTodo(String identifier) {
      for (var i = 0; i < db.todoList.length; i++) {
        List currentList = db.todoList[i];
        if (currentList.contains(identifier)) {
          db.todoList.removeAt(i);
        }
      }
      db.updateTodoDatabase();
      _scrollController.animateTo(_scrollController.offset + 5,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
    }

    void toggleDoneTodo(String identifier) {
      for (int i = 0; i < db.todoList.length; i++) {
        if (db.todoList[i][2] == identifier) {
          setState(() {
            rowIndex = i;
          });
          break;
        }
      }
      ;
      setState(() {
        db.todoList[rowIndex][1] = !db.todoList[rowIndex][1];
      });

      db.updateTodoDatabase();
    }

    bool noneEqual = true;

    void deleteTodoGroup(String groupName) {
      for (var j = 0; j < db.todoGroupList.length; j++) {
        if (db.todoGroupList[j][0].toString().toLowerCase() ==
            groupName.toLowerCase()) {
          db.todoGroupList.removeAt(j);
          break;
        }
      }
      _scrollController.animateTo(_scrollController.offset + 5,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
      db.updateNotesDatabase();
    }

    void deleteGroupOfTodo(String groupName) {
      db.todoList.removeWhere((list) => list.any(
          (item) => item.toString().toLowerCase() == groupName.toLowerCase()));
      db.updateNotesDatabase();
    }

    void createTodoGroup() {
      for (List entry in db.todoGroupList) {
        if (entry[0].toString().toLowerCase() ==
            _createTodoGroupController.text.toLowerCase()) {
          noneEqual = false;
          break;
        }
      }
      if (noneEqual == true) {
        setState(() {
          for (var i = 0; i < db.todoGroupList.length; i++) {
            setState(() {
              db.todoGroupList[i][2] = false;
            });
          }
          db.todoGroupList
              .add([_createTodoGroupController.text, formateDateTime, true]);
        });
      } else {
        final snackbar = SnackBar(
          content: Text(
            "That group already exists",
            style: TextStyle(
                fontFamily: 'CustomFont1',
                color: Colors.white,
                fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      db.updateTodoDatabase();
      Navigator.of(context).pop();
      _createTodoGroupController.clear();
    }

    void createNoteTodo() {
      if (cardSwitch == 'notes') {
        setState(() {
          setState(() {
            db.noteList.add([
              _createNoteController.text,
              false,
              formattedDate,
              false,
              formateDateTime
            ]);
          });
          db.updateNotesDatabase();
          Navigator.of(context).pop();
          _createNoteController.clear();
        });
        db.updateNotesDatabase();
      } else if (cardSwitch == 'todo') {
        setState(() {
          db.todoList.add([
            _createTodoController.text,
            false,
            formateDateTime,
            false,
            todoGroupName,
            false
          ]);
        });

        db.todoList.sort((a, b) {
          // Prioritize items with true at index 1
          if (a[1] && !b[1]) {
            return 1; // a comes before b
          } else if (!a[1] && b[1]) {
            return -1; // b comes before a
          } else {
            // If both have the same boolean value, sort based on the date string at index 4
            return a[2].compareTo(b[2]);
          }
        });
        db.updateTodoDatabase();
        Navigator.of(context).pop();
        _createTodoController.clear();
      }
    }

    void editNote(int index) {
      setState(() {
        db.noteList[index][0] = _editNoteController.text;
      });
      db.updateNotesDatabase();
      Navigator.of(context).pop();
      _editNoteController.clear();
    }

    void editTodo(String identifier, String groupName) {
      for (int i = 0; i < db.todoList.length; i++) {
        if (db.todoList[i][2] == identifier) {
          setState(() {
            rowIndex = i;
          });
        }
      }
      ;
      setState(() {
        db.todoList[rowIndex][4] = groupName;
      });
      db.updateNotesDatabase();
    }

    void editTodoContent(String identifier) {
      for (var i = 0; i < db.todoList.length; i++) {
        List currentList = db.todoList[i];
        if (currentList.contains(identifier)) {
          db.todoList[i][0] = _editTodoController.text;
          break;
        }
      }
      db.updateTodoDatabase();
    }

    void createNoteDialog() {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          context: context,
          builder: (builder) {
            return CreateNote(
              date: formattedDate,
              onCreate: () {
                createNoteTodo();
              },
              controller: _createNoteController,
            );
          });
    }

    void deleteTodoGroupDialog(String groupName) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          context: context,
          builder: (builder) {
            return DeleteTodoGroup(
              groupName: groupName,
              onDelete: () {
                HapticFeedback.lightImpact();
                deleteTodoGroup(groupName);
                deleteGroupOfTodo(groupName);
              },
            );
          });
    }

    void createTodoDialog() {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          context: context,
          builder: (builder) {
            return CreateTodo(
              onCreate: () {
                createNoteTodo();
              },
              controller: _createTodoController,
            );
          });
    }

    void createTodoGroupDialog() {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          context: context,
          builder: (builder) {
            return CreateTodoGroup(
              onCreate: () {
                createTodoGroup();
              },
              controller: _createTodoGroupController,
            );
          });
    }

    void editNoteDialog(int index) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          context: context,
          builder: (builder) {
            return EditNote(
              date: db.noteList[index][2],
              onEdit: () {
                editNote(index);
              },
              controller: _editNoteController,
            );
          });
      _editNoteController.text = db.noteList[index][0].toString();
    }

    void editTodoDialog(String identifier, String todoContent) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          context: context,
          builder: (builder) {
            return EditTodo(
              onEdit: () {
                editTodoContent(identifier);
                Navigator.of(context).pop();
              },
              controller: _editTodoController,
            );
          });
      _editTodoController.text = todoContent;
    }

    void toggleOpenNotesContainer(int index) {
      setState(() {
        if (db.noteList[index][3] == false) {
          for (var element in db.noteList) {
            element[3] = false;
          }
          db.noteList[index][3] = true;
        } else {
          db.noteList[index][3] = false;
        }
      });
      _scrollController.animateTo(_scrollController.offset + 2,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
      db.updateNotesDatabase();
    }

    void toggleOpenTodoGroupContainer(int index) {
      setState(() {
        if (db.todoGroupList[index][2] == false) {
          for (var element in db.todoGroupList) {
            element[2] = false;
          }
          db.todoGroupList[index][2] = true;
        } else {
          db.todoGroupList[index][2] = false;
        }
      });

      _scrollController.animateTo(_scrollController.offset + 2,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
      db.updateNotesDatabase();
    }

    void toggleOpenTodoContainer(String identifier) {
      for (int i = 0; i < db.todoList.length; i++) {
        if (db.todoList[i][2] == identifier) {
          setState(() {
            rowIndex = i;
          });
          break;
        }
      }
      ;

      setState(() {
        if (db.todoList[rowIndex][3] == false) {
          for (var element in db.todoList) {
            element[3] = false;
          }
          db.todoList[rowIndex][3] = true;
        } else {
          db.todoList[rowIndex][3] = false;
        }
      });
      _scrollController.animateTo(_scrollController.offset + 2,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
      db.updateTodoDatabase();
    }

    void toggleFavourite(int index) {
      setState(() {
        db.noteList[index][1] = !db.noteList[index][1];
      });
      db.updateNotesDatabase();
    }

    spaceFromTop = MediaQuery.of(context).size.height * 0.12;

    return IgnorePointer(
      ignoring: !toggleTouch,
      child: Scaffold(
          key: _scaffoldkey,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: cardSwitch == 'todo' ? false : true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: animDuration),
                opacity: toggleTouch ? 1 : 0,
                child: FloatingActionButton(
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.add_rounded,
                      size: 40,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    onPressed: () {
                      if (cardSwitch == 'todo') {
                        createTodoGroupDialog();
                        HapticFeedback.lightImpact();
                      } else if (cardSwitch == 'notes') {
                        HapticFeedback.lightImpact();
                        createNoteDialog();
                      }
                    }),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: NotificationListener(
            onNotification: (notif) {
              if (notif is ScrollUpdateNotification) {
                if (notif.scrollDelta == null) {
                  return false;
                }
                setState(() {
                  scrollOffset = _scrollController.offset;
                  topTitle = -(_scrollController.offset / 5);
                  topBg1 = -(_scrollController.offset / 1);

                  topBg2 = (_scrollController.offset / 6);

                  topBg3 = -(_scrollController.offset / 6);
                  cardSpacingVertical = cardSpacingVerticalMax -
                      (_scrollController.offset / 20)
                          .clamp(0, cardSpacingVerticalMax / 3);

                  cardHeightVertical = cardHeightVerticalMax -
                      (_scrollController.offset / 20)
                          .clamp(0, cardHeightVerticalMax * 0.2);
                  titleOpacity =
                      1 - (_scrollController.offset / 200).clamp(0, 1);

                  settingsOpacity =
                      (-(_scrollController.offset / 50)).clamp(0, 1);
                  curveStr1 = curveStrMax1 -
                      (_scrollController.offset / 10)
                          .clamp(0, curveStrMax1 / 1.3);
                  curveStr2 = curveStrMax2 -
                      (_scrollController.offset / 2).clamp(0, curveStrMax2 / 2);

                  if (_scrollController.offset <= -60) {
                    if (toggleTouch == true) {
                      HapticFeedback.heavyImpact();

                      if (cardSwitch == 'notes') {
                        setState(() {
                          cardSwitch = 'todo';
                          toggleTouch = false;
                        });
                      } else if (cardSwitch == 'todo') {
                        setState(() {
                          cardSwitch = 'notes';
                          toggleTouch = false;
                        });
                      }
                    }

                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: animDuration),
                        curve: Curves.ease);
                    Future.delayed(
                        Duration(milliseconds: animDuration + animDelay), () {
                      setState(() {
                        toggleTouch = true;
                      });
                    });
                  }
                });
                setState(() {});
              }
              return true;
            },
            child: SafeArea(
              child: Stack(
                children: [
                  Stack(
                    children: [
                      BackgroundCard(
                          animDuration: animDuration,
                          cardColor: cardSwitch == 'notes'
                              ? Theme.of(context).colorScheme.onSecondary
                              : cardSwitch == 'todo'
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onPrimary,
                          curveStr: curveStr1,
                          top: spaceFromTop + topBg2 + spacing - 5),
                      Positioned.fill(
                        top: spaceFromTop + topBg2 + 25 + spacing - 5,
                        left: 30,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: MediaQuery.of(context).size.width *
                                        0.83,
                                    height: spaceFromTop - 60,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Opacity(
                                          opacity: settingsOpacity,
                                          child: Row(
                                            children: [
                                              Text(
                                                cardSwitch == 'settings'
                                                    ? 'Notes'
                                                    : cardSwitch == 'notes'
                                                        ? 'To-do'
                                                        : 'Notes',
                                                style: TextStyle(
                                                    height: 1,
                                                    fontSize: 35,
                                                    fontFamily: 'CustomFont1',
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                              RotatedBox(
                                                quarterTurns: 90,
                                                child: const Icon(
                                                  Icons.arrow_drop_down_rounded,
                                                  size: 45,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      BackgroundCard(
                          animDuration: animDuration,
                          cardColor: cardSwitch == 'notes'
                              ? Theme.of(context).colorScheme.onPrimary
                              : cardSwitch == 'todo'
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Theme.of(context).colorScheme.onTertiary,
                          curveStr: curveStr1,
                          top: spaceFromTop + topBg1 + 15 + spacing),
                      Positioned.fill(
                          top: spacing - 15,
                          child: IgnorePointer(
                            ignoring: !toggleTouch,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              controller: _scrollController,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: spaceFromTop + 50),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Visibility(
                                            visible: cardSwitch == 'notes' &&
                                                    db.noteList.isEmpty
                                                ? true
                                                : false,
                                            child: IgnorePointer(
                                              ignoring: true,
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    spaceFromTop -
                                                    300,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  cardSwitch == 'notes'
                                                      ? '( Add notes )'
                                                      : cardSwitch == 'todo'
                                                          ? '( Add Tasks )'
                                                          : '',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily: 'CustomFont1',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: cardSwitch ==
                                                              'notes'
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .onSecondary
                                                          : cardSwitch == 'todo'
                                                              ? Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onTertiary
                                                              : Colors
                                                                  .transparent),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: cardSwitch == 'notes'
                                                ? true
                                                : false,
                                            child: Column(
                                              children: List.generate(
                                                  db.noteList.length,
                                                  (index) => RmttyaCard(
                                                      borderColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiary,
                                                      onEdit: () {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        editNoteDialog(index);
                                                      },
                                                      openContainerToggle:
                                                          db.noteList[index][3],
                                                      toggleOpenContainer: () {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        toggleOpenNotesContainer(
                                                            index);
                                                      },
                                                      date: db.noteList[index]
                                                          [2],
                                                      cardText:
                                                          db.noteList[index][0],
                                                      favouriteToggle:
                                                          db.noteList[index][1],
                                                      onFavourite: () {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        toggleFavourite(index);
                                                      },
                                                      onDelete: () {
                                                        HapticFeedback
                                                            .lightImpact();
                                                        deleteNote(index);
                                                      },
                                                      cardHeightvertical:
                                                          cardHeightVertical,
                                                      cardSpacingVertical:
                                                          cardSpacingVertical,
                                                      curvStr: curveStr2,
                                                      cardColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary)),
                                            ),
                                          ),
                                          Visibility(
                                              visible: cardSwitch == 'todo'
                                                  ? true
                                                  : false,
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: List.generate(
                                                        db.todoGroupList.length,
                                                        (Outerindex) {
                                                      String groupName = db
                                                          .todoGroupList[
                                                              Outerindex][0]
                                                          .toString()
                                                          .toLowerCase();

                                                      List filteredInnerList = db
                                                          .todoList
                                                          .where((element) =>
                                                              element[4]
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              groupName)
                                                          .toList();
                                                      int filteredListLength =
                                                          filteredInnerList
                                                              .length;
                                                      int filteredListDoneLength =
                                                          filteredInnerList
                                                              .where(
                                                                  (element) =>
                                                                      element[
                                                                          1] ==
                                                                      true)
                                                              .toList()
                                                              .length;
                                                      return RmttyaTodoGroupingCard(
                                                        dragStart: dragStart,
                                                        onDelete: () {
                                                          HapticFeedback
                                                              .lightImpact();
                                                          deleteTodoGroupDialog(
                                                              groupName);
                                                        },
                                                        totalItems:
                                                            filteredListLength,
                                                        itemsDone:
                                                            filteredListDoneLength,
                                                        dragUpdate: dragUpdate,
                                                        onAccept: (String
                                                            identifier) {
                                                          editTodo(
                                                              identifier,
                                                              db.todoGroupList[
                                                                      Outerindex]
                                                                      [0]
                                                                  .toString()
                                                                  .toLowerCase());
                                                        },
                                                        openContainer:
                                                            db.todoGroupList[
                                                                Outerindex][2],
                                                        toggleOpenContainer:
                                                            () {
                                                          HapticFeedback
                                                              .lightImpact();
                                                          db.todoList
                                                              .sort((a, b) {
                                                            // Prioritize items with true at index 1
                                                            if (a[1] && !b[1]) {
                                                              return 1; // a comes before b
                                                            } else if (!a[1] &&
                                                                b[1]) {
                                                              return -1; // b comes before a
                                                            } else {
                                                              // If both have the same boolean value, sort based on the date string at index 4
                                                              return a[2]
                                                                  .compareTo(
                                                                      b[2]);
                                                            }
                                                          });
                                                          toggleOpenTodoGroupContainer(
                                                              Outerindex);
                                                        },
                                                        onCreateTodo: () {
                                                          HapticFeedback
                                                              .lightImpact();
                                                          createTodoDialog();
                                                          todoGroupName = db
                                                              .todoGroupList[
                                                                  Outerindex][0]
                                                              .toString()
                                                              .toLowerCase();
                                                        },
                                                        cardText:
                                                            db.todoGroupList[
                                                                Outerindex][0],
                                                        curvStr: curveStr1,
                                                        cardSpacingVertical:
                                                            cardSpacingVertical,
                                                        child: Column(
                                                          children: List.generate(
                                                              filteredInnerList.length,
                                                              (Innerindex) => RmttyaTodoCard(
                                                                  onEdit: () {
                                                                    HapticFeedback
                                                                        .lightImpact();
                                                                    editTodoDialog(
                                                                        filteredInnerList[Innerindex][2]
                                                                            .toString()
                                                                            .toLowerCase(),
                                                                        filteredInnerList[Innerindex][0]
                                                                            .toString());
                                                                  },
                                                                  todoData: filteredInnerList[Innerindex][2],
                                                                  onDragStart: () {
                                                                    setState(
                                                                        () {
                                                                      dragStart =
                                                                          true;
                                                                    });
                                                                    HapticFeedback
                                                                        .lightImpact();
                                                                  },
                                                                  onDragEnd: () {
                                                                    HapticFeedback
                                                                        .lightImpact();
                                                                    setState(
                                                                        () {
                                                                      dragStart =
                                                                          false;
                                                                      dragUpdate =
                                                                          false;
                                                                    });
                                                                  },
                                                                  onDrag: (details) {
                                                                    setState(
                                                                        () {
                                                                      dragUpdate =
                                                                          true;
                                                                      draggedItemPosition = (context.findRenderObject()!
                                                                              as RenderBox)
                                                                          .localToGlobal(
                                                                              details.globalPosition)
                                                                          .dy;
                                                                    });
                                                                  },
                                                                  openContainerToggle: filteredInnerList[Innerindex][3],
                                                                  toggleOpenContainer: () {
                                                                    HapticFeedback
                                                                        .lightImpact();
                                                                    toggleOpenTodoContainer(
                                                                        filteredInnerList[Innerindex][2]
                                                                            .toString());
                                                                  },
                                                                  onDone: filteredInnerList[Innerindex][1],
                                                                  onDoneToggle: () {
                                                                    HapticFeedback
                                                                        .lightImpact();
                                                                    toggleDoneTodo(filteredInnerList[
                                                                            Innerindex][2]
                                                                        .toString()
                                                                        .toLowerCase());
                                                                  },
                                                                  borderColor: Theme.of(context).colorScheme.onTertiary,
                                                                  cardText: filteredInnerList[Innerindex][0],
                                                                  onDelete: () {
                                                                    HapticFeedback
                                                                        .lightImpact();
                                                                    deleteTodo(filteredInnerList[
                                                                            Innerindex][2]
                                                                        .toString()
                                                                        .toLowerCase());
                                                                  },
                                                                  cardHeightvertical: cardHeightVertical,
                                                                  cardSpacingVertical: cardSpacingVertical,
                                                                  curvStr: curveStr2,
                                                                  cardColor: Theme.of(context).colorScheme.onPrimary)),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    curveStr1),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            HapticFeedback
                                                                .lightImpact();
                                                            createTodoGroupDialog();
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              curveStr1)),
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .add_rounded,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .background,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        'Create new group',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'CustomFont1',
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Theme.of(context).colorScheme.background),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 120,
                                    )
                                  ]),
                            ),
                          ))
                    ],
                  ),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                        top: scrollOffset >= 0
                            ? topTitle * 1.5 + 20
                            : -(topTitle * 0.4) + 20,
                        child: Opacity(
                          opacity: titleOpacity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 10, top: 5),
                                child: SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: Material(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(100),
                                    child: InkWell(
                                      splashColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        Provider.of<ThemeProvider>(context,
                                                listen: false)
                                            .toggleTheme();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: ImageIcon(
                                          AssetImage(
                                              'lib/assets/images/thumbtack.png'),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                cardSwitch == 'notes'
                                    ? 'Notes '
                                    : cardSwitch == 'todo'
                                        ? 'To-do '
                                        : 'Settings :',
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 45,
                                    fontFamily: 'CustomFont1',
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
