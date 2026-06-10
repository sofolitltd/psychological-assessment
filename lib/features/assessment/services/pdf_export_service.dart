
import 'dart:typed_data';
import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart'; // import the fixer package
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../domain/assessment_bundle.dart';

class PdfExportService {
  /// Unified text renderer that uses bangla_pdf_fixer widgets for proper 
  /// layout mapping and multi-page text breaking logic.
  static pw.Widget _text(
    String text, {
    double size = 12,
    PdfColor? color,
    bool isBold = false,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return pw.SizedBox();
    
    // Bangla PDF Fixer provides ready-to-use BanglaText that automatically
    // manages complex font reshaper parameters without throwing RangeErrors.
    return BanglaText(
      trimmed,
      fontSize: size,
      fontType: isBold ? BanglaFontType.kalpurush : BanglaFontType.kalpurush,
      color: color ?? PdfColors.grey900,
    );
  }

  static Future<Uint8List> generateAssessmentReport(
      AssessmentResultBundle bundle) async {
    // CRITICAL REQUIREMENT FOR V2.0.0: Make sure this initialization 
    // runs so the layout engine cache shapes up properly.
    await BanglaFontManager().initialize();

    final pdf = pw.Document();

    final regularFont = await PdfGoogleFonts.outfitRegular();
    final boldFont = await PdfGoogleFonts.outfitBold();

    final accentColor = PdfColor.fromHex('#6750A4');
    final now = DateFormat('MMMM dd, yyyy — hh:mm a').format(DateTime.now());

    pw.TextStyle engStyle({
      isBold = false,
      double size = 12,
      pw.Font? font,
      PdfColor? color,
    }) =>
        pw.TextStyle(
          fontBold: isBold ? boldFont : regularFont,
          font: font ?? regularFont,
          fontSize: size,
          color: color ?? PdfColors.grey900,
        );

    // Build the score table rows safely
    pw.Widget buildScoreTable() {
      const headerDecoration = pw.BoxDecoration(color: PdfColor.fromInt(0xFF6750A4));
      final borderSide = const pw.BorderSide(color: PdfColors.grey300, width: 0.5);

      pw.TableRow headerRow() => pw.TableRow(
            decoration: headerDecoration,
            children: ['Scale', 'Score', 'Result']
                .map((h) => pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: pw.Text(h, style: engStyle(font: boldFont, size: 12, color: PdfColors.white)),
                    ))
                .toList(),
          );

      final dataRows = bundle.scores.values.map((s) {
        return pw.TableRow(
          decoration: pw.BoxDecoration(
            border: pw.Border(bottom: borderSide),
          ),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: pw.Text(
                s.scale.replaceAll('_', ' ').toUpperCase(),
                style: engStyle(size: 11),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: pw.Text(
                '${s.rawScore}${s.maxScore > 0 ? ' / ${s.maxScore}' : ''}',
                style: engStyle(size: 11),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: pw.Text(
                s.severity,
                style: engStyle(isBold: true, size: 11),
              ),
            ),
          ],
        );
      }).toList();

      return pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(3),
        },
        children: [headerRow(), ...dataRows],
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        build: (pw.Context ctx) {
          return [
            // ── Header ────────────────────────────────────────────────────
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Psychological Assessment Report',
                  style: engStyle(font: boldFont, size: 22, color: accentColor),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 4),
                pw.Text('Generated: $now', style: engStyle(size: 10, color: PdfColors.grey600)),
                pw.SizedBox(height: 12),
                pw.Divider(color: PdfColors.grey400),
              ],
            ),

            pw.SizedBox(height: 16),

            // ── Test Info ──────────────────────────────────────────────────
            pw.Text('Assessment Information', style: engStyle(font: boldFont, size: 15, color: accentColor)),
            pw.SizedBox(height: 8),
            pw.Text('Test Name: ${bundle.testName}', style: engStyle(isBold: true, size: 13)),
            if (bundle.test.category != null) ...[
              pw.SizedBox(height: 4),
              pw.Text('Category: ${bundle.test.category!}', style: engStyle(size: 12)),
            ],
            if (bundle.test.about != null && bundle.test.about!.isNotEmpty) ...[
              pw.SizedBox(height: 6),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: _text(bundle.test.about!, size: 11, color: PdfColors.grey700)),
              
            ],

            pw.SizedBox(height: 20),

            // ── Score Table ────────────────────────────────────────────────
            pw.Text('Score Summary', style: engStyle(font: boldFont, size: 15, color: accentColor)),
            pw.SizedBox(height: 8),
            buildScoreTable(),

            pw.SizedBox(height: 24),

            // ── Detailed Results ───────────────────────────────────────────
            pw.Text('Detailed Interpretation', style: engStyle(font: boldFont, size: 15, color: accentColor)),
            pw.SizedBox(height: 10),

            ...bundle.scores.values.map((result) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
                    ),
                    child: pw.Text(
                      '${result.scale.replaceAll('_', ' ').toUpperCase()}  •  ${result.severity}',
                      style: engStyle(
                        
                      isBold: true,
                      size: 13,
                      color: accentColor,),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  
                  if (result.interpretation != null && result.interpretation!.isNotEmpty) ...[
                    _text(result.interpretation!, size: 12),
                    pw.SizedBox(height: 6),
                  ],
                  if (result.suggestions != null && result.suggestions!.isNotEmpty) ...[
                    _text('পরামর্শ:', isBold: true, size: 12),
                    pw.SizedBox(height: 4),
                    _text(result.suggestions!, size: 12, color: PdfColors.grey800),
                  ],
                  
                  pw.SizedBox(height: 16),
                ],
              );
            }),

            pw.SizedBox(height: 16),

            // ── Disclaimer ─────────────────────────────────────────────────
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.red50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: PdfColors.red200),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Medical Disclaimer', style: engStyle(font: boldFont, size: 11, color: PdfColors.red900)),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'This report is generated by an automated psychological assessment tool and is intended for informational and preliminary screening purposes only. It does NOT constitute a formal clinical diagnosis. For any significant mental health concerns, please consult a qualified psychiatrist or psychologist immediately.',
                    style: engStyle(
                    size: 10,
                    color: PdfColors.red900,
                  ),),
                ],
              ),
            ),
          ];
        },
        footer: (pw.Context ctx) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Page ${ctx.pageNumber} of ${ctx.pagesCount}  •  Psychological Assessment App',
            style: engStyle(size: 9, color: PdfColors.grey500),
          ),
        ),
      ),
    );

    return pdf.save();
  }
}

