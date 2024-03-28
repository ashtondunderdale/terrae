import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:terrae/quiz/country.dart';

class CountryApi {

  Future<List<Country>> getCountries(String? gamemode, String category) async {
    try {
      
      String link = "https://restcountries.com/v3.1/all?fields=name,capital,unMember,continents";
      
      http.Response response = await http.get(Uri.parse(link));

      var json = jsonDecode(response.body);
      List<Country> countries = [];

      for (var countryInfo in json) {
        var name = countryInfo['name']['common'];
        List<dynamic> capitals = countryInfo['capital'];
        List<dynamic> continents = countryInfo['continents'];

        if (!countryInfo['unMember']) continue;

        if (category == 'WORLD') {
          countries.add(Country(
            name: name,
            capitals: capitals,
            continents: continents,
          ));

        } else {  
          if (continents.first.toLowerCase() != category.toLowerCase()) continue; 

          countries.add(Country(
            name: name,
            capitals: capitals,
            continents: continents,
          ));
        }
      }

      return countries;

    } catch (exception) {
      //print(exception);
      return [];
    }
  }

}