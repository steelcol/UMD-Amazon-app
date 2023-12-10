import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../inherited/books_inherited.dart';
import '../models/book_model.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final List<String> videoIds = [
    'YMx8Bbev6T4&t=25s',
    'dSlaBuspxZU',

  ];

  @override
  void initState() {

      super.initState();
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
      body: ListView.builder(
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
      ),
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
