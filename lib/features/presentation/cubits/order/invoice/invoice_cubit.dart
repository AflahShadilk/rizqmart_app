// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';
import 'invoice_state.dart';

/// Cubit rendering order data into a formatted PDF invoice for printing/download.
class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceInitial());

  Future<void> generateAndPrint(OrderEntities order) async {
    emit(InvoiceLoading());
    try {
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.interRegular();
      final boldFont = await PdfGoogleFonts.interBold();

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            theme: pw.ThemeData.withFont(base: font, bold: boldFont),
          ),
          build: (pw.Context _) {
            return [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('RizqMart',
                          style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue)),
                      pw.Text('Your Daily Needs, Delivered.',
                          style: const pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey600)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('INVOICE',
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(
                          'Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}'),
                      pw.Text(
                          'Order ID: #${order.orderId.substring(0, 8).toUpperCase()}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Bill To:',
                          style:
                              pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(order.userName ?? 'Customer'),
                      pw.Text(order.userEmail ?? ''),
                      if (order.userPhone != null)
                        pw.Text(order.userPhone!),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Delivery Address:',
                          style:
                              pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text(order.deliveryAddress ?? '',
                            textAlign: pw.TextAlign.right),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Table.fromTextArray(
                headers: ['Item', 'Qty', 'Unit Price', 'Total'],
                data: order.items.map((item) {
                  double unitPrice = 0.0;
                  if (item.variantDetails.isNotEmpty &&
                      item.variantIndex < item.variantDetails.length) {
                    final variant =
                        item.variantDetails[item.variantIndex];
                    final priceAtPurchase = variant['priceAtPurchase'];
                    final mrpRaw = variant['mrp'];
                    final priceRaw = variant['price'];
                    if (priceAtPurchase != null) {
                      unitPrice = (priceAtPurchase as num).toDouble();
                    } else if (mrpRaw != null) {
                      unitPrice = (mrpRaw as num).toDouble();
                    } else if (priceRaw != null) {
                      unitPrice = (priceRaw as num).toDouble();
                    }
                  }
                  final double total = unitPrice * item.count;
                  return [
                    item.name,
                    '${item.count}',
                    'INR ${unitPrice.toStringAsFixed(2)}',
                    'INR ${total.toStringAsFixed(2)}',
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blue),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                },
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          'Subtotal:   INR ${order.subtotal.toStringAsFixed(2)}'),
                      pw.Text(
                          'Delivery Fee:   INR ${order.deliveryFee.toStringAsFixed(2)}'),
                      pw.Text(
                          'Discount:   - INR ${order.discount.toStringAsFixed(2)}',
                          style:
                              const pw.TextStyle(color: PdfColors.green)),
                      if ((order.discountAmount ?? 0) > 0)
                        pw.Text(
                            'Coupon Discount${order.couponName != null ? ' (${order.couponName})' : ''}:   - INR ${order.discountAmount!.toStringAsFixed(2)}',
                            style:
                                const pw.TextStyle(color: PdfColors.green)),
                      pw.Divider(),
                      pw.Text(
                        'Grand Total:   INR ${order.totalCost.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Divider(color: PdfColors.grey300),
              pw.Center(
                child: pw.Text('Thank you for shopping with RizqMart!',
                    style:
                        const pw.TextStyle(color: PdfColors.grey600)),
              ),
              pw.Center(
                child: pw.Text('For support: support@rizqmart.com',
                    style: const pw.TextStyle(
                        fontSize: 10, color: PdfColors.grey500)),
              ),
            ];
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name:
            'RizqMart_Invoice_${order.orderId.substring(0, 8)}.pdf',
      );

      emit(InvoiceSuccess());
    } catch (e) {
      emit(InvoiceFailure(e.toString()));
    }
  }
}