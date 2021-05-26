import '../../../factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    validation: makeLoginValidation(),
    authentication: makeRemoteAuthentication(),
    saveCurrentAccount: makeSaveCurrentAccount(),
  );
}
