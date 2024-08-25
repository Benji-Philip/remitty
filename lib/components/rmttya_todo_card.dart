import 'package:flutter/material.dart';

class RmttyaTodoCard extends StatefulWidget {
  final VoidCallback onEdit;
  final Color cardColor;
  final double curvStr;
  final double cardSpacingVertical;
  final double cardHeightvertical;
  final String cardText;
  final VoidCallback onDelete;
  final Color borderColor;
  final bool onDone;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final VoidCallback onDoneToggle;
  final VoidCallback toggleOpenContainer;
  final bool openContainerToggle;
  final Function(DragUpdateDetails) onDrag;
  final String todoData;
  const RmttyaTodoCard(
      {super.key,
      required this.cardHeightvertical,
      required this.cardColor,
      required this.curvStr,
      required this.cardSpacingVertical,
      required this.cardText,
      required this.onDelete,
      required this.borderColor,
      required this.onDone,
      required this.onDoneToggle,
      required this.toggleOpenContainer,
      required this.openContainerToggle,
      required this.onDrag,
      required this.onDragStart,
      required this.onDragEnd,
      required this.todoData,
      required this.onEdit});

  @override
  State<RmttyaTodoCard> createState() => _RmttyaTodoCardState();
}

class _RmttyaTodoCardState extends State<RmttyaTodoCard> {
  @override
  Widget build(BuildContext context) {
    String cardText = widget.cardText;
    return LongPressDraggable(
      data: widget.todoData,
      onDragStarted: widget.onDragStart,
      onDragEnd: (details) {
        widget.onDragEnd();
      },
      onDragUpdate: widget.onDrag,
      onDraggableCanceled: (velocity, offset) {},
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.cardSpacingVertical - 10, horizontal: 30),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: widget.cardColor,
                border: Border.all(
                    color: widget.onDone ? Colors.amber : widget.borderColor,
                    width: 4),
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.curvStr))),
            child: Material(
              color: widget.cardColor,
              borderRadius: BorderRadius.all(Radius.circular(widget.curvStr)),
              child: InkWell(
                splashColor: widget.cardColor,
                enableFeedback: true,
                borderRadius: BorderRadius.all(Radius.circular(widget.curvStr)),
                onTap: widget.toggleOpenContainer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 24, left: 5),
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.onDone
                                            ? Colors.amber
                                            : Colors.grey,
                                        width: 3),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Material(
                                  borderRadius: BorderRadius.circular(100),
                                  color: widget.onDone
                                      ? Colors.amber
                                      : widget.cardColor,
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    enableFeedback: true,
                                    onTap: widget.onDoneToggle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        const AssetImage(
                                            'lib/assets/images/check.png'),
                                        color: widget.onDone
                                            ? Colors.white
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                cardText,
                                style: TextStyle(
                                    decoration: widget.onDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontFamily: 'CustomFont1',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.openContainerToggle ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.redAccent,
                            child: InkWell(
                              splashColor: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                              enableFeedback: true,
                              onTap: widget.onDelete,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ImageIcon(
                                  AssetImage('lib/assets/images/delete.png'),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      feedback: Padding(
        padding: EdgeInsets.only(top: 25),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.cardSpacingVertical - 10, horizontal: 30),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: widget.cardColor,
                border: Border.all(
                    color: widget.onDone ? Colors.amber : widget.borderColor,
                    width: 4),
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.curvStr))),
            child: Material(
              color: widget.cardColor,
              borderRadius: BorderRadius.all(Radius.circular(widget.curvStr)),
              child: InkWell(
                splashColor: widget.cardColor,
                enableFeedback: true,
                borderRadius: BorderRadius.all(Radius.circular(widget.curvStr)),
                onTap: widget.toggleOpenContainer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 24, left: 5),
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.onDone
                                            ? Colors.amber
                                            : Colors.grey,
                                        width: 3),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Material(
                                  borderRadius: BorderRadius.circular(100),
                                  color: widget.onDone
                                      ? Colors.amber
                                      : widget.cardColor,
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    enableFeedback: true,
                                    onTap: widget.onDoneToggle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        const AssetImage(
                                            'lib/assets/images/check.png'),
                                        color: widget.onDone
                                            ? Colors.white
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                cardText,
                                style: TextStyle(
                                    decoration: widget.onDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontFamily: 'CustomFont1',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.openContainerToggle ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.redAccent,
                            child: InkWell(
                              splashColor: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                              enableFeedback: true,
                              onTap: widget.onDelete,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ImageIcon(
                                  AssetImage('lib/assets/images/delete.png'),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: widget.cardSpacingVertical - 10, horizontal: 30),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: widget.cardColor,
              border: Border.all(
                  color: widget.onDone ? Colors.amber : widget.borderColor,
                  width: 4),
              borderRadius: BorderRadius.all(Radius.circular(widget.curvStr))),
          child: Material(
            color: widget.cardColor,
            borderRadius: BorderRadius.all(Radius.circular(widget.curvStr)),
            child: InkWell(
              splashColor: widget.cardColor,
              enableFeedback: true,
              borderRadius: BorderRadius.all(Radius.circular(widget.curvStr)),
              onTap: widget.toggleOpenContainer,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 24, left: 5),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: widget.onDone
                                          ? Colors.amber
                                          : Colors.grey,
                                      width: 3),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Material(
                                borderRadius: BorderRadius.circular(100),
                                color: widget.onDone
                                    ? Colors.amber
                                    : widget.cardColor,
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  enableFeedback: true,
                                  onTap: widget.onDoneToggle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ImageIcon(
                                      const AssetImage(
                                          'lib/assets/images/check.png'),
                                      color: widget.onDone
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              cardText,
                              style: TextStyle(
                                  decoration: widget.onDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontFamily: 'CustomFont1',
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.openContainerToggle ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 85,
                            height: 35,
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).colorScheme.primary,
                              child: InkWell(
                                splashColor: Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                                enableFeedback: true,
                                onTap: widget.onEdit,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ImageIcon(
                                    AssetImage('lib/assets/images/pen.png'),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            height: 35,
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.redAccent,
                              child: InkWell(
                                splashColor: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                                enableFeedback: true,
                                onTap: widget.onDelete,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ImageIcon(
                                    AssetImage('lib/assets/images/delete.png'),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
