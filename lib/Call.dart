import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '100';
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Service'),
      ),
      drawer: Drawers(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Card(
            child: Text(
              "'Every year more than 700 000 people die due to suicide globally. For every suicide, there are many more people who attempt to take their lives. Almost 77 percent of suicides occur in low and middle-income countries.While suicide is a serious public health problem, it can be prevented with timely evidence-based, and often low-cost interventions including early identification of risk, assessing, managing, and follow-up of people exhibiting suicidal behavior.'",
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              //                   )),),
            ),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: _hasCallSupport
                ? () => setState(() {
                      _launched = _makePhoneCall(_phone);
                    })
                : null,
            child: _hasCallSupport
                ? const Text('Emergency Call')
                : const Text('Calling not supported'),
          ),
        ),
      ]),
    );
  }
}
