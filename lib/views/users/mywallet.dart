import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonic_patti/utils/constants.dart';
import 'package:sonic_patti/views/components/appbar.dart';
import 'package:sonic_patti/views/components/cardatm.dart';
import 'package:sonic_patti/views/components/cardslides.dart';
import 'package:sonic_patti/views/pymnts/offline_pymnt_method.dart';
import 'package:sonic_patti/views/pymnts/pymnt_methods.dart';
import 'package:sonic_patti/views/pymnts/transactions.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  late TextEditingController textController;
  final formKey = GlobalKey<FormState>();
  final amounCtltxt = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    amounCtltxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: TopAppBar(istate: 0),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width,
              height: 340,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
                color: Color(0xff113726),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        direction: Axis.vertical,
                        alignment: WrapAlignment.start,
                        children: [
                          Text(
                            'Hello, USER',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.kAtmCardTitle,
                          ),
                          Text(
                            'Good Morning',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.kAtmCardTitle,
                          )
                        ],
                      ),
                    ),
                  ),
                  const BuildATMCard(),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: GestureDetector(
                              onTap: () => Get.to(const TransactionsScreen(),
                                  transition: Transition.downToUp),
                              child: walletButtons(
                                  'Withdraw', Icons.outbond_outlined),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: GestureDetector(
                              onTap: () => Get.to(const TransactionsScreen(),
                                  transition: Transition.downToUp),
                              child: walletButtons(
                                  'Transfer', Icons.play_for_work_outlined),
                            ),
                          ),
                          /*       
                                GestureDetector(
                            onTap: () => Get.to(const TransactionsScreen(),
                                transition: Transition.downToUp),
                            child: walletButtons(
                                'Transfer', Icons.play_for_work_outlined),
                          ), GestureDetector(
                            onTap: () => Get.to(const TransactionsScreen(),
                                transition: Transition.downToUp),
                            child: walletButtons(
                                'History', Icons.auto_stories_outlined),
                          ),
 */
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            addMoney(),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
                color: Color(0xff113726),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    width: Get.width,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return buildCard(index);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 2,
                          );
                        },
                        itemCount: 5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addMoney() {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              width: Get.width * .65,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color.fromRGBO(0, 34, 40, 1),
                border: Border.all(
                  color: const Color.fromRGBO(0, 0, 0, 1),
                  width: 5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(4),
                child: TextFormField(
                  controller: amounCtltxt,
                  onChanged: (_) => EasyDebounce.debounce(
                    'textController',
                    const Duration(milliseconds: 2000),
                    () => setState(() {}),
                  ),
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'ENTER AMOUNT',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    filled: true,
                    fillColor: const Color(0x3CE0E3E7),
                    prefixIcon: Icon(
                      Icons.currency_rupee,
                      color: Colors.blueGrey.shade100,
                    ),
                    suffixIcon: amounCtltxt.text.isNotEmpty
                        ? InkWell(
                            onTap: () => setState(
                              () => amounCtltxt.clear(),
                            ),
                            child: const Icon(
                              Icons.clear,
                              color: Color(0xFFFB0D0D),
                              size: 22,
                            ),
                          )
                        : null,
                  ),
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile Number required!';
                    } else if (value.length != 10) {
                      return '10 digit Mobile Number!';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(const OfflinePaymentMethod(),
                        transition: Transition.downToUp);
                  },
                  child: Container(
                    width: 158,
                    height: 45,
                    decoration: AppStyles.yellowBtn,
                    child: Center(
                      child: Text(
                        'OFFLINE',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.kYellowBtnTitle,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(const PaymentMethods(),
                        transition: Transition.downToUp);
                  },
                  child: Container(
                    width: 158,
                    height: 45,
                    decoration: AppStyles.yellowBtn,
                    child: Center(
                      child: Text(
                        'ONLINE',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.kYellowBtnTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 158,
                    height: 45,
                    decoration: AppStyles.yellowBtn,
                    child: Center(
                      child: Text(
                        'REQUEST FRIEND',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.kYellowBtnTitle,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 158,
                    height: 45,
                    decoration: AppStyles.yellowBtn,
                    child: Center(
                      child: Text(
                        'REDEAM COINS',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.kYellowBtnTitle,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  openMoneyModal(param) {
    return showModalBottomSheet(
        /*  isDismissible: false, */
        backgroundColor: bottomBarBg,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: Get.height * .6,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                    color: bottomBarHeader,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(flex: 2, child: Text('DEPOSITE AMOUNT')),
                      IconButton(
                        onPressed: (() => Get.back()),
                        icon: const Icon(
                          Icons.question_mark_outlined,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: (() => Get.back()),
                        icon: const Icon(
                          Icons.close_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text('data'),
                ),
              ],
            ),
          );
        });
  }

  walletButtons(String? btntext, IconData listOfIcons) {
    return Container(
      height: 68,
      padding: const EdgeInsets.all(4.0),
      decoration: AppStyles.buttonBg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            listOfIcons,
            size: 28,
            color: const Color(0xff3F00FD),
            shadows: const <Shadow>[
              Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset.zero)
            ],
          ),
          Center(
            child: Text(
              btntext!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inter',
                  fontSize: 14,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
        ],
      ),
    );
  }
}
