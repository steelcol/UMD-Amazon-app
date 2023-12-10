import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../inherited/books_inherited.dart';
import '../models/book_model.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key, required this.videoURL}) : super(key: key);

  final String videoURL;

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late YoutubePlayerController _controller;
  //final String videoURL = 'YMx8Bbev6T4&t=25s';
  /*
  final List<String> videoIds = [
    'YMx8Bbev6T4&t=25s',
    'dSlaBuspxZU',

  ];

   */

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        widget.videoURL,
      )!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
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
            /*SizedBox(height: 16),
            Text(
              widget.exerciseName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _addExercisePopup();
              },
              icon: Icon(Icons.add),
              label: Text(
                'Add Exercise to Workout',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

             */
          ],
        ),
      ),
     /* body: ListView.builder(
        itemCount: videoIds.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoId: videoIds[index]),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text('Video ${index + 1}'),
                // You can add more information about the video here if needed
              ),
            ),
          );
        },
      ), */
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Video'),
      ),
      body: InAppWebView(
        initialFile: 'https://www.youtube.com/embed/${widget.videoId}',
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
          ),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
    );
  }
}
