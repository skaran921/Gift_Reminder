import 'package:bloc/bloc.dart';
import 'package:gift_reminder/bloc/state.dart';

import 'events.dart';

class GiftAppBloc extends Bloc<GiftAppEvent, GiftAppState> {
  static final GiftAppBloc _giftAppBloc = GiftAppBloc.internal();

  factory GiftAppBloc() {
    return _giftAppBloc;
  }

  GiftAppBloc.internal();

  // var
  bool isLoginLoading = false;
  bool isLogin = false;
  bool isDarkMode = false;
  String loginError = "";
  @override
  GiftAppState get initialState => UnGiftAppState();

  @override
  Stream<GiftAppState> mapEventToState(
    GiftAppEvent event,
  ) async* {
    try {
      yield UnGiftAppState();
      await event.applyAsyncEvent(bloc: this, currentState: currentState);
    } catch (error) {
      print(error);
      yield ErrorGiftAppState(error);
    }
  }
}
