import '../../../factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

SurveysPresenter makeGetxSurveysPresenter() => GetXSurveysPresenter(
      loadSurveys: makeRemoteLoadSurveysWithLocalFallback(),
    );
