// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Formatting can break multitests, so don't format them.
// dart format off

// Regression test for the combined use of metatargets and static fields with
// annotations.

import 'dart:mirrors';

class A {
  @reflectable
  var reflectableField = 0; //# 01: ok

  @UsedOnlyAsMetadata()
  var unreflectableField = 1; //# 02: ok

  @reflectable
  static var reflectableStaticField = 2; //# 03: ok

  @UsedOnlyAsMetadata()
  static var unreflectableStaticField = 3;
}

class Reflectable {
  const Reflectable();
}

const Reflectable reflectable = const Reflectable();

class UsedOnlyAsMetadata {
  const UsedOnlyAsMetadata();
}

void main() {
  print(new A());
}
