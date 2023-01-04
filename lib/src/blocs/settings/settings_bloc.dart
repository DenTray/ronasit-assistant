import 'settings_state.dart';
import '../../models/settings.dart';
import './events/update_rate_event.dart';
import './events/get_settings_event.dart';
import './events/base_settings_event.dart';
import './events/update_locale_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../resources/settings_repository.dart';
import './events/update_working_days_count_event.dart';

class SettingsBlock extends Bloc<BaseSettingsEvent, SettingsState> {
  final _repository = SettingsRepository.getInstance();

  SettingsBlock() : super(SettingsState(null)) {
    on<GetSettingsEvent>((event, emit) async {
      Settings settings = await _repository.getSettings();
      SettingsState state = SettingsState(settings);

      emit(state);
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
  }
}