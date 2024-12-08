// import 'package:flutter/material.dart';
// import 'package:sayyarti/constants.dart';

// class ForgotPassword extends StatelessWidget {
//   final Function? press;
//   const ForgotPassword({
//     Key? key,
//     required this.press,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         const Text(
//           "Forgot your password? ",
//           style: TextStyle(color: kPrimaryColor),
//         ),
//         GestureDetector(
//           onTap: press as void Function()?,
//           child: const Text(
//             "Reset",
//             style: TextStyle(
//               color: kPrimaryColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:sayyarti/constants.dart';
import 'package:sayyarti/Screens/resetpassword/resetpassword.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Forgot your password? ",
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ResetPasswordPage(
                  title: 'Reset Password', // Pass the title
                ),
              ),
            );
          },
          child: const Text(
            "Reset",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
