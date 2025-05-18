import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/app/api/api_service.dart';
import 'package:remember_me/app/provider/user/user.dart';

final userProvider = NotifierProvider<UserProvider, User>(UserProvider.new);

class UserProvider extends Notifier<User> {
  @override
  build() {
    return User(
      id: -1,
      email: '',
      firebase_uid: '',
      display_name: '',
      created_at: '',
    );
  }

  void getUser() async {
    final response = await ApiService.I.getUser();
    response.fold(
      onSuccess: (user) {
        state = user;
      },
      onFailure: (error) {},
    );
  }
}
