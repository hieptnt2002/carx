import 'dart:io';

enum PostStateStatus { initial, loading, success, failure }

class PostState {
  final List<File> imageFiles;
  final String? textError;
  final PostStateStatus status;
  const PostState({
    required this.imageFiles,
    required this.textError,
    required this.status,
  });
  PostState.initial()
      : imageFiles = [],
        textError = null,
        status = PostStateStatus.initial;
  PostState copyWith({
    List<File>? imageFiles,
    String? textError,
    PostStateStatus? status,
  }) =>
      PostState(
        imageFiles: imageFiles ?? this.imageFiles,
        textError: textError ?? this.textError,
        status: status ?? this.status,
      );
}
