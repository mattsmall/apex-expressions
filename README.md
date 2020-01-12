# apex-expressions

Boolean expression interpreter written in Salesforce Apex.

This allows you to apply a boolean expression to a Salesforce SObject and determine if the object matches the expression. Can be used to filter SObjects from query results.

Based on the work of: https://github.com/unnikkedga/BooleanExpressionEvaluator

https://unnikked.ga/how-to-build-a-boolean-expression-evaluator-518e9e068a65#.ikpb9mm6h

This repo is set up as an SFDX project but it should be easy just to pull in https://github.com/mattsmall/apex-expressions/blob/master/force-app/main/default/classes/ExpressionInterpreter.cls and its test class https://github.com/mattsmall/apex-expressions/blob/master/force-app/main/default/classes/ExpressionInterpreterTest.cls.

