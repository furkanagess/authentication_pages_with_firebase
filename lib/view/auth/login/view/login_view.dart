// ignore_for_file: sort_child_properties_last

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../core/constants/svg/svg_constants.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../core/init/lang/locale_keys.g.dart';
import '../viewModel/login_view_model.dart';

class LoginView extends StatelessWidget {
  final VoidCallback onClickedSignUp;
  const LoginView({super.key, required this.onClickedSignUp});

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      onModelReady: (model) {
        model.setContext(context);
      },
      onPageBuilder: (BuildContext context, LoginViewModel viewModel) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: context.paddingNormal,
          child: Column(
            children: [
              const Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 5,
                child: buildSVG(),
              ),
              Expanded(
                flex: 2,
                child: buildMailTextField(context, viewModel),
              ),
              Expanded(
                flex: 2,
                child: buildPasswordTextField(context, viewModel),
              ),
              Expanded(
                flex: 2,
                child: loginButton(context, viewModel),
              ),
              Expanded(
                flex: 1,
                child: forgotText(context, viewModel),
              ),
              Expanded(
                flex: 1,
                child: signupRow(context, viewModel),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Row signupRow(BuildContext context, LoginViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Spacer(),
        RichText(
          text: TextSpan(
            text: LocaleKeys.login_noAccount.locale,
            style: context.textTheme.bodyText2,
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = onClickedSignUp,
                text: LocaleKeys.login_signup.locale,
                style: context.textTheme.bodyText2?.copyWith(
                  color: context.colors.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget forgotText(BuildContext context, LoginViewModel viewModel) {
    return GestureDetector(
      child: Text(
        LocaleKeys.login_forgot.locale,
        style: context.textTheme.bodyText2?.copyWith(
          color: context.colors.onSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => viewModel.navigateToPassword(),
    );
  }

  Padding loginButton(BuildContext context, LoginViewModel viewModel) {
    return Padding(
      padding: context.paddingNormal,
      child: ElevatedButton(
        onPressed: () {
          viewModel.signIn();
        },
        child: Center(
          child: Text(
            LocaleKeys.login_login.locale,
            style: context.textTheme.headline6?.copyWith(
              color: context.colors.background,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: context.paddingLow,
          shape: const StadiumBorder(),
          backgroundColor: context.colors.onSecondary,
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context, LoginViewModel viewModel) {
    return Observer(builder: (_) {
      return TextFormField(
        validator: (password) => password != null && password.length < 6 ? LocaleKeys.valid_password.locale : null,
        controller: viewModel.passwordController,
        cursorColor: context.colors.onSecondary,
        obscureText: viewModel.isLockOpen,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () {
              viewModel.isLockChange();
            },
            child: Observer(
              builder: (_) {
                return Icon(
                  viewModel.isLockOpen ? Icons.visibility_off : Icons.visibility,
                  color: context.iconTheme.color,
                );
              },
            ),
          ),
          labelText: LocaleKeys.login_password.locale,
          icon: Icon(
            Icons.lock_outline_rounded,
            size: 30,
            color: context.colors.onSecondary,
          ),
        ),
      );
    });
  }

  TextFormField buildMailTextField(BuildContext context, LoginViewModel viewModel) {
    return TextFormField(
      validator: (email) => email != null && email.contains("@") ? null : LocaleKeys.valid_mail.locale,
      controller: viewModel.emailController,
      cursorColor: context.colors.onSecondary,
      decoration: InputDecoration(
        focusColor: context.colors.onSecondary,
        labelText: LocaleKeys.login_mail.locale,
        icon: Icon(
          Icons.mail_outline,
          size: 30,
          color: context.colors.onSecondary,
        ),
      ),
    );
  }

  SvgPicture buildSVG() => SvgPicture.asset(SVGConstants.instance.welcome);
}
