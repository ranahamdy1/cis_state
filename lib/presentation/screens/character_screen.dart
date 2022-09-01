import 'package:cis_state/business_logic/cubit/characters_cubit.dart';
import 'package:cis_state/constants/mycolors.dart';
import 'package:cis_state/data/models/characters.dart';
import 'package:cis_state/presentation/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character>? allCharacters;
  List<Character>? searchForCharacter;
  bool isSearching = false;
  final _searchForCharacter = TextEditingController();

  Widget buildSearchFeild() {
    return TextField(
      controller: _searchForCharacter,
      cursorColor: myGrey,
      decoration: const InputDecoration(
        hintText: "find a character...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: myGrey, fontSize: 18),
      ),
      style: const TextStyle(color: myGrey, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemToSearchedList(String searchedCharacter) {
    searchForCharacter = allCharacters
        ?.where((character) =>
            character.name.toLowerCase().startsWith(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarAction() {
    if (isSearching) {
      return [
        IconButton(
            onPressed: () {
              clearSearching();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.grey,
            ))
      ];
    } else {
      return [
        IconButton(
            onPressed: _startSearch,
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ))
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      isSearching = true;
    });
  }

  void _stopSearching() {
    clearSearching();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearching() {
    setState(() {
      _searchForCharacter.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = (state).characters;
          return buildLoadedListWidget();
        } else {
          return showLoading();
        }
      },
    );
  }

  Widget showLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: myGrey,
      ),
    );
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: myGrey,
        child: Column(
          children: [buildCharacterWidget()],
        ),
      ),
    );
  }

  Widget buildCharacterWidget() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _searchForCharacter.text.isEmpty
            ? allCharacters?.length
            : searchForCharacter?.length,
        itemBuilder: (context, index) {
          return CharacterItem(
            character: _searchForCharacter.text.isEmpty
                ? allCharacters![index]
                : searchForCharacter![index],
          );
        });
  }

  Widget buildAppBarTitle() {
    return const Text(
      "characters",
      style: TextStyle(color: myGrey),
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "can not connect check Internet",
              style: TextStyle(
                fontSize: 22,
                color: myGrey,
              ),
            ),
            Image.asset("assets/images/2.png"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myYellow,
        leading: isSearching ? const BackButton(color: myGrey) : Container(),
        title: isSearching ? buildSearchFeild() : buildAppBarTitle(),
        actions: _buildAppBarAction(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buildBlocWidget();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoading(),
      ),
    );
  }
}
