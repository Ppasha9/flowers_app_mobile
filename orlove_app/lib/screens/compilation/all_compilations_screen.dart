import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/compilation_controller.dart';
import 'package:orlove_app/screens/compilation/compilation_screen.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';

class AllCompilationsScreen extends StatefulWidget {
  const AllCompilationsScreen();

  @override
  _AllCompilationsScreenState createState() => _AllCompilationsScreenState();
}

class _AllCompilationsScreenState extends State<AllCompilationsScreen> {
  bool _isLoading = true;
  List<CompilationCuttedFormDTO> _compilations;

  Future<List<CompilationCuttedFormDTO>> _loadAllCompilations() async {
    return CompilationController.getAllCompilationsCuttedForms();
  }

  @override
  void initState() {
    _loadAllCompilations().then((value) {
      setState(() {
        _isLoading = false;
        _compilations = value;
      });
    });
    super.initState();
  }

  Widget _getCompilationsGridWidget(MediaQueryData mediaQuery) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: List.generate(_compilations.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => CompilationScreen(
                    id: _compilations[index].id,
                  ),
                ),
              );
            },
            child: Container(
              height: mediaQuery.size.height / 3,
              width: (mediaQuery.size.width - 20) / 2.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: mediaQuery.size.height / 5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_compilations[index].picUrl),
                        fit: BoxFit.fill,
                      ),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(4.0)),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "${_compilations[index].name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontWeight: FontWeight.normal,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            "ВСЕ ПОДБОРКИ",
            style: TextStyle(
              fontSize: 16 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontWeight: FontWeight.w600,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _getCompilationsGridWidget(mediaQuery),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context),
      bottomNavigationBar: getBottomNavigationBar(context),
    );
  }
}
