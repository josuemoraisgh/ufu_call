import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

class NavDrawer extends StatelessWidget {
  final User user;
  final Token token;
  const NavDrawer({
    super.key,
    required this.user,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return _buildDrawer(context);
  }

  _buildDrawer(BuildContext context) {
    //final ByteData imageData = await NetworkAssetBundle(Uri.parse('https://picsum.photos/250?image=9')).load("");
    //final Uint8List bytes = imageData.buffer.asUint8List();
    var imagem = NetworkImage(
        '${user.userpictureurl.replaceFirst("?", "&").replaceFirst(".php", ".php?file=")}&forcedownload=1&token=${token.token}');
    return ClipPath(
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: const BoxDecoration(
              //color: ColorConst.WHITE_BG_COLOR,
              boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                      ),
                      onPressed: () => Modular.to.pop(),
                    ),
                  ),
                  InkWell(
                    onTap: () => _navigateOnNextScreen('Profile'),
                    child: Container(
                      height: 128,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Colors.green, Colors.blue])),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: imagem,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text('${user.firstname} ${user.lastname}'),
                  Text("@${user.username}"),
                  const SizedBox(height: 30.0),
                  _buildRow(Icons.home, "Home"),
                  _buildDivider(),
                  _buildRow(Icons.category, "Category"),
                  _buildDivider(),
                  _buildRow(Icons.local_movies, "Tranding Movie",
                      showBadge: true),
                  _buildDivider(),
                  _buildRow(Icons.movie_filter, "Popular Movie",
                      showBadge: false),
                  _buildDivider(),
                  _buildRow(Icons.movie, "Upcoming Movie", showBadge: true),
                  _buildDivider(),
                  _buildRow(Icons.person_pin, "Profile"),
                  _buildDivider(),
                  _buildRow(Icons.settings, "Settings"),
                  _buildDivider(),
                  _buildRow(Icons.email, "Contact us"),
                  _buildDivider(),
                  _buildRow(Icons.info_outline, "About us"),
                  _buildDivider(),
                  _buildRow(Icons.exit_to_app, "Exit"),
                  _buildDivider(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
        //color: ColorConst.GREY_COLOR,
        );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () => _navigateOnNextScreen(title),
        child: Row(children: [
          Icon(
            icon,
            //color: ColorConst.BLACK_COLOR,
          ),
          const SizedBox(width: 10.0),
          Text(title),
          const Spacer(),
          if (showBadge)
            Material(
              //color: ColorConst.APP_COLOR,
              elevation: 2.0,
              // shadowColor: ColorConst.APP_COLOR,
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                width: 10,
                height: 10,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  //color: ColorConst.APP_COLOR,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // child: Text(
                //   "10+",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.bold),
                // ),
              ),
            )
        ]),
      ),
    );
  }

  void _navigateOnNextScreen(String title) {
    switch (title) {
      case "Home":
        // navigationPush(_context, CategoryMovie());
        break;
      case "Category":
        //navigationPush(_context, MovieListScreen(apiName: ApiConstant.GENRES_LIST));
        break;
      case "Tranding Movie":
        //navigationPush(_context, MovieListScreen(apiName: ApiConstant.TRENDING_MOVIE_LIST));
        break;
      case "Popular Movie":
        //navigationPush(_context, MovieListScreen(apiName: ApiConstant.POPULAR_MOVIES));
        break;
      case "Upcoming Movie":
        //navigationPush(_context, MovieListScreen(apiName: ApiConstant.UPCOMING_MOVIE));
        break;
      case "Profile":
        //navigationStateLessPush(_context, ProfileScreen());
        break;
      case "Settings":
        //navigationPush(_context, SettingScreen());
        break;
      case "Contact us":
        break;
      case "About us":
        break;
      case "Exit":
        //onWillPop(_context);
        break;
      default:
        Modular.to.pop();
        break;
    }
  }
}
