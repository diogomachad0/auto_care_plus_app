import 'dart:convert';

import 'package:auto_care_plus_app/app/shared/api/constantes.dart';
import 'package:auto_care_plus_app/app/shared/models/personagem.dart';
import 'package:http/http.dart' as http;

class PersonagemServices {
  Future<List<Personagem>> getPersonagens() async {
    final response = await http.get(Uri.parse('$BASE_URL/quotes?count=32'));

    if(response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((personagem) => Personagem.fromJson(personagem)).toList();
    } else {
      throw Exception("Erro ao buscar personagens!");
    }
  }
}