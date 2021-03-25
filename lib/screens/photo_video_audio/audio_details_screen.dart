import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

// const kUrl =
//     "https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3";
class AudioDetailScreen extends StatefulWidget {
  @override
  _AudioDetailScreenState createState() => _AudioDetailScreenState();
}

class _AudioDetailScreenState extends State<AudioDetailScreen> {
  BuildContext _ctx;
  bool _isdataLoading = true;
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  String AudioUrl;
  String Title,url;

  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _onload();
      initAudioPlayer();
    });
  }

  // _onload(){
  //   setState(() {
  //     _ctx = context;
  //     final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
  //     if (arguments != null) {
  //
  //       _isdataLoading = false;
  //     }
  //   });
  // }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(url);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        Title = arguments['Title'];
        AudioUrl = arguments['AudioUrl'];
        url = RestDatasource.AUDIO_URL + AudioUrl;
        _isdataLoading = false;
      }
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(Title),
        ),
        body: (_isdataLoading)
               ?  new Center(
                  child: CircularProgressIndicator(),
                  )
               :
                 Card(
                elevation: 8.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(child: _buildPlayer()),
                  ],
                ),
              ),
      );
    }
  }

  Widget _buildPlayer() => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  IconButton(
                    onPressed: isPlaying ? () => pause() : () => play(),
                    iconSize: 64.0,
                    icon: isPlaying
                      ? Icon(
                          Icons.pause,
                          color: Theme.of(context).primaryColor,
                        )
                      : Icon(
                          Icons.play_arrow,
                          color: Theme.of(context).primaryColor,
                        ),
                   ),
                // IconButton(
                //   onPressed: isPlaying ? () => pause() : null,
                //   iconSize: 64.0,
                //   icon: Icon(Icons.pause),
                //   color: Colors.cyan,
                // ),
                IconButton(
                  onPressed: isPlaying || isPaused ? () => stop() : null,
                  iconSize: 64.0,
                  icon: Icon(
                    Icons.stop,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ]),
            ),
            if (duration != null)
              Slider(
                value: position?.inMilliseconds?.toDouble() ?? 0.0,
                onChanged: (double value) {
                  return audioPlayer.seek((value / 1000).roundToDouble());
                      },
                min: 0.0,
                max: duration.inMilliseconds.toDouble(),
              ),
            if (position != null) _buildMuteButtons(),
            if (position != null) _buildProgressView(),
          ],
        ),
      );

  Row _buildProgressView() => Row(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator(
            value: position != null && position.inMilliseconds > 0
                ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
                    (duration?.inMilliseconds?.toDouble() ?? 0.0)
                : 0.0,
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).primaryColor,
            ),
            backgroundColor: Colors.grey.shade400,
          ),
        ),
        Text(
          position != null
              ? "${positionText ?? ''} / ${durationText ?? ''}"
              : duration != null
                  ? durationText
                  : '',
          style: TextStyle(fontSize: 24.0),
        ),
      ]);

  Row _buildMuteButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (!isMuted)
          FlatButton.icon(
            onPressed: () => mute(true),
            icon: Icon(
              Icons.headset_off,
              color: Theme.of(context).primaryColor,
            ),
            label: Text('Mute',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
            ),
          ),
        if (isMuted)
          FlatButton.icon(
            onPressed: () => mute(false),
            icon: Icon(
              Icons.headset,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Unmute',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
