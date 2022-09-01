import 'package:cis_state/business_logic/cubit/characters_cubit.dart';
import 'package:cis_state/data/models/characters.dart';
import 'package:cis_state/presentation/screens/character_detail.dart';
import 'package:cis_state/presentation/screens/character_screen.dart';
import 'package:flutter/material.dart';
import 'package:cis_state/data/repository/character_repository.dart';
import 'package:cis_state/data/web_services/characters_web_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharacterWebServec());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (BuildContext context) => charactersCubit,
                child: const CharactersScreen()));

      case charactersDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                /*charactersCubit,*/
                CharactersCubit(charactersRepository),
            child: CharactersDetailsScreen(
              character: character,
            ),
          ),
        );
    }
    //return generateRoute(settings);
  }
}
