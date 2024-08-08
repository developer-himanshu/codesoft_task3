// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isShuffling = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _currentIndex = 0;
  Random _random = Random();

  List<String> _playlist = [
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });


    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _playNext();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playNext() {
    setState(() {
      if (_isShuffling) {
        _currentIndex = _random.nextInt(_playlist.length);
      } else {
        _currentIndex = (_currentIndex + 1) % _playlist.length;
      }
      _audioPlayer.play(UrlSource(_playlist[_currentIndex]));
    });
  }

  void _playPrevious() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % _playlist.length;
      _audioPlayer.play(UrlSource(_playlist[_currentIndex]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Center(child: Text('Music Player', style: TextStyle(fontWeight: FontWeight.bold),)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Track Title' ,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 16.0),
          Slider(
            value: _position.inSeconds.toDouble(),
            min: 0.0,
            max: _duration.inSeconds.toDouble(),
            onChanged: (double value) {
              setState(() {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: _playPrevious,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (_isPlaying) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play(UrlSource(_playlist[_currentIndex]));
                  }
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: _playNext,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_position.toString().split('.').first),
              Text(' / '),
              Text(_duration.toString().split('.').first),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Shuffle', style: TextStyle(fontWeight: FontWeight.bold)),
              Switch(
                value: _isShuffling,
                onChanged: (bool value) {
                  setState(() {
                    _isShuffling = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
