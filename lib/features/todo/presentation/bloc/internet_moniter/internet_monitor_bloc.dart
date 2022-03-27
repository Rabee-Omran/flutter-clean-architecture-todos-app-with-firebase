// ignore_for_file: cancel_subscriptions, invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_monitor_event.dart';
part 'internet_monitor_state.dart';

class InternetMonitorBloc
    extends Bloc<InternetMonitorEvent, InternetMonitorState> {
  final InternetConnectionChecker? internetConnectionChecker;
  StreamSubscription? internetConnectionStreamSubscription;
  InternetMonitorBloc({required this.internetConnectionChecker})
      : super(InternetConnectionLoading()) {
    on<InternetMonitorEvent>((event, emit) async {
      internetConnectionStreamSubscription =
          InternetConnectionChecker().onStatusChange.listen((status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            emitInternetConnectionConnected(InternetConnectionStatus.connected);
            break;
          case InternetConnectionStatus.disconnected:
            emitInternetConnectionDisconnected();
            break;
        }
      });
    });
  }
  void emitInternetConnectionConnected(
          InternetConnectionStatus _internetConnectionStatus) =>
      emit(InternetConnectionConnected(
          internetConnectionStatus: _internetConnectionStatus));

  void emitInternetConnectionDisconnected() =>
      emit(InternetConnectionDisconnected());

  @override
  Future<void> close() async {
    internetConnectionStreamSubscription!.cancel();
    return super.close();
  }
}
