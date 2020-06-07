import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/state.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GiftAppEvent {
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc});
}

//LoadingGiftAppEvent
class LoadingGiftAppEvent extends GiftAppEvent {
  @override
  String toString() => "LoadingGiftAppEvent";

  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.isLogin = Gift.prefs.get(Gift.loginTokenPref) == null ? false : true;
      bloc.isLoginLoading = false;
      bloc.loginError = "";
      await Future.delayed(Duration(milliseconds: 500));
      return InGiftAppState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

// LoginPageLoading Event

class LoginLoadingEvent extends GiftAppEvent {
  final bool isLoading;
  LoginLoadingEvent(this.isLoading);

  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.isLoginLoading = isLoading;
      return InGiftAppState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

// SetLoginError Event

class SetLoginErrorEvent extends GiftAppEvent {
  final String error;
  SetLoginErrorEvent(this.error);

  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.loginError = error;
      return InGiftAppState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

// SetLoginEvent
class SetLoginEvent extends GiftAppEvent {
  final bool isLogin;
  SetLoginEvent(this.isLogin);

  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.isLogin = isLogin;
      return InGiftAppState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}
