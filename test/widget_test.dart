// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:irecycle/testing/testCases.dart';

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
  test("Test post advice valid", () {
    var obj = PostAdviceTest();
    String actual =
        obj.post("Recycle", "1ae763f7-79dc-4044-b07d-01ab9214b830.png");
    String matcher = "The post is under review by the admin";
    expect(actual, matcher);
  });

  //TC2
  test("Test post advice invalid", () {
    var obj = PostAdviceTest();
    String actual = obj.post("", "");
    String matcher = "Empty Fields,\nPlease enter required fields";
    expect(actual, matcher);
  });

///////////////////////////////////
//Edit advice
  //TC1
  test("Test edit advice valid", () {
    var obj = EditAdviceTest();
    String actual = obj.edit("Reuse");
    String matcher = "The post is under review by the admin";
    expect(actual, matcher);
  });

  //TC2
  test("Test edit advice invalid", () {
    var obj = EditAdviceTest();
    String actual = obj.edit("");
    String matcher = "Empty Fields,\nPlease enter required fields";
    expect(actual, matcher);
  });

  //Add Category

  //TC1
  test("Add category advice valid", () {
    var obj = AddCategoryTest();
    String actual =
        obj.addCat("Plastic", "1ae763f7-79dc-4044-b07d-01ab9214b830.png");
    String matcher = "The category has been added successfully";
    expect(actual, matcher);
  });

  //TC2
  test("Add category advice invalid", () {
    var obj = AddCategoryTest();
    String actual = obj.addCat("", "");
    String matcher = "Empty Fields,\nPlease enter required fields";
    expect(actual, matcher);
  });

  //Text recognition
  //TC1
  test("Text recognition valid", () {
    var obj = CodeRecTest();
    String actual = obj.takeImage("8BABA77D-4D45-4455-B2AA-E7346F29DB8A.png");
    String matcher = "This is PETE";
    expect(actual, matcher);
  });

  //TC2
  test("Text recognition invalid", () {
    var obj = CodeRecTest();
    String actual = obj.takeImage("");
    String matcher = "Empty Fields,\nPlease enter required fields";
    expect(actual, matcher);
  });

//Accept/Decline

  //TC1
  test("Accept advice ", () {
    var obj = AcceptDeclineTest();
    String actual = obj.updateStatus("True");
    String matcher = "The post has been accepted successfully";
    expect(actual, matcher);
  });

  //TC2
  test("Decline advice ", () {
    var obj = AcceptDeclineTest();
    String actual = obj.updateStatus("False");
    String matcher = "The post has been declined successfully";
    expect(actual, matcher);
  });
}
