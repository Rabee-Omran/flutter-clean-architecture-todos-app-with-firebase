part of 'internet_monitor_bloc.dart';

abstract class InternetMonitorState extends Equatable {
  const InternetMonitorState();

  @override
  List<Object> get props => [];
}

class InternetConnectionLoading extends InternetMonitorState {}

class InternetConnectionConnected extends InternetMonitorState {
  final InternetConnectionStatus? internetConnectionStatus;

  InternetConnectionConnected({required this.internetConnectionStatus});
}

class InternetConnectionDisconnected extends InternetMonitorState {}
