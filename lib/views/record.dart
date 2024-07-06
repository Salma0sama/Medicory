import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/flutter_sound.dart' as flutter_sound;
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:just_audio/just_audio.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordAudio extends StatelessWidget {
  const RecordAudio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
  void onDelete() {}
}

class _MyWidgetState extends State<MyWidget> {
  final recorder = flutter_sound.FlutterSoundRecorder();
  bool isRecorderReady = false;
  String? audioFilePath;
  Duration timerDuration = Duration.zero;
  bool isRecording = false;
  StreamSubscription? _recordingDispositionSubscription;
  bool hasRecordedAudio =
      false; // State variable to track if there's recorded audio

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );

    _recordingDispositionSubscription =
        recorder.onProgress?.listen((flutter_sound.RecordingDisposition disp) {
      setState(() {
        timerDuration = disp.duration ?? Duration.zero;
      });
    });

    // Check if there are any recorded audio files
    await checkRecordedAudio();
  }

  Future<void> _deleteAudioFile(String filePath) async {
    final recordId =
        int.parse(filePath.split('/').last); // Extract record ID from file path
    final url = Uri.parse(
        'http://localhost:8081/pharmacy/prescriptions/1CDAA42EA626493F/medications/1/records/$recordId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Audio record deleted successfully');
        void _showSnackBar({
          required String title,
          required String message,
          required ContentType contentType,
        }) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: title,
              message: message,
              contentType: contentType,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }

        _showSnackBar(
          title: 'Success',
          message: 'Audio deleted successfully',
          contentType: ContentType.success,
        );
        widget.onDelete(); // Notify parent widget to update UI
      } else {
        print('Failed to delete audio record: ${response.statusCode}');
        final responseBody = response.body;
        print('Response body: $responseBody');
      }
    } catch (error) {
      print('Error deleting audio record: $error');
    }
  }

  Future<void> checkRecordedAudio() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8081/pharmacy/prescriptions/1CDAA42EA626493F/medications/1/records'));

      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          hasRecordedAudio = responseBody.isNotEmpty;
        });
      } else {
        print('Failed to fetch recorded audio: ${response.statusCode}');
        setState(() {
          hasRecordedAudio = false;
        });
      }
    } catch (error) {
      print('Error fetching recorded audio: $error');
      setState(() {
        hasRecordedAudio = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    _recordingDispositionSubscription?.cancel();
    recorder.closeRecorder();
    super.dispose();
  }

  Future record() async {
    if (!isRecorderReady) return;
    if (isRecording)
      return; // Prevent starting a new recording if already recording
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/audio.aac';
    try {
      await recorder.startRecorder(toFile: path);
      setState(() {
        audioFilePath = path;
        isRecording = true;
      });
    } catch (e) {
      print('Failed to start recording: $e');
    }
  }

  Future stop() async {
    if (!isRecorderReady) return;
    if (!isRecording) return; // Prevent stopping if not recording
    await recorder.stopRecorder();
    setState(() {
      isRecording = false;
    });
  }

  Future<void> uploadAudio() async {
    if (audioFilePath == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "http://10.0.2.2:8081/pharmacy/prescriptions/1CDAA42EA626493F/medications/1"),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', audioFilePath!),
    );

    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      print("Audio uploaded successfully");
      void _showSnackBar({
        required String title,
        required String message,
        required ContentType contentType,
      }) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }

      _showSnackBar(
        title: 'Success',
        message: 'Audio uploaded successfully',
        contentType: ContentType.success,
      );

      final prefs = await SharedPreferences.getInstance();
      List<String>? audioFiles = prefs.getStringList('audioFiles');
      if (audioFiles == null) {
        audioFiles = [];
      }
      audioFiles.add(audioFilePath!);
      await prefs.setStringList('audioFiles', audioFiles);

      setState(() {
        audioFilePath = null;
        timerDuration = Duration.zero;
        isRecording = false;
        hasRecordedAudio = true;
      });
    } else {
      print("Failed to upload audio: ${response.statusCode}");
      final responseBody = await response.stream.bytesToString();
      print("Response body: $responseBody");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Audio Recorder",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${timerDuration.inMinutes.toString().padLeft(2, '0')}:${(timerDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (isRecording) {
                          await stop();
                          await uploadAudio();
                        } else {
                          await record();
                        }
                        setState(() {});
                      },
                      child: Icon(isRecording ? Icons.stop : Icons.mic),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    if (isRecording)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                          foregroundColor: Colors.white, // Text color
                        ),
                        onPressed: deleteAudio,
                        child: Icon(
                          Icons.delete,
                        ),
                      ),
                  ],
                ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (hasRecordedAudio)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyWidgett(),
                  ),
                );
              },
              child: const Text('Recorded Audio'),
            ),
        ],
      ),
    );
  }

  Future<void> deleteAudio() async {
    if (isRecording) {
      await stop(); // Stop recording if currently recording
    }
    if (audioFilePath != null) {
      final file = File(audioFilePath!);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          audioFilePath = null;
          timerDuration = Duration.zero;
          isRecording = false;
          hasRecordedAudio = false; // Assume no recorded audio after deletion
        });
      }
    }
  }
}

class MyWidgett extends StatefulWidget {
  const MyWidgett({Key? key}) : super(key: key);

  @override
  State<MyWidgett> createState() => _MyWidgettState();
}

class _MyWidgettState extends State<MyWidgett> {
  List<String> audioFiles = [];

  @override
  void initState() {
    super.initState();
    loadAudioFiles();
  }

  Future<void> loadAudioFiles() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      audioFiles = prefs.getStringList('audioFiles') ?? [];
    });
  }

  void addAudioFile(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    audioFiles.add(filePath);
    await prefs.setStringList('audioFiles', audioFiles);
    setState(() {});
  }

  void deleteAudioFile(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      audioFiles.remove(filePath);
    });
    await prefs.setStringList('audioFiles', audioFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Prescriptions List",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 45,
          ),
          CircleAvatar(
            radius: 90,
            backgroundColor: kPrimaryColor,
            child: CircleAvatar(
              radius: 89,
              backgroundImage: AssetImage("lib/images/medicory2.jpg"),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "MEDICORY",
                style: TextStyle(
                  fontFamily: "Pacifico",
                  color: kPrimaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: audioFiles.length,
              itemBuilder: (context, index) {
                return AudioPlayerWidget(
                  filePath: audioFiles[index],
                  onDelete: () {
                    deleteAudioFile(audioFiles[index]); // Update UI on delete
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;
  final VoidCallback onDelete;

  const AudioPlayerWidget({
    Key? key,
    required this.filePath,
    required this.onDelete,
  }) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late just_audio.AudioPlayer _player;
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  @override
  void initState() {
    super.initState();
    _player = just_audio.AudioPlayer();
    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    await _player.setFilePath(widget.filePath);
    _duration = await _player.duration ?? Duration.zero;

    _positionSubscription = _player.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _durationSubscription = _player.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.ready && state.playing) {
        setState(() {
          _isPlaying = true;
          _isPaused = false;
        });
      } else if (state.processingState == ProcessingState.ready &&
          !state.playing) {
        setState(() {
          _isPlaying = false;
          _isPaused = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _deleteAudioFile(String filePath) async {
    // final recordId =
    //     int.parse(filePath.split('/').last); // Extract record ID from file path
    // final url = Uri.parse(
    //     'http://localhost:8081/pharmacy/prescriptions/1CDAA42EA626493F/medications/1/records/$recordId');

    try {
      // final response = await http.delete(url);

      if (true) {
        print('Audio record deleted successfully');
        void _showSnackBar({
          required String title,
          required String message,
          required ContentType contentType,
        }) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: title,
              message: message,
              contentType: contentType,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }

        _showSnackBar(
          title: 'Success',
          message: 'Audio deleted successfully',
          contentType: ContentType.success,
        );
        widget.onDelete(); // Notify parent widget to update UI
      }
    } catch (error) {
      print('Error deleting audio record: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.filePath.split('/').last),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              var position = snapshot.data ?? Duration.zero;
              var maxDuration = _duration.inSeconds.toDouble();
              var currentValue = position.inSeconds.toDouble();
              return Slider(
                value: currentValue,
                min: 0,
                max: maxDuration,
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await _player.seek(position);
                },
              );
            },
          ),
          Text(
              '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')} / ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            icon: _isPlaying
                ? (_isPaused ? Icon(Icons.play_arrow) : Icon(Icons.pause))
                : Icon(Icons.play_arrow),
            onPressed: _playPause,
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () => _deleteAudioFile(widget.filePath),
          ),
        ],
      ),
    );
  }
}
