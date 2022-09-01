import 'package:bloc/bloc.dart';
import 'package:cis_state/data/models/quotes.dart';
import 'package:flutter/cupertino.dart';
import '../../data/models/characters.dart';
import '../../data/repository/character_repository.dart';
part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character> characters = [];

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
    return characters;
  }

  void getQuotes(String quoteName) {
    charactersRepository.getAllCharactersQuotes(quoteName).then((quotes) {
      emit(QuotesLoaded(quotes));
      //this.quotes = quotes;
    });
    //return quotes;
  }
}
