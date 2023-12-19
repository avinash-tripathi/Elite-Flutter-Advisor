import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:advisorapp/service/stripeservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionForm extends StatelessWidget {
  const SubscriptionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final prvAdmin = Provider.of<AdminProvider>(context, listen: false);

    return SizedBox(
      width: SizeConfig.screenWidth / 2,
      height: SizeConfig.screenHeight / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Consumer<AdminProvider>(builder: (context, prvSelect, child) {
                  return DataTable(columnSpacing: 15, columns: [
                    DataColumn(
                        label: SizedBox(
                      width: SizeConfig.screenWidth / 20,
                      child: const Text('Select'),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: SizeConfig.screenWidth / 10,
                      child: const Text('Subscription'),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: SizeConfig.screenWidth / 10,
                      child: const Text('Price'),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: SizeConfig.screenWidth / 10,
                      child: const Text('Period'),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: SizeConfig.screenWidth / 10,
                      child: const Text('Purchase'),
                    )),
                  ], rows: [
                    for (var i = 0; i < prvAdmin.subscriptions.length; i++)
                      DataRow.byIndex(index: i, cells: [
                        DataCell(Checkbox(
                          value: prvSelect.isSubscriptionSelected(i),
                          onChanged: (bool? value) {
                            prvAdmin.selectedSubscription(i, value!);
                          },
                        )),
                        DataCell(
                          Text(
                            prvAdmin.subscriptions[i].subscriptionname,
                            style: appstyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            prvAdmin.subscriptions[i].price.toString(),
                            style: appstyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            prvAdmin.subscriptions[i].period.toString() +
                                prvAdmin.subscriptions[i].periodunit.toString(),
                            style: appstyle,
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            style: buttonStyleBlue,
                            onPressed: () async => {
                              await StripeService()
                                  .createCheckOutSession('Atr3434', '', '')
                            },
                            child: const Text('Purchase'),
                          ),
                        ),
                      ])
                  ]);
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          prvAdmin.initSubscription = false;
                        },
                        style: buttonStyleBlue,
                        child: const Text('Close'),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /*  displayPaymentSheet(context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  } */
}
