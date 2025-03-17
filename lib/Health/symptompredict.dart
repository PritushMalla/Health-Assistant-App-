import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/router_report.dart';
import 'package:http/http.dart' as http;

class Symptompredict extends StatefulWidget {
  const Symptompredict({super.key});

  @override
  State<Symptompredict> createState() => _SymptompredictState();
}

class _SymptompredictState extends State<Symptompredict> {
  List<String> inputsymptoms = [];

  List<String> symptoms = [
    'back_pain',
    'constipation',
    'abdominal_pain',
    'diarrhoea',
    'mild_fever',
    'yellow_urine',
    'yellowing_of_eyes',
    'acute_liver_failure',
    'swelling_of_stomach',
    'swelled_lymph_nodes',
    'malaise',
    'blurred_and_distorted_vision',
    'phlegm',
    'throat_irritation',
    'redness_of_eyes',
    'sinus_pressure',
    'runny_nose',
    'congestion',
    'chest_pain',
    'weakness_in_limbs',
    'fast_heart_rate',
    'pain_during_bowel_movements',
    'pain_in_anal_region',
    'bloody_stool',
    'irritation_in_anus',
    'neck_pain',
    'dizziness',
    'cramps',
    'bruising',
    'obesity',
    'swollen_legs',
    'swollen_blood_vessels',
    'puffy_face_and_eyes',
    'enlarged_thyroid',
    'brittle_nails',
    'swollen_extremeties',
    'excessive_hunger',
    'extra_marital_contacts',
    'drying_and_tingling_lips',
    'slurred_speech',
    'knee_pain',
    'hip_joint_pain',
    'muscle_weakness',
    'stiff_neck',
    'swelling_joints',
    'movement_stiffness',
    'spinning_movements',
    'loss_of_balance',
    'unsteadiness',
    'weakness_of_one_body_side',
    'loss_of_smell',
    'bladder_discomfort',
    'foul_smell_of urine',
    'continuous_feel_of_urine',
    'passage_of_gases',
    'internal_itching',
    'toxic_look_(typhos)',
    'depression',
    'irritability',
    'muscle_pain',
    'altered_sensorium',
    'red_spots_over_body',
    'belly_pain',
    'abnormal_menstruation',
    'dischromic _patches',
    'watering_from_eyes',
    'increased_appetite',
    'polyuria',
    'family_history',
    'mucoid_sputum',
    'rusty_sputum',
    'lack_of_concentration',
    'visual_disturbances',
    'receiving_blood_transfusion',
    'receiving_unsterile_injections',
    'coma',
    'stomach_bleeding',
    'distention_of_abdomen',
    'history_of_alcohol_consumption',
    'fluid_overload',
    'blood_in_sputum',
    'prominent_veins_on_calf',
    'palpitations',
    'painful_walking',
    'pus_filled_pimples',
    'blackheads',
    'scurring',
    'skin_peeling',
    'silver_like_dusting',
    'small_dents_in_nails',
    'inflammatory_nails',
    'blister',
    'red_sore_around_nose',
    'yellow_crust_ooze'
  ];
  String selectedSymptom1 = 'back_pain';
  String selectedSymptom2 = 'back_pain';
  String selectedSymptom3 = 'back_pain';
  String selectedSymptom4 = 'back_pain';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dropdownwidget(selectedSymptom1, (String? newVal) {
            setState(() {
              selectedSymptom1 = newVal!;
            });
            // inputsymptoms.insert(inputsymptoms.length, selectedSymptom1);
          }),
          SizedBox(height: 20),
          dropdownwidget(selectedSymptom2, (String? newVal) {
            setState(() {
              selectedSymptom2 = newVal!;
            });
            // inputsymptoms.insert(inputsymptoms.length, selectedSymptom2);
          }),
          SizedBox(height: 20),
          dropdownwidget(selectedSymptom3, (String? newVal) {
            setState(() {
              selectedSymptom3 = newVal!;
            });
            // inputsymptoms.insert(inputsymptoms.length, selectedSymptom3);
          }),
          SizedBox(height: 20),
          dropdownwidget(selectedSymptom4, (String? newVal) {
            setState(() {
              selectedSymptom4 = newVal!;
            });
            // inputsymptoms.insert(inputsymptoms.length, selectedSymptom4);
          }),
          ElevatedButton(
              onPressed: () {
                predictdisease();
              },
              child: Text("Predict disease")),
          // printresult(inputsymptoms)
        ],
      ),
    ));
  }

  Widget dropdownwidget(
      String selected_item, ValueChanged<String?> onChangedpred) {
    return DropdownButton<String>(
        value: selected_item,
        items: symptoms.map<DropdownMenuItem<String>>((String values) {
          return DropdownMenuItem<String>(value: values, child: Text(values));
        }).toList(),
        onChanged: onChangedpred);
  }

  predictdisease() async {
    inputsymptoms = [
      selectedSymptom1,
      selectedSymptom2,
      selectedSymptom3,
      selectedSymptom4
    ];
    try {
      await getprediction(inputsymptoms);
    } catch (e) {
      print("Error: $e");
    }
    print(inputsymptoms);
  }

  Future<void> getprediction(List<String> inputValue) async {
    final url = Uri.parse(
        'http://192.168.162.63:5000/getprediction'); // Replace with your deployed API URL
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"symptoms": inputValue}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print("Prediction: ${result['disease']}");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Prediction: ${result['disease']}")));
    } else {
      print("Error: ${response.body}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
    }
  }
}
