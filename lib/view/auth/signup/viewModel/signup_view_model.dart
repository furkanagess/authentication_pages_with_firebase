// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../core/base/model/base_view_model.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../core/init/lang/locale_keys.g.dart';

part 'signup_view_model.g.dart';

class SignUpViewModel = _SignUpViewModelBase with _$SignUpViewModel;

abstract class _SignUpViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => viewModelContext = context;

  @override
  void init() {}
  void navigateToLogin() {
    navigation.navigateToPage(path: NavigationConstants.LOGIN_VIEW);
  }

  @observable
  bool isLockOpen = false;
  @action
  void isLockChange() {
    isLockOpen = !isLockOpen;
  }

  void showError(BuildContext context, {required String text, required String title}) {
    QuickAlert.show(
      type: QuickAlertType.error,
      context: context,
      text: text,
      title: title,
      backgroundColor: context.colors.background,
      textColor: context.colors.secondary,
      titleColor: context.colors.secondary,
      confirmBtnColor: context.colors.onSecondary,
    );
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException {
      showError(viewModelContext, text: LocaleKeys.alert_validMP.locale, title: LocaleKeys.alert_wrongMP.locale);
    }
  }
}
