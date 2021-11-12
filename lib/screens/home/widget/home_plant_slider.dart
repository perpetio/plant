import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/home/widget/home_next_button.dart';
import 'package:plant/screens/home/widget/home_plant_item.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomePlantsSlider extends StatefulWidget {
  final List<PlantsModels> listPlantsModels;

  HomePlantsSlider({
    @required this.listPlantsModels,
  });

  @override
  _HomePlantSliderState createState() => _HomePlantSliderState();
}

class _HomePlantSliderState extends State<HomePlantsSlider> {
  final CarouselController _controller = CarouselController();

  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // ignore: close_sinks
    final bloc = BlocProvider.of<HomeBloc>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 13),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'My plants',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
          ),
          Container(
            height: height * 0.44,
            child: Stack(
              children: [
                CarouselSlider(
                  items: widget.listPlantsModels
                      .map((plant) => HomePlantItem(
                            plantsModels: plant,
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: height * 0.43,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    autoPlayInterval: Duration(seconds: 4),
                    enlargeCenterPage: true,
                    viewportFraction: 0.75,
                    aspectRatio: 16 / 9,
                    onPageChanged: (index, reason) => bloc.add(
                      NextImageEvent(index: index),
                    ),
                  ),
                  carouselController: _controller,
                ),
                Positioned(
                  bottom: 0,
                  right: 40,
                  child: HomeNextButton(controller: _controller),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
