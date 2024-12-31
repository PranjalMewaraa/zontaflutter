import 'package:flutter/material.dart';
import 'package:zonta/screens/services/cash/cash_wallet_screen.dart';
import './service_item.dart';
import './services_modal.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  void _showServicesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ServicesModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 4
        : screenWidth < 900
            ? 6
            : 8;
    final itemSize = screenWidth < 600 ? 24.0 : 32.0;

    final services = [
      {'icon': Icons.directions_car, 'name': 'Auto', 'color': Colors.green},
      {'icon': Icons.home, 'name': 'Home', 'color': Colors.blue},
      {'icon': Icons.store, 'name': 'Commercial', 'color': Colors.purple},
      {'icon': Icons.more_horiz, 'name': 'Others', 'color': Colors.black},
      {'icon': Icons.attach_money, 'name': 'Cash', 'color': Colors.green},
      {'icon': Icons.account_balance, 'name': 'Bank', 'color': Colors.black},
      {
        'icon': Icons.account_balance_wallet,
        'name': 'Loan',
        'color': Colors.black
      },
      {'icon': Icons.credit_card, 'name': 'Card', 'color': Colors.green},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return ServiceItem(
          icon: services[index]['icon'] as IconData,
          name: services[index]['name'] as String,
          color: services[index]['color'] as Color,
          size: itemSize,
          onTap: services[index]['name'] == 'Cash'
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CashWalletScreen()),
                  );
                }
              : services[index]['name'] == 'Others'
                  ? () => _showServicesModal(context)
                  : null,
        );
      },
    );
  }
}
