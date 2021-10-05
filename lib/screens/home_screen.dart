import 'package:flutter/material.dart';
import 'package:ipod_classic/widgets/albumcard_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.6);
  double currentPage = 0.0;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        minimum: EdgeInsets.only(
          top: 60,
        ),
        child: Column(
          children: [
            Container(
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, int currentIdx) {
                  return AlbumCard(
                    color: Colors.accents[currentIdx],
                    currentIdx: currentIdx,
                    currentPage: currentPage,
                  );
                },
              ),
            ),
            Spacer(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onPanUpdate: _panHandler,
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Stack(children: [
                        Container(
                          child: Text(
                            'MENU',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 36),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.fast_forward),
                            color: Colors.white,
                            iconSize: 40,
                            onPressed: () => _pageController.animateToPage(
                                (_pageController.page + 1).toInt(),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn),
                          ),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 30),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.fast_rewind),
                            color: Colors.white,
                            iconSize: 40,
                            onPressed: () => _pageController.animateToPage(
                                (_pageController.page - 1).toInt(),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 30),
                        ),
                        Container(
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 30),
                        )
                      ]),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _panHandler(DragUpdateDetails d) {
    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= 150; // 150 == radius of circle
    bool onLeftSide = d.localPosition.dx <= 150;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double vert = (onRightSide && panUp) || (onLeftSide && panDown)
        ? yChange
        : yChange * -1;

    double horz =
        (onTop && panLeft) || (onBottom && panRight) ? xChange : xChange * -1;

    // Total computed change with velocity
    double scrollOffsetChange = (horz + vert) * (d.delta.distance * 0.2);

    // Move the page view scroller
    _pageController.jumpTo(_pageController.offset + scrollOffsetChange);
  }
}
