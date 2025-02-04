import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm/models/forex_pair.dart';
import 'package:fxtm/repositories/forex_repository.dart';

class ForexPairItemBloc extends Bloc<ForexPairItemEvent, ForexPairItemState> {
  ForexPairItemBloc(
      {required ForexRepository forexRepository, required ForexPair forexPair})
      : super(ForexPairItemState(forexPair: forexPair)) {
    on<ForexPairItemChanged>(_onForexPairItemChanged);
    _forexPairsSubscription =
        forexRepository.forexPairs.listen(_onForexPairsChanged);
  }

  late StreamSubscription<List<ForexPair>> _forexPairsSubscription;

  void _onForexPairsChanged(List<ForexPair> forexPairs) {
    final updatedForexPair = forexPairs
        .firstWhereOrNull((pair) => pair.symbol == state.forexPair.symbol);
    if (updatedForexPair != null) {
      add(ForexPairItemChanged(forexPair: updatedForexPair));
    }
  }

  Future<void> _onForexPairItemChanged(
    ForexPairItemChanged event,
    Emitter<ForexPairItemState> emit,
  ) async {
    emit(ForexPairItemState(forexPair: event.forexPair));
  }

  @override
  Future<void> close() {
    _forexPairsSubscription.cancel();
    return super.close();
  }
}

@immutable
sealed class ForexPairItemEvent {
  const ForexPairItemEvent();
}

final class ForexPairItemChanged extends ForexPairItemEvent {
  const ForexPairItemChanged({required this.forexPair});

  final ForexPair forexPair;
}

final class ForexPairItemState {
  const ForexPairItemState({required this.forexPair});

  final ForexPair forexPair;
}
