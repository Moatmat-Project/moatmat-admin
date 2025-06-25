import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Presentation/auth/view/on_boarding_v.dart';
import 'package:moatmat_admin/Presentation/auth/view/update_view.dart';

import '../../home/view/pages_holder_v.dart';
import '../state/auth_c/auth_cubit_cubit.dart';
import 'error_v.dart';
import 'sign_in_v.dart';
import 'sign_up_v.dart';
import 'start_auth.dart';

class AuthViewsManager extends StatefulWidget {
  const AuthViewsManager({super.key});

  @override
  State<AuthViewsManager> createState() => _AuthViewsManagerState();
}

class _AuthViewsManagerState extends State<AuthViewsManager> {
  @override
  void initState() {
    context.read<AuthCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthStartAuth) {
            return const StartAuthView();
          } else if (state is AuthSignIn) {
            return const SignInView();
          } else if (state is AuthSignUP) {
            return const SignUpView();
          } else if (state is AuthDone) {
            return const PagesHolderView();
          } else if (state is AuthError) {
            return ErrorView(error: state.error);
          } else if (state is AuthUpdate) {
            return UpdateView(updateInfo: state.updateInfo);
          }else if (state is AuthLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else {
            return const OnBoardingView();
          }
        },
      ),
    );
  }
}
