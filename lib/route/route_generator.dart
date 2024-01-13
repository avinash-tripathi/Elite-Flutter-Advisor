import 'package:advisorapp/adminforms/invoices.dart';
import 'package:advisorapp/adminforms/mysubscription.dart';
import 'package:advisorapp/adminforms/paymentmethods/formpaymentmethod.dart';
import 'package:advisorapp/checkout/checkoutwidget.dart';
import 'package:advisorapp/component/errorpage.dart';
import 'package:advisorapp/component/successpage.dart';
import 'package:advisorapp/custom/noDuplicatePageRoute.dart';
import 'package:advisorapp/forms/Login/login_screen.dart';

import 'package:advisorapp/forms/accountform/companyprofile.dart';
import 'package:advisorapp/forms/accountform/invitecoworker.dart';
import 'package:advisorapp/forms/accountform/lp.dart';
import 'package:advisorapp/forms/accountform/yourprofile.dart';
import 'package:advisorapp/forms/contracts/mycontracts.dart';

import 'package:advisorapp/forms/employer/employerforms.dart';
import 'package:advisorapp/forms/employer/sl_employerlaunchpack.dart';
import 'package:advisorapp/forms/ideas/ideas.dart';
import 'package:advisorapp/forms/invite/inviteother.dart';

import 'package:advisorapp/forms/partner/partner.dart';
import 'package:advisorapp/forms/resetpassword/resetpassword_screen.dart';

import 'package:flutter/material.dart';
import '../adminforms/htmlcontentwidget.dart';
import '../home/home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: prefer_typing_uninitialized_variables, unused_local_variable
    //
    var args;

    args = settings.arguments;
    MaterialPageRoute matPageRoute;

    switch (settings.name) {
      case '/':
        {
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const LoginScreen());
        }
        break;
      case '/Subscription':
        {
          matPageRoute = NoDuplicatePageRoute(
              builder: (_) => const MySubscription()); //HtmlContentWidget());
        }
        break;

      case '/Home':
        {
          //matPageRoute = MaterialPageRoute(builder: (_) => Home());
          matPageRoute = NoDuplicatePageRoute(builder: (_) => Home());
        }
        break;

      case '/ResetPassword':
        {
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const ResetPasswordScreen());
        }
        break;

      case '/Login':
        {
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const LoginScreen());
        }
        break;

      case '/empLaunchPack':
        {
          /*   matPageRoute = MaterialPageRoute(
              builder: (_) => EmployerLaunchPack(
                    selectedEmployer: args,
                  )); */
          matPageRoute = NoDuplicatePageRoute(
              builder: (_) => SLEmployerLaunchPack(
                    selectedEmployer: args,
                  ));
        }
        break;
      case '/companyProfile':
        {
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const CompanyProfile());
        }
        break;
      case '/yourProfile':
        {
          matPageRoute = NoDuplicatePageRoute(builder: (_) => YourProfile());
        }
        break;
      case '/addLaunchPack':
        {
          /*   matPageRoute =
              MaterialPageRoute(builder: (_) => const AddLaunchPack()); */
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const LaunchPackDetail());
        }
        break;
      case '/addOther':
        {
          //matPageRoute = MaterialPageRoute(builder: (_) => const AddOther());
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const InviteCoworker());
        }
        break;
      case '/invite':
        {
          //matPageRoute = MaterialPageRoute(builder: (_) => const InviteForm());
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const InviteOther());

          //InviteOther
        }
        break;

      /* case '/Screen':
        {
          matPageRoute = MaterialPageRoute(
              builder: (_) => const ScreenNavigator(
                    screens: [
                      CompanyProfile(),
                      YourProfile(),
                      AddLaunchPack(),
                      AddOther()
                    ],
                  ));
        }
        break; */
      case '/contracts':
        {
          matPageRoute = NoDuplicatePageRoute(builder: (_) => MyContracts());
        }
        break;
      case '/Partner':
        {
          matPageRoute = NoDuplicatePageRoute(builder: (_) => PartnerForm());
        }
        break;
      case '/Employer':
        {
          matPageRoute = NoDuplicatePageRoute(builder: (_) => EmployerForms());
        }
        break;
      case '/Ideas':
        {
          matPageRoute = NoDuplicatePageRoute(builder: (_) => const Ideas());
        }
        break;
      case '/Billing':
        {
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const FormPaymentMethod());
        }
        break;
      case '/Invoices':
        {
          matPageRoute =
              NoDuplicatePageRoute(builder: (_) => const FormInvoices());
        }
        break;

      case '/success':
        {
          matPageRoute = MaterialPageRoute(builder: (_) => const SuccessPage());
        }
        break;
      case '/cancel':
        {
          matPageRoute = MaterialPageRoute(builder: (_) => const CancelPage());
        }
        break;
      case '/session':
        {
          matPageRoute = MaterialPageRoute(
              builder: (_) => CheckOutWidget(
                    htmlContent: args,
                  ));
        }
        break;

      default:
        return _errorRoute();
    }
    return matPageRoute;
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          title: const Text("Blank Page"),
        ),
        body: const Center(
          child: Text("Blank Page"),
        ),
      );
    });
  }
}
