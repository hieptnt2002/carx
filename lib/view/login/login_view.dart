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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late bool _hiddenPassword;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    _hiddenPassword = true;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _passwordFocusNode.dispose();
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
          if (state is AuthStateLoggedIn) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.routeMain, (route) => false);
          } else if (state is AuthStateRegistering) {
            Navigator.pushNamed(context, Routes.routeRegister);
          } else if (state is AuthStateLoggedOut) {
            if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                  context: context, text: 'Email không hợp lệ*');
            } else if (state.exception
                is InvalidLoginCredentialsAuthException) {
              await showErrorDialog(
                  context: context, text: 'Thông tin đăng nhập không hợp lệ*');
            } else if (state.exception is MissingPasswordAuthException) {
              await showErrorDialog(context: context, text: 'Thiếu mật khẩu*');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context: context, text: 'Lỗi xác thực*');
            } else if (state.exception
                is UserCancelLoginWithGoogleAuthException) {
              await showErrorDialog(
                  context: context, text: 'Người dùng hủy đăng nhập*');
            }
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Đăng Nhập'),
          ),
          backgroundColor: const Color.fromARGB(255, 243, 243, 243),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo-dark.png',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width / 2,
                    height: 120,
                  ),
                  Text(
                    'ĐĂNG NHẬP',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppText.header.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    focusNode: _nameFocusNode,
                    controller: _emailController,
                    autocorrect: false,
                    cursorColor: Colors.black,
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
                        borderSide: BorderSide(width: 1, color: Colors.black54),
                      ),
                      prefixIconColor: Colors.grey,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    cursorColor: Colors.black,
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Quên mật khẩu',
                        style: TextStyle(color: AppColors.fontColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) * (2 / 3),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999))),
                      onPressed: () {
                        _nameFocusNode.unfocus();
                        _passwordFocusNode.unfocus();
                        context.read<AuthBloc>().add(
                              AuthEventLogIn(
                                  email: _emailController.text,
                                  password: _passwordController.text),
                            );
                      },
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'Hoặc tiếp tục với',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xffe0e3e7),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(999)),
                                side: BorderSide(
                                    width: 1, color: Color(0xffe0e3e7)),
                              )),
                          label: const Text(
                            'Facebook',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          icon: Image.asset(
                            'assets/images/facebook.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogInWithGoogle());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xffe0e3e7),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(999)),
                                side: BorderSide(
                                    width: 1, color: Color(0xffe0e3e7)),
                              )),
                          label: const Text(
                            'Google',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          icon: Image.asset(
                            'assets/images/google.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Bạn chưa có tài khoản?',
                        style:
                            TextStyle(fontSize: 16, color: AppColors.fontColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: TextButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventShouldRegister());
                          },
                          style: TextButton.styleFrom(
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.transparent),
                          child: Text(
                            'Đăng ký',
                            style: AppText.subtitle1.copyWith(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
