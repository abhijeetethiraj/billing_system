import 'package:billing_system/models/cart_model.dart';
import 'package:billing_system/models/order_item_model.dart';
import 'package:billing_system/models/order_model.dart';
import 'package:billing_system/provider/cart_provider.dart';
import 'package:billing_system/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentsPage extends StatefulWidget {
  final List<CartModel> cartItems;
  final double amount;

  const PaymentsPage({
    super.key,
    required this.cartItems,
    required this.amount,
  });

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  static const String _razorpayKeyId = 'rzp_test_T53I1W3nMKK3Rq';
  late final Razorpay _razorpay;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openCheckout();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout() {
    if (_opened) {
      return;
    }

    _opened = true;

    final options = {
      'key': _razorpayKeyId,
      'amount': (widget.amount * 100).round(),
      'name': 'billing_system',
      'description': 'Food order payment',
      'prefill': {'contact': '9999999999', 'email': 'test@example.com'},
      'theme': {'color': '#FF6B3A'},
    };

    try {
      _razorpay.open(options);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open payment popup: $error'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      paymentId: response.paymentId ?? 'unknown',
      amount: widget.amount,
      createdAt: DateTime.now(),
      items: widget.cartItems
          .map(
            (item) => OrderItemModel(
              id: item.id,
              name: item.name,
              restaurant: item.restaurant,
              price: item.price,
              quantity: item.quantity,
              image: item.image,
            ),
          )
          .toList(),
    );

    await context.read<OrderProvider>().addOrder(order);
    await context.read<CartProvider>().clearCart();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment successful. Order saved in history.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message ?? 'Unknown error'}'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName ?? 'wallet'}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Opening Razorpay checkout for ₹ ${widget.amount.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}