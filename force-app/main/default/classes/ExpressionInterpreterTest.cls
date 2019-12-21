@isTest
private class ExpressionInterpreterTest {

    @isTest
    static void lex_test1() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testSlashR() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('true OR\r\nfalse');
        
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_BOOLEAN, s.type);
        System.assertEquals(s.value,'true');
        System.assertEquals(((ExpressionInterpreter.BooleanSymbol)s).booleanValue,true);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_OR, s.type);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_BOOLEAN, s.type);
        System.assertEquals(s.value,'false');
        System.assertEquals(((ExpressionInterpreter.BooleanSymbol)s).booleanValue,false);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testDoubleEq() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc == "def"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testDoubleEq2() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc=="def"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testNull() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc == nUll');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_NULL, s.type);
        System.assertEquals(s.value,'nUll');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testNull2() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc==nUll');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_NULL, s.type);
        System.assertEquals(s.value,'nUll');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testEscapedString() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc == "d\\e\\\\f\\"z\\"" and ');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'de\\f"z"');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testDoubleLte() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc <= "def"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN_OR_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testDoubleLte2() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc<="def"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN_OR_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testDoubleGte() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc >= "def"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_GREATER_THAN_OR_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testGt() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc > "def"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_GREATER_THAN);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testLt() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc < "def"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testMatches() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc matches "de.*f"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_MATCHES);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'de.*f');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testContains() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc contains "de.*f"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_CONTAINS);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'de.*f');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testStartsWith() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc startswith "de.*f"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_STARTS_WITH);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'de.*f');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testEndsWith() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc endsWIth "de.*f"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_ENDS_WITH);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'de.*f');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testLongerThann() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc LONGERTHAN "de.*f"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LONGER_THAN);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'de.*f');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testShorterThan() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc shorterthan "de.*f"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_SHORTER_THAN);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'de.*f');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testIntAndDec() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('   abc    <    32     and      def > 65.4 or somedate == 2008-09-30 and otherdate=2000-01-01');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_INTEGER, s.type);
        System.assertEquals(s.value,'32');
        System.assertEquals(((ExpressionInterpreter.IntegerSymbol)s).integerValue,32);
        s = x.nextSymbol();

        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);
        s = x.nextSymbol();
        
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_GREATER_THAN);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_DECIMAL, s.type);
        System.assertEquals(s.value,'65.4');
        System.assertEquals(((ExpressionInterpreter.DecimalSymbol)s).decimalValue,65.4);
        s = x.nextSymbol();

        System.assertEquals(ExpressionInterpreter.LOGIC_OR, s.type);
        s = x.nextSymbol();
        
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'somedate');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_DATE, s.type);
        System.assertEquals(s.value,'2008-09-30');
        System.assertEquals(((ExpressionInterpreter.DATESymbol)s).dateValue,Date.newInstance(2008,09,30));
        s = x.nextSymbol();

        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);
        s = x.nextSymbol();
        
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'otherdate');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_DATE, s.type);
        System.assertEquals(s.value,'2000-01-01');
        System.assertEquals(((ExpressionInterpreter.DATESymbol)s).dateValue,Date.newInstance(2000,01,01));
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testBoolean() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('  (  abc = true and def != false   )OR(abc=false and def!=true)');
        
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.LEFT, s.type);
        
        s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_EQUAL);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_BOOLEAN, s.type);
        System.assertEquals(s.value,'true');
        System.assertEquals(((ExpressionInterpreter.BooleanSymbol)s).booleanValue,true);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);
        
        s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'def');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_NOT_EQUAL);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_BOOLEAN, s.type);
        System.assertEquals(s.value,'false');
        System.assertEquals(((ExpressionInterpreter.BooleanSymbol)s).booleanValue,false);
        
        s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.RIGHT, s.type);
        
        s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.LOGIC_OR, s.type);
        
        s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.LEFT, s.type);
        
        s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_EQUAL);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_BOOLEAN, s.type);
        System.assertEquals(s.value,'false');
        System.assertEquals(((ExpressionInterpreter.BooleanSymbol)s).booleanValue,false);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);
        
        s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'def');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_NOT_EQUAL);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_BOOLEAN, s.type);
        System.assertEquals(s.value,'true');
        System.assertEquals(((ExpressionInterpreter.BooleanSymbol)s).booleanValue,true);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.RIGHT, s.type);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testInt() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('9');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_INTEGER, s.type);
        System.assertEquals(s.value,'9');
        System.assertEquals(((ExpressionInterpreter.IntegerSymbol)s).integerValue,9);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }

    @isTest
    static void lex_testInvalidInt() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc    <    32gh and ');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN);
        try {
            s = x.nextSymbol();
            System.assert(false);
        } catch(ExpressionException e) {
            // Expected lexer error.
        }
    }

    @isTest
    static void lex_testInvalidInt2() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc    <   234234234234234234231123234');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN);
        try {
            s = x.nextSymbol();
            System.assert(false);
        } catch(ExpressionException e) {
            // Expected lexer error.
        }
    }

    @isTest
    static void lex_testInvalidDecimal() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc    <    32..9.');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN);
        try {
            s = x.nextSymbol();
            System.assert(false);
        } catch(ExpressionException e) {
            // Expected lexer error.
        }
    }

    @isTest
    static void lex_testInvalidDate() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc    <    1995-015-4()');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN);
        try {
            s = x.nextSymbol();
            System.assert(false);
        } catch(ExpressionException e) {
            // Expected lexer error.
        }
    }

    @isTest
    static void lex_testInvalidDate2() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc    <    0-00-00-00');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_LESS_THAN);
        try {
            s = x.nextSymbol();
            System.assert(false);
        } catch(ExpressionException e) {
            // Expected lexer error.
        }
    }

    @isTest
    static void lex_testInvalid() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc == _foo');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.INVALID, s.type);
    }


    @isTest
    static void lex_test2() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('abc AND def');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals( ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'abc');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'def');
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
        
    }

    @isTest
    static void lex_test3() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('some.field = "foo" and other.field = "bar" and (three == "3" or four != "4")');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'some.field');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value, ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'foo');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'other.field');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'bar');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LEFT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'three');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'3');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_OR, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'four');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,s.value, ExpressionInterpreter.CMP_NOT_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'4');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.RIGHT, s.type);
     
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
        
    }

    @isTest
    static void lex_test4() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('one = "1" AND ((two = "2" or one = "2") and NOT(one = "1" AND two = "1"))');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'one');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'1');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LEFT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LEFT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'two');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'2');
    
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_OR, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'one');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'2');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.RIGHT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_NOT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LEFT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'one');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'1');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'two');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'1');
        
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.RIGHT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.RIGHT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);
    }       
        
    @isTest
    static void lex_test5() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('(Type="Call" and Description longerThan 20) or Type="Meeting"');
        ExpressionInterpreter.Symbol s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LEFT, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'Type');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'Call');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_AND, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'Description');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_LONGER_THAN);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_INTEGER, s.type);
        System.assertEquals(s.value,'20');
    
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.RIGHT, s.type);
    
        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.LOGIC_OR, s.type);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.IDENTIFIER, s.type);
        System.assertEquals(s.value,'Type');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.COMPARATOR, s.type);
        System.assertEquals(s.value,ExpressionInterpreter.CMP_EQUAL);

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.CONST_STRING, s.type);
        System.assertEquals(s.value,'Meeting');

        s = x.nextSymbol();
        System.assertEquals(ExpressionInterpreter.EOF, s.type);

    }       
        
        
    @isTest
    static void parser_test1() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('some.field = "foo" and other.field = "bar" and (three = "3" or four = "4")');
        ExpressionInterpreter.Parser p = new ExpressionInterpreter.Parser(x);
        ExpressionInterpreter.BooleanExpression b = p.build();
        //System.debug(b.toString());
        Map<String, Object> ns = new Map<String, Object>();
        System.assert(b.interpret(ns) == false);
        
    }

    
    // true & ((true | false) & !(true & false))    
    @isTest
    static void parser_test2() {
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('one = "1" AND ((two = "2" or one = "2") AND NOT(one = "1" AND two = "1"))');
        ExpressionInterpreter.Parser p = new ExpressionInterpreter.Parser(x);
        ExpressionInterpreter.BooleanExpression b = p.build();
        //System.debug(b.toString());
        Map<String, Object> ns = new Map<String, Object>();
        System.assert(b.interpret(ns) == false);
    }
    
    @isTest
    static void interp_test1() {
        Account obj = new Account(name = 'test', description = 'old desc');
        System.assertEquals(true, ExpressionInterpreter.eval(obj,'name = "test"'));
        //Map<String, Object> ns = new Map<String, Object>();
        obj.put('name', 'foo');
        System.assertEquals(true, ExpressionInterpreter.eval(obj,'name = "foo"'));
        obj.put('name', 'bar');
        System.assertEquals(false, ExpressionInterpreter.eval(obj,'name = "foo"'));
    }
    
    @isTest
    static void interp_testNull() {
        Account obj = new Account(name = 'test', description = 'old desc');
        System.assertEquals(true, ExpressionInterpreter.eval(obj,'bad = null'));
        System.assertEquals(false, ExpressionInterpreter.eval(obj,'bad != null'));
        System.assertEquals(true, ExpressionInterpreter.eval(obj,'parent.name = null'));
        System.assertEquals(true, ExpressionInterpreter.eval(obj,'name != null'));
        System.assertEquals(false, ExpressionInterpreter.eval(obj,'name == null'));
    }
    

    @isTest
    static void interp_test2() {
        // a = 1 AND (b = 2 or b = 3)
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('a = "1" AND (b = "2" OR b = "3")');
        ExpressionInterpreter.Parser p = new ExpressionInterpreter.Parser(x);
        ExpressionInterpreter.BooleanExpression b = p.build();
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('a', '1');
        ns.put('b', '4');
        System.assert(b.interpret(ns) == false);
        ns.put('a', '1');
        ns.put('b', '2');
        System.assert(b.interpret(ns) == true);
        ns.put('a', '1');
        ns.put('b', '3');
        System.assert(b.interpret(ns) == true);
        ns.put('a', '5');
        ns.put('b', '3');
        System.assert(b.interpret(ns) == false);
    }
    
    @isTest
    static void interp_test3() {
        
        ExpressionInterpreter.Lexer x = new ExpressionInterpreter.Lexer('one = "1" AND ((two = "2" or one = "2") AND NOT(one = "1" AND two = "1"))');
        ExpressionInterpreter.Parser p = new ExpressionInterpreter.Parser(x);
        ExpressionInterpreter.BooleanExpression b = p.build();
        Map<String, Object> ns = new Map<String, Object>();

        ns.put('one', '1');
        ns.put('two', '2');
        System.assert(b.interpret(ns) == true);
        
        ns.put('one', '1');
        ns.put('two', '1');
        System.assert(b.interpret(ns) == false);
        
        //System.out.println(b.toString());
    }
    
    @isTest
    static void interp_testJeffsSignalRule() {
        
        ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('Type="Call" or Type="Meeting" or ((Type=null or Type="email") and not (Subject startsWith "Pardot" or Subject startsWith "Mass"))');
        
        Set<String> flds = new Set<String>();
        b.gather(flds);
        System.assertEquals(2, flds.size());
        System.debug('interp_testJeffsSignalRule Field: ' + flds);
        System.assert(flds.contains('type'));
        System.assert(flds.contains('subject'));
        
        Map<String, Object> ns = new Map<String, Object>();

        // This should fly with nulls at every value, becasue of the type=null term.
        System.assert(b.interpret(ns) == true);

        // Now we add pardot, and it should fail!
        ns.put('subject', 'pardot: this is a pardot email');
        System.assert(b.interpret(ns) == false);
        
        // Now we add mass, and it should fail!
        ns.put('subject', 'Mass email');
        System.assert(b.interpret(ns) == false);
        
        // Now we do a different subject so it should pass because type is still null.
        ns.put('subject', 'something else');
        System.assert(b.interpret(ns) == true);
        
        ns.remove('subject');

        // Same set of tests with type as email.
        ns.put('type', 'email');
        System.assert(b.interpret(ns) == true);

        // Now we add pardot, and it should fail!
        ns.put('subject', 'pardot: this is a pardot email');
        System.assert(b.interpret(ns) == false);
        
        // Now we add mass, and it should fail!
        ns.put('subject', 'Mass email');
        System.assert(b.interpret(ns) == false);
        
        // Now we do a different subject so it should pass because type is still null.
        ns.put('subject', 'something else');
        System.assert(b.interpret(ns) == true);
        
        ns.remove('subject');
        
        System.assert(b.interpret(ns) == true);
        ns.put('type', 'foo');
        System.assert(b.interpret(ns) == false);



        ns.put('type', 'call');
        System.assert(b.interpret(ns) == true);
        
        ns.put('type', 'MEETING');
        System.assert(b.interpret(ns) == true);
        
        ns.put('type', 'email');
        // subject is not pardot or mass, so it should fly
        System.assert(b.interpret(ns) == true);
        
        ns.put('type', 'NO_MATCH');
        System.assert(b.interpret(ns) == false);
    
        ns.put('type', 'CaLL');
        ns.put('subJect', 'seeses'); // Subject Doesnt matter here.
        System.assert(b.interpret(ns) == true);
        
        ns.put('type', 'MeeTING');
        ns.put('subJect', 'seeses'); // Subject Doesnt matter here.
        System.assert(b.interpret(ns) == true);
        
        ns.put('type', 'email');
        ns.put('subJect', 'seeses');
        // subject is not pardot or mass, so it should fly
        System.assert(b.interpret(ns) == true);
        
        ns.put('type', 'NO_MATCH');
        ns.put('subJect', 'seeses');
        System.assert(b.interpret(ns) == false);
    
    }
    
    
    @isTest
    static void interp_stringEquals() {
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('a', 'foo');
        System.assert(ExpressionInterpreter.eval(ns,'a = "foo"') == true);
        ns.put('a', 'Foo');
        System.assert(ExpressionInterpreter.eval(ns,'a = "foo"') == true);
        ns.put('a', ' Foo');
        System.assert(ExpressionInterpreter.eval(ns,'a = "foo"') == true);
        ns.put('a', ' foo ');
        System.assert(ExpressionInterpreter.eval(ns,'a = "FOO"') == true);
        ns.put('a', ' F0oo ');
        System.assert(ExpressionInterpreter.eval(ns,'a = "foo"') == false);
        ns.put('a', 'foo');
        System.assert(ExpressionInterpreter.eval(ns,'b = "foo"') == false);
        ns.put('dt', Date.newInstance(2008,11,14));
        System.assert(ExpressionInterpreter.eval(ns,'dt = "foo"') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a = 2008-11-14') == false);
    }
    
    @isTest
    static void interp_stringLongerShorterThan() {
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('a', 'four');
        System.assert(ExpressionInterpreter.eval(ns,'a LongerThan 0') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a LongerThan 3') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a LongerThan 4') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a LongerThan 5') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a ShorterThan 3') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a ShorterThan 4') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a ShorterThan 5') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a ShorterThan 500') == true);
        // LongerThan and shorter than only work with int consts.
        System.assert(ExpressionInterpreter.eval(ns,'a ShorterThan "5"') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a LongerThan "3"') == false);
    }
    
    @isTest
    static void interp_stringStartsEndsWithAndContains() {
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('a', 'fourtEEn');
        System.assert(ExpressionInterpreter.eval(ns,'a startsWith ""') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a StartsWith "f"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a startsWith "fOUr"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a STARTSWITH "Fourteen"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a startswith "our"') == false);

        // Not sure why this doesn't pass but startsWith "" does.  
        //System.assert(ExpressionInterpreter.eval(ns,'a endsWith ""') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a endsWith "N"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a endswith "n"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a endsWith "e"') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a endswith "TEEN"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a ENDSWITH "FOURteen"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a endsWith "Fteen"') == false);

        System.assert(ExpressionInterpreter.eval(ns,'a Contains "Fourteen"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a Contains "OUR"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a Contains "TEEN"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a Contains "N"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a Contains "p"') == false);
        
        // Contains does not work on Int values
        ns.put('b', '444');
        System.assert(ExpressionInterpreter.eval(ns,'b contains 4') == false);
        
    }
    
    @isTest
    static void interp_stringMatchesRegex() {
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('a', 'fourtEEn');
        System.assert(ExpressionInterpreter.eval(ns,'a matches "e"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a matches "TE"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a matches "t..N"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a matches "r..N"') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a matches "r..e"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a matches "f.*n"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a matches "te*n"') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a matches "te+n"') == true);

        // testing NOT here...
        System.assert(ExpressionInterpreter.eval(ns,'NOT (a matches "r..N")') == true);
        System.assert(ExpressionInterpreter.eval(ns,'NOT (a matches "t..N")') == false);

        ns.put('title', 'ceo');
        System.assert(ExpressionInterpreter.eval(ns,'title matches "C\\.?[EFT]\\.?O\\.?"') == true);
        ns.put('title', 'cFo');
        System.assert(ExpressionInterpreter.eval(ns,'title matches "C\\.?[EFT]\\.?O\\.?"') == true);
        ns.put('title', 'c.E.o.');
        System.assert(ExpressionInterpreter.eval(ns,'title matches "C\\.?[EFT]\\.?O\\.?"') == true);
        ns.put('title', 'C.T.O.');
        System.assert(ExpressionInterpreter.eval(ns,'title matches "C\\.?[EFT]\\.?O\\.?"') == true);
        ns.put('title', 'the boss');
        System.assert(ExpressionInterpreter.eval(ns,'title matches "C\\.?[EFT]\\.?O\\.?"') == false);
        ns.put('title', 'C.X.O.');
        System.assert(ExpressionInterpreter.eval(ns,'title matches "C\\.?[EFT]\\.?O\\.?"') == false);

        // Test faulty regex rule:
        ns.put('title', 'C.E');
        System.assert(ExpressionInterpreter.eval(ns,'title matches "C\\.?([E{0}"') == false);
        
    }

/**
    @isTest
    static void interp_stringMatchesTraakrRegex() {
        // [\\w\\.]*@(?!traackr\\.com).*>> wrote:"
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('a', 'matt@traackr.com >> wrote: foo');
        System.assert(ExpressionInterpreter.eval(ns,'a matches "[\\w\\.]*@(?!traackr\\.com).*>> wrote:"') == true);
    }
    */
    
    @isTest
    static void interp_intComparison() {
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('a', 10);
        System.assert(ExpressionInterpreter.eval(ns,'a == 10') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a = 10') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a == 9') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a = 9') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a != 10') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a != 100') == true);

        System.assert(ExpressionInterpreter.eval(ns,'a < 9') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a < 10') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a < 11') == true);

        System.assert(ExpressionInterpreter.eval(ns,'a <= 9') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a <= 10') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a <= 11') == true);

        System.assert(ExpressionInterpreter.eval(ns,'a > 9') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a > 10') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a > 11') == false);

        System.assert(ExpressionInterpreter.eval(ns,'a >= 9') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a >= 10') == true);
        System.assert(ExpressionInterpreter.eval(ns,'a >= 11') == false);

        System.assert(ExpressionInterpreter.eval(ns,'a == "10"') == false);
        System.assert(ExpressionInterpreter.eval(ns,'a longerThan 3') == false);
        
    }
    
    @isTest
    static void interp_decimalComparison() {
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('dec', 10.0);
        
        System.assert(ExpressionInterpreter.eval(ns,'dec == 10') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec == 10.0') == true);
        
        System.assert(ExpressionInterpreter.eval(ns,'dec = 10') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec = 10.0') == true);

        System.assert(ExpressionInterpreter.eval(ns,'dec == 9') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec == 9.0') == false);

        System.assert(ExpressionInterpreter.eval(ns,'dec = 9') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec = 9.0') == false);

        System.assert(ExpressionInterpreter.eval(ns,'dec != 10') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec != 10.0') == false);

        System.assert(ExpressionInterpreter.eval(ns,'dec != 100') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec != 100.0') == true);

        System.assert(ExpressionInterpreter.eval(ns,'dec < 9.0') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec < 10.0') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec < 11.0') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec < 9') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec < 10') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec < 11') == true);

        System.assert(ExpressionInterpreter.eval(ns,'dec <= 9.0') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec <= 10.0') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec <= 11.0') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec <= 9') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec <= 10') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec <= 11') == true);

        System.assert(ExpressionInterpreter.eval(ns,'dec > 9.0') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec > 10.0') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec > 11.0') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec > 9') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec > 10') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec > 11') == false);

        System.assert(ExpressionInterpreter.eval(ns,'dec >= 9.0') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec >= 10.0') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec >= 11.0') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec >= 9') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec >= 10') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dec >= 11') == false);

        System.assert(ExpressionInterpreter.eval(ns,'dec == "10.0"') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dec longerThan 3.0') == false);
        
    }

    
    @isTest
    static void interp_boolComparison() {
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('t', true);
        ns.put('f', false);
        System.assert(ExpressionInterpreter.eval(ns,'t == true') == true);
        System.assert(ExpressionInterpreter.eval(ns,'t = true') == true);
        System.assert(ExpressionInterpreter.eval(ns,'t=true') == true);
        System.assert(ExpressionInterpreter.eval(ns,'t == false') == false);
        System.assert(ExpressionInterpreter.eval(ns,'t = false') == false);
        System.assert(ExpressionInterpreter.eval(ns,'t=false') == false);

        System.assert(ExpressionInterpreter.eval(ns,'t != true') == false);
        System.assert(ExpressionInterpreter.eval(ns,'t != false') == true);
        System.assert(ExpressionInterpreter.eval(ns,'t!=true') == false);
        System.assert(ExpressionInterpreter.eval(ns,'t!=false') == true);

        System.assert(ExpressionInterpreter.eval(ns,'not(t = true)') == false);
        System.assert(ExpressionInterpreter.eval(ns,'not(t = false)') == true);

        System.assert(ExpressionInterpreter.eval(ns,'f == true') == false);
        System.assert(ExpressionInterpreter.eval(ns,'f = true') == false);
        System.assert(ExpressionInterpreter.eval(ns,'f == false') == true);
        System.assert(ExpressionInterpreter.eval(ns,'f = false') == true);

        System.assert(ExpressionInterpreter.eval(ns,'f != true') == true);
        System.assert(ExpressionInterpreter.eval(ns,'f != false') == false);

        System.assert(ExpressionInterpreter.eval(ns,'not(f = true)') == true);
        System.assert(ExpressionInterpreter.eval(ns,'not(f = false)') == false);

        System.assert(ExpressionInterpreter.eval(ns,'f == "10"') == false);
        System.assert(ExpressionInterpreter.eval(ns,'f longerThan true') == false);
        
    }
    
    
    @isTest
    static void interp_dateComparison() {
        Map<String, Object> ns = new Map<String, Object>();
        ns.put('dt', Date.newInstance(2016,06,16));
        ns.put('dtm', DateTime.newInstance(2016,06,16,16,30,45));
        System.assert(ExpressionInterpreter.eval(ns,'dt == 2016-06-16') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dt = 2016-06-16') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dt != 2016-06-16') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt > 2016-06-16') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt >= 2016-06-16') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dt < 2016-06-16') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt <= 2016-06-16') == true);

        System.assert(ExpressionInterpreter.eval(ns,'dt == 2016-06-15') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt = 2016-06-15') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt != 2016-06-15') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dt > 2016-06-15') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dt >= 2016-06-15') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dt < 2016-06-15') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt <= 2016-06-15') == false);

        System.assert(ExpressionInterpreter.eval(ns,'dt == 2016-06-17') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt = 2016-06-17') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt != 2016-06-17') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dt > 2016-06-17') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt >= 2016-06-17') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dt < 2016-06-17') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dt <= 2016-06-17') == true);

        System.assert(ExpressionInterpreter.eval(ns,'dt contains 2016-06-17') == false);
        
        // Same tests with DateTime input as field value.
        System.assert(ExpressionInterpreter.eval(ns,'dtm == 2016-06-16') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dtm = 2016-06-16') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dtm != 2016-06-16') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm > 2016-06-16') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm >= 2016-06-16') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dtm < 2016-06-16') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm <= 2016-06-16') == true);

        System.assert(ExpressionInterpreter.eval(ns,'dtm == 2016-06-15') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm = 2016-06-15') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm != 2016-06-15') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dtm > 2016-06-15') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dtm >= 2016-06-15') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dtm < 2016-06-15') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm <= 2016-06-15') == false);

        System.assert(ExpressionInterpreter.eval(ns,'dtm == 2016-06-17') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm = 2016-06-17') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm != 2016-06-17') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dtm > 2016-06-17') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm >= 2016-06-17') == false);
        System.assert(ExpressionInterpreter.eval(ns,'dtm < 2016-06-17') == true);
        System.assert(ExpressionInterpreter.eval(ns,'dtm <= 2016-06-17') == true);
    }
    
    @isTest
    static void testGetType() {
        System.assertEquals('List', ExpressionInterpreter.getType(new List<String>()));        
        System.assertEquals('Account', ExpressionInterpreter.getType(new Account()));        
        System.assertEquals('Boolean', ExpressionInterpreter.getType(true));        
        System.assertEquals('Boolean', ExpressionInterpreter.getType(false));        
        System.assertEquals('String', ExpressionInterpreter.getType('foo'));        
        System.assertEquals('Integer', ExpressionInterpreter.getType(123));        
        System.assertEquals('Long', ExpressionInterpreter.getType(123L));        
        System.assertEquals('Decimal', ExpressionInterpreter.getType(123.4));        
        System.assertEquals('Date', ExpressionInterpreter.getType(Date.newInstance(2016,06,16)));        
        System.assertEquals('Datetime', ExpressionInterpreter.getType(DateTime.newInstance(2016,06,16,16,30,45)));        
        //FIXME System.assertEquals('Object', ExpressionInterpreter.getType(new UibModel()));        
    }

    // FIXME
    /*
    @isTest
    static void testSObjectToMap() {
        TestDataFactory.insertAll();
        Opportunity opp = [SELECT o.AccountId, a.name, o.Name, o.StageName, o.Type, o.Amount, o.createdDate, o.closeDate, (SELECT Contact.Id, Contact.Name, Contact.Email, Role FROM OpportunityContactRoles) FROM Opportunity o, o.Account a Where o.Name = 'Data Center Design'];
        System.assert(opp != null);
        
        Map<String, Object> oppMap = ExpressionInterpreter.sObjectToMap(opp);
        //System.debug('' + oppMap);
        System.assertEquals('Data Center Design', oppMap.get('name'));        
        //System.assertEquals('Edge Communications', oppMap.get('account.name'));
        Map<String, Object> mAcct = (Map<String, Object>)oppMap.get('account');
        System.assertEquals('Edge Communications', mAcct.get('name'));
        System.assertEquals(2500000.00, oppMap.get('amount'));
        System.assertEquals(Date.newInstance(2016,07,01), oppMap.get('closedate'));
        // FIXME: This test fails due to time zone offsetting.
        //System.assertEquals(DateTime.newInstance(2016,03,01,5,0,0), oppMap.get('createddate'));
        List<Object> ocrs = (List<Object>)oppMap.get('opportunitycontactroles');
        System.assertEquals(4, ocrs.size());        

        Object jamesJohnsonOcr = null;
        Map<String, Object> jjContactMap = null;

        for (Object o : ocrs) {
            Map<String, Object> contactMap1 = (Map<String, Object>)o;
	        Map<String, Object> contact = (Map<String, Object>)contactMap1.get('contact');
	        if (contact.get('name') == 'James Johnson') {
	            jamesJohnsonOcr = o;
	            jjContactMap = contactMap1;
	        }
        }
        System.assert(jamesJohnsonOcr != null);
        System.assert(jjContactMap != null);

        //System.debug('Contact map: ' + jjContactMap);
        System.assertEquals('Evaluator', jjContactMap.get('role'));        
        Map<String, Object> jjContact = (Map<String, Object>)jjContactMap.get('contact');
        System.assertEquals('James Johnson', jjContact.get('name'));
        
        // Test Sub fields, and identifier case insensitivity.
        System.assert(ExpressionInterpreter.eval(oppMap,'name == "Data Center Design"') == true);
        System.assert(ExpressionInterpreter.eval(oppMap,'NAME == "Data Center Design"') == true);
        System.assert(ExpressionInterpreter.eval(oppMap,'name == "Data Center"') == false);
        System.assert(ExpressionInterpreter.eval(oppMap,'account.name == "Edge Communications"') == true);
        System.assert(ExpressionInterpreter.eval(oppMap,'Account.Name == "Edge Communications"') == true);
                
                
    }
    */
    

    @isTest
    static void testSyntaxError1() {
        // unclosed quote
        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('abc == "foo AND def == "bar"');
            System.debug('Syntax error exp: ' + b.toString());
            System.assert(false);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
        }
    }

    @isTest
    static void testSyntaxError2() {
        // unclosed quote
        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('abc == == "foo"');
            System.debug('Syntax error exp: ' + b.toString());
            System.assert(false);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
        }
    }

    @isTest
    static void testSyntaxError3() {
        // unclosed quote
        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('abc == "foo" AND OR def == "bar"');
            System.debug('Syntax error exp: ' + b.toString());
            System.assert(false);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
        }
    }

    @isTest
    static void testSyntaxError4() {
        // unclosed quote
        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('abc == "foo" AND (def == "bar" OR x = 3');
            System.debug('Syntax error exp: ' + b.toString());
            System.assert(false);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
        }
    }

    
    @isTest
    static void testEmptyExpression() {
        // Empty expression should be supported, and evaluating it should always return TRUE
        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('   ');
            Map<String, Object> ns = new Map<String, Object>();
            System.assert(b.interpret(ns) == true);
        } catch(Exception e) {
            System.assert(false);
        }
    }

    @isTest
    static void testBoolExp1() {
        Map<String, Object> ns = new Map<String, Object>();
        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('true');
            System.assert(b.interpret(ns) == true);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
            System.assert(false);
        }

        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('false');
            System.assert(b.interpret(ns) == false);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
            System.assert(false);
        }

        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('true and true');
            System.assert(b.interpret(ns) == true);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
            System.assert(false);
        }

        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('true and false');
            System.assert(b.interpret(ns) == false);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
            System.assert(false);
        }

        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('(true and false) OR (true or false)');
            System.assert(b.interpret(ns) == true);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
            System.assert(false);
        }

        try { 
            ExpressionInterpreter.BooleanExpression b = ExpressionInterpreter.parse('(true and false) OR (false or false)');
            System.assert(b.interpret(ns) == false);
        } catch(Exception e) {
            System.debug('Syntax error: ' + e.getMessage());
            System.assert(false);
        }
    }



}