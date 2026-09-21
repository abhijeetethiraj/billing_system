import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../payment/payments_page.dart';
import '../widgets/cart_item.dart';
import '../../provider/cart_provider.dart';
import '../../utils/apptheme.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: cs.surfaceContainerLow,
        elevation: 0,
        title: Text(
          "My Cart",
          style: TextStyle(color: context.deepAccent, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      // If the cart is empty, show a message
                      if (viewModel.cartItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text("Your cart is empty. Add items from Home!", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          ),
                        )
                      else
                        // Otherwise, generate the list of cart items
                        ...List.generate(viewModel.cartItems.length, (index) {
                          return CartItemWidget(item: viewModel.cartItems[index], onIncrement: () => viewModel.incrementQuantity(index), onDecrement: () => viewModel.decrementQuantity(index), onDelete: () => viewModel.removeItem(index));
                        }),
                    ],
                  ),
                ),
              ),

              // Bottom Summary Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cs.surfaceContainer,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(context, "Subtotal", viewModel.subtotal),
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, "Delivery Fee", viewModel.subtotal > 0 ? viewModel.deliveryFee : 0),
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, "Tax", viewModel.tax),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(
                          "₹ ${viewModel.total.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF983D2A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        // Disable the button if the cart is empty
                        onPressed: viewModel.cartItems.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PaymentsPage(cartItems: viewModel.cartItems, amount: viewModel.total),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B3A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: context.cs.onSurfaceVariant)),
        Text("₹ ${value.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
