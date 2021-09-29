import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plant/models/plant_net.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/home/view/home_next_button.dart';
import 'package:plant/screens/home/view/home_plant_item.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomePlantsSlider extends StatefulWidget {
  final List<PlantDetect> plants;

  HomePlantsSlider({@required this.plants});

  @override
  _HomePlantSliderState createState() => _HomePlantSliderState();
}

class _HomePlantSliderState extends State<HomePlantsSlider> {
  final CarouselController _controller = CarouselController();

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
                  items: widget.plants
                      .map((plant) => HomePlantItem(plant: plant))
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