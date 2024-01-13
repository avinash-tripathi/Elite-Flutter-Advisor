import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/models/admin/paymentmethod/printInvoice.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class FrmPdfPreview extends StatelessWidget {
  const FrmPdfPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth / 2,
      child: PdfPreview(
        maxPageWidth: 700,
        /* build: (format) => examples[_tab].builder(format, _data), */
        build: (format) =>
            generateInvoice(format, adminProvider.invoicetoprint),
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
        allowSharing: false,
        dynamicLayout: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }
}
