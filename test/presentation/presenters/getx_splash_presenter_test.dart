import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:get/state_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/splash/splash.dart';
import 'package:fordev/domain/usecases/load_current_account/load_current_account.dart';

import 'getx_splash_presenter_test.mocks.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  var _navigateTo = RxnString();

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount() async {
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account.token.isEmpty ? '/login' : '/surveys';
    } catch (e) {
      print(e);
      _navigateTo.value = '/login';
    }
  }
}

@GenerateMocks([], customMocks: [
  MockSpec<LoadCurrentAccount>(as: #LoadCreationAccountMock, returnNullOnMissingStub: true),
])
main() {
  late GetxSplashPresenter sut;
  late LoadCreationAccountMock loadCreationAccount;

  PostExpectation mockLoadCurrentAccountCall() => when(loadCreationAccount.load());

  void mockLoadCurrentAccount({required AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCreationAccount = LoadCreationAccountMock();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCreationAccount);
    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount();
    verify(loadCreationAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount();
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: AccountEntity(''));
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });

  test('Should go to login page on error', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });
}
