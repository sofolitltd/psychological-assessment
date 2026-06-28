import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../design_system/app_theme.dart';
import '../design_system/responsive.dart';
import '../services/pdf_cache_service.dart';

class PdfViewerScreen extends ConsumerStatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({super.key, required this.url, required this.title});

  @override
  ConsumerState<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends ConsumerState<PdfViewerScreen> {
  Future<Uint8List>? _pdfFuture;
  double _zoomPercent = 100;

  @override
  void initState() {
    super.initState();
    _pdfFuture = ref.read(pdfCacheServiceProvider).getPdf(widget.url);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_zoomPercent == 100 && Responsive.isDesktop(context)) {
      setState(() => _zoomPercent = 75);
    }
  }

  double get _widthFactor => _zoomPercent / 100;

  void _setZoom(double percent) {
    setState(() => _zoomPercent = percent);
  }

  String get _zoomLabel {
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    final str = _zoomPercent.round().toString();
    final bangla = str.split('').map((c) => bengali[int.parse(c)]).join();
    return '$bangla%';
  }

  Future<void> _share() async {
    final appName = 'Psychological Assessment';
    final appWebsite = 'psychologicalassessmentbd.web.app';
    final text = '$appName\n\n${widget.title}\n\nLink:${widget.url}\n\n'
        'Explore more psychological assessments on $appWebsite.';
    await SharePlus.instance.share(ShareParams(text: text, subject: widget.title));
  }

  Future<void> _print(Uint8List bytes) async {
    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
    );
  }

  Future<void> _download(Uint8List bytes) async {
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${widget.title}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);
    final maxWidth = Responsive.maxContentWidth(context);
    final iconSize = isDesktop ? 22.0 : 18.0;
    final regularBtn = OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(14),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.roundedSm,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                _buildTopBar(isDark),
                Expanded(
                  child: FutureBuilder<Uint8List>(
                    future: _pdfFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                const SizedBox(height: 16),
                                Text(
                                  'পিডিএফ লোড করা সম্ভব হয়নি',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  snapshot.error.toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                FilledButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _pdfFuture = ref.read(pdfCacheServiceProvider).getPdf(widget.url);
                                    });
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('পুনরায় চেষ্টা করুন'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        final bytes = snapshot.data!;
                        return Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  width: maxWidth * _widthFactor,
                                  child: PdfPreview(
                                    build: (format) async => bytes,
                                    allowPrinting: false,
                                    allowSharing: false,
                                    canChangePageFormat: false,
                                    canChangeOrientation: false,
                                    canDebug: false,
                                    useActions: false,
                                  ),
                                ),
                              ),
                            ),
                            _buildBottomBar(bytes, iconSize, regularBtn, isDark),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () => context.pop(),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'পিডিএফ',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Uint8List bytes, double iconSize, ButtonStyle regularBtn, bool isDark) {
    final notoSerif = GoogleFonts.notoSerifBengali();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          PopupMenuButton<double>(
            onSelected: _setZoom,
            tooltip: 'জুম স্তর',
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.roundedSm,
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.border,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: AppRadius.roundedSm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _zoomLabel,
                    style: TextStyle(
                      fontFamily: notoSerif.fontFamily,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textSecondary),
                ],
              ),
            ),
            itemBuilder: (context) => [
              _zoomMenuItem('৫০%', 50),
              _zoomMenuItem('৭৫%', 75),
              _zoomMenuItem('১০০%', 100),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: _share,
            style: regularBtn,
            child: Icon(Icons.share, size: iconSize),
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton(
            onPressed: () => _print(bytes),
            style: regularBtn,
            child: Icon(Icons.print, size: iconSize),
          ),
          const SizedBox(width: AppSpacing.md),
          FilledButton.icon(
            onPressed: () => _download(bytes),
            icon: Icon(Icons.download, size: iconSize),
            label: Text('ডাউনলোড', style: TextStyle(fontFamily: notoSerif.fontFamily)),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.roundedSm,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<double> _zoomMenuItem(String label, double value) {
    final selected = _zoomPercent == value;
    return PopupMenuItem(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      height: 36,
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.notoSerifBengali(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? AppColors.primary : null,
            ),
          ),
          const Spacer(),
          if (selected)
            Icon(Icons.check, size: 16, color: AppColors.primary),
        ],
      ),
    );
  }
}
