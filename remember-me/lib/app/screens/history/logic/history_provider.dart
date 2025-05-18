import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/app/api/api_service.dart';
import 'package:remember_me/app/screens/history/logic/history_state.dart';

final historyProvider = NotifierProvider<HistoryNotifier, HistoryState>(
  HistoryNotifier.new,
);

class HistoryNotifier extends Notifier<HistoryState> {
  @override
  build() {
    return HistoryState();
  }

  void getHistories() async {
    final result = await ApiService.I.getHistories();

    result.fold(
      onSuccess: (data) {
        state = state.copyWith(histories: data);
      },
      onFailure: (error) {},
    );
  }
}
