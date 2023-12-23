import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../utils/constants.dart';
import '../../utils/models/course.dart';
import '../../utils/models/token_model.dart';
import 'models_view/nav_drawer.dart';
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
/*
  @override
  Future<void> didChangeDependencies() async {
    if (user == null) {
      await initUserProfile();
    }
    super.didChangeDependencies();
  }
*/
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeIcon = IconButton(
        icon: const Icon(Icons.sort),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        });

    return FutureBuilder<bool>(
      future: controller.initUserProfile(),
      builder: (BuildContext context, AsyncSnapshot<bool> initUserProfile) =>
          Scaffold(
              key: _scaffoldKey,
              appBar: getAppBarWithBackBtn(
                  ctx: context,
                  title: Texts.APP_NAME,
                  //bgColor: ColorConst.WHITE_BG_COLOR,
                  icon: homeIcon),
              drawer: initUserProfile.hasData ? NavDrawer(controller) : null,
              body: initUserProfile.hasData
                  ? _createUi(controller.token!, controller.courses!)
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
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

  Widget _createUi(Token token, List<Course> courses) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (BuildContext context, int index) =>
                  gridListView(context, index, token, courses),
            ),
          ],
        ),
      ),
    );
  }

  Widget gridListView(
      BuildContext context, int index, Token token, List<Course> courses) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: () => Modular.to.pushNamed(
            "/students/",
            arguments: {"course": courses[index]},
          ),
          child: Card(
            color: Colors.white,
            elevation: 5,
            child: Row(
              children: <Widget>[
                Hero(
                  tag: courses[index].id,
                  child: Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5)),
                      image: courses[index].fileurl.isNotEmpty
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                '${courses[index].fileurl.replaceFirst(".php", ".php?file=")}&forcedownload=1&token=${token.token}',
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: constraints.maxWidth - 130,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                courses[index].fullname,
                                softWrap: false,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 240,
                        child: Text(
                          courses[index].shortname,
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
      ),
    );
  }
}
