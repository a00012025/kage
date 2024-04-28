import 'dart:math';

import 'package:app/features/common/constants.dart';
import 'package:app/features/home/controllers/user_balance_controller.dart';
import 'package:app/features/home/controllers/user_txs_controller.dart';
import 'package:app/features/home/widgets/app_bar.dart';
import 'package:app/features/home/widgets/total_balance.dart';
import 'package:app/features/home/widgets/tx_history_item.dart';
import 'package:app/features/payment/application/payment_service.dart';
import 'package:app/features/send_token/scan_address_screen.dart';
import 'package:app/utils/app_tap.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/string_utils.dart';
import 'package:app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double expandedHeight = 300;
    double appBarHeight = kToolbarHeight;
    double offset = _scrollController.offset;
    if (offset < 200) {
      _opacity = 0;
      setState(() {});
      return;
    }
    double newOpacity = (offset / (expandedHeight - appBarHeight)).clamp(0, 1);
    // 更新透明度
    setState(() {
      _opacity = newOpacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userTxs = ref.watch(userTxsProvider);
    final userBalance = ref.watch(userBalanceProvider);
    debugPrint('======={userTxs} : $userTxs=========');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: AnimationLimiter(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.read(userBalanceProvider.notifier).updateState();
              ref.read(userTxsProvider.notifier).updateState();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true, // 固定AppBar在顶部
                  surfaceTintColor: Colors.transparent,
                  expandedHeight: 300.0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    title: Opacity(
                      opacity: _opacity,
                      child: userBalance.when(
                          data: (value) => AppBarSmall(balance: value.total),
                          error: (error, _) => const AppBarSmall(balance: 0),
                          loading: () => const AppBarSmall(balance: 0)),
                    ),
                    background: const Column(
                      children: [
                        Gaps.h24,
                        TotalBalanceWidget(),
                        Gaps.h24,
                        SendReceiveBtn(),
                        Gaps.h24,
                      ],
                    ),
                  ),
                ),
                userTxs.when(
                  data: (value) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 150.0,
                              child: TxHistoryItem(value: value[index]),
                            ),
                          );
                        },
                        childCount: value.length,
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  error: (error, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error: $error'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SendReceiveBtn extends StatelessWidget {
  const SendReceiveBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            DefaultButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const QrcodeCard();
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/icons/receive.png',
                  width: 32,
                ),
              ),
            ),
            const Text("Receive"),
          ],
        ),
        Gaps.w24,
        Column(
          children: [
            DefaultButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanAddressScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/icons/send.png',
                  width: 32,
                ),
              ),
            ),
            const Text("Send"),
          ],
        ),
        Gaps.w24,
        Column(
          children: [
            DefaultButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const InvestCard();
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/icons/earn.png',
                  width: 32,
                ),
              ),
            ),
            const Text("Invest"),
          ],
        ),
      ],
    );
  }
}

class InvestCard extends ConsumerStatefulWidget {
  const InvestCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InvestCardState();
}

class _InvestCardState extends ConsumerState<InvestCard> {
  // text input
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userBalance = ref.watch(userBalanceProvider);
    final usdcBalance = userBalance.value?.usdc ?? 0;
    final maxAmount = max(usdcBalance - 0.5, 0);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: _amountController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter amount to invest',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          Gaps.h4,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Max: ',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                '${maxAmount.toStringAsFixed(2)} USDC',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
          Gaps.h24,
          DefaultButton(
            showIcon: true,
            onPressed: () async {
              final amount = double.tryParse(_amountController.text);
              if (amount == null) {
                customToast('Invalid amount');
                return;
              }
              if (amount > maxAmount) {
                customToast('Insufficient balance');
                return;
              }
              await showDialog(
                  context: context,
                  builder: (_) {
                    return InvestingCard(
                      amount: _amountController.text,
                    );
                  });
              ref.read(userBalanceProvider.notifier).updateState();
              ref.read(userTxsProvider.notifier).updateState();
              Navigator.pop(context);
            },
            isDisable: _amountController.text == "",
            text: "Invest",
          ),
        ],
      ),
    );
  }
}

class InvestingCard extends StatefulWidget {
  const InvestingCard({
    super.key,
    required this.amount,
  });

  final String amount;

  @override
  State<InvestingCard> createState() => _InvestingCardState();
}

class _InvestingCardState extends State<InvestingCard> {
  bool isSuccess = false;
  String hash = '';
  @override
  void initState() {
    asyncInit();
    super.initState();
  }

  void asyncInit() async {
    final service = PaymentService();
    hash = await service.sendInvestUserOperation(widget.amount);
    setState(() {
      isSuccess = true;
    });
    debugPrint('=======hash : $hash=========');
  }

  @override
  Widget build(BuildContext context) {
    return SendingTxCard(
      isSuccess: isSuccess,
      hash: hash,
    );
  }
}

class SendingTxCard extends StatelessWidget {
  final bool isSuccess;
  final String hash;

  const SendingTxCard({
    super.key,
    required this.isSuccess,
    required this.hash,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppTap(
        onTap: () {
          Clipboard.setData(ClipboardData(text: hash));
          customToast('Copied to clipboard!');
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSuccess
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 48,
                        )
                      : Image.asset(
                          'assets/icons/ninja_run.gif',
                          width: 200,
                        ),
                  Gaps.h16,
                  Text(
                    isSuccess
                        ? "🥷：Mission Completed! ${hash.toFormattedAddress()}"
                        : "🥷：We're working on it.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QrcodeCard extends StatelessWidget {
  const QrcodeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: PrettyQrView.data(
                data: Constants.simpleAccount.hex,
                decoration: const PrettyQrDecoration(
                  image: PrettyQrDecorationImage(
                    image: AssetImage('assets/icons/usdc.png'),
                  ),
                ),
                errorCorrectLevel: QrErrorCorrectLevel.H),
          ),
          const Text(
            'Only supports Arbitrum USDC now',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Gaps.h8,
          DefaultButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: Constants.simpleAccount.hex),
              );
              customToast(
                'Copied to clipboard!',
              );
            },
            text: "Copy Address",
            showIcon: true,
          ),
        ],
      ),
    );
  }
}
