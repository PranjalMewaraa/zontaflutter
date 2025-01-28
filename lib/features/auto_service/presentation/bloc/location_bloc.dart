import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/repositories/i_location_repository.dart';
import 'dart:async';

// Events
abstract class LocationEvent {}

class InitializeLocation extends LocationEvent {}

class UpdateCurrentLocation extends LocationEvent {
  final LatLng position;
  UpdateCurrentLocation(this.position);
}

// States
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationUpdated extends LocationState {
  final LatLng position;
  LocationUpdated(this.position);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final ILocationRepository _repository;
  StreamSubscription? _locationSubscription;

  LocationBloc(this._repository) : super(LocationInitial()) {
    on<InitializeLocation>(_onInitializeLocation);
    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);
  }

  Future<void> _onInitializeLocation(
    InitializeLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(LocationLoading());
      final position = await _repository.getCurrentLocation();
      emit(LocationUpdated(LatLng(position.latitude, position.longitude)));

      _locationSubscription?.cancel();
      _locationSubscription = _repository.getLocationStream().listen(
        (position) {
          add(UpdateCurrentLocation(
            LatLng(position.latitude, position.longitude),
          ));
        },
      );
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void _onUpdateCurrentLocation(
    UpdateCurrentLocation event,
    Emitter<LocationState> emit,
  ) {
    emit(LocationUpdated(event.position));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
