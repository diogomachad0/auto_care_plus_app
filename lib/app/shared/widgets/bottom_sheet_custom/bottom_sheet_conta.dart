import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';

class BottomSheetConta extends StatefulWidget {
  final List<UserAccount> accounts;
  final String? activeAccountId;
  final Function(UserAccount)? onAccountSelected;
  final VoidCallback? onAddAccount;

  const BottomSheetConta({
    super.key,
    required this.accounts,
    this.activeAccountId,
    this.onAccountSelected,
    this.onAddAccount,
  });

  static Future<void> show({
    required BuildContext context,
    required List<UserAccount> accounts,
    String? activeAccountId,
    Function(UserAccount)? onAccountSelected,
    VoidCallback? onAddAccount,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return BottomSheetConta(
          accounts: accounts,
          activeAccountId: activeAccountId,
          onAccountSelected: onAccountSelected,
          onAddAccount: onAddAccount,
        );
      },
    );
  }

  @override
  State<BottomSheetConta> createState() => _BottomSheetContaState();
}

class _BottomSheetContaState extends State<BottomSheetConta> with ThemeMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Alterar contas',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.accounts.map((account) => _buildAccountItem(account)),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: () {
                if (widget.onAddAccount != null) {
                  widget.onAddAccount!();
                }
                Navigator.of(context).pop();
              },
              icon: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              label: Text(
                'Deseja adicionar outra conta?',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildAccountItem(UserAccount account) {
    final isActive = account.id == widget.activeAccountId;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  account.email,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Ativa',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            )
          else
            InkWell(
              onTap: () {
                if (widget.onAccountSelected != null) {
                  widget.onAccountSelected!(account);
                }
                Navigator.of(context).pop();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//todo: mockado para testes front end
class UserAccount {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;

  UserAccount({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
  });
}
