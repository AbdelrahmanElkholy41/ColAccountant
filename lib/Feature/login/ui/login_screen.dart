import 'package:cal/Feature/login/ui/widget/email_and_password.dart';
import 'package:cal/core/helpers/extensions.dart';
import 'package:cal/core/helpers/spacing.dart';
import 'package:cal/core/widgets/coutom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_main_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              verticalSpace(50.h),
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
                            onPressed: () {

                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyles.font13BlueRegular,
                            ),
                          ),
                        ),
                        verticalSpace(50.h),
                        AppTextButton(
                          buttonText: 'Sign in as admin',
                          textStyle: TextStyles.font15DarkBlueMedium,
                          onPressed: () {

                          },
                        ),
                        verticalSpace(50.h),

                            AppTextButton(
                              buttonText: 'Seller',
                              textStyle: TextStyles.font15DarkBlueMedium,
                              onPressed: () {
                                context.pushNamed(Routes.homeScreen);
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
