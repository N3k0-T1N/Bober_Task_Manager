import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthorized extends AuthState {
  final User user;
  
  AuthAuthorized({required this.user});
}

class AuthUnauthorized extends AuthState {
  final String? error;
  
  AuthUnauthorized({this.error});
}