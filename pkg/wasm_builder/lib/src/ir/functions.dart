// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../builder/module.dart';
import '../serialize/serialize.dart';
import 'ir.dart';

part 'function.dart';

/// The interface for the functions in a module.
class Functions {
  /// The start function.
  final BaseFunction? start;

  /// Imported functions.
  final List<ImportedFunction> imported;

  /// Defined functions.
  final List<DefinedFunction> defined;

  /// Declared functions.
  final List<BaseFunction> declared;

  /// Named functions.
  final int namedCount;

  Functions(
      this.start, this.imported, this.defined, this.declared, this.namedCount);
}
