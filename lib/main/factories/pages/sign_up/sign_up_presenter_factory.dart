import '../../../factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

SignUpPresenter makeGetxSignUpPresenter() => GetxSignUpPresenter(
      addAccount: makeRemoteAddAccount(),
      validation: makeSignUpValidation(),
      saveCurrentAccount: makeSaveCurrentAccount(),
    );
