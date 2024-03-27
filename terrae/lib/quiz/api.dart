import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:terrae/quiz/country.dart';

class QuizApi {

  Future<List<Country>> getCountries() async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://restcountries.com/v3.1/all?fields=name,capital")
      );

      var json = jsonDecode(response.body);
      List<Country> countries = [];

      for (var countryInfo in json) {
        var name = countryInfo['name']['common'];
        List<dynamic> capital = countryInfo['capital'];

        countries.add(
          Country(
            name: name,
            capital: capital,
          )
        );
      }

    } catch (exception) {
      print(exception);
    }
  }

}