import 'package:flutter/material.dart';

void showCenterNotice(
    BuildContext context, {
      required String message,
      IconData icon = Icons.check_circle_rounded,
    }) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;

  const softOrangeBg = Color(0xFFFFE5D9);
  const softOrangeBorder = Color(0xFFFFB596);
  const primaryColor = Color(0xFFE66A3C);
  const brownColor = Color(0xFF8B3E20);

  entry = OverlayEntry(
    builder: (overlayContext) {
      return IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: softOrangeBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: softOrangeBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: brownColor.withValues(alpha: 0.14),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: brownColor,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);

  Future.delayed(const Duration(milliseconds: 1800), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}