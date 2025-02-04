import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm/bloc/home_bloc.dart';
import 'package:fxtm/widgets/forex_pair_item.dart';

import '../repositories/forex_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This menu item is disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FXTM Forex Tracker'),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(
          forexRepository: RepositoryProvider.of<ForexRepository>(context),
        )..add(const HomeStarted()),
        child: const HomePageBody(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final forexPairs = state.forexPairs;
        return ListView.separated(
          itemCount: forexPairs.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => ForexPairItem(
              key: Key(state.forexPairs[index].symbol),
              forexPair: forexPairs[index]),
        );
      },
    );
  }
}
