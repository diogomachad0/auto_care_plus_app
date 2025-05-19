import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';

class CustomActionSheet extends StatefulWidget {
  const CustomActionSheet({super.key});

  @override
  State<CustomActionSheet> createState() => _CustomActionSheetState();
}

class _CustomActionSheetState extends State<CustomActionSheet> with ThemeMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildOption(context, 'Reabastecimento'),
              _buildDivider(),
              _buildOption(context, 'Troca de óleo'),
              _buildDivider(),
              _buildOption(context, 'Lavagem'),
              _buildDivider(),
              _buildOption(context, 'Seguro'),
              _buildDivider(),
              _buildOption(context, 'Serviço mecânico'),
              _buildDivider(),
              _buildOption(context, 'Financiamento'),
              _buildDivider(),
              _buildOption(context, 'Compras'),
              _buildDivider(),
              _buildOption(context, 'Impostos'),
              _buildDivider(),
              _buildOption(context, 'Outros'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildCancelButton(context),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, title);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            title,
            style: textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.black12,
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'Cancelar',
            style: textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
