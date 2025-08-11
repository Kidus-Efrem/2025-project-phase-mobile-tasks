import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_authenticated_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final IsAuthenticatedUseCase isAuthenticatedUseCase;

  AuthBloc({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.isAuthenticatedUseCase,
  }) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signUpUseCase(SignUpParams(
      email: event.email,
      password: event.password,
      name: event.name,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signInUseCase(SignInParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    print('🚀 AuthBloc - _onSignOut called');
    emit(AuthLoading());

    try {
      print('🚀 AuthBloc - Calling signOutUseCase...');
      final result = await signOutUseCase(NoParams());

      result.fold(
        (failure) {
          print('❌ AuthBloc - Sign out failed: ${failure.toString()}');
          emit(AuthError(failure.toString()));
        },
        (_) {
          print('✅ AuthBloc - Sign out successful, emitting Unauthenticated');
          emit(Unauthenticated());
        },
      );
    } catch (e) {
      print('❌ AuthBloc - Exception in sign out: $e');
      emit(AuthError('Exception during sign out: $e'));
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await isAuthenticatedUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (isAuthenticated) {
        if (isAuthenticated) {
          add(GetCurrentUserEvent());
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onGetCurrentUser(GetCurrentUserEvent event, Emitter<AuthState> emit) async {
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }
}
