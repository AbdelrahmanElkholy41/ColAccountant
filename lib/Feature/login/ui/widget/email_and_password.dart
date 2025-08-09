// Feature/login/ui/widget/email_and_password.dart
import 'package:cal/Feature/login/Logic/cubit/cubit/login_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/coutom_text_field.dart';

class EmailAndPassword extends StatelessWidget {
  const EmailAndPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          verticalSpace(50.h),
          CustomTextField2(
            controller: cubit.emailController,
            hintText: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          verticalSpace(50.h),
          CustomTextField2(
            controller: cubit.passwordController,
            hintText: 'Password',
            isObscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
