import 'package:flutter/material.dart';

class RmttyaTodoGroupingCard extends StatefulWidget {
  final bool dragStart;
  final double curvStr;
  final double cardSpacingVertical;
  final String cardText;
  final Widget child;
  final VoidCallback onCreateTodo;
  final bool openContainer;
  final bool dragUpdate;
  final VoidCallback toggleOpenContainer;
  final Function(String)? onAccept;
  final int totalItems;
  final int itemsDone;
  final VoidCallback onDelete;
  const RmttyaTodoGroupingCard(
      {super.key,
      required this.curvStr,
      required this.cardSpacingVertical,
      required this.cardText,
      required this.child,
      required this.onCreateTodo,
      required this.openContainer,
      required this.toggleOpenContainer,
      required this.onAccept,
      required this.dragUpdate,
      required this.itemsDone,
      required this.totalItems,
      required this.onDelete,
      required this.dragStart});

  @override
  State<RmttyaTodoGroupingCard> createState() => _RmttyaTodoGroupingCardState();
}

class _RmttyaTodoGroupingCardState extends State<RmttyaTodoGroupingCard> {
  @override
  Widget build(BuildContext context) {
    int itemsDone = widget.itemsDone;
    int totalItems = widget.totalItems;

    String cardText = widget.cardText;
    return DragTarget(
        onAccept: widget.onAccept,
        builder: (BuildContext context, List accepted, List rejected) {
          return Opacity(
            opacity: widget.dragStart
                ? accepted.isEmpty
                    ? 1
                    : 0.4
                : 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: widget.cardSpacingVertical - 10, horizontal: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.curvStr)),
                    color: Theme.of(context).colorScheme.onPrimary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: widget.openContainer
                              ? widget.cardSpacingVertical - 5
                              : cardText == ""
                                  ? 10
                                  : 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleOpenContainer();
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.only(left: 30),
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: cardText == ""
                                        ? CrossAxisAlignment.center
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Visibility(
                                            visible:
                                                cardText == "" ? false : true,
                                            child: Flexible(
                                              child: Text(
                                                cardText,
                                                style: TextStyle(
                                                    fontFamily: 'CustomFont1',
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Visibility(
                                              visible:
                                                  cardText == "" ? false : true,
                                              child: RotatedBox(
                                                quarterTurns:
                                                    widget.openContainer
                                                        ? 0
                                                        : 135,
                                                child: Icon(
                                                  Icons.arrow_drop_down_rounded,
                                                  size: 32,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Opacity(
                                            opacity: cardText == "" ? 1 : 0.5,
                                            child: Text(
                                              "[$itemsDone/$totalItems]",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontFamily: 'CustomFont1',
                                                  fontSize:
                                                      cardText == "" ? 20 : 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Visibility(
                                              visible:
                                                  cardText == "" ? true : false,
                                              child: RotatedBox(
                                                quarterTurns:
                                                    widget.openContainer
                                                        ? 0
                                                        : 135,
                                                child: Icon(
                                                  Icons.arrow_drop_down_rounded,
                                                  size: 32,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: widget.openContainer,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 20.0),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.redAccent,
                                        child: InkWell(
                                          splashColor: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          enableFeedback: true,
                                          onTap: widget.onDelete,
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.white,
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
                      ],
                    ),
                    SizedBox(
                        height: widget.openContainer
                            ? widget.cardSpacingVertical
                            : 0),
                    Visibility(
                      visible: widget.openContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: GestureDetector(
                          onTap: widget.onCreateTodo,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      )),
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Add To-Do',
                                        style: TextStyle(
                                            fontFamily: 'CustomFont1',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background),
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
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: widget.openContainer,
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(widget.curvStr)),
                              color: Theme.of(context).colorScheme.onPrimary),
                          child: widget.child),
                    ),
                    Visibility(
                      visible: widget.openContainer,
                      child: SizedBox(
                        height: widget.cardSpacingVertical,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
