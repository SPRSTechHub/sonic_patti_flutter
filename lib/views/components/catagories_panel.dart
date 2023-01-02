import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class ListofGames extends StatefulWidget {
  const ListofGames({super.key});

  @override
  State<ListofGames> createState() => _ListofGamesState();
}

class _ListofGamesState extends State<ListofGames> {
  final HomeController listController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: ((context, index) {
          var catData = listController.catLists[index];
          return GestureDetector(
            onTap: (() {
              setState(() {
                Get.snackbar('Message', 'We are working on this....');
              });
              print(catData.catId);
            }),
            child: Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: NetworkImage(
                        "https://control.fatafatguru.in/uploads/cat_img/${catData.catIurl}"),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          padding: const EdgeInsets.all(4.0),
                          width: 42,
                          height: 18,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(0),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topCenter,
                                colors: [
                                  Color.fromRGBO(255, 4, 4, 1),
                                  Color.fromRGBO(255, 4, 4, 0.7),
                                ]),
                          ),
                          child: const Text(
                            'LIVE',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontFamily: 'Inter',
                                fontSize: 10,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      color: Color.fromRGBO(21, 55, 34, 0.90),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(catData.catTitle, textAlign: TextAlign.left),
                        Text("imageHero$index", textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        itemCount: listController.catLists.length);
  }
}
