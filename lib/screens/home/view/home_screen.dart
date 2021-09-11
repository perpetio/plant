import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/home/view/home_recently_added.dart';
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
                    ? HomeRecentlyAdded(
                        plants: plants,
                        docs: snapshot.data.docs,
                        size: size,
                      )
                    : _createNoPlants(size);
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

  Widget _createNoPlants(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.3),
      child: Center(
        child: Text(
          'No plants yet',
          style: TextStyle(color: Colors.grey, fontSize: 23.0),
        ),
      ),
    );
  }
}
