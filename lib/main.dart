import 'package:flutter/material.dart';
import 'package:learning_wallpaper_app/model.dart';
import 'package:learning_wallpaper_app/service.dart';
import 'package:learning_wallpaper_app/set_wallpaper_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'wallpaper app',
      debugShowCheckedModeBanner: false,
      home: WallpaperScreen(),
    );
  }
}

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({Key? key}) : super(key: key);

  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  late List<Empty?>? photos;
  late List<Empty?>? morePhotos;
  int page = 1;

  bool isLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhotos();
  }

  void getPhotos() async {
    photos = await ApiService().getPhotos();
    if (photos != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  void loadMore() async {
    page++;
    debugPrint(page.toString());
    morePhotos = await ApiService().loadMore(page: page);
    if (morePhotos != null) {
      debugPrint('wild');
      setState(() {
        morePhotos?.forEach((element) {
          photos?.add(element);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: isLoaded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  childAspectRatio: 2 / 3),
                          itemCount: photos?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SetWallpaperScreen(
                                            imageUrl: photos![index]!
                                                .src!
                                                .large2X!)));
                              },
                              child: Container(
                                color: Colors.white,
                                child: Image.network(
                                  photos![index]!.src!.tiny!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          })),
                  GestureDetector(
                    onTap: () {
                      loadMore();
                    },
                    child: Container(
                      color: Colors.black,
                      height: 60,
                      width: double.infinity,
                      child: const Center(
                          child: Text(
                        'load more',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
