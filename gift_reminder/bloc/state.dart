import 'package:meta/meta.dart';

@immutable
abstract class GiftAppState {
  GiftAppState getStateCopy();
}

// *************************************UnGiftAppState****************************
class UnGiftAppState extends GiftAppState {
  @override
  String toString() => "UnGiftAppState";
  @override
  GiftAppState getStateCopy() {
    return UnGiftAppState();
  }
}

// *************************************InGiftAppState****************************
class InGiftAppState extends GiftAppState {
  @override
  String toString() => "InGiftAppState";
  @override
  GiftAppState getStateCopy() {
    return InGiftAppState();
  }
}

// *************************************ErrorGiftAppState****************************
class ErrorGiftAppState extends GiftAppState {
  final String error;

  ErrorGiftAppState(this.error);
  @override
  String toString() => "ErrorGiftAppState";
  @override
  GiftAppState getStateCopy() {
    return ErrorGiftAppState(error);
  }
}

// *************************************InGiftAppDashBoardState****************************
class InGiftAppDashBoardState extends GiftAppState {
  InGiftAppDashBoardState();
  @override
  String toString() => "InGiftAppDashBoardState";
  @override
  GiftAppState getStateCopy() {
    return InGiftAppDashBoardState();
  }
}
