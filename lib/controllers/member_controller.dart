import 'package:get/get.dart';

import '../data/member_repository.dart';
import '../models/member.dart';

class MemberController extends GetxController {
  MemberController({required MemberRepository repository})
      : _repository = repository;

  final MemberRepository _repository;

  final Rxn<Member> _member = Rxn<Member>();
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString errorMessage = RxnString();
  final Rx<DateTime?> lastUpdated = Rx<DateTime?>(null);

  Member? get member => _member.value;

  bool get hasData => _member.value != null;

  @override
  void onInit() {
    super.onInit();
    loadMember();
  }

  Future<void> loadMember({bool forceRefresh = false}) async {
    if (forceRefresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final result = await _repository.fetchMember(forceRefresh: forceRefresh);
      _member.value = result;
      lastUpdated.value = DateTime.now();
    } catch (error) {
      errorMessage.value =
          'We could not reach the SACCO services. Please try again.';
    } finally {
      if (forceRefresh) {
        isRefreshing.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  Future<void> refreshMember() => loadMember(forceRefresh: true);

  void dismissError() => errorMessage.value = null;
}
