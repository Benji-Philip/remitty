import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTodo extends StatelessWidget {
  final VoidCallback onEdit;
  final TextEditingController controller;
  const EditTodo({super.key, required this.onEdit, required this.controller});

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
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).colorScheme.background),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      child: TextField(
                        style: const TextStyle(
                            fontFamily: 'CustomFont1',
                            fontWeight: FontWeight.w700),
                        controller: controller,
                        autofocus: true,
                        maxLines: null,
                        textAlign: TextAlign.left,
                        expands: false,
                        decoration: const InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily: 'CustomFont1',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 105,
                        height: 45,
                        child: Material(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.redAccent,
                          child: InkWell(
                            splashColor: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                            enableFeedback: true,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(11.0),
                              child: ImageIcon(
                                AssetImage('lib/assets/images/close.png'),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 105,
                        height: 45,
                        child: Material(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.primary,
                          child: InkWell(
                            splashColor: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(100),
                            enableFeedback: true,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              onEdit();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageIcon(
                                const AssetImage('lib/assets/images/check.png'),
                                color: Theme.of(context).colorScheme.background,
                              ),
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
