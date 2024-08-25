import 'package:flutter/material.dart';

class RmttyaCard extends StatefulWidget {
  final Color cardColor;
  final double curvStr;
  final double cardSpacingVertical;
  final double cardHeightvertical;
  final VoidCallback onFavourite;
  final String cardText;
  final String date;
  final VoidCallback onDelete;
  final bool favouriteToggle;
  final Color borderColor;
  final VoidCallback toggleOpenContainer;

  final VoidCallback onEdit;
  final bool openContainerToggle;
  const RmttyaCard(
      {super.key,
      required this.date,
      required this.cardHeightvertical,
      required this.cardColor,
      required this.curvStr,
      required this.cardSpacingVertical,
      required this.onFavourite,
      required this.cardText,
      required this.favouriteToggle,
      required this.onDelete,
      required this.toggleOpenContainer,
      required this.openContainerToggle,
      required this.onEdit,
      required this.borderColor});

  @override
  State<RmttyaCard> createState() => _RmttyaCardState();
}

class _RmttyaCardState extends State<RmttyaCard> {
  @override
  Widget build(BuildContext context) {
    String cardText = widget.cardText;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widget.cardColor,
                  border: Border.all(
                      color: widget.favouriteToggle
                          ? Colors.amber
                          : widget.borderColor,
                      width: 4),
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.curvStr))),
              margin: EdgeInsets.symmetric(
                  vertical: widget.cardSpacingVertical, horizontal: 20),
              child: Material(
                color: widget.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(widget.curvStr)),
                child: InkWell(
                  splashColor: widget.cardColor,
                  enableFeedback: true,
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.curvStr)),
                  onTap: widget.toggleOpenContainer,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            cardText,
                            style: const TextStyle(
                                fontFamily: 'CustomFont1',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.openContainerToggle ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 65,
                                height: 35,
                                child: Material(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Theme.of(context).colorScheme.primary,
                                  child: InkWell(
                                    splashColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(100),
                                    enableFeedback: true,
                                    onTap: widget.onEdit,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        const AssetImage(
                                            'lib/assets/images/pen.png'),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 65,
                                height: 35,
                                child: Material(
                                  borderRadius: BorderRadius.circular(100),
                                  color: widget.favouriteToggle
                                      ? Colors.amber
                                      : Colors.grey,
                                  child: InkWell(
                                    highlightColor: widget.favouriteToggle
                                        ? Colors.grey
                                        : Colors.amber,
                                    splashColor: widget.favouriteToggle
                                        ? Colors.amber
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(100),
                                    enableFeedback: true,
                                    onTap: widget.onFavourite,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        AssetImage(
                                            'lib/assets/images/thumbtack.png'),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 65,
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
                                        AssetImage(
                                            'lib/assets/images/delete.png'),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: (widget.cardHeightvertical - 52) / 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: widget.cardColor,
                ),
                margin: const EdgeInsets.only(left: 50),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        widget.date,
                        style: TextStyle(
                            height: 0,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'CustomFont1',
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 120,
          child: Divider(
            height: 0,
            thickness: 2,
          ),
        )
      ],
    );
  }
}
