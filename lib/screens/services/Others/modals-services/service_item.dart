import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String name;
  final Color color;
  final VoidCallback? onTap;
  final double size;

  const ServiceItem({
    super.key,
    this.icon,
    this.imagePath,
    required this.name,
    required this.color,
    this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          final iconSize = size;
          final containerPadding = size * 0.4;
          final containerSize = iconSize + (containerPadding * 2);

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: containerSize,
                height: containerSize,
                padding: EdgeInsets.all(containerPadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        icon,
                        color: color,
                        size: iconSize,
                      ),
              ),
              SizedBox(height: availableHeight * 0.05),
              Flexible(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size * 0.45,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
