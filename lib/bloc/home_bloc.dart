import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm/models/forex_pair.dart';
import 'package:fxtm/repositories/forex_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required ForexRepository forexRepository})
      : _forexRepository = forexRepository,
        super(HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
  }

  final ForexRepository _forexRepository;

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final forexPairs = await _forexRepository.getForexPairs();
      _forexRepository.subscribeToForexTrades(
          forexPairs.map((pair) => pair.symbol).toList());
      emit(HomeLoaded(forexPairs));
    } catch (e) {
      emit(const HomeError());
    }
  }
}

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded(this.forexPairs);

  final List<ForexPair> forexPairs;
}

final class HomeError extends HomeState {
  const HomeError();
}
