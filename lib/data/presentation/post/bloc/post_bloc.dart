import 'dart:io';

import 'package:carx/data/presentation/post/bloc/post_event.dart';
import 'package:carx/data/presentation/post/bloc/post_state.dart';
import 'package:carx/data/reponsitories/posts/posts_reponsitory.dart';
import 'package:carx/service/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final ImagePicker _picker = ImagePicker();
  final PostsReponsitory reponsitory;
  PostBloc(this.reponsitory) : super(PostState.initial()) {
    on<AddImageFromGallary>(
      (event, emit) async {
        final List<XFile> imageXFiles = await _picker.pickMultiImage();
        List<File> imageFiles = state.imageFiles;
        if (imageXFiles.isNotEmpty) {
          for (int i = 0; i < imageXFiles.length; i++) {
            imageFiles.addIf(imageFiles.length < 4, File(imageXFiles[i].path));
          }
          emit(state.copyWith(imageFiles: imageFiles));
        }
      },
    );
    on<AddPostEvent>(
      (event, emit) => _addPost(event, emit),
    );
  }

  void _addPost(AddPostEvent event, Emitter emit) async {
    emit(state.copyWith(status: PostStateStatus.loading));
    String? content = event.content;
    String uId = AuthService.firebase().currentUser!.id;
    final imageFiles = state.imageFiles;

    try {
      if (content != null && content.isNotEmpty) {
        int postId = await reponsitory.addPost(uId, content);
        for (File imageFile in imageFiles) {
          await reponsitory.addPostImage(postId, imageFile);
        }
        emit(state.copyWith(status: PostStateStatus.success, imageFiles: []));
      }
    } catch (e) {
      emit(state.copyWith(
          status: PostStateStatus.failure, textError: e.toString()));
    }
    emit(state.copyWith(status: PostStateStatus.initial));
  }
}
