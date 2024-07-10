import 'package:carx/service/auth/auth_provider.dart';
import 'package:carx/service/auth/auth_user.dart';
import 'package:carx/service/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService({required this.provider});

  factory AuthService.firebase() =>
      AuthService(provider: FirebaseAuthProvider());

  @override
  Future<AuthUser> createUserWithEmail({
    required String email,
    required String password,
    required String name,
    required confirmPassword,
  }) =>
      provider.createUserWithEmail(
          email: email,
          password: password,
          name: name,
          confirmPassword: confirmPassword);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> loginWithEmail(
          {required String email, required String password}) =>
      provider.loginWithEmail(email: email, password: password);
  @override
  Future<AuthUser> loginWithPhone({required String phone}) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetWithEmail({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetWithPhone({required String phone}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> loginWithGoogle() => provider.loginWithGoogle();
}
