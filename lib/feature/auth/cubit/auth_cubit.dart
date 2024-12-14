import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthCubit(this._firebaseAuth) : super(AuthInitial());

  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthAuthorized(user: userCredential.user!));
    } catch (e) {
      emit(AuthUnauthorized(error: e.toString()));
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthAuthorized(user: userCredential.user!));
    } catch (e) {
      emit(AuthUnauthorized(error: e.toString()));
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    emit(AuthUnauthorized());
  }
}