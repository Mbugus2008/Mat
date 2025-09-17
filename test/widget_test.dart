import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:mat_app/app/app.dart';
import 'package:mat_app/controllers/member_controller.dart';
import 'package:mat_app/data/member_repository.dart';

void main() {
  setUp(() async {
    await Get.reset();
    Get.testMode = true;
    final repository = DemoMemberRepository();
    Get.put<MemberRepository>(repository);
    Get.put(MemberController(repository: repository));
  });

  tearDown(() async => Get.reset());

  testWidgets('Member dashboard renders key sections', (tester) async {
    await tester.pumpWidget(const MatApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Jane Muthoni'), findsOneWidget);
    expect(find.text('Fleet (3)'), findsOneWidget);
    expect(find.text('Loans (2)'), findsOneWidget);
    expect(find.textContaining('Member No.'), findsWidgets);
    expect(find.textContaining('Vehicle Upgrade Facility'), findsOneWidget);
    expect(find.textContaining('Working Capital Boost'), findsOneWidget);

    await tester.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Account snapshot'), findsOneWidget);
  });
}
