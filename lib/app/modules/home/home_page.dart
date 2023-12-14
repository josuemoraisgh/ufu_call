import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants.dart';
import '../../utils/models/category.dart';
import '../login/models/user_model.dart';
import '../../utils/models_view/nav_drawer.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController controller = Modular.get<HomeController>();
  User? user;
  List<Category>? levels;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (user == null) {
      await initUserProfile();
    }
  }

  Future<void> initUserProfile() async {
    setState(() async {
      user = await controller.moodleLocalStorage.getUserProfile();
    });
  }

  @override
  void initState() {
    super.initState();
    //model = MovieModel();
    //model.fetchNowPlaying();
    //model.fetchTrandingPerson();
    //callMovieApi(ApiConstant.POPULAR_MOVIES, model);
    //callMovieApi(ApiConstant.GENRES_LIST, model);
    //callMovieApi(ApiConstant.TRENDING_MOVIE_LIST, model);
    //callMovieApi(ApiConstant.DISCOVER_MOVIE, model);
    //callMovieApi(ApiConstant.UPCOMING_MOVIE, model);
    //model.fetchTrandingPerson();
    //callMovieApi(ApiConstant.TOP_RATED, model);
  }

  void requestData() {
    levels = [];
    //for (int i = 0; i < books.length; i++)
    //  bookList.add(BookItem<Book>(books[i]));
    levels?.add(Category(1, "Primary 1", "", "Primary 1 level", "", 0, 0, 0, 0,
        0, 0, 0, "", ""));
    levels?.add(Category(2, "Primary 2", "", "Primary 2 level", "", 0, 0, 0, 0,
        0, 0, 0, "", ""));
    levels?.add(Category(3, "Primary 3", "", "Primary 3 level", "", 0, 0, 0, 0,
        0, 0, 0, "", ""));
    levels?.add(Category(4, "Primary 4", "", "Primary 4 level", "", 0, 0, 0, 0,
        0, 0, 0, "", ""));
    levels?.add(Category(5, "Primary 5", "", "Primary 5 level", "", 0, 0, 0, 0,
        0, 0, 0, "", ""));
    levels?.add(Category(6, "Primary 6", "", "Primary 6 level", "", 0, 0, 0, 0,
        0, 0, 0, "", ""));
    levels?.add(Category(
        7, "JSS 1", "", "JSS 1 level", "", 0, 0, 0, 0, 0, 0, 0, "", ""));
    levels?.add(Category(
        8, "JSS 2", "", "JSS 2 level", "", 0, 0, 0, 0, 0, 0, 0, "", ""));
    levels?.add(Category(
        9, "JSS 3", "", "JSS 3 level", "", 0, 0, 0, 0, 0, 0, 0, "", ""));
    levels?.add(Category(
        10, "SSS 1", "", "SSS 1 level", "", 0, 0, 0, 0, 0, 0, 0, "", ""));
    levels?.add(Category(
        11, "SSS 2", "", "SSS 2 level", "", 0, 0, 0, 0, 0, 0, 0, "", ""));
    levels?.add(Category(
        12, "SSS 3", "", "SSS 3 level", "", 0, 0, 0, 0, 0, 0, 0, "", ""));
  }

  @override
  Widget build(BuildContext context) {
    var homeIcon = IconButton(
        icon: const Icon(Icons.sort),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        });

    if (levels == null) {
      levels = <Category>[];
      requestData();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBarWithBackBtn(
          ctx: context,
          title: Texts.APP_NAME,
          //bgColor: ColorConst.WHITE_BG_COLOR,
          icon: homeIcon),
      drawer: const NavDrawer(),
      body: _createUi(),
    );
  }

  AppBar getAppBarWithBackBtn(
      {required BuildContext ctx,
      String? title,
      Color? bgColor,
      double? fontSize,
      String? titleTag,
      Widget? icon}) {
    return AppBar(
      //backgroundColor: bgColor == null ? ColorConst.APP_COLOR : bgColor,
      leading: icon,
      centerTitle: true,
      title: Hero(tag: titleTag ?? "", child: Text(title ?? "")),
    );
  }

  Widget _createUi() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                /*child: Text(
                  "CHOOSE YOUR LEVEL",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),*/
                child: Text(
                  "CHOOSE YOUR LEVEL",
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "PRIMARY",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: levels!.length,
              itemBuilder: gridListView,
            ),
          ],
        ),
      ),
    );
  }

  Widget gridListView(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Card(
          color: Colors.white,
          elevation: 5,
          child: Row(
            children: <Widget>[
              Hero(
                tag: levels![index].id,
                child: Container(
                  height: 120,
                  width: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/appicon.png")),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      levels![index].name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 240,
                      child: Text(
                        levels![index].name,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
