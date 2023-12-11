import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../inherited/books_inherited.dart';
import '../models/book_model.dart';


class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late YoutubePlayerController _controller;

  String goodStudyHabits = "https://www.youtube.com/watch?v=BdfoFY3Sp9k";
  String flutterTutorial = "https://www.youtube.com/watch?v=8sAyPDLorek";
  String bookBuyingTips = "https://www.youtube.com/watch?v=6VjUgfXBSFw";

  switchToFlutterTutorial() {
    _controller.load(YoutubePlayer.convertUrlToId(flutterTutorial)!);
  }

  switchToGoodStudyHabits() {
    _controller.load(YoutubePlayer.convertUrlToId(goodStudyHabits)!);
  }

  switchToBookBuyingTips() {
    _controller.load(YoutubePlayer.convertUrlToId(bookBuyingTips)!);
  }

  @override
  initState() {
    //VideoInformation info = VideoInformation.create() as VideoInformation;
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        goodStudyHabits,
      )!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        showLiveFullscreenButton: false,
      ),
    );


    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = BooksData.of(context).books;
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),
      drawer: Drawer(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: <Widget> [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [
                      /*
                        Image(
                          image: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!) ??,
                        ),
                        */
                        FirebaseAuth.instance.currentUser!.displayName != null
                        ? Text(FirebaseAuth.instance.currentUser!.displayName!) 
                        : const Text('User'),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Calendar'),
                    onTap: () => Navigator.of(context).pushReplacementNamed(calendar),
                  ),
                  const ListTile(
                    title: Text('Videos'),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: const Text('Settings'),
                  onTap: () => Navigator.of(context).pushReplacementNamed(userSettings),
                ),
              ),
            ),
          ]
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            ElevatedButton(
              onPressed: () {
                switchToFlutterTutorial();
              },
              child: Text('Switch to Flutter Tutorial Video!'),
            ),
            ElevatedButton(
              onPressed: () {
                switchToBookBuyingTips();
              },
              child: Text('Switch to Book Buying Tips Video!'),
            ),
            ElevatedButton(
              onPressed: () {
                switchToGoodStudyHabits();
              },
              child: Text('Switch to a Good Study Habits Video!'),
            ),
          ],
        ),
      ),
    );
  }
}
