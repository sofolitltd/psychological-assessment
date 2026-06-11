import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/app_theme.dart';

enum PdfType {
  full,
  summary,
}

class PdfUserInfo {
  final String name;
  final String? clientId;
  final String? phone;
  final PdfType pdfType;

  const PdfUserInfo({
    required this.name,
    this.clientId,
    this.phone,
    this.pdfType = PdfType.full,
  });
}

class _PdfInfoDialogState extends State<_PdfInfoDialogBody> {
  final nameController = TextEditingController();
  final clientIdController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var selectedType = PdfType.full;

  static bool _isOnlyEnglish(String text) {
    return RegExp(r'^[a-zA-Z0-9\s\.\,\-\_\(\)\/\+\#]+$').hasMatch(text);
  }

  @override
  void dispose() {
    nameController.dispose();
    clientIdController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 520,
          maxWidth: 460,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: AppRadius.roundedSm,
                              ),
                              child: const Icon(
                                LucideIcons.fileDown,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'ফলাফল ডাউনলোড',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.notoSerifBengali()
                                    .fontFamily,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.x),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 4),
                    Text(
                      'Enter your details before download:',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          labelStyle: GoogleFonts.outfit(),
                          hintStyle: GoogleFonts.outfit(),
                          prefixIcon: const Icon(LucideIcons.user, size: 20),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          if (!_isOnlyEnglish(value.trim())) {
                            return 'Only English characters allowed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: clientIdController,
                        decoration: InputDecoration(
                          labelText: 'Client ID',
                          hintText: 'Enter client ID (optional)',
                          labelStyle: GoogleFonts.outfit(),
                          hintStyle: GoogleFonts.outfit(),
                          prefixIcon: const Icon(LucideIcons.badge, size: 20),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          if (!_isOnlyEnglish(value.trim())) {
                            return 'Only English characters allowed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          hintText: 'Enter phone number (optional)',
                          labelStyle: GoogleFonts.outfit(),
                          hintStyle: GoogleFonts.outfit(),
                          prefixIcon: const Icon(LucideIcons.phone, size: 20),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          if (!_isOnlyEnglish(value.trim())) {
                            return 'Only English characters allowed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select report type:',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SegmentedButton<PdfType>(
                          segments: [
                            ButtonSegment(
                              value: PdfType.full,
                              label: Text('সম্পূর্ণ',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                                  fontSize: 14,
                                ),
                              ),
                              icon: const Icon(LucideIcons.fileText, size: 18),
                            ),
                            ButtonSegment(
                              value: PdfType.summary,
                              label: Text('সংক্ষিপ্ত',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                                  fontSize: 14,
                                ),
                              ),
                              icon: const Icon(LucideIcons.fileMinus, size: 18),
                            ),
                          ],
                          selected: {selectedType},
                          onSelectionChanged: (selection) {
                            setState(() => selectedType = selection.first);
                          },
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            backgroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary
                                    .withValues(alpha: 0.15);
                              }
                              return null;
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedType == PdfType.full
                            ? 'ক্লায়েন্ট তথ্য, মূল্যায়ন, স্কোর, বিস্তারিত ব্যাখ্যা ও সতর্কতা'
                            : 'ক্লায়েন্ট তথ্য, মূল্যায়ন, স্কোর ও সতর্কতা (ব্যাখ্যা ছাড়া)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          fontFamily:
                              GoogleFonts.notoSerifBengali().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('বাতিল',
                        style: TextStyle(
                          fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      icon: const Icon(LucideIcons.fileDown, size: 18),
                      label: Text('ডাউনলোড',
                        style: TextStyle(
                          fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(
                            context,
                            PdfUserInfo(
                              name: nameController.text.trim(),
                              clientId: clientIdController.text.trim().isEmpty
                                  ? null
                                  : clientIdController.text.trim(),
                              phone: phoneController.text.trim().isEmpty
                                  ? null
                                  : phoneController.text.trim(),
                              pdfType: selectedType,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<PdfUserInfo?> showPdfInfoDialog(BuildContext context) {
  return showDialog<PdfUserInfo>(
    context: context,
    builder: (_) => const _PdfInfoDialogBody(),
  );
}

class _PdfInfoDialogBody extends StatefulWidget {
  const _PdfInfoDialogBody();

  @override
  State<_PdfInfoDialogBody> createState() => _PdfInfoDialogState();
}
