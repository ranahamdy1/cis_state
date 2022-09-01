import 'package:cis_state/data/models/quotes.dart';
import 'package:cis_state/data/web_services/characters_web_services.dart';
import '../models/characters.dart';

class CharactersRepository {
  final CharacterWebServec characterWebServec;

  CharactersRepository(this.characterWebServec);

  Future<List<Character>> getAllCharacters() async {
    final characters = await characterWebServec.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getAllCharactersQuotes(String quoteName) async {
    final quotes = await characterWebServec.getAllCharactersQuotes(quoteName);
    return quotes.map((quoteName) => Quote.fromJson(quoteName)).toList();
  }
}
