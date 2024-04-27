import 'package:app/features/common/constants.dart';
import 'package:app/features/home/controllers/user_balance_controller.dart';
import 'package:app/features/home/controllers/user_controller.dart';
import 'package:app/features/home/controllers/user_txs_controller.dart';
import 'package:app/features/home/domain/jumping_dot.dart';
import 'package:app/features/home/domain/tx_data.dart';
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
    final userData = ref.watch(userDataControllerProvider);
    final userTxs = ref.watch(userTxsProvider);
    final userBalance = ref.watch(userBalanceProvider);
    debugPrint('======={userData} : $userData=========');
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
                          data: (value) => AppBarSmall(balance: value),
                          error: (error, _) => const AppBarSmall(balance: 0),
                          loading: () => const AppBarSmall(balance: 0)),
                    ),
                    background: const Column(
                      children: [
                        Gaps.h32,
                        TotalBalanceWidget(),
                        Gaps.h32,
                        SendReceiveBtn(),
                        Gaps.h32,
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
                              child: TxHistoryItem(
                                value: value[index],
                              ),
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

class TxHistoryItem extends StatelessWidget {
  TxHistoryItem({
    super.key,
    required this.value,
  });

  final TxData value;

  final emojis = [
    '🥷',
    '👨‍🚀',
    '👨‍🚒',
    '👨‍🎨',
    '👨‍🎤',
    '👨‍🏫',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: AppTap(
        onTap: () {
          Clipboard.setData(
            ClipboardData(
              text: value.counterParty,
            ),
          );
          customToast(
            'Copied to clipboard!',
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  emojis[value.counterParty.hashCode % emojis.length],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 24,
                      ),
                ),
              ),
              Gaps.w16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.balanceChange > 0 ? 'Received' : 'Sent',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value.counterParty.toFormattedAddress(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value.balanceChange.toStringAsFixed(2),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.w4,
                    Image.asset('assets/icons/usdc.png', width: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarSmall extends StatelessWidget {
  const AppBarSmall({super.key, required this.balance});

  final double balance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          const Spacer(),
          Text(
            balance.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Gaps.w12,
          Image.asset('assets/icons/usdc.png', width: 24),
        ],
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
            const Text("Invest"),
          ],
        ),
      ],
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
          Gaps.h24,
          DefaultButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: Constants.simpleAccount.hex,
                ),
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

class TotalBalanceWidget extends ConsumerWidget {
  const TotalBalanceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBalance = ref.watch(userBalanceProvider);

    return Column(
      children: [
        Text(
          '🥷 Total Balance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Gaps.h24,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/usdc.png',
              width: 28,
            ),
            Gaps.w8,

            //richText with decimal
            userBalance.when(
              data: (value) {
                final balance = value.toStringAsFixed(2);
                return RichText(
                  text: TextSpan(
                    text: balance.split('.')[0],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: balance.split('.').length > 1
                            ? '.${balance.split('.')[1]}'
                            : '.00',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                      ),
                      TextSpan(
                        text: 'USDC',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                );
              },
              loading: () {
                return const SizedBox(
                  width: 32.0,
                  height: 52.0,
                  child: JumpingDotIndicator(
                    duration: Duration(milliseconds: 300),
                  ),
                );
              },
              error: (error, _) => Text('Error: $error'),
            ),
          ],
        ),
      ],
    );
  }
}
