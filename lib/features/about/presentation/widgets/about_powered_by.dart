import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/design_system/app_theme.dart';

class AboutPoweredBy extends StatelessWidget {
  final TextTheme textTheme;

  const AboutPoweredBy({super.key, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Powered by', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse('https://sofolit.vercel.app')),
            child: Text(
              'Sofol IT',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
