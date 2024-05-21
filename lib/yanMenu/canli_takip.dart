import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CanliTakip extends StatefulWidget {
  const CanliTakip({super.key});

  @override
  State<CanliTakip> createState() => _CanliTakipState();
}

class _CanliTakipState extends State<CanliTakip> {
  final List<Tarla> tarlalar = [
    Tarla(baslik: 'Kamera - 1', bilgi: 'Kocaeli', videoPath: 'assets/cctv.mp4'),
    Tarla(baslik: 'Kamera - 2', bilgi: 'Kocaeli', videoPath: 'assets/cctv.mp4'),
    Tarla(baslik: 'Kamera - 3', bilgi: 'Kocaeli', videoPath: 'assets/cctv.mp4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Takip'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tarlalar.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(tarlalar[index].baslik, style: const TextStyle(color: Colors.white ,fontSize: 18),),
                subtitle: Text(tarlalar[index].bilgi,style: const TextStyle(color: Colors.white),),
                trailing: IconButton(
                  icon: const Icon(Icons.video_settings,color: Colors.white,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoEkrani(videoPath: tarlalar[index].videoPath)),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Tarla {
  final String baslik;
  final String bilgi;
  final String videoPath;

  Tarla({required this.baslik, required this.bilgi, required this.videoPath});
}

class VideoEkrani extends StatefulWidget {
  final String videoPath;

  VideoEkrani({required this.videoPath});

  @override
  _VideoEkraniState createState() => _VideoEkraniState(videoPath: videoPath);
}

class _VideoEkraniState extends State {
  final String videoPath;
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  _VideoEkraniState({required this.videoPath});

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(videoPath);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    _videoPlayerController.play();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamera'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio/1.6,
                    child: VideoPlayer(_videoPlayerController),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<DateTime>(
                stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final now = snapshot.data!;
                    return Column(
                      children: [
                        Text(
                          'Tarih: ${now.day}/${now.month}/${now.year}',
                          style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                        ),
                        Text('Saat: ${now.hour}:${now.minute}:${now.second}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      ],
                    );
                  } else {
                    return const Text('Yükleniyor...');
                  }
                },
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              width: 220,
              decoration: BoxDecoration(color: Colors.grey ,borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.fast_rewind),
                    onPressed: () {
                      final newPosition = _videoPlayerController.value.position - const Duration(seconds: 2);
                      _videoPlayerController.seekTo(newPosition);
                    },
                  ),

                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if (_videoPlayerController.value.isPlaying) {
                          _videoPlayerController.pause();
                        } else {
                          _videoPlayerController.play();
                        }
                      });
                    },
                    child: Icon(
                      _videoPlayerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop_circle_outlined),
                    onPressed: () {
                      _videoPlayerController.seekTo(Duration.zero); 
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
