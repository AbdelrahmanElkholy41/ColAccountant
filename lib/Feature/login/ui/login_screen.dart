// Feature/login/ui/login_screen.dart
import 'package:cal/Feature/login/Logic/cubit/cubit/login_cubit.dart';
import 'package:cal/Feature/login/Logic/cubit/cubit/login_state.dart';
import 'package:cal/Feature/login/ui/widget/email_and_password.dart';
import 'package:cal/core/helpers/extensions.dart';
import 'package:cal/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_main_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, this.isAdmin = false});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: 150.w,
                    height: 150.h,
                  ),
                ],
              ),
              verticalSpace(20.h),
              SizedBox(
                width: 400.w,
                height: 600.h,
                child: Card(
                  elevation: 5,
                  borderOnForeground: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        EmailAndPassword(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot password?',
                              style: TextStyles.font13BlueRegular,
                            ),
                          ),
                        ),
                        verticalSpace(50.h),
                        BlocConsumer<LoginCubit, LoginState>(
                          listener: (context, state) {
                            if (state is LoginFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.errorMessage)),
                              );
                              Center(child: CircularProgressIndicator());
                            } else if (state is LoginSuccess) {
                              // لو نجاح تسجيل دخول أدمن، نفترض أنك تمرر isAdmin = true
                              context.pushNamed(
                                Routes.dashboardScreen,
                                arguments: {'isAdmin': true},
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return AppTextButton(
                              buttonText: 'Sign in as admin',
                              textStyle: TextStyles.font15DarkBlueMedium,
                              onPressed: () {
                                final cubit = context.read<LoginCubit>();
                                cubit.loginWithEmail();
                              },
                            );
                          },
                        ),
                        verticalSpace(50.h),
                        AppTextButton(
                          buttonText: 'Seller',
                          textStyle: TextStyles.font15DarkBlueMedium,
                          onPressed: () {
                            context.pushNamed(
                              Routes.homeScreen,
                              arguments: {'isAdmin': false}, // هنا نمرر false للبائع
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
