import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm/bloc/forex_pair_item_bloc.dart';
import 'package:fxtm/models/forex_pair.dart';
import 'package:fxtm/pages/history_page.dart';
import 'package:fxtm/repositories/forex_repository.dart';

class ForexPairItem extends StatelessWidget {
  const ForexPairItem({super.key, required this.forexPair});

  final ForexPair forexPair;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForexPairItemBloc(
        forexRepository: RepositoryProvider.of<ForexRepository>(context),
        forexPair: forexPair,
      ),
      child: const _ForexPairItemView(),
    );
  }
}

class _ForexPairItemView extends StatelessWidget {
  const _ForexPairItemView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForexPairItemBloc, ForexPairItemState>(
      builder: (context, state) {
        final pair = state.forexPair;
        final isPriceUp = pair.change >= 0;
        final arrowIcon = isPriceUp ? Icons.arrow_upward : Icons.arrow_downward;
        final arrowColor = isPriceUp ? Colors.green : Colors.red;

        return ListTile(
          leading: Icon(arrowIcon, color: arrowColor),
          title: Text(
            pair.symbol,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
            'Price: ${pair.currentPrice.toStringAsFixed(4)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${pair.change >= 0 ? '+' : ''}${pair.change.toStringAsFixed(4)}',
                style: TextStyle(
                  color: arrowColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${pair.percentChange >= 0 ? '+' : ''}${pair.percentChange.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: arrowColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryPage(forexPair: pair),
              ),
            );
          },
        );
      },
    );
  }
}
