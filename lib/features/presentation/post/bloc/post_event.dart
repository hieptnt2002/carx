abstract class PostEvent {}

class AddImageFromGallary extends PostEvent {
  AddImageFromGallary();
}

class AddPostEvent extends PostEvent {
  final String? content;
  AddPostEvent({this.content});
}
