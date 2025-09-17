import 'package:get/get.dart';

import '../../controllers/member_controller.dart';
import '../../data/member_repository.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MemberRepository>()) {
      Get.lazyPut<MemberRepository>(
        () => DemoMemberRepository(),
        fenix: true,
      );
    }

    if (!Get.isRegistered<MemberController>()) {
      Get.put(
        MemberController(repository: Get.find<MemberRepository>()),
      );
    }
  }
}
