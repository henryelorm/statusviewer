import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:statusviewer/src/data/enums/custom_response.dart';
import 'package:statusviewer/src/data/repository/photo_repo.dart';

class PhotoBloc {
  final PhotoRepository _photoRepository = PhotoRepository();

  final _photoListController = BehaviorSubject<List>();
  final _statusController = BehaviorSubject<Response<String>>();

  Stream<List> get photoStream => _photoListController.stream;

  Stream<Response<String>> get statusStream => _statusController.stream;

  StreamSink<List> get parsePhotoList => _photoListController.sink;

  StreamSink<Response<String>> get parseStatus => _statusController.sink;

  fetchPhotos() {
    try {
      parseStatus.add(Response.loading('loading'));
      parsePhotoList.add(_photoRepository.imageList());
      parseStatus.add(Response.completed('completed'));
    } catch (ex) {
      parseStatus.add(Response.error(ex.toString()));
    }
  }
}
