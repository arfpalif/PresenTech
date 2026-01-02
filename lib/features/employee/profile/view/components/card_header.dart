import 'package:flutter/material.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class CardHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;

  // ignore: prefer_const_constructors_in_immutables
  CardHeader({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  imageUrl.isNotEmpty
                      ? imageUrl
                      : 'https://www.gravatar.com/avatar/?d=mp',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(name, style: AppTextStyle.heading1),
              SizedBox(height: 10),
              Text(
                role,
                style: AppTextStyle.normal.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
