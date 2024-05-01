import 'package:app/extension/context_extension.dart';
import 'package:app/features/common/single_page_custom_scaffold.dart';
import 'package:app/features/home/controllers/user_wallet_controller.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showPrivateKeyProvider =
    StateProvider.autoDispose<bool>((ref) => true); // Initially hidden

class ExportWalletScreen extends ConsumerWidget {
  const ExportWalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletData = ref.watch(userWalletProvider);
    final showPrivateKey = ref.watch(showPrivateKeyProvider);
    final toShow = walletData.when(
      data: (data) =>
          data.mnemonic ??
          (data.privateKey.startsWith('0x')
              ? data.privateKey
              : '0x${data.privateKey}'),
      loading: () => '',
      error: (e, s) => '',
    );
    return SinglePageCustomScaffold(
      isModalStyle: true,
      height: context.height * 0.88,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              walletData.when(
                data: (data) => data.mnemonic != null
                    ? 'Your Recovery Phrase'
                    : 'Your Private Key',
                loading: () => 'Loading...',
                error: (e, s) => 'Error',
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.h32,
            walletData.when(
              data: (data) => SizedBox(
                width: context.width * 0.85,
                child: SelectableText(
                  showPrivateKey ? '•' * toShow.length : toShow,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Error: $e'),
            ),
            const Expanded(child: SizedBox.shrink()),
            DefaultButton(
              onPressed: () {
                ref
                    .read(showPrivateKeyProvider.notifier)
                    .update((state) => !state);
              },
              text: showPrivateKey ? 'Display' : 'Hide',
              shimmer: false,
            ),
            Gaps.h12,
            DefaultButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: toShow));
                customToast(
                  'Copied to clipboard!',
                );
              },
              text: 'Copy',
              shimmer: false,
              textStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.black),
              backgroundColor: Colors.white,
              borderColor: Colors.black38,
            ),
            Gaps.h24,
          ],
        ),
      ),
    );
  }
}
