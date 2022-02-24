import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:india_today_demo/data/models/response/get_all_relative_profile_response/get_all_relative_profile_response.dart';
import 'package:india_today_demo/data/repositories/relative_profile_repository.dart';
import 'package:india_today_demo/utils/network/result_state/result_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'family_profile_event.dart';
part 'family_profile_state.dart';
part 'family_profile_bloc.freezed.dart';

class FamilyProfileBloc extends Bloc<FamilyProfileEvent, FamilyProfileState> {
  FamilyProfileBloc()
      : super(const FamilyProfileState(
            relativesProfileFetchState: ResultState.idle())) {
    on<GetAllProfile>((event, emit) async {
      await _getAllFamilyProfile(emit);
    });
  }

  _getAllFamilyProfile(Emitter<FamilyProfileState> emit) async {
    BotToast.showLoading();
    state.copyWith(relativesProfileFetchState: const ResultState.loading());
    var res = await RelativeProfileRepository.getAllRelativeProfile();
    res.when(success: (v) {
      emit(state.copyWith(
          relativesProfileFetchState: ResultState.data(data: v)));
    }, failure: (v) {
      emit(state.copyWith(
          relativesProfileFetchState: ResultState.error(error: v)));
    });
    BotToast.closeAllLoading();
  }
}
