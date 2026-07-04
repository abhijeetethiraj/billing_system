import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/order_provider.dart';

class OrderHistoryPage extends StatefulWidget {
	const OrderHistoryPage({super.key});

	@override
	State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
	@override
	void initState() {
		super.initState();
		Future.microtask(() => context.read<OrderProvider>().loadOrders());
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			appBar: AppBar(
				backgroundColor: Colors.white,
				elevation: 0,
				foregroundColor: Colors.black87,
				title: const Text('Order History'),
			),
			body: Consumer<OrderProvider>(
				builder: (context, orderProvider, child) {
					if (orderProvider.orders.isEmpty) {
						return const Center(
							child: Text(
								'No orders yet',
								style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
							),
						);
					}

					return ListView.builder(
						padding: const EdgeInsets.all(20),
						itemCount: orderProvider.orders.length,
						itemBuilder: (context, index) {
							final order = orderProvider.orders[index];
							return Container(
								margin: const EdgeInsets.only(bottom: 16),
								padding: const EdgeInsets.all(16),
								decoration: BoxDecoration(
									color: Colors.white,
									borderRadius: BorderRadius.circular(18),
									boxShadow: const [
										BoxShadow(
											color: Colors.black12,
											blurRadius: 8,
											offset: Offset(0, 3),
										),
									],
								),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											'Order #${order.id}',
											style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
										),
										const SizedBox(height: 6),
										Text(
											'Paid: ₹ ${order.amount.toStringAsFixed(2)}',
											style: const TextStyle(fontSize: 15, color: Colors.deepOrange, fontWeight: FontWeight.bold),
										),
										const SizedBox(height: 6),
										Text(
											'Items: ${order.items.length}',
											style: TextStyle(color: Colors.grey.shade700),
										),
										const SizedBox(height: 8),
										Text(
											order.createdAt.toString(),
											style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
										),
									],
								),
							);
						},
					);
				},
			),
		);
	}
}
