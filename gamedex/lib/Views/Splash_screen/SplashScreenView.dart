import 'package:flutter/material.dart';
import 'package:gamedex/ViewModels/SplashScreenViewModel.dart';
import 'package:gamedex/Views/TabBarScreensViews/HomeScreenView.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenView> with TickerProviderStateMixin {
  late final SplashScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashScreenViewModel();
    _viewModel.init(this, _navigateToHome); // "this" è il TickerProvider
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreenView()),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.precacheLogo(context);
  }

  @override
  void dispose() {
    _viewModel.disposeVM();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _viewModel.progressController,
                  builder: (context, child) {
                    final opacity =
                    _viewModel.computeOpacity(_viewModel.progressController.value);
                    return Opacity(opacity: opacity, child: child);
                  },
                  child: Image(
                    image: _viewModel.logoImage,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) {
                      return const SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(child: Text('GameDex')),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                height: 6,
                child: AnimatedBuilder(
                  animation: _viewModel.progressController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _viewModel.progressController.value,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
