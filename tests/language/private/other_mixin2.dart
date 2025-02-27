// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Dart test for testing access to private fields on mixins.

library private_mixin2_other;

mixin class C1 {
  int _field = 42;
}

class C2 extends Object with C1 {
  int get field => _field;
}
