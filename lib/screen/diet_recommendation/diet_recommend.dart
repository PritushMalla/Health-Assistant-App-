import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mood_tracker/screen/diet_recommendation/diet_display.dart';

class DietRecommend extends StatefulWidget {
  final Map<String, double> maxConstraints = {
    'Calories': 2000,
    'FatContent': 100,
    'SaturatedFatContent': 13,
    'CholesterolContent': 300,
    'SodiumContent': 2300,
    'CarbohydrateContent': 325,
    'FiberContent': 40,
    'SugarContent': 40,
    'ProteinContent': 200
  };

  DietRecommend({super.key});

  @override
  State<DietRecommend> createState() => _DietRecommendState();
}

class _DietRecommendState extends State<DietRecommend> {
  TextEditingController caloriesController = TextEditingController();

  TextEditingController fatContentController = TextEditingController();

  TextEditingController saturatedFatController = TextEditingController();

  TextEditingController cholesterolContentController = TextEditingController();

  TextEditingController sodiumContentController = TextEditingController();

  TextEditingController carbohydrateContentController = TextEditingController();

  TextEditingController fiberContentController = TextEditingController();

  TextEditingController sugarContentController = TextEditingController();

  TextEditingController proteinContentController = TextEditingController();

  Future<void> getRecommendations() async {
    Map<String, Map<String, dynamic>> userInput = {
      'max_nutritional_values': {
        'Calories': int.tryParse(caloriesController.text) ?? 0,
        'FatContent': int.tryParse(fatContentController.text) ?? 0,
        'SaturatedFatContent': int.tryParse(saturatedFatController.text) ?? 0,
        'CholesterolContent':
            int.tryParse(cholesterolContentController.text) ?? 0,
        'SodiumContent': int.tryParse(sodiumContentController.text) ?? 0,
        'CarbohydrateContent':
            int.tryParse(carbohydrateContentController.text) ?? 0,
        'FiberContent': int.tryParse(fiberContentController.text) ?? 0,
        'SugarContent': int.tryParse(sugarContentController.text) ?? 0,
        'ProteinContent': int.tryParse(proteinContentController.text) ?? 0,
      },
    };
    Map<String, dynamic> nutritionalValuesMap =
        userInput['max_nutritional_values']!;
    List<int> nutritionalValuesList =
        nutritionalValuesMap.values.cast<int>().toList();

    print("Calories: ${caloriesController.text}");
    print("FatContent: ${fatContentController.text}");
    print("SaturatedFatContent: ${saturatedFatController.text}");
    print("CholesterolContent: ${cholesterolContentController.text}");
    print("SodiumContent: ${sodiumContentController.text}");
    print("CarbohydrateContent: ${carbohydrateContentController.text}");
    print("FiberContent: ${fiberContentController.text}");
    print("SugarContent: ${sugarContentController.text}");
    print("ProteinContent: ${proteinContentController.text}");
    print(nutritionalValuesMap);

    final Map<String, dynamic> requestBody = {
      'data': nutritionalValuesList, // If your server expects a key like 'data'
    };
    final response = await http.post(
      Uri.parse('http://192.168.162.63:5000/recommend'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPage(recommendations: data),
          ));
      // This should now work
    } else {
      print("Error: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dietfield("Calories", caloriesController, "Under 2000"),
          dietfield("Fat", fatContentController, "Under 100 "),
          dietfield("Cholesterol", cholesterolContentController, "Under 300"),
          dietfield("Saturated Fat", saturatedFatController, "Under 13"),
          dietfield("Sodium", sodiumContentController, "Under 2300"),
          dietfield("Carbohydrate", carbohydrateContentController, "Under 325"),
          dietfield("Fiber", fiberContentController, "Under 40 "),
          dietfield("Sugar", sugarContentController, "Under 40 "),
          dietfield("Protein", proteinContentController, "Under 200"),
          ElevatedButton(
            onPressed: getRecommendations,
            child: Text('Generate Recommendations'),
          ),

          SizedBox(
            height: 20,
          )
          // dietfields(
          //   parameter: "Saturatedfat",
          //   control: saturatedFatController,
          // ),
          // dietfields(
          //   parameter: "Cholesterol",
          //   control: cholesterolContentController,
          // ),
          // dietfields(
          //   parameter: "Sodium",
          //   control: sodiumContentController,
          // ),
          // dietfields(
          //   parameter: "Carbohydrate",
          //   control: carbohydrateContentController,
          // ),
          // dietfields(
          //   parameter: "Fiber",
          //   control: fiberContentController,
          // ),
          // dietfields(
          //   parameter: "Sugar",
          //   control: sugarContentController,
          // ),
          // dietfields(
          //   parameter: "Protein",
          //   control: proteinContentController,
          // ),
        ],

        //    max_Calories=2000
        // max_daily_fat=100
        // max_daily_Saturatedfat=13
        // max_daily_Cholesterol=300
        // max_daily_Sodium=2300
        // max_daily_Carbohydrate=325
        // max_daily_Fiber=40
        // max_daily_Sugar=40
        // max_daily_Protein=200
      ),
    );
  }

  dietfield(text, control, hinttext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        SizedBox(
          width: 10,
        ),
        SizedBox(
            width: 100,
            child: TextField(
                decoration: InputDecoration(
                    hintText: hinttext,
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w200)),
                keyboardType: TextInputType.number,
                controller: control))
      ],
    );
  }

  // displayrecommend(recommend){
  //   ElevatedButton(onPressed: DisplayPage(recommendations: recommend,), child: Text("Display"))

  // }
}

// class dietfields extends StatefulWidget {
//   final parameter;
//   final control;
//   const dietfields({
//     super.key,
//     required this.parameter,
//     required this.control,
//   });

//   @override
//   State<dietfields> createState() => _dietfieldsState();
// }

// class _dietfieldsState extends State<dietfields> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(widget.parameter),
//         TextField(
//             keyboardType: TextInputType.number, controller: widget.control)
//       ],
//     );
//   }
// }
