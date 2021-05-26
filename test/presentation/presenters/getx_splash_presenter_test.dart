import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'getx_splash_presenter_test.mocks.dart';

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
    await sut.checkAccount(durationInSeconds: 0);
    verify(loadCreationAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: AccountEntity(''));
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on error', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount(durationInSeconds: 0);
  });
}
