// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Formatting can break multitests, so don't format them.
// dart format off

import "dart:ffi";

final class S2 extends Struct {
  external Pointer<Int8> notEmpty;

  external Struct? s; //# 01: compile-time error
}

void main() {
  S2? s2;
}
