import 'package:carx/bloc/auth/auth_bloc.dart';
import 'package:carx/bloc/auth/auth_event.dart';
import 'package:carx/bloc/auth/auth_state.dart';

import 'package:carx/service/auth/auth_exceptions.dart';
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

    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
                context: context, text: 'Invalid Email Auth Exception');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context: context, text: 'Email Already In Use Auth Exception');
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
                context: context, text: 'WeakPasswordAuthException');
          } else if (state.exception is NotInputUserNameException) {
            await showErrorDialog(context: context, text: 'No Input User');
          } else if (state.exception is PasswordIncorrectException) {
            await showErrorDialog(
                context: context, text: 'PasswordIncorrectException');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context: context, text: 'Error');
          }
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Register'),
        ),
        backgroundColor: Color(0xffe5e5e5),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                      width: (MediaQuery.of(context).size.width) / 2,
                      child: Image.asset(
                        'assets/images/xcar-195x195-black.png',
                        fit: BoxFit.contain,
                      )),
                  const Text(
                    'Register Your Account',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    autocorrect: false,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      hintText: 'Name',
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
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    autocorrect: false,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      hintText: 'Email',
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
                      prefixIcon: const Icon(Icons.email_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    cursorColor: Colors.grey,
                    obscureText: _hiddenPassword,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_person_outlined),
                        semanticCounterText: 'Password',
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
                  TextField(
                    controller: _confirmController,
                    cursorColor: Colors.grey,
                    obscureText: _hiddenConfirmPassword,
                    decoration: InputDecoration(
                        hintText: 'Confirm password',
                        prefixIcon: const Icon(Icons.lock_person_outlined),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hiddenConfirmPassword = !_hiddenConfirmPassword;
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              AuthEventRegister(
                                email: _emailController.text,
                                password: _passwordController.text,
                                name: _nameController.text,
                                confirmPassword: _confirmController.text,
                              ),
                            );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You have an account',
                      ),
                      TextButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          },
                          child: const Text(
                            'Login',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
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
    );
  }

  Stream<bool> showPassword(bool s) {
    return Stream.value(s);
  }
}