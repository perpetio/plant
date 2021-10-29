import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/common_widget/plants_loading.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/home/widget/home_recently_added.dart';
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
        buildWhen: (currState, _) =>
            currState is HomeInitial || currState is HomeLoadingState,
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = BlocProvider.of<HomeBloc>(context);
          if (state is HomeInitial) {
            bloc.add(HomeInitialEvent());
          } else if (state is HomeLoadingState) {
            return Stack(
              children: [
                ScreenTemplate(
                    index: 0, title: 'Home', isAppBar: true, body: _Body()),
                PlantsLoading()
              ],
            );
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
    // ignore: close_sinks
    final bloc = BlocProvider.of<HomeBloc>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 90.0),
      child: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            bloc.add(RefreshEvent());
            return SingleChildScrollView(
              child: (bloc.listPlantsModels ?? []).isNotEmpty ?? false
                  ? HomeRecentlyAdded(
                      listPlantsModels: bloc.listPlantsModels,
                      size: size,
                    )
                  : _createNoPlants(size),
            );
          },
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
