import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/core/utils/validators.dart';
import 'package:psychological_assessment/core/widgets/dialog_action_bar.dart';
import 'package:psychological_assessment/core/widgets/dialog_header.dart';
import 'package:psychological_assessment/features/assessment/domain/pdf_info_models.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/pdf_report_type_picker.dart';

class _PdfInfoDialogState extends State<_PdfInfoDialogBody> {
  final nameController = TextEditingController();
  final clientIdController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var selectedType = PdfType.full;

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
              DialogHeader(
                icon: LucideIcons.fileDown,
                title: 'ফলাফল ডাউনলোড',
                subtitle: 'Enter your details before download:',
                onClose: () => Navigator.pop(context),
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
                          if (!isOnlyEnglish(value.trim())) {
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
                          if (!isOnlyEnglish(value.trim())) {
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
                          if (!isOnlyEnglish(value.trim())) {
                            return 'Only English characters allowed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      PdfReportTypePicker(
                        selectedType: selectedType,
                        onChanged: (type) {
                          setState(() => selectedType = type);
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              DialogActionBar(
                cancelLabel: 'বাতিল',
                actionLabel: 'ডাউনলোড',
                actionIcon: LucideIcons.fileDown,
                onCancel: () => Navigator.pop(context),
                onAction: () {
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
                        reportType: selectedType,
                      ),
                    );
                  }
                },
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
