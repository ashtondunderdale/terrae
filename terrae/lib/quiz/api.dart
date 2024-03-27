import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:terrae/quiz/country.dart';

class QuizApi {

  Future<List<Country>> getCountries() async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://restcountries.com/v3.1/all?fields=name,capital,unMember")
      );

      var json = jsonDecode(response.body);
      List<Country> countries = [];

      for (var countryInfo in json) {
        var name = countryInfo['name']['common'];
        List<dynamic> capitals = countryInfo['capital'];
        bool isInUnitedNations = countryInfo['unMember'];

        if (!isInUnitedNations) continue;

        countries.add(Country(
          name: name,
          capitals: capitals,
        ));
      }

      return countries;

    } catch (exception) {
      //print(exception);
      return [];
    }
  }

}