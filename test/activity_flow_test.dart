import 'package:flutter/material.dart';
import 'package:flutter_laboratory/demo_auth.dart';
import 'package:flutter_laboratory/main.dart';
import 'package:flutter_laboratory/social_media/create_post_sheet.dart';
import 'package:flutter_laboratory/social_media/post_card.dart';
import 'package:flutter_test/flutter_test.dart';

Finder navigationTab(String label) => find.widgetWithText(
      NavigationDestination,
      label,
    );

Future<void> selectTab(WidgetTester tester, String label) async {
  await tester.tap(navigationTab(label));
  await tester.pumpAndSettle();
}

Future<void> signIn(
  WidgetTester tester,
  String username,
  String password,
) async {
  await tester.enterText(find.byType(TextFormField).at(0), username);
  await tester.enterText(find.byType(TextFormField).at(1), password);
  await tester.tap(find.widgetWithText(FilledButton, 'Login'));
  await tester.pumpAndSettle();
}

Future<void> createPost(WidgetTester tester, String caption) async {
  await tester.tap(find.byTooltip('Create Post'));
  await tester.pumpAndSettle();
  final fields = find.descendant(
    of: find.byType(CreatePostSheet),
    matching: find.byType(TextField),
  );
  await tester.enterText(fields.at(0), caption);
  await tester.enterText(
    fields.at(1),
    'https://picsum.photos/id/20/600/400',
  );
  await tester.tap(find.text('Submit Post'));
  await tester.pumpAndSettle();
}

Finder postWithCaption(String caption) =>
    find.ancestor(of: find.text(caption), matching: find.byType(PostCard));

void main() {
  setUp(() {
    DemoAuth.registeredUsername = null;
    DemoAuth.registeredPassword = null;
    DemoAuth.logout();
  });

  testWidgets('login validates fields and rejects incorrect credentials', (
    tester,
  ) async {
    await tester.pumpWidget(const StudentApp());
    expect(find.byType(NavigationBar), findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your username.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await signIn(tester, 'admin', 'incorrect');
    expect(find.text('Invalid username or password.'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(DemoAuth.currentUsername, isNull);
  });

  testWidgets('admin flow preserves each tab and clears routes on logout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(480, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StudentApp());
    await signIn(tester, 'admin', 'admin123');
    expect(find.text('Welcome, admin!'), findsOneWidget);

    await selectTab(tester, 'Calculator');
    final first = find.byType(TextField).at(0);
    final second = find.byType(TextField).at(1);
    await tester.enterText(first, '10');
    await tester.enterText(second, '5');
    await tester.tap(find.widgetWithText(FilledButton, '+'));
    await tester.pumpAndSettle();
    expect(find.text('15.0'), findsOneWidget);

    await selectTab(tester, 'Dashboard');
    await selectTab(tester, 'Calculator');
    expect(tester.widget<TextField>(first).controller!.text, '10');
    expect(tester.widget<TextField>(second).controller!.text, '5');
    expect(find.text('15.0'), findsOneWidget);

    await tester.enterText(first, '20');
    for (final entry
        in {'+': '25.0', '-': '15.0', '×': '100.0', '÷': '4.0'}.entries) {
      await tester.tap(find.widgetWithText(FilledButton, entry.key));
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
    }
    await tester.enterText(second, '0');
    await tester.tap(find.widgetWithText(FilledButton, '÷'));
    await tester.pumpAndSettle();
    expect(find.text('Cannot divide by zero'), findsOneWidget);
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(first).controller!.text, isEmpty);
    expect(tester.widget<TextField>(second).controller!.text, isEmpty);
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '+'));
    await tester.pumpAndSettle();
    expect(find.text('Invalid input'), findsOneWidget);

    await selectTab(tester, 'Social');
    const caption = 'First laboratory post';
    const comment = 'Verified the comment flow.';
    await createPost(tester, caption);
    final card = postWithCaption(caption);
    Finder withinCard(Finder matching) =>
        find.descendant(of: card, matching: matching);
    expect(withinCard(find.text('admin')), findsOneWidget);
    await tester.tap(withinCard(find.text('Like')));
    await tester.enterText(withinCard(find.byType(TextField)), comment);
    await tester.tap(withinCard(find.byTooltip('Send comment')));
    await tester.pumpAndSettle();
    expect(withinCard(find.text('Liked')), findsOneWidget);
    expect(withinCard(find.text(comment)), findsOneWidget);

    await selectTab(tester, 'Calculator');
    await selectTab(tester, 'Social');
    expect(withinCard(find.text('Liked')), findsOneWidget);
    expect(withinCard(find.text(comment)), findsOneWidget);

    await createPost(tester, 'Second laboratory post');
    expect(
      find.descendant(
        of: postWithCaption('Second laboratory post'),
        matching: find.text('Like'),
      ),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      withinCard(find.text(comment)),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(withinCard(find.text('Liked')), findsOneWidget);
    expect(withinCard(find.text(comment)), findsOneWidget);

    await selectTab(tester, 'Profile');
    expect(find.text('Justine Ric Intano'), findsOneWidget);
    expect(find.text('Logged in as: admin'), findsOneWidget);
    expect(find.text('Student ID'), findsOneWidget);
    expect(find.text('Course and Section'), findsOneWidget);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    final login = find.widgetWithText(FilledButton, 'Login');
    expect(login, findsOneWidget);
    expect(DemoAuth.currentUsername, isNull);
    expect(Navigator.of(tester.element(login)).canPop(), isFalse);
  });

  testWidgets('registration validates input and propagates the new username', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(480, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StudentApp());
    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    final register = find.widgetWithText(FilledButton, 'Register');
    await tester.enterText(fields.at(0), 'ab');
    await tester.enterText(fields.at(1), '123');
    await tester.enterText(fields.at(2), '1234');
    await tester.tap(register);
    await tester.pumpAndSettle();
    expect(find.text('Use at least three characters.'), findsOneWidget);
    expect(find.text('Use at least six characters.'), findsOneWidget);
    expect(find.text('Passwords must match.'), findsOneWidget);

    await tester.enterText(fields.at(0), 'Admin');
    await tester.enterText(fields.at(1), 'student123');
    await tester.enterText(fields.at(2), 'student123');
    await tester.tap(register);
    await tester.pumpAndSettle();
    expect(find.text('The username admin is reserved.'), findsOneWidget);

    await tester.enterText(fields.at(0), '  labstudent  ');
    await tester.tap(register);
    await tester.pumpAndSettle();
    expect(
      find.text('Registration successful! You can now log in.'),
      findsOneWidget,
    );
    await signIn(tester, 'labstudent', 'student123');
    expect(find.text('Welcome, labstudent!'), findsOneWidget);
    await selectTab(tester, 'Social');
    await createPost(tester, 'Posted from my registered account.');
    expect(
      find.descendant(
        of: postWithCaption('Posted from my registered account.'),
        matching: find.text('labstudent'),
      ),
      findsOneWidget,
    );
    await selectTab(tester, 'Profile');
    expect(find.text('Logged in as: labstudent'), findsOneWidget);
  });
}
