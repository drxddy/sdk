// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Formatting can break multitests, so don't format them.
// dart format off

// Basic test of Symbol class.

main() {
  var x;
  print(x = const Symbol('fisk'));
  try {
    print(const Symbol(0)); //# 01: compile-time error
  } on NoSuchMethodError {
    print('Caught NoSuchMethodError');
  } on TypeError {
    print('Caught TypeError');
  }

  print(const Symbol('0'));
  print(const Symbol('_'));
  print(new Symbol('0'));
  print(new Symbol('_'));

  if (!identical(const Symbol('fisk'), x)) {
    throw 'Symbol constant is not canonicalized';
  }

  if (const Symbol('fisk') != x) {
    throw 'Symbol constant is not equal to itself';
  }

  if (const Symbol('fisk') != new Symbol('fisk')) {
    throw 'Symbol constant is not equal to its non-const equivalent';
  }

  if (new Symbol('fisk') != new Symbol('fisk')) {
    throw 'new Symbol is not equal to its equivalent';
  }

  if (new Symbol('fisk') == new Symbol('hest')) {
    throw 'unrelated Symbols are equal';
  }

  if (new Symbol('fisk') == new Object()) {
    throw 'unrelated objects are equal';
  }

  x.hashCode as int;

  new Symbol('fisk').hashCode as int;

  if (new Symbol('fisk').hashCode != x.hashCode) {
    throw "non-const Symbol's hashCode not equal to its const equivalent";
  }

  if (new Symbol('') != Symbol.empty) {
    throw 'empty Symbol not equals to itself';
  }
}
