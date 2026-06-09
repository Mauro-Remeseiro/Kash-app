import 'package:flutter/material.dart';

import '../theme/kash_colors.dart';

/// Muestra el paywall Pro como un bottom sheet modal.
/// Por ahora es una pantalla de "próximamente" sin integración de pagos.
void mostrarPaywallPro(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _PaywallSheet(),
  );
}

class _PaywallSheet extends StatelessWidget {
  const _PaywallSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = kashColorsOf(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        28,
        20,
        28,
        MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Kash Pro',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Próximamente',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textTertiary,
            ),
          ),
          const SizedBox(height: 32),
          _FeatureRow(
            icon: Icons.sync_alt_rounded,
            label: 'Sincronización entre dispositivos',
            colors: colors,
            theme: theme,
          ),
          _FeatureRow(
            icon: Icons.bar_chart_rounded,
            label: 'Informes y exportación CSV',
            colors: colors,
            theme: theme,
          ),
          _FeatureRow(
            icon: Icons.people_alt_rounded,
            label: 'Empleados y cajas ilimitadas',
            colors: colors,
            theme: theme,
          ),
          _FeatureRow(
            icon: Icons.palette_rounded,
            label: 'Temas personalizados',
            colors: colors,
            theme: theme,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Avisarme cuando esté disponible',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Ahora no',
              style: TextStyle(color: colors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.label,
    required this.colors,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final KashColors colors;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Icon(Icons.check_circle_rounded, size: 18, color: colors.positive),
        ],
      ),
    );
  }
}
