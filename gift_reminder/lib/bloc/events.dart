import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/state.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/service/transaction.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GiftAppEvent {
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc});
}

// *****************login page bloc*******************

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

// *****************add transaction page bloc*******************

// SetTransactionPageLoadingEvent
class SetTransactionPageLoadingEvent extends GiftAppEvent {
  final bool isLoading;
  SetTransactionPageLoadingEvent(this.isLoading);

  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.isAddTransactionPageLoading = isLoading;
      return InGiftAppState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

// SetBookValueEvent
class SetBookValueEvent extends GiftAppEvent {
  final String bookValue;
  SetBookValueEvent(this.bookValue);

  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.bookValue = bookValue ?? "";
      return InGiftAppState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

// *****************dashboard page bloc*******************

// DashboardPageLoadingEvent
class DashboardPageLoadingEvent extends GiftAppEvent {
  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.isDashBoardPageLoading = true;
      bloc.hasDashBoardPageError = false;
      bloc.dashboardPageErrorString = "";
      await TransactionService.getTransaction(adminId: AdminToken.adminId)
          .then((value) {
        if (value["error"] == "X") {
          bloc.hasDashBoardPageError = true;
          bloc.dashboardPageErrorString = value["msg"];
        } else {
          bloc.hasDashBoardPageError = false;
          bloc.dashboardPageErrorString = "";
          bloc.allTransaction = value["results"];
        }
      });
      bloc.isDashBoardPageLoading = false;
      return InGiftAppDashBoardState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

//  SetTransactionData Evvent
class SetTransactionDataEvent extends GiftAppEvent {
  final List transactionData;
  SetTransactionDataEvent(this.transactionData);

  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.allTransaction = transactionData ?? [];
      return InGiftAppDashBoardState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

//  AddTransactionData Evvent
class AddTransactionDataEvent extends GiftAppEvent {
  final Map transactionData;
  AddTransactionDataEvent(this.transactionData);
  @override
  Future applyAsyncEvent({GiftAppState currentState, GiftAppBloc bloc}) async {
    try {
      bloc.allTransaction.insert(0, transactionData);
      return InGiftAppDashBoardState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

//  removeTransactionData Evvent
class RemoveTransactionDataEvent extends GiftAppEvent {
  final int transactionIndex;

  RemoveTransactionDataEvent(
    this.transactionIndex,
  );
  @override
  Future applyAsyncEvent({
    GiftAppState currentState,
    GiftAppBloc bloc,
  }) async {
    try {
      bloc.allTransaction.removeAt(transactionIndex);
      bloc.isRemoveTransactionLoading = false;
      return InGiftAppDashBoardState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

// isRemoveTransactionLoading Event
class IsRemoveTransactionLoadingEvent extends GiftAppEvent {
  final bool isLoading;

  IsRemoveTransactionLoadingEvent(this.isLoading);

  @override
  Future applyAsyncEvent({
    GiftAppState currentState,
    GiftAppBloc bloc,
  }) async {
    try {
      bloc.isRemoveTransactionLoading = isLoading;
      return InGiftAppDashBoardState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

//  updateTransactionData Event
class UpdateTransactionData extends GiftAppEvent {
  final int transactionIndex;
  final Map transactionData;
  UpdateTransactionData(
    this.transactionIndex,
    this.transactionData,
  );
  @override
  Future applyAsyncEvent({
    GiftAppState currentState,
    GiftAppBloc bloc,
  }) async {
    try {
      bloc.allTransaction[transactionIndex] = transactionData;
      bloc.isUpdateTransactionLoading = false;
      return InGiftAppDashBoardState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

// isUpdateTransactionLoadingEvent Event
class IsUpdateTransactionLoadingEvent extends GiftAppEvent {
  final bool isLoading;

  IsUpdateTransactionLoadingEvent(this.isLoading);

  @override
  Future applyAsyncEvent({
    GiftAppState currentState,
    GiftAppBloc bloc,
  }) async {
    try {
      bloc.isUpdateTransactionLoading = isLoading;
      return InGiftAppDashBoardState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}

// **************************EditProfile********************
// isEditProfileLoading Event
class IsEditProfileLoadingEvent extends GiftAppEvent {
  final bool isLoading;

  IsEditProfileLoadingEvent(this.isLoading);

  @override
  Future applyAsyncEvent({
    GiftAppState currentState,
    GiftAppBloc bloc,
  }) async {
    try {
      bloc.isEditProfileLoading = isLoading;
      return InGiftAppDashBoardState();
    } catch (error) {
      return ErrorGiftAppState(error);
    }
  }
}
