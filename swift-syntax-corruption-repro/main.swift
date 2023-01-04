import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

func buggy() {
  let array = [1, 2, 3]
  var elements = [ArrayElementSyntax]()
  for element in array {
    // BUG: This causes "[3,3,3,]" to be printed below.
    elements.append(
      ArrayElementSyntax(
        expression: "\(literal: element)" as ExprSyntax,
        trailingComma: .commaToken()))
  }
  let arrayLiteral = ArrayExprSyntax(
    elements: ArrayElementListSyntax(elements))

  print(arrayLiteral)
}

func correct() {
  let array = [1, 2, 3]
  var elements = [ArrayElementSyntax]()
  for element in array {
    // WORKAROUND: Hoisting the node out into its own local
    // variable causes "[1,2,3,]" to be printed below
    // (correct).
    let elementExpr = "\(literal: element)" as ExprSyntax
    elements.append(
      ArrayElementSyntax(
        expression: elementExpr,
        trailingComma: .commaToken()))
  }
  let arrayLiteral = ArrayExprSyntax(
    elements: ArrayElementListSyntax(elements))

  print(arrayLiteral)
}

buggy()
correct()
