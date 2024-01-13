import 'dart:typed_data';
import 'package:advisorapp/models/admin/paymentmethod/invoice.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' as fw;

Future<Uint8List> generateInvoice(
    PdfPageFormat pageFormat, Invoice invoices) async {
  final invoicetoprint = invoices;

  final invoice = PrintInvoice(
    invoiceNumber: '',
    invoicetoprint: invoicetoprint,
    customerName: invoicetoprint.createdbydata!.accountname,
    customerAddress:
        '${invoicetoprint.createdbydata!.companyname}\n${invoicetoprint.createdbydata!.companyaddress}',
    paymentInfo: '',
    tax: 0,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat);
}

class PrintInvoice {
  PrintInvoice({
    required this.invoicetoprint,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final Invoice invoicetoprint;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  /* double get _total => invoicetoprint
      .map<double>((p) => double.parse(p.total))
      .reduce((a, b) => a + b); */
  double get _total => double.parse(invoicetoprint.total);

  double get _grandTotal => _total * (1 + tax);

  String? _logo;

  String? _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = Document();

    _logo = await rootBundle.loadString('assets/ALICORNCyan.svg');
    _bgShape =
        await rootBundle.loadString('assets/AdvisorLogo_Transparent.svg');

    // Add page to the PDF
    doc.addPage(
      MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          Divider(color: PdfColors.white),
          _contentTable(context),
          SizedBox(height: 20),
          _contentFooter(context),
          SizedBox(height: 20),
          //_termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  Widget _buildHeader(Context context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    height: 110,
                    padding: const EdgeInsets.only(top: 10),
                    child: _logo != null ? SvgImage(svg: _logo!) : PdfLogo(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(bottom: 8, left: 30),
                    alignment: Alignment.topRight,
                    child: Text(
                      'INVOICE',
                      style: TextStyle(
                        //color: baseColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.topRight,
                    height: 90,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      child: buildAlicornAddressInfo(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(color: accentColor),
        if (context.pageNumber > 1) SizedBox(height: 10)
      ],
    );
  }

  static Widget buildBillToInfo(Invoice info) {
    final invoiceTitles = <String>['Invoice Number:', 'Invoice Date: '];
    final invoiceData = <String>[info.invoicenumber, info.paidon];

    final titles = <String>[
      'BILL TO',
      info.createdbydata!.companyname,
      '${info.createdbydata!.accountname} ${info.createdbydata!.lastname}',
      info.createdbydata!.companyaddress,
      ' ',
      info.createdbydata!.workemail,
    ];
    final titleStyles = <TextStyle>[
      TextStyle(fontWeight: FontWeight.bold, color: PdfColors.grey700),
      TextStyle(fontWeight: FontWeight.bold),
      TextStyle(fontWeight: FontWeight.normal),
      TextStyle(fontWeight: FontWeight.normal),
      TextStyle(fontWeight: FontWeight.normal),
      TextStyle(fontWeight: FontWeight.normal),
    ];
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(titles.length, (index) {
              final title = titles[index];
              final titlestyle = titleStyles[index];
              return buildAddressText(
                  title: title,
                  width: 200,
                  titleStyle: titlestyle,
                  textAlign: TextAlign.left);
            }),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(invoiceData.length, (index) {
              final invNumber = invoiceTitles[index];
              final invVal = invoiceData[index];
              return buildText(
                title: invNumber,
                value: invVal,
                width: 200,
              );
            }),
          )
        ]);
  }

  static Widget buildAlicornAddressInfo() {
    final titles = <String>[
      'ALICORN INC.',
      '3401 Annandale Road',
      'Falls Church, Virginia',
      '22042',
      'United States',
      '202-276-3074',
      'alicorn.co'
    ];
    final titleStyles = <TextStyle>[
      TextStyle(fontWeight: FontWeight.bold),
      TextStyle(fontWeight: FontWeight.normal),
      TextStyle(fontWeight: FontWeight.normal),
      TextStyle(fontWeight: FontWeight.normal),
      TextStyle(fontWeight: FontWeight.normal),
      TextStyle(fontWeight: FontWeight.normal),
      TextStyle(fontWeight: FontWeight.normal),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final titlestyle = titleStyles[index];
        return buildAddressText(
            title: title, width: 200, titleStyle: titlestyle);
      }),
    );
  }

  static Widget buildInvoiceInfo(Invoice info) {
    final titles = <String>[
      'Invoice #:',
      'Invoice Date:',
    ];
    final data = <String>[
      '1111',
      info.paidon,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static buildAddressText({
    required String title,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
    TextAlign? textAlign,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);
    final align = textAlign ?? TextAlign.right;

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style, textAlign: align)),
          // Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  /*  Widget _buildFooter( Context context) {
    return  Row(
      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
      crossAxisAlignment:  CrossAxisAlignment.end,
      children: [
         Container(
          height: 20,
          width: 100,
          child:  BarcodeWidget(
            barcode:  Barcode.pdf417(),
            data: 'Invoice# $invoiceNumber',
            drawText: false,
          ),
        ),
         Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const  TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  } */
  Widget _buildFooter(Context context) {
    return _termsAndConditions(context);
  }

  PageTheme _buildTheme(
      PdfPageFormat pageFormat, Font base, Font bold, Font italic) {
    return PageTheme(
      pageFormat: pageFormat,
      theme: ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      /* buildBackground: (context) =>  FullPage(
        ignoreMargins: true,
        child:  SvgImage(svg: _bgShape!),
      ), */
    );
  }

  Widget _contentHeader(Context context) {
    return buildBillToInfo(invoicetoprint);
  }

  Widget _contentFooter(Context context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*  Text(
                'Thank you for your business',
                style:  TextStyle(
                  color: _darkColor,
                  fontWeight:  FontWeight.bold,
                ),
              ), */
              /*  Container(
                margin: const  EdgeInsets.only(top: 20, bottom: 8),
                child:  Text(
                  'Payment Info:',
                  style:  TextStyle(
                    color: baseColor,
                    fontWeight:  FontWeight.bold,
                  ),
                ),
              ),
               Text(
                paymentInfo,
                style: const  TextStyle(
                  fontSize: 8,
                  lineSpacing: 5,
                  color: _darkColor,
                ),
              ), */
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_formatCurrency(
                        double.parse(invoicetoprint.totalfees))),
                  ],
                ),
                Divider(thickness: .5, color: accentColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_formatCurrency(
                        double.parse(invoicetoprint.totalfees))),
                  ],
                ),
                Divider(thickness: .5, color: accentColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount Paid:\n(USD):',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_formatCurrency(
                        double.parse(invoicetoprint.totalfees))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _termsAndConditions(Context context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes / Terms',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '1. The fees are charged by ALICORN for all active users on the last day of each month. Account owner(s) can terminate any or all users before the last day of the month and not incur any fees. There are no refunds once the fee is charged.',
              maxLines: 3,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 12,
                color: _darkColor,
              ),
            ),
            Text(
              '2. A list of active users is available to the account owner(s) in the admin section.',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 12,
                color: _darkColor,
              ),
            ),
            Text(
              '3. Please email support@alicorn.co if you have any questions.',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 12,
                color: _darkColor,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _contentTable(Context context) {
    const tableHeaders = [
      'Total Users',
      'Fees/user/month',
      'Total subscription fees',
      'Recharge by'
    ];
    const tableTitles = ['Items', 'Quantity', 'Price', 'Amount'];

    return TableHelper.fromTextArray(
      border: null,
      cellAlignment: Alignment.centerLeft,
      headerDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        //color: baseColor,
        color: PdfColors.cyan,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: Alignment.topLeft,
        1: Alignment.topCenter,
        2: Alignment.topCenter,
        3: Alignment.topRight,
      },
      headerStyle: TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      cellStyle: const TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableTitles[col],
      ),
      data: List<List<dynamic>>.generate(
        1,
        (row) => List<dynamic>.generate(
          tableHeaders.length,
          (col) => invoicetoprint.getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}
