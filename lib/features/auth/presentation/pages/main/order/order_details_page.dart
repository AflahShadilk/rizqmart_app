// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/chat/chat_page.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderEntities order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late String _deliveryBoyName;
  // ignore: unused_field
  late int _deliveryBoyAvatarIndex;

  @override
  void initState() {
    super.initState();
    // Generate random delivery boy details once
    final random = Random();
    final names = [
      'Rahul Kumar',
      'Amit Singh',
      'Vikram Patel',
      'Suresh Reddy',
      'Mohd. Ali'
    ];
    _deliveryBoyName = names[random.nextInt(names.length)];
    _deliveryBoyAvatarIndex = random.nextInt(5) + 1; // Assuming 5 avatars
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: context.ts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: context.cs.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(context),
              24.h,
              _buildTrackingStepper(context),
              24.h,
              _buildDeliveryBoySection(context),
              24.h,
              _buildOrderItemsList(context),
              24.h,
              _buildOrderSummary(context),
              32.h,
              _buildActionButtons(context),
              40.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest.withAlpha(77), // 0.3
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.cs.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order ID', style: context.ts.bodyMedium),
              Text(
                '#${widget.order.orderId.substring(0, 8).toUpperCase()}',
                style: context.ts.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          8.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date', style: context.ts.bodyMedium),
              Text(
                DateFormat('dd MMM, yyyy').format(widget.order.createdAt),
                style: context.ts.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStepper(BuildContext context) {
    // Determine current step based on status
    int currentStep = 0;
    final status = widget.order.status.toLowerCase();

    // ignore: duplicate_ignore
    // ignore: curly_braces_in_flow_control_structures
    if (status == 'processed' || status == 'processing')
      currentStep = 1;
    else if (status == 'shipped')
      currentStep = 2;
    // else if (status == 'out_for_delivery') currentStep = 3; // "Out" is step 3
    else if (status.contains('out'))
      currentStep = 3;
    else if (status == 'delivered')
      currentStep = 4;
    else if (status == 'cancelled') currentStep = -1; // Handle separately

    final steps = ['Placed', 'Processing', 'Shipped', 'Out', 'Delivered'];

    if (currentStep == -1) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(26), // 0.1
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withAlpha(77)), // 0.3
        ),
        child: Center(
          child: Text(
            'ORDER CANCELLED',
            style: context.ts.titleMedium
                ?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Track Order',
            style:
                context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        16.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final isCompleted = index <= currentStep;
            final isLast = index == steps.length - 1;

            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index == 0
                              ? Colors.transparent
                              : (index <= currentStep
                                  ? context.cs.primary
                                  : context.cs.outlineVariant),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? context.cs.primary
                              : context.cs.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isCompleted
                                  ? context.cs.primary
                                  : context.cs.outlineVariant,
                              width: 2),
                        ),
                        child: isCompleted
                            ? Icon(Icons.check,
                                size: 14, color: context.cs.surface)
                            : null,
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isLast
                              ? Colors.transparent
                              : (index < currentStep
                                  ? context.cs.primary
                                  : context.cs.outlineVariant),
                        ),
                      ),
                    ],
                  ),
                  8.h,
                  Text(
                    steps[index],
                    style: context.ts.labelSmall?.copyWith(
                        color: isCompleted
                            ? context.cs.primary
                            : context.cs.onSurface.withAlpha(128), // 0.5
                        fontWeight:
                            isCompleted ? FontWeight.bold : FontWeight.normal),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  )
                ],
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _buildDeliveryBoySection(BuildContext context) {
    if (widget.order.status.toLowerCase() == 'pending' ||
        widget.order.status.toLowerCase() == 'cancelled') {
      return const SizedBox.shrink(); // Hide if not assigned
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Partner',
            style:
                context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        12.h,
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.cs.surfaceContainerHighest.withAlpha(77), // 0.3
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: context.cs.outlineVariant.withAlpha(128)), // 0.5
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20, // Smaller
                backgroundColor: context.cs.primary.withAlpha(26), // 0.1
                child: Text(_deliveryBoyName[0],
                    style: TextStyle(
                        color: context.cs.primary,
                        fontWeight: FontWeight.bold)),
              ),
              12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_deliveryBoyName,
                        style: context.ts.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Flutter Express • 4.8 ★',
                        style: context.ts.bodySmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _navigateToChat(context),
                icon: const Icon(Icons.chat_bubble_outline, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: context.cs.primary,
                  foregroundColor: context.cs.surface,
                  padding: const EdgeInsets.all(8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Items',
            style:
                context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        12.h,
        ...widget.order.items.map((item) {
          String? imageUrl;
          List<String> details = [];

          // Extract Image URL and clean details
          if (item.variantDetails.isNotEmpty &&
              item.variantIndex < item.variantDetails.length) {
            final variant = item.variantDetails[item.variantIndex];
            // Find URL
            for (var value in variant.values) {
              if (value.toString().contains('http')) {
                imageUrl = value.toString();
              } else {
                details.add(value.toString());
              }
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                ProductImage(
                  imageUrl: imageUrl,
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(8),
                ),
                12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: context.ts.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      if (details.isNotEmpty)
                        Text(
                          '${item.count}x  •  ${details.join(", ")}',
                          style: context.ts.bodySmall,
                        )
                      else
                        Text('${item.count}x', style: context.ts.bodySmall),
                    ],
                  ),
                ),
                 // Price and Chat Button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${(item.count * 100).toStringAsFixed(0)}', // Placeholder price calculation
                      style: context.ts.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    4.h,
                    InkWell(
                      onTap: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              orderId: widget.order.orderId,
                              orderDisplayId: widget.order.orderId.substring(0, 8).toUpperCase(),
                              deliveryPartnerName: 'Product Support', 
                              productId: item.id,
                              productName: item.name,
                              productImage: imageUrl,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Chat',
                          style: context.ts.labelSmall?.copyWith(
                            color: context.cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary',
            style:
                context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        12.h,
        _summaryRow(context, 'Subtotal', widget.order.subtotal),
        8.h,
        _summaryRow(context, 'Delivery Fee', widget.order.deliveryFee),
        8.h,
        _summaryRow(context, 'Discount', -widget.order.discount,
            isDiscount: true),
        12.h,
        Divider(color: context.cs.outlineVariant),
        12.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Amount',
                style: context.ts.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(
              '₹${widget.order.totalCost.toStringAsFixed(2)}',
              style: context.ts.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: context.cs.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(BuildContext context, String label, double amount,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.ts.bodyMedium),
        Text(
          '${isDiscount ? "-" : ""}₹${amount.abs().toStringAsFixed(2)}',
          style: context.ts.bodyMedium?.copyWith(
              color: isDiscount ? Colors.green : context.cs.onSurface,
              fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isCancelled = widget.order.status.toLowerCase() == 'cancelled';
    final isDelivered = widget.order.status.toLowerCase() == 'delivered';

    return Column(
      children: [
        if (!isCancelled && !isDelivered)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showCancelDialog(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                    vertical: 16), // Match MainButton height
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Cancel Order',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        if (!isCancelled && !isDelivered) 16.h,

        // Use MainButton for Invoice
        SizedBox(
          width: double.infinity,
          child: MainButton(
            label: 'Download Invoice',
            onPress: () => _generateAndPrintInvoice(context),
            color: context.cs.primary,
            textColor: context.cs.onPrimary,
            icon: Icons.download_rounded,
          ),
        ),
        16.h,
        InkWell(
          onTap: () => _launchSupport(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.headset_mic_outlined,
                    size: 20, color: context.cs.primary),
                8.w,
                Text(
                  'Need Help? Contact Support',
                  style: context.ts.bodyMedium?.copyWith(
                      color: context.cs.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        16.h,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _navigateToChat(context),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Chat with Seller'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: context.cs.primary),
              foregroundColor: context.cs.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          orderId: widget.order.orderId,
          orderDisplayId: widget.order.orderId.substring(0, 8).toUpperCase(),
          deliveryPartnerName: 'RizqMart Support', // Or specific seller name
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Cancel Order?'),
              content: const Text(
                  'Are you sure you want to cancel this order? This action cannot be undone and the amount will be refunded to your wallet.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context
                          .read<OrderBloc>()
                          .add(CancelOrderEvent(widget.order.orderId));
                      // Pop handled by listener in OrdersPage, or we pop here.
                      // Letting the Bloc listener handle the success state is better, but since we are in Details page,
                      // we can just pop back to list.
                      Navigator.pop(context);
                    },
                    child: const Text('Yes, Cancel',
                        style: TextStyle(color: Colors.red))),
              ],
            ));
  }

  Future<void> _launchSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@rizqmart.com',
      query: 'subject=Help with Order #${widget.order.orderId}',
    );
    if (!await launchUrl(emailLaunchUri)) {}
  }

  Future<void> _generateAndPrintInvoice(BuildContext context) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.interRegular();
    final boldFont = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        ),
        build: (pw.Context context) {
          return [
            // Header
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
                        'Order ID: #${widget.order.orderId.substring(0, 8).toUpperCase()}'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Bill To
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Bill To:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text(widget.order.userName ?? 'Customer'),
                    pw.Text(widget.order.userEmail ?? ''),
                    if (widget.order.userPhone != null)
                      pw.Text(widget.order.userPhone!),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Delivery Address:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.SizedBox(
                      width: 200,
                      child: pw.Text(widget.order.deliveryAddress ?? '',
                          textAlign: pw.TextAlign.right),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Items Table
            // ignore: deprecated_member_use
            pw.Table.fromTextArray(
              headers: ['Item', 'Qty', 'Unit Price', 'Total'],
              data: widget.order.items.map((item) {
                // Approximate unit price since we store count and total might be derived
                // Use a generic placeholder logic or calculate if total per item was stored
                // Assuming item.totalPrice is not in Entity but we can calc 100 * count as per existing UI
                final price = 100.0;
                final total = price * item.count;
                return [
                  item.name,
                  '${item.count}',
                  'INR ${price.toStringAsFixed(2)}',
                  'INR ${total.toStringAsFixed(2)}',
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
            ),
            pw.SizedBox(height: 20),

            // Summary
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                        'Subtotal:   INR ${widget.order.subtotal.toStringAsFixed(2)}'),
                    pw.Text(
                        'Delivery Fee:   INR ${widget.order.deliveryFee.toStringAsFixed(2)}'),
                    pw.Text(
                        'Discount:   - INR ${widget.order.discount.toStringAsFixed(2)}',
                        style: const pw.TextStyle(color: PdfColors.green)),
                    pw.Divider(),
                    pw.Text(
                      'Grand Total:   INR ${widget.order.totalCost.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 40),

            // Footer
            pw.Divider(color: PdfColors.grey300),
            pw.Center(
              child: pw.Text('Thank you for shopping with RizqMart!',
                  style: const pw.TextStyle(color: PdfColors.grey600)),
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
      name: 'RizqMart_Invoice_${widget.order.orderId.substring(0, 8)}.pdf',
    );
  }
}
