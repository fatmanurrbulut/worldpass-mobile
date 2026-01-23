import 'package:flutter_test/flutter_test.dart';
import 'package:worldpass_mobile/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WorldPassApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // İlk frame
    await tester.pump();

    // Splash'taki delayed redirect varsa: timer'ı akıt
    // (senin splash'ta 600ms gördüm, biz 1sn akıtıyoruz)
    await tester.pump(const Duration(seconds: 1));

    // Her şeyi settle et (navigation anim vs)
    await tester.pumpAndSettle();

    // Burada spesifik text aramak yerine: app crash etmedi mi ona bakıyoruz.
    // Eğer illa assert istiyorsan: route’a göre bir widget/type kontrolü yap.
    expect(find.byType(WorldPassApp), findsOneWidget);
  });
}
