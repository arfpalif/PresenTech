import 'package:flutter/material.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class Header extends StatelessWidget {
  final VoidCallback onComingSoonTap;
  final VoidCallback? onChangePage;
  final String imageUrl;
  final String name;
  final String role;
  final double? height;

  const Header({
    super.key,
    required this.onComingSoonTap,
    this.onChangePage,
    required this.imageUrl,
    required this.name,
    required this.role,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.colorPrimary, AppColors.greenPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: height ?? 140,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Presentech",
                    style: AppTextStyle.title.copyWith(color: Colors.white),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      onComingSoonTap();
                    },
                    child: Icon(Icons.help, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      onComingSoonTap();
                    },
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: GestureDetector(
                  onTap: () {
                    onChangePage?.call();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: imageUrl.isEmpty
                        ? CircleAvatar(radius: 20, child: Icon(Icons.person))
                        : Image.network(
                            imageUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                title: Text(
                  "$name",
                  style: AppTextStyle.heading1.copyWith(color: Colors.white),
                ),
                subtitle: Text(
                  "$role",
                  style: AppTextStyle.normal.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
