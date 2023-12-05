import 'dart:io';

import 'package:carx/data/presentation/post/bloc/post_bloc.dart';
import 'package:carx/data/presentation/post/bloc/post_event.dart';
import 'package:carx/data/presentation/post/bloc/post_state.dart';
import 'package:carx/data/reponsitories/posts/posts_repository_impl.dart';
import 'package:carx/loading/loading.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostArticleScreen extends StatefulWidget {
  const PostArticleScreen({super.key});

  @override
  State<PostArticleScreen> createState() => _PostArticleScreenState();
}

class _PostArticleScreenState extends State<PostArticleScreen> {
  late final FocusNode _textFocusNode;
  late TextEditingController _textEditingController;
  @override
  void initState() {
    _textFocusNode = FocusNode();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(PostsReponsitoryImpl.response()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng Bài Post'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<PostBloc, PostState>(
              listener: (context, state) {
                if (state.status == PostStateStatus.loading) {
                  Loading().show(context: context);
                } else if (state.status == PostStateStatus.success) {
                  Loading().hide();
                } else if (state.status == PostStateStatus.failure) {
                  Loading().hide();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.textError ?? 'Error article'),
                  ));
                }else{
                   Loading().hide();
                }
              },
              builder: (context, state) {
                List<File> imageFiles = state.imageFiles;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Viết bài',
                      style: AppText.subtitle1,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textEditingController,
                      focusNode: _textFocusNode,
                      onChanged: (value) {
                       
                      },
                      autocorrect: false,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'Nội dung .....',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: AppColors.whiteSmoke,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLength: 1000,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 10,
                    ),
                    const Text(
                      'Chọn ảnh',
                      style: AppText.subtitle1,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        mainAxisExtent:
                            MediaQuery.of(context).size.width / 2 - 8.0,
                      ),
                      itemCount:
                          imageFiles.length < 4 ? imageFiles.length + 1 : 4,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == imageFiles.length &&
                            imageFiles.length < 4) {
                          return GestureDetector(
                            onTap: () {
                              _textFocusNode.unfocus();
                              context
                                  .read<PostBloc>()
                                  .add(AddImageFromGallary());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: AppColors.whiteSmoke),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 36,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Image.file(
                              imageFiles[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          _textFocusNode.unfocus();
                          context.read<PostBloc>().add(AddPostEvent(
                                content: _textEditingController.text,
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Đăng bài',
                          style: AppText.subtitle1
                              .copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
