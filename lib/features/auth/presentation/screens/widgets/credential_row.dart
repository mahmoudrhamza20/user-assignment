import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/snackbar_utils.dart';

class CredentialRow extends StatelessWidget {
  final String label;
  final String value;
  const CredentialRow({super.key, required this.label, required this.value});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarUtils.showInfo(context, '$label copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
              SelectableText(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy_rounded, size: 18),
          onPressed: () => _copyToClipboard(context, value, label),
          color: AppColors.primaryDark,
          visualDensity: VisualDensity.compact,
          tooltip: 'Copy $label',
        ),
      ],
    );
  }
}
