
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;



class mentalhinfo extends StatefulWidget {
  const mentalhinfo({super.key});

  @override
  State<mentalhinfo> createState() => _mentalhinfoState();
}

String stringresponse='';
class _mentalhinfoState extends State<mentalhinfo> {

  Future apicall() async{
  http.Response response;
 response= await http.get(Uri.parse("https://reqres.in/api/users?page=2"
  ));

 if(response.statusCode==200){
   setState(() {
     stringresponse=response.body;
   });
 }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    apicall();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Mental health Info'),



      ),
      body: Center(
       child:  Container(

         child:
             Center(
         child:
         Text( stringresponse.toString(),),
             )


        ),

      ),


    );
  }
}