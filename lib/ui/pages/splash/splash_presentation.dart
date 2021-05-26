abstract class SplashPresenter {
  Stream<String?> get navigateToStream; //NOTE - nem deveria ter a possibilidade de receber null
  Future<void> checkAccount({int durationInSeconds});
}
