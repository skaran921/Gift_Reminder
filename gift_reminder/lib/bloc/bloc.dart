import 'package:bloc/bloc.dart';
import 'package:gift_reminder/bloc/state.dart';

import 'events.dart';

class GiftAppBloc extends Bloc<GiftAppEvent, GiftAppState> {
  static final GiftAppBloc _giftAppBloc = GiftAppBloc.internal();

  factory GiftAppBloc() {
    return _giftAppBloc;
  }

  GiftAppBloc.internal();

  // login page var
  bool isLoginLoading = false;
  bool isLogin = false;
  bool isDarkMode = false;
  String loginError = "";

  // add transaction page var
  bool isAddTransactionPageLoading = false;
  String bookValue = "";

  // dashboard page var
  List allTransaction = [];
  bool isDashBoardPageLoading = false;
  bool hasDashBoardPageError = false;
  bool isRemoveTransactionLoading = false;
  bool isUpdateTransactionLoading = false;
  String dashboardPageErrorString = "";

  // edit profile page
  bool isEditProfileLoading = false;

  @override
  GiftAppState get initialState => UnGiftAppState();

  @override
  Stream<GiftAppState> mapEventToState(
    GiftAppEvent event,
  ) async* {
    try {
      yield UnGiftAppState();
      yield await event.applyAsyncEvent(bloc: this, currentState: currentState);
    } catch (error) {
      print(error);
      yield ErrorGiftAppState(error);
    }
  }
}
