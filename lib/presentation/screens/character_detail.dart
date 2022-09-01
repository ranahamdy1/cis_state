import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cis_state/business_logic/cubit/characters_cubit.dart';
import 'package:cis_state/constants/mycolors.dart';
import 'package:cis_state/data/models/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersDetailsScreen extends StatelessWidget {
  const CharactersDetailsScreen({Key? key, required this.character})
      : super(key: key);
  final Character character;

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.nickName,
          style: const TextStyle(color: myWhite),
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: myYellow,
      endIndent: endIndent,
      height: 30,
      thickness: 2,
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
              text: title,
              style: const TextStyle(
                  color: myWhite, fontWeight: FontWeight.bold, fontSize: 18)),
          TextSpan(
              text: value,
              style: const TextStyle(
                  color: myWhite, fontWeight: FontWeight.bold, fontSize: 16))
        ]));
  }

  Widget checkIfQuodAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoterEmptySpace(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget displayRandomQuoterEmptySpace(state) {
    var quotes = (state).quotes;
    if (quotes.length != 0) {
      int randomQuodIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: myYellow, shadows: [
              Shadow(
                blurRadius: 7,
                color: myYellow,
                offset: Offset(0, 0),
              )
            ]),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                FlickerAnimatedText(quotes[randomQuodIndex].quote),
              ],
            )),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: myYellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo('Jops : ', character.jobs.join(' / ')),
                      buildDivider(315),
                      characterInfo(
                          'Appered in : ', character.categoryForTwoEries),
                      buildDivider(250),
                      character.appearanceOFSeasons.isEmpty
                          ? Container()
                          : characterInfo('Sessons : ',
                              character.appearanceOFSeasons.join(' / ')),
                      character.appearanceOFSeasons.isEmpty
                          ? Container()
                          : buildDivider(150),
                      characterInfo('Status : ', character.statusIfDeadOrAlive),
                      buildDivider(300),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : characterInfo('Better Call Saul Seasons : ',
                              character.betterCallSaulAppearance.join(' / ')),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : buildDivider(150),
                      characterInfo('Actor/Actoress : ', character.actorName),
                      buildDivider(235),
                      const SizedBox(height: 20),
                      BlocBuilder<CharactersCubit, CharactersState>(
                          builder: (context, state) {
                        return checkIfQuodAreLoaded(state);
                      })
                    ],
                  ),
                ),
                const SizedBox(height: 500)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
