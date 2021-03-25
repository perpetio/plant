import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/core/data.dart';
import 'package:plant/models/models.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/widgets/screen_template.dart';

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
            body: _Body(),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  _Body({Key key}) : super(key: key);

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // ignore: close_sinks
    final provider = context.watch<HomeBloc>();

    final List<Widget> promoSliders =
        promoList.map((promo) => _PromoImage(promo: promo)).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Container(
        height: height * 0.455,
        child: Stack(
          children: [
            CarouselSlider(
              items: promoSliders,
              options: CarouselOptions(
                height: height * 0.44,
                autoPlay: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 4),
                enlargeCenterPage: false,
                viewportFraction: 0.7,
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
    );
  }
}

class _PromoImage extends StatelessWidget {
  final Promo promo;

  const _PromoImage({Key key, this.promo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(13.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        elevation: 5.0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          child: Container(
            child: Stack(
              children: [
                Container(
                  child: Image.asset(promo.image,
                      fit: BoxFit.cover, width: 1000.0, height: 1000.0),
                ),
                Positioned(bottom: 0, child: _PromoImageInfo(promo: promo)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PromoImageInfo extends StatelessWidget {
  final Promo promo;

  const _PromoImageInfo({Key key, this.promo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      color: Color.fromRGBO(255, 255, 255, 0.97),
      child: Padding(
        padding: const EdgeInsets.only(top: 60, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              promo.date,
              style: TextStyle(
                  color: Colors.black, letterSpacing: 1.0, fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            Text(
              promo.discount,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: 33.0),
            ),
            SizedBox(height: 4.0),
            Text(
              promo.category,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: 17.0),
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
        Icons.navigate_next,
        size: 35.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(14.0),
      shape: CircleBorder(),
    );
  }
}
