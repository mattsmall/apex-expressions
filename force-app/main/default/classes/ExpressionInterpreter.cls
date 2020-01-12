/*

Based on the work of: https://github.com/unnikkedga/BooleanExpressionEvaluator
https://unnikked.ga/how-to-build-a-boolean-expression-evaluator-518e9e068a65#.ikpb9mm6h

The MIT License (MIT)

Copyright (c) 2015 unnikked

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/**
 * <expression> ::= <term> {<or> <term>}
 * <term> ::= <factor> {<and> <factor>}
 * <factor> ::= <condition> | <not> <factor> | (<expression>)
 * <condition> ::= <Identifier> <operator> <const>
 * <operator> ::= <equals>|<notEquals>|etc.
 * <const> ::= <string>|<integer>|<decimal>|<date>
 * <or>::='or'
 * <and>::='and'
 * <not>::='not'
 */
 
 /*
 * Security Note: This class does not enforce Field Level Security
 * as it never externally exposes individual field values. This class
 * only evaluates boolean expressions based on matching field values
 * to return a response of true or false.
 */
 
public with sharing class ExpressionInterpreter {

    public static final String NONE = 'NONE';
    public static final String EOF = 'EOF';
    public static final String INVALID = 'INVALID';
    
    public static final String LOGIC_OR = 'OR';
    public static final String LOGIC_AND  = 'AND';
    public static final String LOGIC_NOT = 'NOT';
    
    public static final String LEFT = 'LEFT';
    public static final String RIGHT = 'RIGHT';
    
    public static final String CONST_STRING = 'STRING';
    public static final String CONST_INTEGER = 'INTEGER';
    public static final String CONST_DECIMAL = 'DECIMAL';
    public static final String CONST_DATE = 'DATE';
    public static final String CONST_BOOLEAN = 'BOOLEAN';
    public static final String CONST_NULL = 'NULL';

    public static final String IDENTIFIER = 'IDENTIFIER';
    
    // Comparators: = (or ==?) <= != >= > < 
    // matches (regex) contains startswith endswith longerthan shorterthan
    public static final String COMPARATOR = 'COMPARATOR';

    public static final String CMP_EQUAL = 'equal';
    public static final String CMP_NOT_EQUAL = 'notEqual';
    public static final String CMP_LESS_THAN_OR_EQUAL = 'lessThanOrEqual';
    public static final String CMP_GREATER_THAN_OR_EQUAL = 'greaterThanOrEqual';
    public static final String CMP_LESS_THAN = 'lessThan';
    public static final String CMP_GREATER_THAN = 'greaterThan';
    public static final String CMP_MATCHES = 'matches';
    public static final String CMP_CONTAINS = 'contains';
    public static final String CMP_STARTS_WITH = 'startsWith';
    public static final String CMP_ENDS_WITH = 'endsWith';
    public static final String CMP_LONGER_THAN = 'longerThan';
    public static final String CMP_SHORTER_THAN = 'shorterThan';

    private static Map<String, BooleanExpression> expressionCache = new Map<String, BooleanExpression>();

    public static Integer mapTime = 0;
    public static Integer parseTime = 0;
    public static Integer interpTime = 0;

    private static final Boolean TRACE_ENABLED = false;

    public static Boolean eval(SObject obj, String boolExp) {
        Map<String, Object> m = sObjectToMap(obj);
        BooleanExpression b;
        if (expressionCache.containsKey(boolExp)) {
            b = expressionCache.get(boolExp);
        } else {
            Integer pT = TRACE_ENABLED ? Limits.getCpuTime() : 0;
	        Lexer x = new Lexer(boolExp);
	        Parser p = new Parser(x);
	        b = p.build();
            expressionCache.put(boolExp,b);
            if (TRACE_ENABLED) parseTime = parseTime + (Limits.getCpuTime() - pT);
        }
        Integer iT = TRACE_ENABLED ? Limits.getCpuTime() : 0;
        Boolean ret = b.interpret(m);
        if (TRACE_ENABLED) interpTime = interpTime + (Limits.getCpuTime() - iT);
        return ret;
    }   

    public static Boolean eval(Map<String, Object> m, String boolExp) {
        BooleanExpression b;
        if (expressionCache.containsKey(boolExp)) {
            b = expressionCache.get(boolExp);
        } else {
            Integer pT = TRACE_ENABLED ? Limits.getCpuTime() : 0;
            Lexer x = new Lexer(boolExp);
            Parser p = new Parser(x);
            b = p.build();
            //System.debug('Parsed expression: ' + boolExp);
            expressionCache.put(boolExp,b);
            if (TRACE_ENABLED) parseTime = parseTime + (Limits.getCpuTime() - pT);
        }
        Integer iT = TRACE_ENABLED ? Limits.getCpuTime() : 0;
        Boolean ret = b.interpret(m);
        if (TRACE_ENABLED) interpTime = interpTime + (Limits.getCpuTime() - iT);
        return ret;
    }   
    
    // Parses the expression to an AST which can be repeatedly used for interpreting the expression on various objects.
    // Using this then calling interpret on the returned object is more efficient for multiple calls than 
    // using either of the eval calls above, which require fully parsing the expression on each call.
    public static BooleanExpression parse(String boolExp) {
        Lexer x = new Lexer(boolExp);
        Parser p = new Parser(x);
        BooleanExpression b = p.build();
        return b;
    }

    public abstract with sharing class Symbol {
        public String type;
        public String value;
        public override String toString() {
            return type + (value == null ? '' : ' ' + value);
        }
    }

    public with sharing class StringSymbol extends Symbol {
    }
    
    public with sharing class IntegerSymbol extends Symbol {
        public Integer integerValue;
    }
    
    public with sharing class DateSymbol extends Symbol {
        public Date dateValue;
    }
    
    public with sharing class DecimalSymbol extends Symbol {
        public Decimal decimalValue;
    }
    
    public with sharing class BooleanSymbol extends Symbol {
        public Boolean booleanValue;
    }
    
	public with sharing class Lexer {
        public String input;
        public String inputLc;
	    // points at next unread char.
	    public Integer i = 0;
	
	    public Lexer(String inp) {
	        input = inp;
	        inputLc = inp.toLowerCase();
	    }
	    
	    public String nextChar() {
	        if (i < 0) {
	            throw new ExpressionException('EOF');
	        }
	        if (i >= input.length()) {
	            i = -1;
	            return '';
	        } else {
	            return input.substring(i, ++i);
	        }
	    }
	    
	    public boolean isSpace(String ch) {
	        if (ch != null && ch.isWhitespace()) {
	            return true;
	        }
	        return false;
	    }
	    
	    public Symbol nextSymbol() {
	        String ch;
	        Symbol s = new StringSymbol();
	        try {
	            while(isSpace(ch = nextChar())) {
	                // consume spaces.
	            }
	            String remInputLc = inputLc.substring(i-1);
	            if (ch == '"') {
                    s.value = '';
                    s.type = CONST_STRING;
                    while(!(ch = nextChar()).equals('"')) {
                        // consume string.
                        if (ch == '\\') {
                            // escape char, consume next char regardless of what it is.
                            ch = nextChar();
                        }
                        s.value = s.value + ch;
                    }
                } else if (ch.isNumeric()) {
                    s.value = '';
                    while(ch.isNumeric() || ch == '.' || ch == '-') {
                        // consume string.
                        s.value = s.value + ch;
                        ch = nextChar();
                    }
                    // need to back up one char.
                    i--;
                    if (s.value.indexOf('-') > 0) {
                        if (s.value.substring(4,5) != '-' || s.value.substring(7,8) != '-') {
                            throw new ExpressionException('Expected date, but value could not be parsed as date: ' + s.value + '. Input: ' + input);
                        }
                        DateSymbol dateSymbol = new DateSymbol();
                        // Must be either date in format of yyyy-mm-dd or its invalid.
                        try {
                            Integer year = Integer.valueOf(s.value.substring(0,4));
                            Integer month = Integer.valueOf(s.value.substring(5,7));
                            Integer day = Integer.valueOf(s.value.substring(8));
                            Date d = Date.newInstance(year, month, day);
                            dateSymbol.type = CONST_DATE;
                            dateSymbol.dateValue = d;
                            dateSymbol.value = s.value;
                        } catch (Exception e) {
                            throw new ExpressionException('Expected date, but value could not be parsed as date: ' + s.value + '. Input: ' + input);
                        }
                        s = dateSymbol;
                    } else if (s.value.indexOf('.') > 0) {
                        DecimalSymbol DecimalSymbol = new DecimalSymbol();
                        try {
                            decimalSymbol.type = CONST_DECIMAL;
                            decimalSymbol.decimalValue = Decimal.valueOf(s.value);
                            decimalSymbol.value = s.value;
                        } catch (Exception e) {
                            throw new ExpressionException('Expected decimal, but value could not be parsed as decimal: ' + s.value + '. Input: ' + input);
                        }
                        s = decimalSymbol;
                    } else {
                        s.type = CONST_INTEGER;
                        IntegerSymbol integerSymbol = new IntegerSymbol();
                        try {
                            integerSymbol.type = CONST_INTEGER;
                            integerSymbol.integerValue = Integer.valueOf(s.value);
                            integerSymbol.value = s.value;
                        } catch (Exception e) {
                            throw new ExpressionException('Expected integer, but value could not be parsed as integer: ' + s.value + '. Input: ' + input);
                        }
                        s = integerSymbol;
                    } 
                    if (ch != '' && !isSpace(ch) && ch != ')') { 
                        throw new ExpressionException('Date, integer, or decimal value must be terminted by a space or right parenthesis. Input: ' + input);
                    }
                } else if (remInputLc.startsWith('and ') || remInputLc.startsWith('and\r') || remInputLc.startsWith('and\n') || remInputLc.startsWith('and\t') || remInputLc.startsWith('and(')) {
	                i += 2;
	                s.type = LOGIC_AND;
	            } else if (remInputLc.startsWith('or ') || remInputLc.startsWith('or\r') || remInputLc.startsWith('or\n') || remInputLc.startsWith('or\t') || remInputLc.startsWith('or(') ) {
	                i += 1;
	                s.type = LOGIC_OR;
	            } else if (remInputLc.startsWith('not ') || remInputLc.startsWith('not\r') || remInputLc.startsWith('not\n') || remInputLc.startsWith('not\t') || remInputLc.startsWith('not(')) {
                    i += 2;
                    s.type = LOGIC_NOT;
                } else if (remInputLc.startsWith('matches ') || remInputLc.startsWith('matches\r') || remInputLc.startsWith('matches\n') || remInputLc.startsWith('matches\t')) {
                    i += 6;
                    s.type = COMPARATOR;
                    s.value = CMP_MATCHES;
                } else if (remInputLc.startsWith('contains ') || remInputLc.startsWith('contains\r') || remInputLc.startsWith('contains\n') || remInputLc.startsWith('contains\t')) {
                    i += 7;
                    s.type = COMPARATOR;
                    s.value = CMP_CONTAINS;
                } else if (remInputLc.startsWith('startswith ') || remInputLc.startsWith('startswith\r') || remInputLc.startsWith('startswith\n') || remInputLc.startsWith('startswith\t')) {
                    i += 9;
                    s.type = COMPARATOR;
                    s.value = CMP_STARTS_WITH;
                } else if (remInputLc.startsWith('endswith ') || remInputLc.startsWith('endswith\r') || remInputLc.startsWith('endswith\n') || remInputLc.startsWith('endswith\t')) {
                    i += 7;
                    s.type = COMPARATOR;
                    s.value = CMP_ENDS_WITH;
                } else if (remInputLc.startsWith('longerthan ') || remInputLc.startsWith('longerthan\r') || remInputLc.startsWith('longerthan\n') || remInputLc.startsWith('longerthan\t')) {
                    i += 9;
                    s.type = COMPARATOR;
                    s.value = CMP_LONGER_THAN;
                } else if (remInputLc.startsWith('shorterthan ') || remInputLc.startsWith('shorterthan\r') || remInputLc.startsWith('shorterthan\n') || remInputLc.startsWith('shorterthan\t')) {
                    i += 10;
                    s.type = COMPARATOR;
                    s.value = CMP_SHORTER_THAN;
                } else if (remInputLc.startsWith('==')) {
                    i += 1;
                    s.type = COMPARATOR;
                    s.value = CMP_EQUAL;
                } else if (remInputLc.startsWith('!=')) {
                    i += 1;
                    s.type = COMPARATOR;
                    s.value = CMP_NOT_EQUAL;
                } else if (remInputLc.startsWith('<=')) {
                    i += 1;
                    s.type = COMPARATOR;
                    s.value = CMP_LESS_THAN_OR_EQUAL;
                } else if (remInputLc.startsWith('>=')) {
                    i += 1;
                    s.type = COMPARATOR;
                    s.value = CMP_GREATER_THAN_OR_EQUAL;
	            } else if (ch.equals('=')) {
                    s.type = COMPARATOR;
                    s.value = CMP_EQUAL;
                } else if (ch.equals('<')) {
                    s.type = COMPARATOR;
                    s.value = CMP_LESS_THAN;
                } else if (ch.equals('>')) {
                    s.type = COMPARATOR;
                    s.value = CMP_GREATER_THAN;
                } else if (ch.equals('(')) {
	                s.type = LEFT;
	            } else if (ch.equals(')')) {
	                s.type = RIGHT;
	            } else if (ch.isAlpha()) {
	                s.value = '';
	                s.type = IDENTIFIER;
	                do {
	                    s.value = s.value + ch;
	                    ch = nextChar();
	                } while (ch.length() == 1 && (ch.isAlphanumeric() || ch == '.' || ch == '_'));
	                // Need to back up a character, so abc= resolves to abc and = tokens.
	                i--;
	                if (s.value.toLowerCase() == 'null') {
                        s.type = CONST_NULL;
                    } else if (s.value.toLowerCase() == 'true') {
                        BooleanSymbol b = new BooleanSymbol();
                        b.value = s.value;
                        b.type = CONST_BOOLEAN;
                        b.booleanValue = true;
                        s = b;
                    } else if (s.value.toLowerCase() == 'false') {
                        BooleanSymbol b = new BooleanSymbol();
                        b.value = s.value;
                        b.type = CONST_BOOLEAN;
                        b.booleanValue = false;
                        s = b;
                    }
	            } else {
	                s.type = INVALID;
	            }
	        } catch (Exception e) {
	            if (e.getMessage() == 'EOF') {
                    s.type = EOF;
	            } else {
	                throw e;
	            }
	        }
	        return s;
	    }
	}

	public abstract with sharing class BooleanExpression {
	    // Interprets the expression on an object, returning either true or false depending
	    // on whether the object matches for the expression.
	    public abstract Boolean interpret(Map<String, Object> obj);
	    
	    // Gathers all of the fields/identifiers used in the expression so they 
	    // can be included in a SOQL query.
	    public abstract void gather(Set<String> fieldIdentifiers);
	}	
	
	public abstract with sharing class Terminal extends BooleanExpression{
	}
	
    public with sharing class TrueTerminal extends Terminal {
        public override void gather(Set<String> fieldIdentifiers) {
            return;
        }
    
        public override Boolean interpret(Map<String, Object> obj) {
            return true;
        }
    }
    
    public with sharing class FalseTerminal extends Terminal {
        public override void gather(Set<String> fieldIdentifiers) {
            return;
        }
    
        public override Boolean interpret(Map<String, Object> obj) {
            return false;
        }
    }
    
    public abstract with sharing class NonTerminal extends BooleanExpression {
        protected BooleanExpression L, R;
    
        public void setLeft(BooleanExpression Lleft) {
            this.L = Lleft;
        }
    
        public void setRight(BooleanExpression Rright) {
            this.R = Rright;
            if (this instanceof LogicalNot) {
                throw new ExpressionException('Cannot set RHS of NOT. Input: ' + toString());
            }
        }
    }
    
    public with sharing class LogicalAnd extends NonTerminal {
        public override Boolean interpret(Map<String, Object> obj) {
            return L.interpret(obj) && R.interpret(obj);
        }
        
        public override void gather(Set<String> fieldIdentifiers) {
            L.gather(fieldIdentifiers);
            R.gather(fieldIdentifiers);
        }
    
        public override String toString() {
            return '(' + L.toString() + ' AND ' + R.toString() + ')';
        }
    }
    
    public with sharing class LogicalOr extends NonTerminal {
        public override Boolean interpret(Map<String, Object> obj) {
            //System.debug('Interpreting OR.');
            return L.interpret(obj) || R.interpret(obj);
        }
    
        public override void gather(Set<String> fieldIdentifiers) {
            L.gather(fieldIdentifiers);
            R.gather(fieldIdentifiers);
        }

        public override String toString() {
            return '(' + L.toString() + ' OR ' + R.toString() + ')';
        }
    }
    
    public with sharing class LogicalNot extends NonTerminal {

	    public void setChild(BooleanExpression child) {
	        setLeft(child);
	    }
	
        public override void gather(Set<String> fieldIdentifiers) {
            L.gather(fieldIdentifiers);
        }
	
        public override Boolean interpret(Map<String, Object> obj) {
            return !L.interpret(obj);
        }
    
        public override String toString() {
            return 'NOT ' + L.toString();
        }
    }
    
	public with sharing class Parser {
	
	    private Lexer lexer;
	    private Symbol symbol;
	    private BooleanExpression root;
	
	    public Parser(Lexer lexer) {
	        this.lexer = lexer;
	    }
	
	    public BooleanExpression build() {
	        expression();
	        if (symbol.type != EOF) {
                throw new ExpressionException('Expression Malformed. Parse completed without processing symbol ' + symbol + '.');
	        }
	        return root;
	    }
	
	    private void expression() {
	        term();
	        while (symbol.type == LOGIC_OR) {
	            LogicalOr orr = new LogicalOr();
	            orr.setLeft(root);
	            term();
	            orr.setRight(root);
	            root = orr;
	        }
	    }
	
	    private void term() {
	        factor();
	        while (symbol.type == LOGIC_AND) {
	            LogicalAnd andd = new LogicalAnd();
	            andd.setLeft(root);
	            factor();
	            andd.setRight(root);
	            root = andd;
	        }
	    }
	
	    private void factor() {
	        symbol = lexer.nextSymbol();
            if (symbol.type == EOF) {
                root = new TrueTerminal();
            } else if (symbol.type == CONST_BOOLEAN) {
                Boolean boolConst = ((BooleanSymbol)symbol).booleanValue;
                if (boolConst != null && boolConst) {
                    root = new TrueTerminal();
                } else {
                    root = new FalseTerminal();
                } 
                symbol = lexer.nextSymbol();
            } else if (symbol.type == IDENTIFIER) {
	            root = new Condition(symbol, lexer.nextSymbol(), lexer.nextSymbol());
	            symbol = lexer.nextSymbol();
	        } else if (symbol.type == LOGIC_NOT) {
	            LogicalNot nnot = new LogicalNot();
	            factor();
	            nnot.setChild(root);
	            root = nnot;
	        } else if (symbol.type == LEFT) {
	            expression();
	            // last symbol pulled should have been right paren.
                if (symbol.type != RIGHT) {
                    throw new ExpressionException('Expression Malformed. Unclosed parenthesis. ' + symbol + '. Input: ' + lexer.input);
                }
	            symbol = lexer.nextSymbol(); // we don't care about ')'
	        } else {
	            throw new ExpressionException('Expression Malformed. Input: ' + lexer.input);
	        }
	    }
	}
    
    public static string getType(Object o) {
        if(o==null) return '';              // we can't say much about null with our current techniques
        if(o instanceof List<Object>)       return 'List';
        if(o instanceof SObject)            return ((SObject)o).getSObjectType().getDescribe().getName()+''; 
        if(o instanceof Boolean)            return 'Boolean';
        if(o instanceof Id)                 return 'Id';
        if(o instanceof String)             return 'String';
        if(o instanceof Blob)               return 'Blob';
        if(o instanceof Date)               return 'Date';
        if(o instanceof Datetime)           return 'Datetime';
        if(o instanceof Time)               return 'Time';
        if(o instanceof String)             return 'String';
        if(o instanceof Integer)            return 'Integer';
        if(o instanceof Long)               return 'Long';
        if(o instanceof Decimal)            return 'Decimal';  // we can't distinguish between decimal and double
        //if(o instanceof Double)             return 'Double';   // we can't distinguish between decimal and double
        return 'Object';                    // actually we can't detect maps and sets and maps
    }       
    
    public static Map<String, Object> sObjectToMap(SObject sobj) {
        Integer mT = TRACE_ENABLED ? Limits.getCpuTime() : 0;
        String namespace = null; // Set Namespace here if needed
        Map<String, Object> objFields = sobj.getPopulatedFieldsAsMap();
        Map<String, Object> newObjFields = new Map<String, Object>();
        for (String key : objFields.keySet()) {
            Object fldValue = objFields.get(key);
            String type = getType(fldValue);
            if (type == 'List') {
                List<Object> fldList = (List<Object>)fldValue;
                if (fldList.size() > 0) {
                    Object firstObj = fldList[0];
                    if (firstObj instanceof SObject) {
                        List<Map<String, Object>> sobjList = new List<Map<String, Object>>();
                        for (Object o : fldList) {
                            sobjList.add(sObjectToMap((SObject)o));
                        }
                        newObjFields.put(key.toLowerCase(), sobjList);
                    }
                } else {
                    newObjFields.put(key.toLowerCase(), fldList);
                }
            } else if (fldValue instanceof SObject) {
                newObjFields.put(key.toLowerCase(), sObjectToMap((SObject)fldValue));
                if (namespace != null && namespace.length() > 0 && key.startsWith(namespace+'__')) {
                    // EX: aknu_qa__Account__r --> Account
                    // AND: aknu_qa__Account__r --> Account__r
                    System.debug('Putting __r fields for ' + key);
                    System.debug('Putting: ' + key.toLowerCase().substring(namespace.length() + 2, key.length() - 3) + ' as object');
                    newObjFields.put(key.toLowerCase().substring(namespace.length() + 2, key.length() - 3), sObjectToMap((SObject)fldValue));
                    newObjFields.put(key.toLowerCase().substring(namespace.length() + 2), sObjectToMap((SObject)fldValue));
                } else if (key.endsWith('__r')) {
                    // As alternate form, put custom relationships in without __r suffix.
                    newObjFields.put(key.toLowerCase().substring(0, key.length() - 3), sObjectToMap((SObject)fldValue));
                }
            } else {
                newObjFields.put(key.toLowerCase(), fldValue);
                if (namespace != null && namespace.length() > 0 && key.startsWith(namespace+'__')) {
                    // EX: aknu_qa__InitiatorRole__c --> InitiatorRole (unless aknu_qa__InitiatorRole__r has already been mapped to InitiatorRole)
                    // AND: aknu_qa__InitiatorRole__c --> InitiatorRole__c
                    System.debug('Putting __c fields for ' + key);
                    if (!newObjFields.containsKey(key.toLowerCase().substring(namespace.length() + 2, key.length() - 3))) {
                        System.debug('Putting: ' + key.toLowerCase().substring(namespace.length() + 2, key.length() - 3));
                        newObjFields.put(key.toLowerCase().substring(namespace.length() + 2, key.length() - 3), fldValue);
                    }
                    newObjFields.put(key.toLowerCase().substring(namespace.length() + 2), fldValue);
                } else if (key.endsWith('__c')) {
                    // As alternate form, put custom fields in without __c suffix.
                    if (!newObjFields.containsKey(key.toLowerCase().substring(0, key.length() - 3))) {
                        newObjFields.put(key.toLowerCase().substring(0, key.length() - 3), fldValue);
                    }
                }
            }
        }
        if (TRACE_ENABLED) mapTime = mapTime + (Limits.getCpuTime() - mT);
        // log('Expression Object Field Map: ' + newObjFields);
        return newObjFields;
    }
    
    public with sharing class Condition extends Terminal {
        
        String ident;
        String oper;
        
        Symbol symConst;
        
        public Condition(Symbol identifierSymbol, Symbol operatorSymbol, Symbol constSymbol) {
            this.ident = identifierSymbol.value;
            this.oper = operatorSymbol.value;
            this.symConst = constSymbol;
            if (identifierSymbol.type != IDENTIFIER) {
                throw new ExpressionException('Condition expected identifier. Found ' + identifierSymbol.type.toLowerCase() + '. Input: ' + toString());
            }
            if (operatorSymbol.type != COMPARATOR) {
                throw new ExpressionException('Condition expected operator. Found ' + operatorSymbol.type.toLowerCase() + '. Input: ' + toString());
            }
            if (constSymbol.type != CONST_STRING && constSymbol.type != CONST_DECIMAL && constSymbol.type != CONST_INTEGER && constSymbol.type != CONST_DATE && constSymbol.type != CONST_NULL && constSymbol.type != CONST_BOOLEAN) {
                throw new ExpressionException('Condition expected constant. Found ' + constSymbol.type.toLowerCase() + '. Input: ' + toString());
            }
            

        }
        
        private Boolean isNull(Map<String, Object> obj) {
            Map<String, Object> m = obj;
            //System.debug('Identifier: ' + ident);
            List<String> parts = ident.split('\\.');
            for (String part : parts) {
                if (part.length() > 0) {
                    //System.debug('Part: ' + part.toLowerCase());
                    if (m == null) {
                        return true;
                    }
                    Object o = m.get(part.toLowerCase());
                    if (o == null) {
                        return true;
                    } else if (o instanceof Map<String, Object>) {
                        m = (Map<String, Object>)o;
                    } else {
                        m = null;
                    }
                }
            }
            return false;
        }
        
        // Recurse down map to get field value.
        private Object getFieldValue(Map<String, Object> obj) {
            Map<String, Object> m = obj;
            //System.debug('Identifier: ' + ident);
            List<String> parts = ident.split('\\.');
            for (String part : parts) {
                if (part.length() > 0) {
                    //System.debug('Part: ' + part.toLowerCase());
                    Object o = m.get(part.toLowerCase());
                    if (o == null) {
                        return null;
                    } else if (o instanceof Map<String, Object>) {
                        m = (Map<String, Object>)o;
                    } else {
                        return o;
                    }
                }
            }
            return null;
        }
    
        public override void gather(Set<String> fieldIdentifiers) {
            if (fieldIdentifiers != null) {
                fieldIdentifiers.add(this.ident.toLowerCase());
            }
        }
    
        public override Boolean interpret(Map<String, Object> obj) {
            
            if (symConst.type == CONST_NULL) {
                if (oper == CMP_EQUAL) {
                    return isNull(obj);
                } else if (oper == CMP_NOT_EQUAL) {
                    return !isNull(obj);
                } else {
                    throw new ExpressionException('Condition can only compare to null with the = or != comparators.');
                }
            }
            
            //System.debug('Interpreting Condition.');
            Object fieldVal = getFieldValue(obj);
            //System.debug('Field Value: ' + fieldVal);
            if (fieldVal == null) {
                if (oper == CMP_EQUAL && symConst.type == CONST_NULL) {
                    return true;
                }
                // ERROR HERE???
                return false;
            } 
            // TODO: What if Field value is not a String?? Integer, Date, DateTime???
            // Always trim values stored in fields??
            if (fieldVal instanceof List<Object>) {
                // TODO: Which operators work on Lists?
            } else if (fieldVal instanceof String) {
                return interpretString((String)fieldVal);
            } else if (fieldVal instanceof Integer) {
                return interpretInteger((Integer)fieldVal);
            } else if (fieldVal instanceof Date) {
                return interpretDate((Date)fieldVal);
            } else if (fieldVal instanceof Boolean) {
                return interpretBoolean((Boolean)fieldVal);
            } else if (fieldVal instanceof DateTime) {
                DateTime dtm = (DateTime)fieldVal;
                Date dt = Date.newInstance(dtm.year(), dtm.month(), dtm.day());
                return interpretDate(dt);
            } else if (fieldVal instanceof Decimal) {
                Decimal dec = (Decimal)fieldVal;
                return interpretDecimal(dec);
            }
            return false;
        }
        
        private Boolean interpretString(String fieldValueIn) {
            String fieldValue = fieldValueIn.trim();
    
            if (symConst instanceof IntegerSymbol) {
                // EX: account.stringField longerThan 10 
                Integer intConst = ((IntegerSymbol)symConst).integerValue;
                if (oper == CMP_LONGER_THAN) return fieldValue.length() > intConst;
                else if (oper == CMP_SHORTER_THAN) return fieldValue.length() < intConst;
                else return false;
            } else if (symConst instanceof StringSymbol) {
                // EX: Account.Name == "IBM" 
                String cnst = symConst.value;
                if (oper == CMP_EQUAL) {
                    return fieldValue.equalsIgnoreCase(cnst);
                } else if (oper == CMP_NOT_EQUAL){
                    return !fieldValue.equalsIgnoreCase(cnst);
                } else if (oper == CMP_STARTS_WITH){
                    return fieldValue.toLowerCase().startsWith(cnst.toLowerCase());
                } else if (oper == CMP_ENDS_WITH){
                    return fieldValue.toLowerCase().endsWith(cnst.toLowerCase());
                } else if (oper == CMP_MATCHES){
		            try {
		                // Add (?i) to make the match Case Insensitive
		                Pattern ptrn = Pattern.compile('(?i)' + cnst);
		                Matcher mtchr = ptrn.matcher(fieldValue);
		                if (mtchr.find()) {
		                    return true;
		                }
		            } catch (Exception e) {
		                // FIXME: log('Error processing regex value for regex ' + cnst + ', fieldValue: ' + fieldValue + '.' + e.getMessage());
		            }
		            return false;
                } else if (oper == CMP_CONTAINS){
                    return fieldValue.toLowerCase().indexOf(cnst.toLowerCase()) >= 0;
                } else {
                    return false;
                } 
            }
            return false;            
        }
        
        private Boolean interpretInteger(Integer fieldValue) {
            if (symConst instanceof IntegerSymbol) {
                Integer intConst = ((IntegerSymbol)symConst).integerValue;
                if (oper == CMP_EQUAL) return fieldValue == intConst;
                else if (oper == CMP_NOT_EQUAL) return fieldValue != intConst;
                else if (oper == CMP_GREATER_THAN) return fieldValue > intConst;
                else if (oper == CMP_GREATER_THAN_OR_EQUAL) return fieldValue >= intConst;
                else if (oper == CMP_LESS_THAN) return fieldValue < intConst;
                else if (oper == CMP_LESS_THAN_OR_EQUAL) return fieldValue <= intConst;
                else return false;
            }          
            return false;
        }
        
        private Boolean interpretDecimal(Decimal fieldValue) {
            if (symConst instanceof IntegerSymbol) {
                Integer intConst = ((IntegerSymbol)symConst).integerValue;
                Integer intFieldValue = Integer.valueOf(fieldValue);
                if (oper == CMP_EQUAL) return intFieldValue == intConst;
                else if (oper == CMP_NOT_EQUAL) return intFieldValue != intConst;
                else if (oper == CMP_GREATER_THAN) return intFieldValue > intConst;
                else if (oper == CMP_GREATER_THAN_OR_EQUAL) return intFieldValue >= intConst;
                else if (oper == CMP_LESS_THAN) return intFieldValue < intConst;
                else if (oper == CMP_LESS_THAN_OR_EQUAL) return intFieldValue <= intConst;
                else return false;
            } else if (symConst instanceof DecimalSymbol) {
                Decimal decConst = ((DecimalSymbol)symConst).decimalValue;
                if (oper == CMP_EQUAL) return fieldValue == decConst;
                else if (oper == CMP_NOT_EQUAL) return fieldValue != decConst;
                else if (oper == CMP_GREATER_THAN) return fieldValue > decConst;
                else if (oper == CMP_GREATER_THAN_OR_EQUAL) return fieldValue >= decConst;
                else if (oper == CMP_LESS_THAN) return fieldValue < decConst;
                else if (oper == CMP_LESS_THAN_OR_EQUAL) return fieldValue <= decConst;
                else return false;
            }          
            return false;
        }
        
        private Boolean interpretBoolean(Boolean fieldValue) {
            if (symConst instanceof BooleanSymbol) {
                Boolean boolConst = ((BooleanSymbol)symConst).booleanValue;
                if (oper == CMP_EQUAL) return fieldValue == boolConst;
                else if (oper == CMP_NOT_EQUAL) return fieldValue != boolConst;
                else return false;
            }          
            return false;
        }
        
        private Boolean interpretDate(Date fieldValue) {
            if (symConst instanceof DateSymbol) {
                Date dateConst = ((DateSymbol)symConst).dateValue;
                if (oper == CMP_EQUAL) return fieldValue == dateConst;
                else if (oper == CMP_NOT_EQUAL) return fieldValue != dateConst;
                else if (oper == CMP_GREATER_THAN) return fieldValue > dateConst;
                else if (oper == CMP_GREATER_THAN_OR_EQUAL) return fieldValue >= dateConst;
                else if (oper == CMP_LESS_THAN) return fieldValue < dateConst;
                else if (oper == CMP_LESS_THAN_OR_EQUAL) return fieldValue <= dateConst;
                else return false;
            }          
            return false;
        }
        
        public override String toString() {
            return ident + ' ' + oper + ' ' + '"' + symConst.value + '"';
        }
    }

    
}
