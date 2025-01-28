import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/driver.dart';

// Events
abstract class RideEvent {}

class RequestRide extends RideEvent {
  final Driver driver;
  RequestRide(this.driver);
}

// States
abstract class RideState {}

class RideInitial extends RideState {}

class RideRequesting extends RideState {}

class RideAccepted extends RideState {
  final Driver driver;
  RideAccepted(this.driver);
}

class RideError extends RideState {
  final String message;
  RideError(this.message);
}

class RideBloc extends Bloc<RideEvent, RideState> {
  RideBloc() : super(RideInitial()) {
    on<RequestRide>(_onRequestRide);
  }

  Future<void> _onRequestRide(
    RequestRide event,
    Emitter<RideState> emit,
  ) async {
    try {
      emit(RideRequesting());
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      emit(RideAccepted(event.driver));
    } catch (e) {
      emit(RideError(e.toString()));
    }
  }
}
