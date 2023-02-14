// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:irecycle/main.dart';
import 'package:irecycle/testing/postAdviceTest.dart';
import 'package:irecycle/testing/test1.dart';

void main() {
  /* testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

//1
  test('calls test method 1', () {
    var cal = Test1();
    expect(cal.add(1, 2), 3);
  });

  test('calls test method 2', () {
    var cal = Test1();
    expect(cal.add(1, -1), 0);
  });
*/
  //Post advice
  //TC1
  test("Test post advice 1", () {
    var obj = PostAdviceTest();
    String actual = obj.post("Recycle", "g");
    String matcher = "The post is under review by the admin";
    expect(actual, matcher);
  });

  //TC2
  test("Test post advice 2", () {
    var obj = PostAdviceTest();
    String actual = obj.post("", "");
    String matcher = "Empty Fields,\nPlease enter required fields";
    expect(actual, matcher);
  });
}
