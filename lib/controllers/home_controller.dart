import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sonic_patti/models/bids_modal.dart';
import 'package:sonic_patti/models/games_model.dart';
import 'package:sonic_patti/utils/constants.dart';

import '../models/catagory_model.dart';
import '../services/api.dart';

class HomeController extends GetxController {
  RxBool permissions = false.obs;
  var tabIndex = 0.obs;
  ScrollController scrollController = ScrollController();
  RxBool isVisible = true.obs;

  ////////////////////
  final RxList<BidsModal> bids = RxList<BidsModal>([]);
  late BidsModal bidsModal;
  var bid = 0.obs;

/*   String matchID = Constant.box.read('matchID');
  String betType = Constant.box.read('betType'); */

  addBid(String bidVal, String bidamnt) {
    final index = bids.indexWhere((element) => element.bidNum == bidVal);
    if (index >= 0) {
      Get.snackbar('Alert', 'Already added',
          duration: const Duration(seconds: 1),
          shouldIconPulse: true,
          backgroundColor: Colors.amber);
    } else {
      bidsModal = BidsModal(bidNum: bidVal, bidAmnt: bidamnt);
      bids.add(bidsModal);
      bid.value = bids.length;
    }
  }

  void removeBids(int index) {
    bids.removeAt(index);
    bid.value = bids.length;
  }

  get itemsAll => bids;

  void formSubmit() async {
    if (Constant.box.read('matchID') != '' &&
        Constant.box.read('betType') != '') {
      if (itemsAll.length > 0) {
        var bidsData = bids.map((item) {
          return {
            "matchId": Constant.box.read('matchID'),
            "betType": Constant.box.read('betType'),
            "mobile": '8013738089',
            "date": DateFormat('dd-MM-yyyy').format(currentTime),
            "time": DateFormat('HH:mm').format(currentTime),
            "Amount": item.bidAmnt,
            "BidValue": item.bidNum,
          };
        }).toList();
        String selectedBids = json.encode(bidsData);
        print(selectedBids);
        bids.clear();
        bid.value = bids.length;
      } else {
        Get.snackbar('Alert', "No Bids selected!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1));
      }
    } else {
      Get.snackbar('title', 'No data found');
    }
  }

  /*
        "{
    action: betplace,
    day: monday,
    matchId:FFGC1,
    betType: SingleDigit/SinglePanna/DoublePanna/TripplePanna/cp,
    betVal:betnumbers (ie: 123),
    betAmnt: 'bet amount in INR 0.00',
    mobile:'user mobile no',
    date:'DD-MM-YYYY',
    time:HH:MM (it will be match time in hour in 24, minutes)
}"
*/

  var catLists = <Catlists>[].obs;
  var isDataProcessing = false.obs;
  var gameLists = <GameLists>[].obs;
  var isGameDataProcessing = false.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    fetchCatagories();
    super.onInit();
  }

  @override
  void onReady() {
    scrollCtlr();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  scrollCtlr() {
    scrollController.addListener(() {
      final ScrollDirection direction =
          scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        isVisible.value = true;
      } else if (direction == ScrollDirection.reverse) {
        isVisible.value = false;
      }
    });
  }

  void fetchCatagories() async {
    try {
      isDataProcessing(true);
      var cats = await RemoteApi.fetchCatagory('game_cat', 'monday');
      catLists.clear();
      if (cats != null) {
        isDataProcessing(false);
        catLists.assignAll(cats);
      }
    } finally {
      isDataProcessing(false);
    }
  }

  void gameRefresh() {
    gameLists.refresh(); //clear();
  }

  void fetchGameLists(String? catId) async {
    try {
      isGameDataProcessing(true);
      var games =
          await RemoteApi.fetchGameLists('game_list', 'saturday', catId!);
      gameLists.clear();
      gameLists.refresh();
      if (games != null) {
        isGameDataProcessing(false);
        gameLists.assignAll(games);
      }
    } finally {
      isGameDataProcessing(false);
    }
  }
}
