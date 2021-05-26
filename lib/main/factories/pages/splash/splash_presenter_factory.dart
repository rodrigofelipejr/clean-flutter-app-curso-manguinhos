import '../../../factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
}
