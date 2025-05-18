import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remember_me/app/screens/history/logic/history.dart';

part 'history_state.freezed.dart';
part 'history_state.g.dart';

@freezed
class HistoryState with _$HistoryState {
  factory HistoryState({@Default([]) List<History> histories}) = _HistoryState;

  factory HistoryState.fromJson(Map<String, dynamic> json) =>
      _$HistoryStateFromJson(json);
}
