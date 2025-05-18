import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';
part 'home_state.g.dart';

enum HomeTabs { record, answer }

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(false) bool isUploading,
    @Default(HomeTabs.record) HomeTabs selectedTab,
  }) = _HomeState;

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);
}
