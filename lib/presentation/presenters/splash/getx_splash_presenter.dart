import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../presentation/mixins/mixins.dart';
import '../../../shared/routes/routes.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController with NavigationManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      navigateTo = account.token.isEmpty ? AppRoutes.login : AppRoutes.surveys;
    } catch (error) {
      navigateTo = AppRoutes.login;
    }
  }
}
