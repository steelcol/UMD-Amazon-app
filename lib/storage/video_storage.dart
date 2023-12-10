import 'package:beta_books/models/video_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoInformation {
  late List<Video> video;

  // Database shorthand
  final dbRef = FirebaseFirestore.instance.collection('VideoURL');

  // Private constructor
  VideoInformation._create();

  // Async constructor initialization
  static Future<VideoInformation> create() async {
    // Call private constructor
    var info = VideoInformation._create();

    // Perform initialization
    await info._getVideoURL();
    //await info._getLowerBodyExercises();
    //await info._getCoreExercises();
    //await info._getStretchExercises();

    return info;
  }

  // Private functions

  // Function to grab exercises
  Future<void> _getVideoURL() async {
    try {
      video = [];

      await dbRef.doc('VideoURL').get().then((value) {
        List.from(value.data()!['Exercises']).forEach((element) {
          Video videoName = Video(
              videoURL: element['VideoURL']
          );
          video.add(videoName);
        });
      });
    }
    catch (e) {
      throw Future.error("ERROR $e");
    }
  }
}