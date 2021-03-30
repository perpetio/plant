import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/utils/router.dart';
import 'package:plant/widgets/screen_template.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return HomeBloc();
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // ignore: close_sinks
          final provider = context.watch<HomeBloc>();

          if (state is RefreshState) {
            provider.add(RefreshEvent());
          }
          return ScreenTemplate(
            index: 0,
            title: 'Home',
            isAppBar: true,
            body: _Body(),
          );
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({Key key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  CollectionReference collection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('plants');

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  void _onRefresh() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _onLoading() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.loadComplete();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: collection.orderBy('createdAt').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (snapshot.hasData) {
                List plants = [];
                snapshot.data.docs.map((plant) => plants.add(plant)).toList();

                return snapshot.data.docs.length != 0
                    ? Column(
                        children: [
                          Container(
                            height: size.height * 0.13,
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 7,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0, left: 14.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Recently added:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                      SizedBox(height: 10.0),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              plants.last['name'],
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                            plants.last['score'],
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      plants.last['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                )
                              ],
                            ),
                          ),
                          PlantsSlider(data: snapshot.data.docs),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 270.0),
                        child: Center(
                          child: Text(
                            'No plants yet',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 23.0),
                          ),
                        ),
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PlantsSlider extends StatefulWidget {
  List<QueryDocumentSnapshot> data;

  PlantsSlider({Key key, this.data}) : super(key: key);

  @override
  _PlantsSliderState createState() => _PlantsSliderState();
}

class _PlantsSliderState extends State<PlantsSlider> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // ignore: close_sinks
    final provider = context.watch<HomeBloc>();

    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, bottom: 13.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'My plants',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ),
          ),
          Container(
            height: height * 0.44,
            child: Stack(
              children: [
                CarouselSlider(
                  items: widget.data
                      .map((plant) => _PlantItem(plant: plant))
                      .toList(),
                  options: CarouselOptions(
                    height: height * 0.43,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    autoPlayInterval: Duration(seconds: 4),
                    enlargeCenterPage: true,
                    viewportFraction: 0.75,
                    aspectRatio: 16 / 9,
                    onPageChanged: (index, reason) => provider.add(
                      NextImageEvent(index: index),
                    ),
                  ),
                  carouselController: _controller,
                ),
                Positioned(
                  bottom: 0.0,
                  right: 40.0,
                  child: _NextButton(controller: _controller),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlantItem extends StatelessWidget {
  final QueryDocumentSnapshot plant;

  const _PlantItem({Key key, this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routers.plant);
      },
      child: Padding(
        padding:
            EdgeInsets.only(left: 4.0, right: 4.0, bottom: 20.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 7,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            child: Stack(
              children: [
                Container(
                  child: Image.network(plant['image'],
                      fit: BoxFit.cover, width: 1000.0, height: 1000.0),
                ),
                Positioned(
                  bottom: 0,
                  child: buildMainInfo(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMainInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Color.fromRGBO(255, 255, 255, 0.97),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 60, bottom: 60, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plant['name'],
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              plant['score'],
              style: TextStyle(
                  color: Colors.black, letterSpacing: 1.0, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final CarouselController controller;
  const _NextButton({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => controller.nextPage(),
      elevation: 7.0,
      fillColor: Colors.orangeAccent,
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 30.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16.0),
      shape: CircleBorder(),
    );
  }
}
