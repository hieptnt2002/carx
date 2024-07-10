// ignore_for_file: use_build_context_synchronously

import 'package:carx/loading/loading_screen.dart';
import 'package:carx/service/auth/firebase_auth_provider.dart';
import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:carx/view/login/bloc/auth_bloc.dart';
import 'package:carx/view/login/bloc/auth_event.dart';
import 'package:carx/view/login/bloc/auth_state.dart';

import 'package:carx/service/auth/auth_exceptions.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/dialog/error_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _confirmController;
  late bool _hiddenPassword;
  late bool _hiddenConfirmPassword;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  @override
  void initState() {
    _hiddenPassword = true;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _hiddenConfirmPassword = true;
    _nameController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _passwordFocusNode.dispose();

    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.isLoading) {
            LoadingScreen().show(
                context: context,
                text: state.loadingText ?? 'Xin vui lòng chờ trong giây lát!');
          } else if (!state.isLoading) {
            LoadingScreen().hide();
          }
          if (state is AuthStateLoggedOut) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.routeLogin, (route) => false);
          } else if (state is AuthStateRegistering) {
            if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                  context: context, text: 'Email không hợp lệ*');
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(
                  context: context, text: 'Email đã được sử dụng*');
            } else if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(context: context, text: 'Mật khẩu yếu*');
            } else if (state.exception is NotInputUserNameException) {
              await showErrorDialog(
                  context: context, text: 'Không có người dùng*');
            } else if (state.exception is PasswordIncorrectException) {
              await showErrorDialog(
                  context: context, text: 'Mật khẩu không chính xác');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context: context, text: 'Lỗi xác thực*');
            }
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: const Color.fromARGB(255, 243, 243, 243),
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                icon: const Icon(Icons.arrow_back)),
            title: const Text('Đăng ký'),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 48,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo-dark.png',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 120,
                    ),
                    const Text(
                      'TẠO TÀI KHOẢN',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Vui lòng nhập thông tin để tạo tài khoản',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      focusNode: _nameFocusNode,
                      controller: _nameController,
                      autocorrect: false,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        hintText: 'Tên người dùng',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black54),
                        ),
                        prefixIconColor: Colors.grey,
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      focusNode: _emailFocusNode,
                      controller: _emailController,
                      autocorrect: false,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        hintText: 'Email của bạn',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black54),
                        ),
                        prefixIconColor: Colors.grey,
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      cursorColor: Colors.grey,
                      obscureText: _hiddenPassword,
                      decoration: InputDecoration(
                          hintText: 'Mật khẩu',
                          prefixIcon: const Icon(Icons.lock_person_outlined),
                          semanticCounterText: 'Mật khẩu',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hiddenPassword = !_hiddenPassword;
                              });
                            },
                            icon: Icon(
                              _hiddenPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black54),
                          ),
                          prefixIconColor: Colors.grey,
                          suffixIconColor: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      focusNode: _confirmPasswordFocusNode,
                      controller: _confirmController,
                      cursorColor: Colors.grey,
                      obscureText: _hiddenConfirmPassword,
                      decoration: InputDecoration(
                          hintText: 'Xác nhận mật khẩu',
                          prefixIcon: const Icon(Icons.lock_person_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hiddenConfirmPassword =
                                    !_hiddenConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _hiddenConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black54),
                          ),
                          prefixIconColor: Colors.grey,
                          suffixIconColor: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width) * (2 / 3),
                      child: ElevatedButton(
                        onPressed: () {
                          _nameFocusNode.unfocus();
                          _emailFocusNode.unfocus();
                          _confirmPasswordFocusNode.unfocus();
                          _passwordFocusNode.unfocus();
                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text,
                                  confirmPassword: _confirmController.text,
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999))),
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bạn đã có tài khoản?',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthEventLogOut());
                            },
                            child: Text(
                              'Đăng nhập',
                              style: AppText.subtitle1.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline),
                            ))
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Stream<bool> showPassword(bool s) {
    return Stream.value(s);
  }
}
