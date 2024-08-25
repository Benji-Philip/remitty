import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeleteTodoGroup extends StatelessWidget {
  final VoidCallback onDelete;
  final String groupName;
  const DeleteTodoGroup(
      {super.key, required this.onDelete, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50)),
                color: Theme.of(context).colorScheme.background,
                border: Border(
                    top: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 5))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Text(
                    "Delete this group and it's To-Dos?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'CustomFont1',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        splashColor: Colors.grey,
                        borderRadius: BorderRadius.circular(100),
                        enableFeedback: true,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onDelete();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 145,
                          height: 65,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Colors.redAccent),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                                fontFamily: 'CustomFont1',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        splashColor: Colors.grey,
                        borderRadius: BorderRadius.circular(100),
                        enableFeedback: true,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 145,
                          height: 65,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Theme.of(context).colorScheme.primary),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontFamily: 'CustomFont1',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
