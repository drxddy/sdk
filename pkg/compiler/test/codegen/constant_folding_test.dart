// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test constant folding on numbers.

import 'package:expect/async_helper.dart';
import 'package:expect/expect.dart';
import '../helpers/compiler_helper.dart';

const String NUMBER_FOLDING = """
void main() {
  var a = 4;
  var b = 3;
  print(a + b);
}
""";

const String NEGATIVE_NUMBER_FOLDING = """
void main() {
  var a = 4;
  var b = -3;
  print(a + b);
}
""";

const String NULL_EQUALS_FOLDING = """
foo(a, b, c, d) {
  if (a == null) return 1;
  if (null == b) return 2;
  if (4 == c) return 3;
  if ("foo" == d) return 3;
}
""";

const String LIST_LENGTH_FOLDING = """
foo() {
  return const [1, 2, 3].length;
}
""";

const String STRING_LENGTH_FOLDING = """
foo() {
  return '123'.length;
}
""";

const String LIST_INDEX_FOLDING = """
foo() {
  return const [1, 2, 3][0];
}
""";

const String RANGE_ERROR_INDEX_FOLDING = """
foo() {
  return [1][1];
}
""";

main() {
  runTests() async {
    await compileAndMatch(NUMBER_FOLDING, 'main', RegExp(r"print\(7\)"));
    await compileAndMatch(
      NEGATIVE_NUMBER_FOLDING,
      'main',
      RegExp(r"print\(1\)"),
    );
    await compile(
      NULL_EQUALS_FOLDING,
      entry: 'foo',
      check: (String generated) {
        RegExp regexp = RegExp(r'a == null');
        Expect.isTrue(
          regexp.hasMatch(generated),
          'No match found for ${regexp}',
        );

        regexp = RegExp(r'b == null');
        Expect.isTrue(
          regexp.hasMatch(generated),
          'No match found for ${regexp}',
        );

        regexp = RegExp(r'4 === c');
        Expect.isTrue(
          regexp.hasMatch(generated),
          'No match found for ${regexp}',
        );

        regexp = RegExp('"foo" === d');
        Expect.isTrue(
          regexp.hasMatch(generated),
          'No match found for ${regexp}',
        );
      },
    );
    await compileAndMatch(LIST_LENGTH_FOLDING, 'foo', RegExp(r"return 3"));
    await compileAndMatch(LIST_INDEX_FOLDING, 'foo', RegExp(r"return 1"));
    await compileAndDoNotMatch(LIST_INDEX_FOLDING, 'foo', RegExp(r"ioore"));
    await compileAndMatch(STRING_LENGTH_FOLDING, 'foo', RegExp(r"return 3"));
    await compileAndMatch(RANGE_ERROR_INDEX_FOLDING, 'foo', RegExp(r"ioore"));
  }

  asyncTest(() async {
    print('--test from kernel------------------------------------------------');
    await runTests();
  });
}
