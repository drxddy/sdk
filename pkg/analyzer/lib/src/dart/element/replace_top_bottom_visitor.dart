// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_fe_analyzer_shared/src/type_inference/type_analyzer_operations.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:analyzer/src/dart/element/extensions.dart';
import 'package:analyzer/src/dart/element/type.dart';
import 'package:analyzer/src/dart/element/type_system.dart';

/// Replace every "top" type in a covariant position with [_bottomType].
/// Replace every "bottom" type in a contravariant position with [_topType].
class ReplaceTopBottomVisitor {
  final TypeSystemImpl _typeSystem;
  final DartType _topType;
  final DartType _bottomType;

  ReplaceTopBottomVisitor._(
    this._typeSystem,
    this._topType,
    this._bottomType,
  );

  DartType process(DartType type, Variance variance) {
    if (variance.isContravariant) {
      // ...replacing every occurrence in `T` of a type `S` in a contravariant
      // position where `S <: Never` by `Object?`
      if (_typeSystem.isSubtypeOf(type, NeverTypeImpl.instance)) {
        return _topType;
      }
    } else {
      // ...and every occurrence in `T` of a top type in a position which
      // is not contravariant by `Never`.
      if (_typeSystem.isTop(type)) {
        return _bottomType;
      }
    }

    var alias = type.alias;
    if (alias != null) {
      return _instantiatedTypeAlias(type, alias, variance);
    } else if (type is InterfaceTypeImpl) {
      return _interfaceType(type, variance);
    } else if (type is FunctionType) {
      return _functionType(type, variance);
    }
    return type;
  }

  DartType _functionType(FunctionType type, Variance variance) {
    var newReturnType = process(type.returnType, variance);

    var newParameters = type.formalParameters.map((parameter) {
      return parameter.copyWith(
        type: process(
          parameter.type,
          variance.combine(Variance.contravariant),
        ),
      );
    }).toList();

    return FunctionTypeImpl.v2(
      typeParameters: type.typeParameters,
      formalParameters: newParameters,
      returnType: newReturnType,
      nullabilitySuffix: type.nullabilitySuffix,
    );
  }

  DartType _instantiatedTypeAlias(
    DartType type,
    InstantiatedTypeAliasElement alias,
    Variance variance,
  ) {
    var aliasElement = alias.element2;
    var aliasArguments = alias.typeArguments;

    var typeParameters = aliasElement.typeParameters2;
    assert(typeParameters.length == aliasArguments.length);

    var newTypeArguments = <DartType>[];
    for (var i = 0; i < typeParameters.length; i++) {
      var typeParameter = typeParameters[i] as TypeParameterElementImpl2;
      newTypeArguments.add(
        process(
          aliasArguments[i],
          typeParameter.variance.combine(variance),
        ),
      );
    }

    return aliasElement.instantiate(
      typeArguments: newTypeArguments,
      nullabilitySuffix: type.nullabilitySuffix,
    );
  }

  InterfaceTypeImpl _interfaceType(InterfaceTypeImpl type, Variance variance) {
    var typeParameters = type.element3.typeParameters2;
    if (typeParameters.isEmpty) {
      return type;
    }

    var typeArguments = type.typeArguments;
    assert(typeParameters.length == typeArguments.length);

    var newTypeArguments = <DartType>[];
    for (var i = 0; i < typeArguments.length; i++) {
      var newTypeArgument = process(typeArguments[i], variance);
      newTypeArguments.add(newTypeArgument);
    }

    return InterfaceTypeImpl.v2(
      element: type.element3,
      nullabilitySuffix: type.nullabilitySuffix,
      typeArguments: newTypeArguments,
    );
  }

  /// Runs an instance of the visitor on the given [type] and returns the
  /// resulting type.  If the type contains no instances of Top or Bottom, the
  /// original type object is returned to avoid unnecessary allocation.
  static DartType run({
    required DartType topType,
    required DartType bottomType,
    required TypeSystemImpl typeSystem,
    required DartType type,
  }) {
    var visitor = ReplaceTopBottomVisitor._(typeSystem, topType, bottomType);
    return visitor.process(type, Variance.covariant);
  }
}
