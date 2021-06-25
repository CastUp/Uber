import 'dart:convert';
import 'package:http/http.dart' as http;


class RequestAssistants{

  static Future<dynamic> getRequest({String? url}) async{
    
    http.Response response = await http.get(Uri.parse(url!));

    try{
      if(response.statusCode == 200){
        var decodeDate = json.decode(response.body);
        return decodeDate ;
      }else{

        return "Failed";
      }
    }catch(e){

      return "Failed";
    }
  }


}