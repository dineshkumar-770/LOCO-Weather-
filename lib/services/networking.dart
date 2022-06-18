import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper{

    NetworkHelper(this.url);
    final String url;

    Future getData() async{
    http.Response res = await http.get(Uri.parse(url));
    String data = res.body;
    if(res.body == 200){
    return jsonDecode(data);
  }
  else{
    print(res.body);
  }
    }
}

    