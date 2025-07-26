import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/coutom_text_field.dart';

class EmailAndPassword extends StatelessWidget {
  const EmailAndPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(50.h),
        CustomTextField2(
          hintText: 'Email',
          validator: (value) {},
        ),
        verticalSpace(50.h),
        CustomTextField2(
          hintText: 'Password',
          validator: (value) {},
        ),

      ],
    );
  }
}
