import 'package:flutter/material.dart';

class DietRecommender extends StatefulWidget {
  const DietRecommender({super.key});

  @override
  State<DietRecommender> createState() => _DietRecommenderState();
}

class _DietRecommenderState extends State<DietRecommender> {
  @override
  Widget build(BuildContext context) {
    TextEditingController caloriesController = TextEditingController();

    TextEditingController fatContentController = TextEditingController();

    TextEditingController saturatedFatController = TextEditingController();

    TextEditingController cholesterolContentController =
        TextEditingController();

    TextEditingController sodiumContentController = TextEditingController();

    TextEditingController carbohydrateContentController =
        TextEditingController();

    TextEditingController fiberContentController = TextEditingController();

    TextEditingController sugarContentController = TextEditingController();

    TextEditingController proteinContentController = TextEditingController();
    return Scaffold(
        body: SizedBox(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This is a Row'),
          SizedBox(width: 20),
          SizedBox(
            width: 1,
            child: TextField(
                keyboardType: TextInputType.number,
                controller: caloriesController),
          )
        ],
      )
    ])));
  }
}
