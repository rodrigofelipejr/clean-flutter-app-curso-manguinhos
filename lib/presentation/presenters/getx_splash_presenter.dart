import 'package:get/get.dart';

import '../../shared/routes/routes.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  var _navigateTo = RxnString();

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account.token.isEmpty ? AppRoutes.login : AppRoutes.surveys;
    } catch (error) {
      _navigateTo.value = AppRoutes.login;
    }
  }
}
