// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'builder.dart';

/// An iterator on [Builder]s that provide the name that they are mapped to.
abstract class NameIterator<T extends Builder> implements Iterator<T> {
  String get name;
}
