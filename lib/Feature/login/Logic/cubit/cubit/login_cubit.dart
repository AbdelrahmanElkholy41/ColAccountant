// Feature/login/Logic/cubit/cubit/login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
      : emailController = TextEditingController(),
        passwordController = TextEditingController(),
        formKey = GlobalKey<FormState>(),
        super(LoginInitial());

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  final _supabase = Supabase.instance.client;

  Future<void> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text;


    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure('Please fill all fields'));
      return;
    }

    emit(LoginLoading());

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        emit(LoginSuccess(response.user!.id));
      } else {
        emit(LoginFailure("Login failed, please try again"));
      }
    } on AuthException catch (e) {

      emit(LoginFailure(e.message));
     
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
  Future<void> logout() async {
  try {
    await Supabase.instance.client.auth.signOut();
    emit(LoginInitial()); 
  } catch (e) {
    emit(LoginFailure('Logout failed: ${e.toString()}'));
  }
}


  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
