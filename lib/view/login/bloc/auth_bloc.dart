import 'package:bloc/bloc.dart';
import 'package:carx/view/login/bloc/auth_event.dart';
import 'package:carx/view/login/bloc/auth_state.dart';
import 'package:carx/service/auth/auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateUnitialized(isLoading: true),
        ) {
    on<AuthEventInitalize>(
      (event, emit) async {
        // await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      },
    );

    on<AuthEventLogInWithGoogle>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Vui lòng đợi trong khi đăng nhập',
          ),
        );
        try {
          await provider.loginWithGoogle();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: provider.currentUser, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );

    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Vui lòng đợi trong khi đăng nhập',
          ),
        );

        final email = event.email;
        final password = event.password;

        try {
          final user = await provider.loginWithEmail(
            email: email,
            password: password,
          );
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(
          const AuthStateRegistering(exception: null, isLoading: false),
        );
      },
    );

    on<AuthEventRegister>(
      (event, emit) async {
        emit(const AuthStateRegistering(
            exception: null,
            isLoading: true,
            loadingText: 'Vui lòng đợi trong khi tạo tài khoản'));
        final email = event.email;
        final password = event.password;
        final name = event.name;
        final confirmPassword = event.confirmPassword;
        try {
          await provider.createUserWithEmail(
            email: email,
            password: password,
            name: name,
            confirmPassword: confirmPassword,
          );
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );

    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
  }
}
