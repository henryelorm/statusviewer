import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:statusviewer/src/data/enums/custom_response.dart';
import 'package:statusviewer/src/data/repository/photo_repo.dart';
import 'package:statusviewer/src/data/repository/video_repo.dart';

class VideoBloc {
  final VideoRepository _videoRepository = VideoRepository();

  final _videoListController = BehaviorSubject<List>();
  final _statusController = BehaviorSubject<Response<String>>();

  Stream<List> get videoStream => _videoListController.stream;

  Stream<Response<String>> get statusStream => _statusController.stream;

  StreamSink<List> get parseVideoList => _videoListController.sink;

  StreamSink<Response<String>> get parseStatus => _statusController.sink;

  fetchVideos() {
    try {
      parseStatus.add(Response.loading('loading'));
      parseVideoList.add(_videoRepository.videoList());
      parseStatus.add(Response.completed('completed'));
    } catch (ex) {
      parseStatus.add(Response.error(ex.toString()));
    }
  }
}
