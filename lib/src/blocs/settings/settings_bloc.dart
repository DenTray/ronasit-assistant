import 'settings_state.dart';
import '../../models/settings.dart';
import '../../models/currency.dart';
import './events/update_rate_event.dart';
import './events/get_settings_event.dart';
import './events/base_settings_event.dart';
import './events/update_locale_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './events/update_rate_currency_event.dart';
import './events/update_working_days_count_event.dart';
import '../../resources/repositories/settings_repository.dart';
import '../../resources/repositories/currencies_repository.dart';

class SettingsBloc extends Bloc<BaseSettingsEvent, SettingsState> {
  final _repository = SettingsRepository.getInstance();
  final _currenciesRepository = CurrenciesRepository.getInstance();

  SettingsBloc() : super(SettingsState()) {
    on<GetSettingsEvent>((event, emit) async {
      Settings settings = await _repository.getSettings();
      List<Currency> currencies = await _currenciesRepository.getCurrencies();

      emit(state.copyWith(
        settings: settings,
        currenciesNames: currencies.map((Currency currency) => currency.name).toList()
      ));
    });

    on<UpdateWorkingDaysCountEvent>((event, emit) async {
      await _repository.updateWorkingDaysCount(event.count);

      add(GetSettingsEvent());
    });

    on<UpdateLocaleEvent>((event, emit) async {
      await _repository.updateLocale(event.locale);

      add(GetSettingsEvent());
    });

    on<UpdateRateEvent>((event, emit) async {
      List<String> parsed = state.rate.toString().split('.');

      String? intRate = parsed[0];
      String? decimalPart = parsed[1];

      if (event.intPart != null) {
        intRate = event.intPart;
      }

      if (event.decimalPart != null) {
        decimalPart = event.decimalPart;
      }

      String newRate = '$intRate.$decimalPart';

      if (state.rate.toString() != newRate) {
        await _repository.updateRate(double.parse(newRate));

        add(GetSettingsEvent());
      }
    });

    on<UpdateRateCurrencyEvent>((event, emit) async {
      await _repository.updateRateCurrency(event.index);

      add(GetSettingsEvent());
    });
  }
}