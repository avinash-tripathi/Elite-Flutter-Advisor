import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FormInvoice extends StatelessWidget {
  const FormInvoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(builder: (context, prvAdmin, child) {
      return DataTable(
          columnSpacing: 8.0,
          columns: [
            DataColumn(
              label: SizedBox(
                width: SizeConfig.screenWidth / 12,
                child: const Center(child: Text('Invoice Date')),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: SizeConfig.screenWidth / 12,
                child: const Center(child: Text('Total Users')),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: SizeConfig.screenWidth / 10,
                child: const Center(child: Text('Fees/user/month')),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: SizeConfig.screenWidth / 8,
                child: const Center(
                  child: Text('Total subscription fees'),
                ),
              ),
            ),
            /*  DataColumn(
              label: SizedBox(
                width: SizeConfig.screenWidth / 10,
                child: const Center(child: Text('Recharge by')),
              ),
            ), */
            DataColumn(
              label: SizedBox(
                width: SizeConfig.screenWidth / 10,
                child: const Center(child: Text('Invoice')),
              ),
            ),
          ],
          rows: List.generate(
            prvAdmin.invoices.length,
            (index) => DataRow(cells: [
              DataCell(Center(
                child: Text(
                  prvAdmin.invoices[index].paidon,
                ),
              )),
              DataCell(Center(
                child: Text(
                  prvAdmin.invoices[index].total,
                ),
              )),
              DataCell(Center(
                child: Text("\$${prvAdmin.invoices[index].peruserlicensefee}"),
              )),
              DataCell(
                Center(child: Text("\$${prvAdmin.invoices[index].totalfees}")),
              ),
              /*  DataCell(
                Center(
                  child:
                      Text(prvAdmin.invoices[index].createdbydata!.accountname),
                ),
              ), */
              DataCell(
                Center(
                  child: IconButton(
                    onPressed: () {
                      prvAdmin.clickedTodownload = !prvAdmin.clickedTodownload;
                      prvAdmin.invoicetoprint = prvAdmin.invoices[index];
                    },
                    icon: const Icon(
                      FontAwesomeIcons.filePdf,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
            ]),
          ));
    });
  }
}
