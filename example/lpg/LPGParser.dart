
    //#line 128 "btParserTemplateF.gi

import 'package:lpg2/lpg2.dart';
import 'dart:io';
import 'LPGParserprs.dart';
import 'LPGParsersym.dart';

    //#line 137 "btParserTemplateF.gi

class LPGParser extends Object implements RuleAction
{

    @override
    void ruleAction(int ruleNumber) {
           var act = _rule_action[ruleNumber];
            if(null != act){
                act(); 
            }
    }

    PrsStream prsStream = PrsStream();

    bool unimplementedSymbolsWarning = false;

    static  ParseTable prsTable  = LPGParserprs();
    ParseTable getParseTable()  { return LPGParser.prsTable; }

    late BacktrackingParser btParser;
    BacktrackingParser getParser(){ return btParser; }

    void setResult(Object? object1){ btParser.setSym1(object1); }
    Object? getRhsSym(int i){ return btParser.getSym(i); }

    int getRhsTokenIndex(int i)  { return btParser.getToken(i); }
    IToken getRhsIToken(int i)   { return prsStream.getIToken(getRhsTokenIndex(i)); }

    int getRhsFirstTokenIndex(int i)   { return btParser.getFirstToken(i); }
    IToken getRhsFirstIToken(int i)  { return prsStream.getIToken(getRhsFirstTokenIndex(i)); }

    int getRhsLastTokenIndex(int i)  { return btParser.getLastToken(i); }
    IToken getRhsLastIToken(int i)  { return prsStream.getIToken(getRhsLastTokenIndex(i)); }

    int getLeftSpan() { return btParser.getFirstToken(); }
    IToken getLeftIToken()   { return prsStream.getIToken(getLeftSpan()); }

    int getRightSpan() { return btParser.getLastToken(); }
    IToken getRightIToken() { return prsStream.getIToken(getRightSpan()); }

    int getRhsErrorTokenIndex(int i)  
    {
        var index = btParser.getToken(i);
        var err = prsStream.getIToken(index);
        return (err is ErrorToken ? index : 0);
    }
    ErrorToken? getRhsErrorIToken(int i)  
    {
        var index = btParser.getToken(i);
        var err = prsStream.getIToken(index);
        return err as ErrorToken?;
    }

    void  reset(ILexStream lexStream)   
    {
        prsStream.resetLexStream(lexStream);
        btParser.reset(prsStream);

        try
        {
            prsStream.remapTerminalSymbols(orderedTerminalSymbols(), LPGParser.prsTable.getEoftSymbol());
        } 
        on NullExportedSymbolsException{}
        on UnimplementedTerminalsException catch (e)
        {
            if (unimplementedSymbolsWarning) {
                var unimplemented_symbols = e.getSymbols();
                stdout.writeln("The Lexer will not scan the following token(s):");
                for (var i  = 0; i < unimplemented_symbols!.size(); i++)
                {
                    int id = unimplemented_symbols.get(i);
                    stdout.writeln("    " + LPGParsersym.orderedTerminalSymbols[id]);               
                }
                stdout.writeln();
            }
        }
        on UndefinedEofSymbolException catch (e)
        {
            throw (UndefinedEofSymbolException
                ("The Lexer does not implement the Eof symbol " +
                LPGParsersym.orderedTerminalSymbols[LPGParser.prsTable.getEoftSymbol()]));
        }

    }
    List<dynamic?> _rule_action = List.filled(147 + 2, null);
    LPGParser([ILexStream? lexStream])
    {
        initRuleAction();
        try
        {
            btParser = BacktrackingParser(null, LPGParser.prsTable, this);
        }
        on  NotBacktrackParseTableException
        {
            throw (NotBacktrackParseTableException
                ("Regenerate LPGParserprs.dart with -BACKTRACK option"));
        }
        on BadParseSymFileException
        {
            throw (BadParseSymFileException("Bad Parser Symbol File -- LPGParsersym.dart"));
        }

        if(lexStream != null){
          reset(lexStream);
        }
    }
    
   
    
    int numTokenKinds(){ return LPGParsersym.numTokenKinds; }
    List<String>  orderedTerminalSymbols()  { return LPGParsersym.orderedTerminalSymbols; }
    String  getTokenKindName(int kind)   { return LPGParsersym.orderedTerminalSymbols[kind]; }
    int  getEOFTokenKind() { return LPGParser.prsTable.getEoftSymbol(); }
    IPrsStream getIPrsStream(){ return prsStream; }


    IAst? parser([int error_repair_count = 0 ,Monitor?  monitor])
    {
        btParser.setMonitor(monitor);
        
        try{
            return btParser.fuzzyParse(error_repair_count) as IAst?;
        }
        on BadParseException catch(e){
            prsStream.reset(e.error_token); // point to error token
            var diagnoseParser = DiagnoseParser(prsStream, LPGParser.prsTable);
            diagnoseParser.diagnose(e.error_token);
        }
        return null;
    }

    //
    // Additional entry points, if any
    //
    

    //#line 224 "LPGParser.g



    //#line 277 "btParserTemplateF.gi

    void initRuleAction(){


            //
            // Rule 1:  LPG ::= options_segment LPG_INPUT
            //
             _rule_action[1]=(){
               //#line 37 "LPGParser.g"
                setResult(
                    //#line 37 LPGParser.g
                    LPG(getLeftIToken(), getRightIToken(),
                        //#line 37 LPGParser.g
                        getRhsSym(1) as option_specList,
                        //#line 37 LPGParser.g
                        getRhsSym(2) as LPG_itemList)
                //#line 37 LPGParser.g
                );
            
            };
            //
            // Rule 2:  LPG_INPUT ::= %Empty
            //
             _rule_action[2]=(){
               //#line 40 "LPGParser.g"
                setResult(
                    //#line 40 LPGParser.g
                    LPG_itemList(getLeftIToken(), getRightIToken(), true /* left recursive */)
                //#line 40 LPGParser.g
                );
            
            };
            //
            // Rule 3:  LPG_INPUT ::= LPG_INPUT LPG_item
            //
             _rule_action[3]=(){
               //#line 41 "LPGParser.g"
                (getRhsSym(1) as LPG_itemList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 4:  LPG_item ::= ALIAS_KEY$ alias_segment END_KEY_OPT$
            //
             _rule_action[4]=(){
               //#line 44 "LPGParser.g"
                setResult(
                    //#line 44 LPGParser.g
                    AliasSeg(getLeftIToken(), getRightIToken(),
                             //#line 44 LPGParser.g
                             getRhsSym(2) as aliasSpecList)
                //#line 44 LPGParser.g
                );
            
            };
            //
            // Rule 5:  LPG_item ::= AST_KEY$ ast_segment END_KEY_OPT$
            //
             _rule_action[5]=(){
               //#line 45 "LPGParser.g"
                setResult(
                    //#line 45 LPGParser.g
                    AstSeg(getLeftIToken(), getRightIToken(),
                           //#line 45 LPGParser.g
                           getRhsSym(2) as action_segmentList)
                //#line 45 LPGParser.g
                );
            
            };
            //
            // Rule 6:  LPG_item ::= DEFINE_KEY$ define_segment END_KEY_OPT$
            //
             _rule_action[6]=(){
               //#line 46 "LPGParser.g"
                setResult(
                    //#line 46 LPGParser.g
                    DefineSeg(getLeftIToken(), getRightIToken(),
                              //#line 46 LPGParser.g
                              getRhsSym(2) as defineSpecList)
                //#line 46 LPGParser.g
                );
            
            };
            //
            // Rule 7:  LPG_item ::= EOF_KEY$ eof_segment END_KEY_OPT$
            //
             _rule_action[7]=(){
               //#line 47 "LPGParser.g"
                setResult(
                    //#line 47 LPGParser.g
                    EofSeg(getLeftIToken(), getRightIToken(),
                           //#line 47 LPGParser.g
                           getRhsSym(2) as ASTNode)
                //#line 47 LPGParser.g
                );
            
            };
            //
            // Rule 8:  LPG_item ::= EOL_KEY$ eol_segment END_KEY_OPT$
            //
             _rule_action[8]=(){
               //#line 48 "LPGParser.g"
                setResult(
                    //#line 48 LPGParser.g
                    EolSeg(getLeftIToken(), getRightIToken(),
                           //#line 48 LPGParser.g
                           getRhsSym(2) as ASTNode)
                //#line 48 LPGParser.g
                );
            
            };
            //
            // Rule 9:  LPG_item ::= ERROR_KEY$ error_segment END_KEY_OPT$
            //
             _rule_action[9]=(){
               //#line 49 "LPGParser.g"
                setResult(
                    //#line 49 LPGParser.g
                    ErrorSeg(getLeftIToken(), getRightIToken(),
                             //#line 49 LPGParser.g
                             getRhsSym(2) as ASTNode)
                //#line 49 LPGParser.g
                );
            
            };
            //
            // Rule 10:  LPG_item ::= EXPORT_KEY$ export_segment END_KEY_OPT$
            //
             _rule_action[10]=(){
               //#line 50 "LPGParser.g"
                setResult(
                    //#line 50 LPGParser.g
                    ExportSeg(getLeftIToken(), getRightIToken(),
                              //#line 50 LPGParser.g
                              getRhsSym(2) as terminal_symbolList)
                //#line 50 LPGParser.g
                );
            
            };
            //
            // Rule 11:  LPG_item ::= GLOBALS_KEY$ globals_segment END_KEY_OPT$
            //
             _rule_action[11]=(){
               //#line 51 "LPGParser.g"
                setResult(
                    //#line 51 LPGParser.g
                    GlobalsSeg(getLeftIToken(), getRightIToken(),
                               //#line 51 LPGParser.g
                               getRhsSym(2) as action_segmentList)
                //#line 51 LPGParser.g
                );
            
            };
            //
            // Rule 12:  LPG_item ::= HEADERS_KEY$ headers_segment END_KEY_OPT$
            //
             _rule_action[12]=(){
               //#line 52 "LPGParser.g"
                setResult(
                    //#line 52 LPGParser.g
                    HeadersSeg(getLeftIToken(), getRightIToken(),
                               //#line 52 LPGParser.g
                               getRhsSym(2) as action_segmentList)
                //#line 52 LPGParser.g
                );
            
            };
            //
            // Rule 13:  LPG_item ::= IDENTIFIER_KEY$ identifier_segment END_KEY_OPT$
            //
             _rule_action[13]=(){
               //#line 53 "LPGParser.g"
                setResult(
                    //#line 53 LPGParser.g
                    IdentifierSeg(getLeftIToken(), getRightIToken(),
                                  //#line 53 LPGParser.g
                                  getRhsSym(2) as ASTNode)
                //#line 53 LPGParser.g
                );
            
            };
            //
            // Rule 14:  LPG_item ::= IMPORT_KEY$ import_segment END_KEY_OPT$
            //
             _rule_action[14]=(){
               //#line 54 "LPGParser.g"
                setResult(
                    //#line 54 LPGParser.g
                    ImportSeg(getLeftIToken(), getRightIToken(),
                              //#line 54 LPGParser.g
                              getRhsSym(2) as import_segment)
                //#line 54 LPGParser.g
                );
            
            };
            //
            // Rule 15:  LPG_item ::= INCLUDE_KEY$ include_segment END_KEY_OPT$
            //
             _rule_action[15]=(){
               //#line 55 "LPGParser.g"
                setResult(
                    //#line 55 LPGParser.g
                    IncludeSeg(getLeftIToken(), getRightIToken(),
                               //#line 55 LPGParser.g
                               getRhsSym(2) as include_segment)
                //#line 55 LPGParser.g
                );
            
            };
            //
            // Rule 16:  LPG_item ::= KEYWORDS_KEY$ keywords_segment END_KEY_OPT$
            //
             _rule_action[16]=(){
               //#line 56 "LPGParser.g"
                setResult(
                    //#line 56 LPGParser.g
                    KeywordsSeg(getLeftIToken(), getRightIToken(),
                                //#line 56 LPGParser.g
                                getRhsSym(2) as keywordSpecList)
                //#line 56 LPGParser.g
                );
            
            };
            //
            // Rule 17:  LPG_item ::= NAMES_KEY$ names_segment END_KEY_OPT$
            //
             _rule_action[17]=(){
               //#line 57 "LPGParser.g"
                setResult(
                    //#line 57 LPGParser.g
                    NamesSeg(getLeftIToken(), getRightIToken(),
                             //#line 57 LPGParser.g
                             getRhsSym(2) as nameSpecList)
                //#line 57 LPGParser.g
                );
            
            };
            //
            // Rule 18:  LPG_item ::= NOTICE_KEY$ notice_segment END_KEY_OPT$
            //
             _rule_action[18]=(){
               //#line 58 "LPGParser.g"
                setResult(
                    //#line 58 LPGParser.g
                    NoticeSeg(getLeftIToken(), getRightIToken(),
                              //#line 58 LPGParser.g
                              getRhsSym(2) as action_segmentList)
                //#line 58 LPGParser.g
                );
            
            };
            //
            // Rule 19:  LPG_item ::= RULES_KEY$ rules_segment END_KEY_OPT$
            //
             _rule_action[19]=(){
               //#line 59 "LPGParser.g"
                setResult(
                    //#line 59 LPGParser.g
                    RulesSeg(getLeftIToken(), getRightIToken(),
                             //#line 59 LPGParser.g
                             getRhsSym(2) as rules_segment)
                //#line 59 LPGParser.g
                );
            
            };
            //
            // Rule 20:  LPG_item ::= SOFT_KEYWORDS_KEY$ keywords_segment END_KEY_OPT$
            //
             _rule_action[20]=(){
               //#line 60 "LPGParser.g"
                setResult(
                    //#line 60 LPGParser.g
                    SoftKeywordsSeg(getLeftIToken(), getRightIToken(),
                                    //#line 60 LPGParser.g
                                    getRhsSym(2) as keywordSpecList)
                //#line 60 LPGParser.g
                );
            
            };
            //
            // Rule 21:  LPG_item ::= START_KEY$ start_segment END_KEY_OPT$
            //
             _rule_action[21]=(){
               //#line 61 "LPGParser.g"
                setResult(
                    //#line 61 LPGParser.g
                    StartSeg(getLeftIToken(), getRightIToken(),
                             //#line 61 LPGParser.g
                             getRhsSym(2) as start_symbolList)
                //#line 61 LPGParser.g
                );
            
            };
            //
            // Rule 22:  LPG_item ::= TERMINALS_KEY$ terminals_segment END_KEY_OPT$
            //
             _rule_action[22]=(){
               //#line 62 "LPGParser.g"
                setResult(
                    //#line 62 LPGParser.g
                    TerminalsSeg(getLeftIToken(), getRightIToken(),
                                 //#line 62 LPGParser.g
                                 getRhsSym(2) as terminals_segment_terminalList)
                //#line 62 LPGParser.g
                );
            
            };
            //
            // Rule 23:  LPG_item ::= TRAILERS_KEY$ trailers_segment END_KEY_OPT$
            //
             _rule_action[23]=(){
               //#line 63 "LPGParser.g"
                setResult(
                    //#line 63 LPGParser.g
                    TrailersSeg(getLeftIToken(), getRightIToken(),
                                //#line 63 LPGParser.g
                                getRhsSym(2) as action_segmentList)
                //#line 63 LPGParser.g
                );
            
            };
            //
            // Rule 24:  LPG_item ::= TYPES_KEY$ types_segment END_KEY_OPT$
            //
             _rule_action[24]=(){
               //#line 64 "LPGParser.g"
                setResult(
                    //#line 64 LPGParser.g
                    TypesSeg(getLeftIToken(), getRightIToken(),
                             //#line 64 LPGParser.g
                             getRhsSym(2) as type_declarationsList)
                //#line 64 LPGParser.g
                );
            
            };
            //
            // Rule 25:  LPG_item ::= RECOVER_KEY$ recover_segment END_KEY_OPT$
            //
             _rule_action[25]=(){
               //#line 65 "LPGParser.g"
                setResult(
                    //#line 65 LPGParser.g
                    RecoverSeg(getLeftIToken(), getRightIToken(),
                               //#line 65 LPGParser.g
                               getRhsSym(2) as SYMBOLList)
                //#line 65 LPGParser.g
                );
            
            };
            //
            // Rule 26:  LPG_item ::= DISJOINTPREDECESSORSETS_KEY$ predecessor_segment END_KEY_OPT$
            //
             _rule_action[26]=(){
               //#line 66 "LPGParser.g"
                setResult(
                    //#line 66 LPGParser.g
                    PredecessorSeg(getLeftIToken(), getRightIToken(),
                                   //#line 66 LPGParser.g
                                   getRhsSym(2) as symbol_pairList)
                //#line 66 LPGParser.g
                );
            
            };
            //
            // Rule 27:  options_segment ::= %Empty
            //
             _rule_action[27]=(){
               //#line 69 "LPGParser.g"
                setResult(
                    //#line 69 LPGParser.g
                    option_specList(getLeftIToken(), getRightIToken(), true /* left recursive */)
                //#line 69 LPGParser.g
                );
            
            };
            //
            // Rule 28:  options_segment ::= options_segment option_spec
            //
             _rule_action[28]=(){
               //#line 69 "LPGParser.g"
                (getRhsSym(1) as option_specList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 29:  option_spec ::= OPTIONS_KEY$ option_list
            //
             _rule_action[29]=(){
               //#line 70 "LPGParser.g"
                setResult(
                    //#line 70 LPGParser.g
                    option_spec(getLeftIToken(), getRightIToken(),
                                //#line 70 LPGParser.g
                                getRhsSym(2) as optionList)
                //#line 70 LPGParser.g
                );
            
            };
            //
            // Rule 30:  option_list ::= option
            //
             _rule_action[30]=(){
               //#line 71 "LPGParser.g"
                setResult(
                    //#line 71 LPGParser.g
                    optionList.optionListfromElement(getRhsSym(1) as option, true /* left recursive */)
                //#line 71 LPGParser.g
                );
            
            };
            //
            // Rule 31:  option_list ::= option_list ,$ option
            //
             _rule_action[31]=(){
               //#line 71 "LPGParser.g"
                (getRhsSym(1) as optionList).addElement(getRhsSym(3)as ASTNode);
            
            };
            //
            // Rule 32:  option ::= SYMBOL option_value
            //
             _rule_action[32]=(){
               //#line 72 "LPGParser.g"
                setResult(
                    //#line 72 LPGParser.g
                    option(getLeftIToken(), getRightIToken(),
                           //#line 72 LPGParser.g
                           ASTNodeToken(getRhsIToken(1)),
                           //#line 72 LPGParser.g
                           getRhsSym(2) as ASTNode?)
                //#line 72 LPGParser.g
                );
            
            };
            //
            // Rule 33:  option_value ::= %Empty
            //
             _rule_action[33]=(){
               //#line 73 "LPGParser.g"
                setResult(null);
            
            };
            //
            // Rule 34:  option_value ::= =$ SYMBOL
            //
             _rule_action[34]=(){
               //#line 73 "LPGParser.g"
                setResult(
                    //#line 73 LPGParser.g
                    option_value0(getLeftIToken(), getRightIToken(),
                                  //#line 73 LPGParser.g
                                  ASTNodeToken(getRhsIToken(2)))
                //#line 73 LPGParser.g
                );
            
            };
            //
            // Rule 35:  option_value ::= =$ ($ symbol_list )$
            //
             _rule_action[35]=(){
               //#line 73 "LPGParser.g"
                setResult(
                    //#line 73 LPGParser.g
                    option_value1(getLeftIToken(), getRightIToken(),
                                  //#line 73 LPGParser.g
                                  getRhsSym(3) as SYMBOLList)
                //#line 73 LPGParser.g
                );
            
            };
            //
            // Rule 36:  symbol_list ::= SYMBOL
            //
             _rule_action[36]=(){
               //#line 75 "LPGParser.g"
                setResult(
                    //#line 75 LPGParser.g
                    SYMBOLList.SYMBOLListfromElement(ASTNodeToken(getRhsIToken(1)), true /* left recursive */)
                //#line 75 LPGParser.g
                );
            
            };
            //
            // Rule 37:  symbol_list ::= symbol_list ,$ SYMBOL
            //
             _rule_action[37]=(){
               //#line 76 "LPGParser.g"
                (getRhsSym(1) as SYMBOLList).addElement(ASTNodeToken(getRhsIToken(3)));
            
            };
            //
            // Rule 38:  alias_segment ::= aliasSpec
            //
             _rule_action[38]=(){
               //#line 79 "LPGParser.g"
                setResult(
                    //#line 79 LPGParser.g
                    aliasSpecList.aliasSpecListfromElement(getRhsSym(1) as ASTNode, true /* left recursive */)
                //#line 79 LPGParser.g
                );
            
            };
            //
            // Rule 39:  alias_segment ::= alias_segment aliasSpec
            //
             _rule_action[39]=(){
               //#line 79 "LPGParser.g"
                (getRhsSym(1) as aliasSpecList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 40:  aliasSpec ::= ERROR_KEY produces alias_rhs
            //
             _rule_action[40]=(){
               //#line 81 "LPGParser.g"
                setResult(
                    //#line 81 LPGParser.g
                    aliasSpec0(getLeftIToken(), getRightIToken(),
                               //#line 81 LPGParser.g
                               ASTNodeToken(getRhsIToken(1)),
                               //#line 81 LPGParser.g
                               getRhsSym(2) as ASTNode,
                               //#line 81 LPGParser.g
                               getRhsSym(3) as ASTNode)
                //#line 81 LPGParser.g
                );
            
            };
            //
            // Rule 41:  aliasSpec ::= EOL_KEY produces alias_rhs
            //
             _rule_action[41]=(){
               //#line 82 "LPGParser.g"
                setResult(
                    //#line 82 LPGParser.g
                    aliasSpec1(getLeftIToken(), getRightIToken(),
                               //#line 82 LPGParser.g
                               ASTNodeToken(getRhsIToken(1)),
                               //#line 82 LPGParser.g
                               getRhsSym(2) as ASTNode,
                               //#line 82 LPGParser.g
                               getRhsSym(3) as ASTNode)
                //#line 82 LPGParser.g
                );
            
            };
            //
            // Rule 42:  aliasSpec ::= EOF_KEY produces alias_rhs
            //
             _rule_action[42]=(){
               //#line 83 "LPGParser.g"
                setResult(
                    //#line 83 LPGParser.g
                    aliasSpec2(getLeftIToken(), getRightIToken(),
                               //#line 83 LPGParser.g
                               ASTNodeToken(getRhsIToken(1)),
                               //#line 83 LPGParser.g
                               getRhsSym(2) as ASTNode,
                               //#line 83 LPGParser.g
                               getRhsSym(3) as ASTNode)
                //#line 83 LPGParser.g
                );
            
            };
            //
            // Rule 43:  aliasSpec ::= IDENTIFIER_KEY produces alias_rhs
            //
             _rule_action[43]=(){
               //#line 84 "LPGParser.g"
                setResult(
                    //#line 84 LPGParser.g
                    aliasSpec3(getLeftIToken(), getRightIToken(),
                               //#line 84 LPGParser.g
                               ASTNodeToken(getRhsIToken(1)),
                               //#line 84 LPGParser.g
                               getRhsSym(2) as ASTNode,
                               //#line 84 LPGParser.g
                               getRhsSym(3) as ASTNode)
                //#line 84 LPGParser.g
                );
            
            };
            //
            // Rule 44:  aliasSpec ::= SYMBOL produces alias_rhs
            //
             _rule_action[44]=(){
               //#line 85 "LPGParser.g"
                setResult(
                    //#line 85 LPGParser.g
                    aliasSpec4(getLeftIToken(), getRightIToken(),
                               //#line 85 LPGParser.g
                               ASTNodeToken(getRhsIToken(1)),
                               //#line 85 LPGParser.g
                               getRhsSym(2) as ASTNode,
                               //#line 85 LPGParser.g
                               getRhsSym(3) as ASTNode)
                //#line 85 LPGParser.g
                );
            
            };
            //
            // Rule 45:  aliasSpec ::= alias_lhs_macro_name produces alias_rhs
            //
             _rule_action[45]=(){
               //#line 86 "LPGParser.g"
                setResult(
                    //#line 86 LPGParser.g
                    aliasSpec5(getLeftIToken(), getRightIToken(),
                               //#line 86 LPGParser.g
                               getRhsSym(1) as alias_lhs_macro_name,
                               //#line 86 LPGParser.g
                               getRhsSym(2) as ASTNode,
                               //#line 86 LPGParser.g
                               getRhsSym(3) as ASTNode)
                //#line 86 LPGParser.g
                );
            
            };
            //
            // Rule 46:  alias_lhs_macro_name ::= MACRO_NAME
            //
             _rule_action[46]=(){
               //#line 88 "LPGParser.g"
                setResult(
                    //#line 88 LPGParser.g
                    alias_lhs_macro_name(getRhsIToken(1))
                //#line 88 LPGParser.g
                );
            
            };
            //
            // Rule 47:  alias_rhs ::= SYMBOL
            //
             _rule_action[47]=(){
               //#line 90 "LPGParser.g"
                setResult(
                    //#line 90 LPGParser.g
                    alias_rhs0(getRhsIToken(1))
                //#line 90 LPGParser.g
                );
            
            };
            //
            // Rule 48:  alias_rhs ::= MACRO_NAME
            //
             _rule_action[48]=(){
               //#line 91 "LPGParser.g"
                setResult(
                    //#line 91 LPGParser.g
                    alias_rhs1(getRhsIToken(1))
                //#line 91 LPGParser.g
                );
            
            };
            //
            // Rule 49:  alias_rhs ::= ERROR_KEY
            //
             _rule_action[49]=(){
               //#line 92 "LPGParser.g"
                setResult(
                    //#line 92 LPGParser.g
                    alias_rhs2(getRhsIToken(1))
                //#line 92 LPGParser.g
                );
            
            };
            //
            // Rule 50:  alias_rhs ::= EOL_KEY
            //
             _rule_action[50]=(){
               //#line 93 "LPGParser.g"
                setResult(
                    //#line 93 LPGParser.g
                    alias_rhs3(getRhsIToken(1))
                //#line 93 LPGParser.g
                );
            
            };
            //
            // Rule 51:  alias_rhs ::= EOF_KEY
            //
             _rule_action[51]=(){
               //#line 94 "LPGParser.g"
                setResult(
                    //#line 94 LPGParser.g
                    alias_rhs4(getRhsIToken(1))
                //#line 94 LPGParser.g
                );
            
            };
            //
            // Rule 52:  alias_rhs ::= EMPTY_KEY
            //
             _rule_action[52]=(){
               //#line 95 "LPGParser.g"
                setResult(
                    //#line 95 LPGParser.g
                    alias_rhs5(getRhsIToken(1))
                //#line 95 LPGParser.g
                );
            
            };
            //
            // Rule 53:  alias_rhs ::= IDENTIFIER_KEY
            //
             _rule_action[53]=(){
               //#line 96 "LPGParser.g"
                setResult(
                    //#line 96 LPGParser.g
                    alias_rhs6(getRhsIToken(1))
                //#line 96 LPGParser.g
                );
            
            };
            //
            // Rule 54:  ast_segment ::= action_segment_list
            //
            
                 
            //
            // Rule 55:  define_segment ::= defineSpec
            //
             _rule_action[55]=(){
               //#line 102 "LPGParser.g"
                setResult(
                    //#line 102 LPGParser.g
                    defineSpecList.defineSpecListfromElement(getRhsSym(1) as defineSpec, true /* left recursive */)
                //#line 102 LPGParser.g
                );
            
            };
            //
            // Rule 56:  define_segment ::= define_segment defineSpec
            //
             _rule_action[56]=(){
               //#line 102 "LPGParser.g"
                (getRhsSym(1) as defineSpecList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 57:  defineSpec ::= macro_name_symbol macro_segment
            //
             _rule_action[57]=(){
               //#line 103 "LPGParser.g"
                setResult(
                    //#line 103 LPGParser.g
                    defineSpec(getLeftIToken(), getRightIToken(),
                               //#line 103 LPGParser.g
                               getRhsSym(1) as ASTNode,
                               //#line 103 LPGParser.g
                               getRhsSym(2) as macro_segment)
                //#line 103 LPGParser.g
                );
            
            };
            //
            // Rule 58:  macro_name_symbol ::= MACRO_NAME
            //
             _rule_action[58]=(){
               //#line 106 "LPGParser.g"
                setResult(
                    //#line 106 LPGParser.g
                    macro_name_symbol0(getRhsIToken(1))
                //#line 106 LPGParser.g
                );
            
            };
            //
            // Rule 59:  macro_name_symbol ::= SYMBOL
            //
             _rule_action[59]=(){
               //#line 107 "LPGParser.g"
                setResult(
                    //#line 107 LPGParser.g
                    macro_name_symbol1(getRhsIToken(1))
                //#line 107 LPGParser.g
                );
            
            };
            //
            // Rule 60:  macro_segment ::= BLOCK
            //
             _rule_action[60]=(){
               //#line 108 "LPGParser.g"
                setResult(
                    //#line 108 LPGParser.g
                    macro_segment(getRhsIToken(1))
                //#line 108 LPGParser.g
                );
            
            };
            //
            // Rule 61:  eol_segment ::= terminal_symbol
            //
            
                 
            //
            // Rule 62:  eof_segment ::= terminal_symbol
            //
            
                 
            //
            // Rule 63:  error_segment ::= terminal_symbol
            //
            
                 
            //
            // Rule 64:  export_segment ::= terminal_symbol
            //
             _rule_action[64]=(){
               //#line 118 "LPGParser.g"
                setResult(
                    //#line 118 LPGParser.g
                    terminal_symbolList.terminal_symbolListfromElement(getRhsSym(1) as ASTNode, true /* left recursive */)
                //#line 118 LPGParser.g
                );
            
            };
            //
            // Rule 65:  export_segment ::= export_segment terminal_symbol
            //
             _rule_action[65]=(){
               //#line 118 "LPGParser.g"
                (getRhsSym(1) as terminal_symbolList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 66:  globals_segment ::= action_segment
            //
             _rule_action[66]=(){
               //#line 121 "LPGParser.g"
                setResult(
                    //#line 121 LPGParser.g
                    action_segmentList.action_segmentListfromElement(getRhsSym(1) as action_segment, true /* left recursive */)
                //#line 121 LPGParser.g
                );
            
            };
            //
            // Rule 67:  globals_segment ::= globals_segment action_segment
            //
             _rule_action[67]=(){
               //#line 121 "LPGParser.g"
                (getRhsSym(1) as action_segmentList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 68:  headers_segment ::= action_segment_list
            //
            
                 
            //
            // Rule 69:  identifier_segment ::= terminal_symbol
            //
            
                 
            //
            // Rule 70:  import_segment ::= SYMBOL drop_command_list
            //
             _rule_action[70]=(){
               //#line 130 "LPGParser.g"
                setResult(
                    //#line 130 LPGParser.g
                    import_segment(getLeftIToken(), getRightIToken(),
                                   //#line 130 LPGParser.g
                                   ASTNodeToken(getRhsIToken(1)),
                                   //#line 130 LPGParser.g
                                   getRhsSym(2) as drop_commandList)
                //#line 130 LPGParser.g
                );
            
            };
            //
            // Rule 71:  drop_command_list ::= %Empty
            //
             _rule_action[71]=(){
               //#line 132 "LPGParser.g"
                setResult(
                    //#line 132 LPGParser.g
                    drop_commandList(getLeftIToken(), getRightIToken(), true /* left recursive */)
                //#line 132 LPGParser.g
                );
            
            };
            //
            // Rule 72:  drop_command_list ::= drop_command_list drop_command
            //
             _rule_action[72]=(){
               //#line 132 "LPGParser.g"
                (getRhsSym(1) as drop_commandList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 73:  drop_command ::= DROPSYMBOLS_KEY drop_symbols
            //
             _rule_action[73]=(){
               //#line 134 "LPGParser.g"
                setResult(
                    //#line 134 LPGParser.g
                    drop_command0(getLeftIToken(), getRightIToken(),
                                  //#line 134 LPGParser.g
                                  ASTNodeToken(getRhsIToken(1)),
                                  //#line 134 LPGParser.g
                                  getRhsSym(2) as SYMBOLList)
                //#line 134 LPGParser.g
                );
            
            };
            //
            // Rule 74:  drop_command ::= DROPRULES_KEY drop_rules
            //
             _rule_action[74]=(){
               //#line 135 "LPGParser.g"
                setResult(
                    //#line 135 LPGParser.g
                    drop_command1(getLeftIToken(), getRightIToken(),
                                  //#line 135 LPGParser.g
                                  ASTNodeToken(getRhsIToken(1)),
                                  //#line 135 LPGParser.g
                                  getRhsSym(2) as drop_ruleList)
                //#line 135 LPGParser.g
                );
            
            };
            //
            // Rule 75:  drop_symbols ::= SYMBOL
            //
             _rule_action[75]=(){
               //#line 137 "LPGParser.g"
                setResult(
                    //#line 137 LPGParser.g
                    SYMBOLList.SYMBOLListfromElement(ASTNodeToken(getRhsIToken(1)), true /* left recursive */)
                //#line 137 LPGParser.g
                );
            
            };
            //
            // Rule 76:  drop_symbols ::= drop_symbols SYMBOL
            //
             _rule_action[76]=(){
               //#line 138 "LPGParser.g"
                (getRhsSym(1) as SYMBOLList).addElement(ASTNodeToken(getRhsIToken(2)));
            
            };
            //
            // Rule 77:  drop_rules ::= drop_rule
            //
             _rule_action[77]=(){
               //#line 139 "LPGParser.g"
                setResult(
                    //#line 139 LPGParser.g
                    drop_ruleList.drop_ruleListfromElement(getRhsSym(1) as drop_rule, true /* left recursive */)
                //#line 139 LPGParser.g
                );
            
            };
            //
            // Rule 78:  drop_rules ::= drop_rules drop_rule
            //
             _rule_action[78]=(){
               //#line 140 "LPGParser.g"
                (getRhsSym(1) as drop_ruleList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 79:  drop_rule ::= SYMBOL optMacroName produces ruleList
            //
             _rule_action[79]=(){
               //#line 142 "LPGParser.g"
                setResult(
                    //#line 142 LPGParser.g
                    drop_rule(getLeftIToken(), getRightIToken(),
                              //#line 142 LPGParser.g
                              ASTNodeToken(getRhsIToken(1)),
                              //#line 142 LPGParser.g
                              getRhsSym(2) as optMacroName?,
                              //#line 142 LPGParser.g
                              getRhsSym(3) as ASTNode,
                              //#line 142 LPGParser.g
                              getRhsSym(4) as ruleList)
                //#line 142 LPGParser.g
                );
            
            };
            //
            // Rule 80:  optMacroName ::= %Empty
            //
             _rule_action[80]=(){
               //#line 144 "LPGParser.g"
                setResult(null);
            
            };
            //
            // Rule 81:  optMacroName ::= MACRO_NAME
            //
             _rule_action[81]=(){
               //#line 144 "LPGParser.g"
                setResult(
                    //#line 144 LPGParser.g
                    optMacroName(getRhsIToken(1))
                //#line 144 LPGParser.g
                );
            
            };
            //
            // Rule 82:  include_segment ::= SYMBOL
            //
             _rule_action[82]=(){
               //#line 147 "LPGParser.g"
                setResult(
                    //#line 147 LPGParser.g
                    include_segment(getRhsIToken(1))
                //#line 147 LPGParser.g
                );
            
            };
            //
            // Rule 83:  keywords_segment ::= keywordSpec
            //
             _rule_action[83]=(){
               //#line 150 "LPGParser.g"
                setResult(
                    //#line 150 LPGParser.g
                    keywordSpecList.keywordSpecListfromElement(getRhsSym(1) as ASTNode, true /* left recursive */)
                //#line 150 LPGParser.g
                );
            
            };
            //
            // Rule 84:  keywords_segment ::= keywords_segment keywordSpec
            //
             _rule_action[84]=(){
               //#line 150 "LPGParser.g"
                (getRhsSym(1) as keywordSpecList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 85:  keywordSpec ::= terminal_symbol
            //
            
                 
            //
            // Rule 86:  keywordSpec ::= terminal_symbol produces name
            //
             _rule_action[86]=(){
               //#line 152 "LPGParser.g"
                setResult(
                    //#line 152 LPGParser.g
                    keywordSpec(getLeftIToken(), getRightIToken(),
                                //#line 152 LPGParser.g
                                getRhsSym(1) as ASTNode,
                                //#line 152 LPGParser.g
                                getRhsSym(2) as ASTNode,
                                //#line 152 LPGParser.g
                                getRhsSym(3) as ASTNode)
                //#line 152 LPGParser.g
                );
            
            };
            //
            // Rule 87:  names_segment ::= nameSpec
            //
             _rule_action[87]=(){
               //#line 155 "LPGParser.g"
                setResult(
                    //#line 155 LPGParser.g
                    nameSpecList.nameSpecListfromElement(getRhsSym(1) as nameSpec, true /* left recursive */)
                //#line 155 LPGParser.g
                );
            
            };
            //
            // Rule 88:  names_segment ::= names_segment nameSpec
            //
             _rule_action[88]=(){
               //#line 155 "LPGParser.g"
                (getRhsSym(1) as nameSpecList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 89:  nameSpec ::= name produces name
            //
             _rule_action[89]=(){
               //#line 156 "LPGParser.g"
                setResult(
                    //#line 156 LPGParser.g
                    nameSpec(getLeftIToken(), getRightIToken(),
                             //#line 156 LPGParser.g
                             getRhsSym(1) as ASTNode,
                             //#line 156 LPGParser.g
                             getRhsSym(2) as ASTNode,
                             //#line 156 LPGParser.g
                             getRhsSym(3) as ASTNode)
                //#line 156 LPGParser.g
                );
            
            };
            //
            // Rule 90:  name ::= SYMBOL
            //
             _rule_action[90]=(){
               //#line 158 "LPGParser.g"
                setResult(
                    //#line 158 LPGParser.g
                    name0(getRhsIToken(1))
                //#line 158 LPGParser.g
                );
            
            };
            //
            // Rule 91:  name ::= MACRO_NAME
            //
             _rule_action[91]=(){
               //#line 159 "LPGParser.g"
                setResult(
                    //#line 159 LPGParser.g
                    name1(getRhsIToken(1))
                //#line 159 LPGParser.g
                );
            
            };
            //
            // Rule 92:  name ::= EMPTY_KEY
            //
             _rule_action[92]=(){
               //#line 160 "LPGParser.g"
                setResult(
                    //#line 160 LPGParser.g
                    name2(getRhsIToken(1))
                //#line 160 LPGParser.g
                );
            
            };
            //
            // Rule 93:  name ::= ERROR_KEY
            //
             _rule_action[93]=(){
               //#line 161 "LPGParser.g"
                setResult(
                    //#line 161 LPGParser.g
                    name3(getRhsIToken(1))
                //#line 161 LPGParser.g
                );
            
            };
            //
            // Rule 94:  name ::= EOL_KEY
            //
             _rule_action[94]=(){
               //#line 162 "LPGParser.g"
                setResult(
                    //#line 162 LPGParser.g
                    name4(getRhsIToken(1))
                //#line 162 LPGParser.g
                );
            
            };
            //
            // Rule 95:  name ::= IDENTIFIER_KEY
            //
             _rule_action[95]=(){
               //#line 163 "LPGParser.g"
                setResult(
                    //#line 163 LPGParser.g
                    name5(getRhsIToken(1))
                //#line 163 LPGParser.g
                );
            
            };
            //
            // Rule 96:  notice_segment ::= action_segment
            //
             _rule_action[96]=(){
               //#line 166 "LPGParser.g"
                setResult(
                    //#line 166 LPGParser.g
                    action_segmentList.action_segmentListfromElement(getRhsSym(1) as action_segment, true /* left recursive */)
                //#line 166 LPGParser.g
                );
            
            };
            //
            // Rule 97:  notice_segment ::= notice_segment action_segment
            //
             _rule_action[97]=(){
               //#line 166 "LPGParser.g"
                (getRhsSym(1) as action_segmentList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 98:  rules_segment ::= action_segment_list nonTermList
            //
             _rule_action[98]=(){
               //#line 169 "LPGParser.g"
                setResult(
                    //#line 169 LPGParser.g
                    rules_segment(getLeftIToken(), getRightIToken(),
                                  //#line 169 LPGParser.g
                                  getRhsSym(1) as action_segmentList,
                                  //#line 169 LPGParser.g
                                  getRhsSym(2) as nonTermList)
                //#line 169 LPGParser.g
                );
            
            };
            //
            // Rule 99:  nonTermList ::= %Empty
            //
             _rule_action[99]=(){
               //#line 171 "LPGParser.g"
                setResult(
                    //#line 171 LPGParser.g
                    nonTermList(getLeftIToken(), getRightIToken(), true /* left recursive */)
                //#line 171 LPGParser.g
                );
            
            };
            //
            // Rule 100:  nonTermList ::= nonTermList nonTerm
            //
             _rule_action[100]=(){
               //#line 171 "LPGParser.g"
                (getRhsSym(1) as nonTermList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 101:  nonTerm ::= ruleNameWithAttributes produces ruleList
            //
             _rule_action[101]=(){
               //#line 173 "LPGParser.g"
                setResult(
                    //#line 173 LPGParser.g
                    nonTerm(getLeftIToken(), getRightIToken(),
                            //#line 173 LPGParser.g
                            getRhsSym(1) as RuleName,
                            //#line 173 LPGParser.g
                            getRhsSym(2) as ASTNode,
                            //#line 173 LPGParser.g
                            getRhsSym(3) as ruleList)
                //#line 173 LPGParser.g
                );
            
            };
            //
            // Rule 102:  ruleNameWithAttributes ::= SYMBOL
            //
             _rule_action[102]=(){
               //#line 177 "LPGParser.g"
                setResult(
                    //#line 177 LPGParser.g
                    RuleName(getLeftIToken(), getRightIToken(),
                             //#line 177 LPGParser.g
                             ASTNodeToken(getRhsIToken(1)),
                             //#line 177 LPGParser.g
                             null,
                             //#line 177 LPGParser.g
                             null)
                //#line 177 LPGParser.g
                );
            
            };
            //
            // Rule 103:  ruleNameWithAttributes ::= SYMBOL MACRO_NAME$className
            //
             _rule_action[103]=(){
               //#line 178 "LPGParser.g"
                setResult(
                    //#line 178 LPGParser.g
                    RuleName(getLeftIToken(), getRightIToken(),
                             //#line 178 LPGParser.g
                             ASTNodeToken(getRhsIToken(1)),
                             //#line 178 LPGParser.g
                             ASTNodeToken(getRhsIToken(2)),
                             //#line 178 LPGParser.g
                             null)
                //#line 178 LPGParser.g
                );
            
            };
            //
            // Rule 104:  ruleNameWithAttributes ::= SYMBOL MACRO_NAME$className MACRO_NAME$arrayElement
            //
             _rule_action[104]=(){
               //#line 179 "LPGParser.g"
                setResult(
                    //#line 179 LPGParser.g
                    RuleName(getLeftIToken(), getRightIToken(),
                             //#line 179 LPGParser.g
                             ASTNodeToken(getRhsIToken(1)),
                             //#line 179 LPGParser.g
                             ASTNodeToken(getRhsIToken(2)),
                             //#line 179 LPGParser.g
                             ASTNodeToken(getRhsIToken(3)))
                //#line 179 LPGParser.g
                );
            
            };
            //
            // Rule 105:  ruleList ::= rule
            //
             _rule_action[105]=(){
               //#line 193 "LPGParser.g"
                setResult(
                    //#line 193 LPGParser.g
                    ruleList.ruleListfromElement(getRhsSym(1) as rule, true /* left recursive */)
                //#line 193 LPGParser.g
                );
            
            };
            //
            // Rule 106:  ruleList ::= ruleList |$ rule
            //
             _rule_action[106]=(){
               //#line 193 "LPGParser.g"
                (getRhsSym(1) as ruleList).addElement(getRhsSym(3)as ASTNode);
            
            };
            //
            // Rule 107:  produces ::= ::=
            //
             _rule_action[107]=(){
               //#line 195 "LPGParser.g"
                setResult(
                    //#line 195 LPGParser.g
                    produces0(getRhsIToken(1))
                //#line 195 LPGParser.g
                );
            
            };
            //
            // Rule 108:  produces ::= ::=?
            //
             _rule_action[108]=(){
               //#line 196 "LPGParser.g"
                setResult(
                    //#line 196 LPGParser.g
                    produces1(getRhsIToken(1))
                //#line 196 LPGParser.g
                );
            
            };
            //
            // Rule 109:  produces ::= ->
            //
             _rule_action[109]=(){
               //#line 197 "LPGParser.g"
                setResult(
                    //#line 197 LPGParser.g
                    produces2(getRhsIToken(1))
                //#line 197 LPGParser.g
                );
            
            };
            //
            // Rule 110:  produces ::= ->?
            //
             _rule_action[110]=(){
               //#line 198 "LPGParser.g"
                setResult(
                    //#line 198 LPGParser.g
                    produces3(getRhsIToken(1))
                //#line 198 LPGParser.g
                );
            
            };
            //
            // Rule 111:  rule ::= symWithAttrsList action_segment_list
            //
             _rule_action[111]=(){
               //#line 200 "LPGParser.g"
                setResult(
                    //#line 200 LPGParser.g
                    rule(getLeftIToken(), getRightIToken(),
                         //#line 200 LPGParser.g
                         getRhsSym(1) as symWithAttrsList,
                         //#line 200 LPGParser.g
                         getRhsSym(2) as action_segmentList)
                //#line 200 LPGParser.g
                );
            
            };
            //
            // Rule 112:  symWithAttrsList ::= %Empty
            //
             _rule_action[112]=(){
               //#line 202 "LPGParser.g"
                setResult(
                    //#line 202 LPGParser.g
                    symWithAttrsList(getLeftIToken(), getRightIToken(), true /* left recursive */)
                //#line 202 LPGParser.g
                );
            
            };
            //
            // Rule 113:  symWithAttrsList ::= symWithAttrsList symWithAttrs
            //
             _rule_action[113]=(){
               //#line 202 "LPGParser.g"
                (getRhsSym(1) as symWithAttrsList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 114:  symWithAttrs ::= EMPTY_KEY
            //
             _rule_action[114]=(){
               //#line 204 "LPGParser.g"
                setResult(
                    //#line 204 LPGParser.g
                    symWithAttrs0(getRhsIToken(1))
                //#line 204 LPGParser.g
                );
            
            };
            //
            // Rule 115:  symWithAttrs ::= SYMBOL optAttrList
            //
             _rule_action[115]=(){
               //#line 205 "LPGParser.g"
                setResult(
                    //#line 205 LPGParser.g
                    symWithAttrs1(getLeftIToken(), getRightIToken(),
                                  //#line 205 LPGParser.g
                                  ASTNodeToken(getRhsIToken(1)),
                                  //#line 205 LPGParser.g
                                  getRhsSym(2) as symAttrs?)
                //#line 205 LPGParser.g
                );
            
            };
            //
            // Rule 116:  optAttrList ::= %Empty
            //
             _rule_action[116]=(){
               //#line 208 "LPGParser.g"
                setResult(
                    //#line 208 LPGParser.g
                    symAttrs(getLeftIToken(), getRightIToken(),
                             //#line 208 LPGParser.g
                             null)
                //#line 208 LPGParser.g
                );
            
            };
            //
            // Rule 117:  optAttrList ::= MACRO_NAME
            //
             _rule_action[117]=(){
               //#line 209 "LPGParser.g"
                setResult(
                    //#line 209 LPGParser.g
                    symAttrs(getLeftIToken(), getRightIToken(),
                             //#line 209 LPGParser.g
                             ASTNodeToken(getRhsIToken(1)))
                //#line 209 LPGParser.g
                );
            
            };
            //
            // Rule 118:  opt_action_segment ::= %Empty
            //
             _rule_action[118]=(){
               //#line 211 "LPGParser.g"
                setResult(null);
            
            };
            //
            // Rule 119:  opt_action_segment ::= action_segment
            //
            
                 
            //
            // Rule 120:  action_segment ::= BLOCK
            //
             _rule_action[120]=(){
               //#line 213 "LPGParser.g"
                setResult(
                    //#line 213 LPGParser.g
                    action_segment(getRhsIToken(1))
                //#line 213 LPGParser.g
                );
            
            };
            //
            // Rule 121:  start_segment ::= start_symbol
            //
             _rule_action[121]=(){
               //#line 217 "LPGParser.g"
                setResult(
                    //#line 217 LPGParser.g
                    start_symbolList.start_symbolListfromElement(getRhsSym(1) as ASTNode, true /* left recursive */)
                //#line 217 LPGParser.g
                );
            
            };
            //
            // Rule 122:  start_segment ::= start_segment start_symbol
            //
             _rule_action[122]=(){
               //#line 217 "LPGParser.g"
                (getRhsSym(1) as start_symbolList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 123:  start_symbol ::= SYMBOL
            //
             _rule_action[123]=(){
               //#line 218 "LPGParser.g"
                setResult(
                    //#line 218 LPGParser.g
                    start_symbol0(getRhsIToken(1))
                //#line 218 LPGParser.g
                );
            
            };
            //
            // Rule 124:  start_symbol ::= MACRO_NAME
            //
             _rule_action[124]=(){
               //#line 219 "LPGParser.g"
                setResult(
                    //#line 219 LPGParser.g
                    start_symbol1(getRhsIToken(1))
                //#line 219 LPGParser.g
                );
            
            };
            //
            // Rule 125:  terminals_segment ::= terminal
            //
             _rule_action[125]=(){
               //#line 222 "LPGParser.g"
                setResult(
                    //#line 222 LPGParser.g
                    terminals_segment_terminalList.terminals_segment_terminalListfromElement(this, getRhsSym(1) as terminal, true /* left recursive */)
                //#line 222 LPGParser.g
                );
            
            };
            //
            // Rule 126:  terminals_segment ::= terminals_segment terminal
            //
             _rule_action[126]=(){
               //#line 222 "LPGParser.g"
                (getRhsSym(1) as terminals_segment_terminalList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 127:  terminal ::= terminal_symbol optTerminalAlias
            //
             _rule_action[127]=(){
               //#line 227 "LPGParser.g"
                setResult(
                    //#line 227 LPGParser.g
                    terminal(getLeftIToken(), getRightIToken(),
                             //#line 227 LPGParser.g
                             getRhsSym(1) as ASTNode,
                             //#line 227 LPGParser.g
                             getRhsSym(2) as optTerminalAlias?)
                //#line 227 LPGParser.g
                );
            
            };
            //
            // Rule 128:  optTerminalAlias ::= %Empty
            //
             _rule_action[128]=(){
               //#line 229 "LPGParser.g"
                setResult(null);
            
            };
            //
            // Rule 129:  optTerminalAlias ::= produces name
            //
             _rule_action[129]=(){
               //#line 229 "LPGParser.g"
                setResult(
                    //#line 229 LPGParser.g
                    optTerminalAlias(getLeftIToken(), getRightIToken(),
                                     //#line 229 LPGParser.g
                                     getRhsSym(1) as ASTNode,
                                     //#line 229 LPGParser.g
                                     getRhsSym(2) as ASTNode)
                //#line 229 LPGParser.g
                );
            
            };
            //
            // Rule 130:  terminal_symbol ::= SYMBOL
            //
             _rule_action[130]=(){
               //#line 231 "LPGParser.g"
                setResult(
                    //#line 231 LPGParser.g
                    terminal_symbol0(getRhsIToken(1))
                //#line 231 LPGParser.g
                );
            
            };
            //
            // Rule 131:  terminal_symbol ::= MACRO_NAME
            //
             _rule_action[131]=(){
               //#line 233 "LPGParser.g"
                setResult(
                    //#line 233 LPGParser.g
                    terminal_symbol1(getRhsIToken(1))
                //#line 233 LPGParser.g
                );
            
            };
            //
            // Rule 132:  trailers_segment ::= action_segment_list
            //
            
                 
            //
            // Rule 133:  types_segment ::= type_declarations
            //
             _rule_action[133]=(){
               //#line 239 "LPGParser.g"
                setResult(
                    //#line 239 LPGParser.g
                    type_declarationsList.type_declarationsListfromElement(getRhsSym(1) as type_declarations, true /* left recursive */)
                //#line 239 LPGParser.g
                );
            
            };
            //
            // Rule 134:  types_segment ::= types_segment type_declarations
            //
             _rule_action[134]=(){
               //#line 239 "LPGParser.g"
                (getRhsSym(1) as type_declarationsList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 135:  type_declarations ::= SYMBOL produces barSymbolList opt_action_segment
            //
             _rule_action[135]=(){
               //#line 241 "LPGParser.g"
                setResult(
                    //#line 241 LPGParser.g
                    type_declarations(getLeftIToken(), getRightIToken(),
                                      //#line 241 LPGParser.g
                                      ASTNodeToken(getRhsIToken(1)),
                                      //#line 241 LPGParser.g
                                      getRhsSym(2) as ASTNode,
                                      //#line 241 LPGParser.g
                                      getRhsSym(3) as SYMBOLList,
                                      //#line 241 LPGParser.g
                                      getRhsSym(4) as action_segment?)
                //#line 241 LPGParser.g
                );
            
            };
            //
            // Rule 136:  barSymbolList ::= SYMBOL
            //
             _rule_action[136]=(){
               //#line 242 "LPGParser.g"
                setResult(
                    //#line 242 LPGParser.g
                    SYMBOLList.SYMBOLListfromElement(ASTNodeToken(getRhsIToken(1)), true /* left recursive */)
                //#line 242 LPGParser.g
                );
            
            };
            //
            // Rule 137:  barSymbolList ::= barSymbolList |$ SYMBOL
            //
             _rule_action[137]=(){
               //#line 242 "LPGParser.g"
                (getRhsSym(1) as SYMBOLList).addElement(ASTNodeToken(getRhsIToken(3)));
            
            };
            //
            // Rule 138:  predecessor_segment ::= %Empty
            //
             _rule_action[138]=(){
               //#line 245 "LPGParser.g"
                setResult(
                    //#line 245 LPGParser.g
                    symbol_pairList(getLeftIToken(), getRightIToken(), true /* left recursive */)
                //#line 245 LPGParser.g
                );
            
            };
            //
            // Rule 139:  predecessor_segment ::= predecessor_segment symbol_pair
            //
             _rule_action[139]=(){
               //#line 245 "LPGParser.g"
                (getRhsSym(1) as symbol_pairList).addElement(getRhsSym(2)as ASTNode);
            
            };
            //
            // Rule 140:  symbol_pair ::= SYMBOL SYMBOL
            //
             _rule_action[140]=(){
               //#line 247 "LPGParser.g"
                setResult(
                    //#line 247 LPGParser.g
                    symbol_pair(getLeftIToken(), getRightIToken(),
                                //#line 247 LPGParser.g
                                ASTNodeToken(getRhsIToken(1)),
                                //#line 247 LPGParser.g
                                ASTNodeToken(getRhsIToken(2)))
                //#line 247 LPGParser.g
                );
            
            };
            //
            // Rule 141:  recover_segment ::= %Empty
            //
             _rule_action[141]=(){
               //#line 250 "LPGParser.g"
                setResult(
                    //#line 250 LPGParser.g
                    SYMBOLList(getLeftIToken(), getRightIToken(), true /* left recursive */)
                //#line 250 LPGParser.g
                );
            
            };
            //
            // Rule 142:  recover_segment ::= recover_segment recover_symbol
            //
             _rule_action[142]=(){
               //#line 250 "LPGParser.g"
                setResult(getRhsSym(1) as SYMBOLList);
            
            };
            //
            // Rule 143:  recover_symbol ::= SYMBOL
            //
             _rule_action[143]=(){
               //#line 252 "LPGParser.g"
                setResult(
                    //#line 252 LPGParser.g
                    recover_symbol(getRhsIToken(1))
                //#line 252 LPGParser.g
                );
            
            };
            //
            // Rule 144:  END_KEY_OPT ::= %Empty
            //
             _rule_action[144]=(){
               //#line 255 "LPGParser.g"
                setResult(null);
            
            };
            //
            // Rule 145:  END_KEY_OPT ::= END_KEY
            //
             _rule_action[145]=(){
               //#line 256 "LPGParser.g"
                setResult(
                    //#line 256 LPGParser.g
                    END_KEY_OPT(getRhsIToken(1))
                //#line 256 LPGParser.g
                );
            
            };
            //
            // Rule 146:  action_segment_list ::= %Empty
            //
             _rule_action[146]=(){
               //#line 258 "LPGParser.g"
                setResult(
                    //#line 258 LPGParser.g
                    action_segmentList(getLeftIToken(), getRightIToken(), true /* left recursive */)
                //#line 258 LPGParser.g
                );
            
            };
            //
            // Rule 147:  action_segment_list ::= action_segment_list action_segment
            //
             _rule_action[147]=(){
               //#line 259 "LPGParser.g"
                (getRhsSym(1) as action_segmentList).addElement(getRhsSym(2)as ASTNode);
            
            };
    //#line 281 "btParserTemplateF.gi

    }

}
abstract class IRootForLPGParser
    {
         IToken getLeftIToken() ;
        IToken  getRightIToken() ;

        void accept(IAstVisitor v );
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>alias_lhs_macro_name
     **<li>macro_segment
     **<li>optMacroName
     **<li>include_segment
     **<li>RuleName
     **<li>symAttrs
     **<li>action_segment
     **<li>recover_symbol
     **<li>END_KEY_OPT
     **<li>alias_rhs0
     **<li>alias_rhs1
     **<li>alias_rhs2
     **<li>alias_rhs3
     **<li>alias_rhs4
     **<li>alias_rhs5
     **<li>alias_rhs6
     **<li>macro_name_symbol0
     **<li>macro_name_symbol1
     **<li>name0
     **<li>name1
     **<li>name2
     **<li>name3
     **<li>name4
     **<li>name5
     **<li>produces0
     **<li>produces1
     **<li>produces2
     **<li>produces3
     **<li>symWithAttrs0
     **<li>symWithAttrs1
     **<li>start_symbol0
     **<li>start_symbol1
     **<li>terminal_symbol0
     **<li>terminal_symbol1
     **</ul>
     **</b>
     **/
abstract class IASTNodeToken implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>LPG</b>
     **/
abstract class ILPG implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>option_specList</b>
     **/
abstract class Ioptions_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>LPG_itemList</b>
     **/
abstract class ILPG_INPUT implements IRootForLPGParser    {
    }

    /***
     ** is implemented by:
     **<b>
     **<ul>
     **<li>AliasSeg
     **<li>AstSeg
     **<li>DefineSeg
     **<li>EofSeg
     **<li>EolSeg
     **<li>ErrorSeg
     **<li>ExportSeg
     **<li>GlobalsSeg
     **<li>HeadersSeg
     **<li>IdentifierSeg
     **<li>ImportSeg
     **<li>IncludeSeg
     **<li>KeywordsSeg
     **<li>NamesSeg
     **<li>NoticeSeg
     **<li>RulesSeg
     **<li>SoftKeywordsSeg
     **<li>StartSeg
     **<li>TerminalsSeg
     **<li>TrailersSeg
     **<li>TypesSeg
     **<li>RecoverSeg
     **<li>PredecessorSeg
     **</ul>
     **</b>
     **/
abstract class ILPG_item implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>aliasSpecList</b>
     **/
abstract class Ialias_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>action_segmentList</b>
     **/
abstract class Iast_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>defineSpecList</b>
     **/
abstract class Idefine_segment implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>terminal_symbol0
     **<li>terminal_symbol1
     **</ul>
     **</b>
     **/
abstract class Ieof_segment implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>terminal_symbol0
     **<li>terminal_symbol1
     **</ul>
     **</b>
     **/
abstract class Ieol_segment implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>terminal_symbol0
     **<li>terminal_symbol1
     **</ul>
     **</b>
     **/
abstract class Ierror_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>terminal_symbolList</b>
     **/
abstract class Iexport_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>action_segmentList</b>
     **/
abstract class Iglobals_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>action_segmentList</b>
     **/
abstract class Iheaders_segment implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>terminal_symbol0
     **<li>terminal_symbol1
     **</ul>
     **</b>
     **/
abstract class Iidentifier_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>import_segment</b>
     **/
abstract class Iimport_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>keywordSpecList</b>
     **/
abstract class Ikeywords_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>nameSpecList</b>
     **/
abstract class Inames_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>action_segmentList</b>
     **/
abstract class Inotice_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>rules_segment</b>
     **/
abstract class Irules_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>start_symbolList</b>
     **/
abstract class Istart_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>terminalList</b>
     **/
abstract class Iterminals_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>action_segmentList</b>
     **/
abstract class Itrailers_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>type_declarationsList</b>
     **/
abstract class Itypes_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>SYMBOLList</b>
     **/
abstract class Irecover_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>symbol_pairList</b>
     **/
abstract class Ipredecessor_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>option_spec</b>
     **/
abstract class Ioption_spec implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>optionList</b>
     **/
abstract class Ioption_list implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>option</b>
     **/
abstract class Ioption implements IRootForLPGParser    {
    }

    /***
     ** is implemented by:
     **<b>
     **<ul>
     **<li>option_value0
     **<li>option_value1
     **</ul>
     **</b>
     **/
abstract class Ioption_value implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>SYMBOLList</b>
     **/
abstract class Isymbol_list implements IRootForLPGParser    {
    }

    /***
     ** is implemented by:
     **<b>
     **<ul>
     **<li>aliasSpec0
     **<li>aliasSpec1
     **<li>aliasSpec2
     **<li>aliasSpec3
     **<li>aliasSpec4
     **<li>aliasSpec5
     **</ul>
     **</b>
     **/
abstract class IaliasSpec implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>defineSpec</b>
     **/
abstract class IdefineSpec implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>drop_commandList</b>
     **/
abstract class Idrop_command_list implements IRootForLPGParser    {
    }

    /***
     ** is implemented by:
     **<b>
     **<ul>
     **<li>drop_command0
     **<li>drop_command1
     **</ul>
     **</b>
     **/
abstract class Idrop_command implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>SYMBOLList</b>
     **/
abstract class Idrop_symbols implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>drop_ruleList</b>
     **/
abstract class Idrop_rules implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>drop_rule</b>
     **/
abstract class Idrop_rule implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>ruleList</b>
     **/
abstract class IruleList implements IRootForLPGParser    {
    }

    /***
     ** is implemented by:
     **<b>
     **<ul>
     **<li>keywordSpec
     **<li>terminal_symbol0
     **<li>terminal_symbol1
     **</ul>
     **</b>
     **/
abstract class IkeywordSpec implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>nameSpec</b>
     **/
abstract class InameSpec implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>nonTermList</b>
     **/
abstract class InonTermList implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>nonTerm</b>
     **/
abstract class InonTerm implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>rule</b>
     **/
abstract class Irule implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>symWithAttrsList</b>
     **/
abstract class IsymWithAttrsList implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by <b>action_segment</b>
     **/
abstract class Iopt_action_segment implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>terminal</b>
     **/
abstract class Iterminal implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>optTerminalAlias</b>
     **/
abstract class IoptTerminalAlias implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>type_declarations</b>
     **/
abstract class Itype_declarations implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>SYMBOLList</b>
     **/
abstract class IbarSymbolList implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>symbol_pair</b>
     **/
abstract class Isymbol_pair implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by <b>END_KEY_OPT</b>
     **/
abstract class IEND_KEY_OPT implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by <b>include_segment</b>
     **/
abstract class Iinclude_segment implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>produces0
     **<li>produces1
     **<li>produces2
     **<li>produces3
     **</ul>
     **</b>
     **/
abstract class Iproduces implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>alias_rhs0
     **<li>alias_rhs1
     **<li>alias_rhs2
     **<li>alias_rhs3
     **<li>alias_rhs4
     **<li>alias_rhs5
     **<li>alias_rhs6
     **</ul>
     **</b>
     **/
abstract class Ialias_rhs implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by <b>alias_lhs_macro_name</b>
     **/
abstract class Ialias_lhs_macro_name implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>action_segmentList</b>
     **/
abstract class Iaction_segment_list implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>macro_name_symbol0
     **<li>macro_name_symbol1
     **</ul>
     **</b>
     **/
abstract class Imacro_name_symbol implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by <b>macro_segment</b>
     **/
abstract class Imacro_segment implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>terminal_symbol0
     **<li>terminal_symbol1
     **</ul>
     **</b>
     **/
abstract class Iterminal_symbol implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by <b>action_segment</b>
     **/
abstract class Iaction_segment implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by <b>optMacroName</b>
     **/
abstract class IoptMacroName implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>name0
     **<li>name1
     **<li>name2
     **<li>name3
     **<li>name4
     **<li>name5
     **</ul>
     **</b>
     **/
abstract class Iname implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>RuleName</b>
     **/
abstract class IruleNameWithAttributes implements IRootForLPGParser    {
    }

    /***
     ** is implemented by:
     **<b>
     **<ul>
     **<li>symWithAttrs0
     **<li>symWithAttrs1
     **</ul>
     **</b>
     **/
abstract class IsymWithAttrs implements IRootForLPGParser    {
    }

    /***
     ** is implemented by <b>symAttrs</b>
     **/
abstract class IoptAttrList implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by:
     **<b>
     **<ul>
     **<li>start_symbol0
     **<li>start_symbol1
     **</ul>
     **</b>
     **/
abstract class Istart_symbol implements IRootForLPGParser    {
    }

    /***
     ** is always implemented by <b>ASTNodeToken</b>. It is also implemented by <b>recover_symbol</b>
     **/
abstract class Irecover_symbol implements IRootForLPGParser    {
    }

abstract class ASTNode implements IAst
    {
        IAst? getNextAst(){ return null; }
    void setNextAst(IAst n){ }
    void resetNextAst(){ }
         late IToken leftIToken ;
         late IToken rightIToken ;
         IAst? parent;
         void setParent(IAst p){ parent = p; }
         IAst? getParent(){ return parent; }

         IToken getLeftIToken()  { return leftIToken; }
         IToken getRightIToken()  { return rightIToken; }
          List<IToken> getPrecedingAdjuncts() { return leftIToken.getPrecedingAdjuncts(); }
          List<IToken> getFollowingAdjuncts() { return rightIToken.getFollowingAdjuncts(); }

        String  toString()  
        {
          var  lex = leftIToken.getILexStream();
          if( lex != null)
            return lex.toStringWithOffset(leftIToken.getStartOffset(), rightIToken.getEndOffset());
          return  '';
        }

    ASTNode(IToken leftIToken ,[ IToken? rightIToken ])
        {
            this.leftIToken = leftIToken;
            if(rightIToken != null) this.rightIToken = rightIToken;
            else            this.rightIToken = leftIToken;
        }

        void initialize(){}

        /**
         * A list of all children of this node, excluding the null ones.
         */
          ArrayList getChildren() 
        {
             var list = getAllChildren() ;
            var k = -1;
            for (var i = 0; i < list.size(); i++)
            {
                var element = list.get(i);
                if (null==element)
                {
                    if (++k != i)
                        list.set(k, element);
                }
            }
            for (var i = list.size() - 1; i > k; i--) // remove extraneous elements
                list.remove(i);
            return list;
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
         ArrayList getAllChildren() ;

         void accept(IAstVisitor v );
    }

abstract class AbstractASTNodeList extends ASTNode implements IAbstractArrayList<ASTNode>
    {
         late bool leftRecursive  ;
          var list  =  ArrayList();
         int size()   { return list.size(); }
         ArrayList getList(){ return list; }
         ASTNode getElementAt(int i) { return list.get(leftRecursive ? i : list.size() - 1 - i); }
         ArrayList getArrayList()
        {
            if (! leftRecursive) // reverse the list 
            {
                for (var i = 0, n = list.size() - 1; i < n; i++, n--)
                {
                    var ith = list.get(i),
                           nth = list.get(n);
                    list.set(i, nth);
                    list.set(n, ith);
                }
                leftRecursive = true;
            }
            return list;
        }
        /**
         * @deprecated replaced by {@link #addElement()}
         *
         */
         bool add(ASTNode element)
        {
            addElement(element);
            return true;
        }

         void addElement(ASTNode element)
        {
            list.add(element);
            if (leftRecursive)
                 rightIToken = element.getRightIToken();
            else leftIToken = element.getLeftIToken();
        }

          AbstractASTNodeList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken){
              this.leftRecursive = leftRecursive;
        }

        /**
         * Make a copy of the list and return it. Note that we obtain the local list by
         * invoking getArrayList so as to make sure that the list we return is in proper order.
         */
            ArrayList getAllChildren() 
        {
            return getArrayList().clone();
        }

    }

class ASTNodeToken extends ASTNode implements IASTNodeToken
    {
        ASTNodeToken(IToken token   ):super(token){  }
         IToken getIToken()  { return leftIToken; }
         String toString(){ return leftIToken.toString(); }

        /**
         * A token class has no children. So, we return the empty list.
         */
            ArrayList getAllChildren()  { return  ArrayList(); }


         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitASTNodeToken(this);
            v.endVisitASTNodeToken(this);
        }
    }

/**
 *<b>
*<li>Rule 1:  LPG ::= options_segment LPG_INPUT
 *</b>
 */
class LPG extends ASTNode implements ILPG
    {
         late option_specList _options_segment;
         late LPG_itemList _LPG_INPUT;

         option_specList getoptions_segment(){ return _options_segment; }
         void setoptions_segment(option_specList _options_segment){ this._options_segment = _options_segment; }
         LPG_itemList getLPG_INPUT(){ return _LPG_INPUT; }
         void setLPG_INPUT(LPG_itemList _LPG_INPUT){ this._LPG_INPUT = _LPG_INPUT; }

        LPG(IToken leftIToken, IToken rightIToken,
            option_specList _options_segment,
            LPG_itemList _LPG_INPUT)
            :super(leftIToken, rightIToken)

        {
            this._options_segment = _options_segment;
            (_options_segment as ASTNode).setParent(this);
            this._LPG_INPUT = _LPG_INPUT;
            (_LPG_INPUT as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _options_segment)  list.add(_options_segment);
            if(null != _LPG_INPUT)  list.add(_LPG_INPUT);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitLPG(this);
            if (checkChildren)
            {
                _options_segment.accept(v);
                _LPG_INPUT.accept(v);
            }
            v.endVisitLPG(this);
        }
    }

/**
 *<b>
*<li>Rule 2:  LPG_INPUT ::= %Empty
*<li>Rule 3:  LPG_INPUT ::= LPG_INPUT LPG_item
 *</b>
 */
class LPG_itemList extends AbstractASTNodeList implements ILPG_INPUT
    {
         ASTNode getLPG_itemAt(int i){ return getElementAt(i) as ASTNode; }

        LPG_itemList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static LPG_itemList LPG_itemListfromElement(ASTNode element,bool leftRecursive )
        {
            var obj = LPG_itemList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _LPG_item)
        {
            super.addElement(_LPG_item);
            _LPG_item.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitLPG_itemList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                    var element = getLPG_itemAt(i);
                    element.accept(v);
                }
            }
            v.endVisitLPG_itemList(this);
        }
    }

/**
 *<b>
*<li>Rule 4:  LPG_item ::= ALIAS_KEY$ alias_segment END_KEY_OPT$
 *</b>
 */
class AliasSeg extends ASTNode implements ILPG_item
    {
         late aliasSpecList _alias_segment;

         aliasSpecList getalias_segment(){ return _alias_segment; }
         void setalias_segment(aliasSpecList _alias_segment){ this._alias_segment = _alias_segment; }

        AliasSeg(IToken leftIToken, IToken rightIToken,
                 aliasSpecList _alias_segment)
            :super(leftIToken, rightIToken)

        {
            this._alias_segment = _alias_segment;
            (_alias_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _alias_segment)  list.add(_alias_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitAliasSeg(this);
            if (checkChildren)
                _alias_segment.accept(v);
            v.endVisitAliasSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 5:  LPG_item ::= AST_KEY$ ast_segment END_KEY_OPT$
 *</b>
 */
class AstSeg extends ASTNode implements ILPG_item
    {
         late action_segmentList _ast_segment;

         action_segmentList getast_segment(){ return _ast_segment; }
         void setast_segment(action_segmentList _ast_segment){ this._ast_segment = _ast_segment; }

        AstSeg(IToken leftIToken, IToken rightIToken,
               action_segmentList _ast_segment)
            :super(leftIToken, rightIToken)

        {
            this._ast_segment = _ast_segment;
            (_ast_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _ast_segment)  list.add(_ast_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitAstSeg(this);
            if (checkChildren)
                _ast_segment.accept(v);
            v.endVisitAstSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 6:  LPG_item ::= DEFINE_KEY$ define_segment END_KEY_OPT$
 *</b>
 */
class DefineSeg extends ASTNode implements ILPG_item
    {
         late defineSpecList _define_segment;

         defineSpecList getdefine_segment(){ return _define_segment; }
         void setdefine_segment(defineSpecList _define_segment){ this._define_segment = _define_segment; }

        DefineSeg(IToken leftIToken, IToken rightIToken,
                  defineSpecList _define_segment)
            :super(leftIToken, rightIToken)

        {
            this._define_segment = _define_segment;
            (_define_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _define_segment)  list.add(_define_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitDefineSeg(this);
            if (checkChildren)
                _define_segment.accept(v);
            v.endVisitDefineSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 7:  LPG_item ::= EOF_KEY$ eof_segment END_KEY_OPT$
 *</b>
 */
class EofSeg extends ASTNode implements ILPG_item
    {
         late ASTNode _eof_segment;

         ASTNode geteof_segment(){ return _eof_segment; }
         void seteof_segment(ASTNode _eof_segment){ this._eof_segment = _eof_segment; }

        EofSeg(IToken leftIToken, IToken rightIToken,
               ASTNode _eof_segment)
            :super(leftIToken, rightIToken)

        {
            this._eof_segment = _eof_segment;
            (_eof_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _eof_segment)  list.add(_eof_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitEofSeg(this);
            if (checkChildren)
                _eof_segment.accept(v);
            v.endVisitEofSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 8:  LPG_item ::= EOL_KEY$ eol_segment END_KEY_OPT$
 *</b>
 */
class EolSeg extends ASTNode implements ILPG_item
    {
         late ASTNode _eol_segment;

         ASTNode geteol_segment(){ return _eol_segment; }
         void seteol_segment(ASTNode _eol_segment){ this._eol_segment = _eol_segment; }

        EolSeg(IToken leftIToken, IToken rightIToken,
               ASTNode _eol_segment)
            :super(leftIToken, rightIToken)

        {
            this._eol_segment = _eol_segment;
            (_eol_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _eol_segment)  list.add(_eol_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitEolSeg(this);
            if (checkChildren)
                _eol_segment.accept(v);
            v.endVisitEolSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 9:  LPG_item ::= ERROR_KEY$ error_segment END_KEY_OPT$
 *</b>
 */
class ErrorSeg extends ASTNode implements ILPG_item
    {
         late ASTNode _error_segment;

         ASTNode geterror_segment(){ return _error_segment; }
         void seterror_segment(ASTNode _error_segment){ this._error_segment = _error_segment; }

        ErrorSeg(IToken leftIToken, IToken rightIToken,
                 ASTNode _error_segment)
            :super(leftIToken, rightIToken)

        {
            this._error_segment = _error_segment;
            (_error_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _error_segment)  list.add(_error_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitErrorSeg(this);
            if (checkChildren)
                _error_segment.accept(v);
            v.endVisitErrorSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 10:  LPG_item ::= EXPORT_KEY$ export_segment END_KEY_OPT$
 *</b>
 */
class ExportSeg extends ASTNode implements ILPG_item
    {
         late terminal_symbolList _export_segment;

         terminal_symbolList getexport_segment(){ return _export_segment; }
         void setexport_segment(terminal_symbolList _export_segment){ this._export_segment = _export_segment; }

        ExportSeg(IToken leftIToken, IToken rightIToken,
                  terminal_symbolList _export_segment)
            :super(leftIToken, rightIToken)

        {
            this._export_segment = _export_segment;
            (_export_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _export_segment)  list.add(_export_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitExportSeg(this);
            if (checkChildren)
                _export_segment.accept(v);
            v.endVisitExportSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 11:  LPG_item ::= GLOBALS_KEY$ globals_segment END_KEY_OPT$
 *</b>
 */
class GlobalsSeg extends ASTNode implements ILPG_item
    {
         late action_segmentList _globals_segment;

         action_segmentList getglobals_segment(){ return _globals_segment; }
         void setglobals_segment(action_segmentList _globals_segment){ this._globals_segment = _globals_segment; }

        GlobalsSeg(IToken leftIToken, IToken rightIToken,
                   action_segmentList _globals_segment)
            :super(leftIToken, rightIToken)

        {
            this._globals_segment = _globals_segment;
            (_globals_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _globals_segment)  list.add(_globals_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitGlobalsSeg(this);
            if (checkChildren)
                _globals_segment.accept(v);
            v.endVisitGlobalsSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 12:  LPG_item ::= HEADERS_KEY$ headers_segment END_KEY_OPT$
 *</b>
 */
class HeadersSeg extends ASTNode implements ILPG_item
    {
         late action_segmentList _headers_segment;

         action_segmentList getheaders_segment(){ return _headers_segment; }
         void setheaders_segment(action_segmentList _headers_segment){ this._headers_segment = _headers_segment; }

        HeadersSeg(IToken leftIToken, IToken rightIToken,
                   action_segmentList _headers_segment)
            :super(leftIToken, rightIToken)

        {
            this._headers_segment = _headers_segment;
            (_headers_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _headers_segment)  list.add(_headers_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitHeadersSeg(this);
            if (checkChildren)
                _headers_segment.accept(v);
            v.endVisitHeadersSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 13:  LPG_item ::= IDENTIFIER_KEY$ identifier_segment END_KEY_OPT$
 *</b>
 */
class IdentifierSeg extends ASTNode implements ILPG_item
    {
         late ASTNode _identifier_segment;

         ASTNode getidentifier_segment(){ return _identifier_segment; }
         void setidentifier_segment(ASTNode _identifier_segment){ this._identifier_segment = _identifier_segment; }

        IdentifierSeg(IToken leftIToken, IToken rightIToken,
                      ASTNode _identifier_segment)
            :super(leftIToken, rightIToken)

        {
            this._identifier_segment = _identifier_segment;
            (_identifier_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _identifier_segment)  list.add(_identifier_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitIdentifierSeg(this);
            if (checkChildren)
                _identifier_segment.accept(v);
            v.endVisitIdentifierSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 14:  LPG_item ::= IMPORT_KEY$ import_segment END_KEY_OPT$
 *</b>
 */
class ImportSeg extends ASTNode implements ILPG_item
    {
         late import_segment _import_segment;

         import_segment getimport_segment(){ return _import_segment; }
         void setimport_segment(import_segment _import_segment){ this._import_segment = _import_segment; }

        ImportSeg(IToken leftIToken, IToken rightIToken,
                  import_segment _import_segment)
            :super(leftIToken, rightIToken)

        {
            this._import_segment = _import_segment;
            (_import_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _import_segment)  list.add(_import_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitImportSeg(this);
            if (checkChildren)
                _import_segment.accept(v);
            v.endVisitImportSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 15:  LPG_item ::= INCLUDE_KEY$ include_segment END_KEY_OPT$
 *</b>
 */
class IncludeSeg extends ASTNode implements ILPG_item
    {
         late include_segment _include_segment;

         include_segment getinclude_segment(){ return _include_segment; }
         void setinclude_segment(include_segment _include_segment){ this._include_segment = _include_segment; }

        IncludeSeg(IToken leftIToken, IToken rightIToken,
                   include_segment _include_segment)
            :super(leftIToken, rightIToken)

        {
            this._include_segment = _include_segment;
            (_include_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _include_segment)  list.add(_include_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitIncludeSeg(this);
            if (checkChildren)
                _include_segment.accept(v);
            v.endVisitIncludeSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 16:  LPG_item ::= KEYWORDS_KEY$ keywords_segment END_KEY_OPT$
 *</b>
 */
class KeywordsSeg extends ASTNode implements ILPG_item
    {
         late keywordSpecList _keywords_segment;

         keywordSpecList getkeywords_segment(){ return _keywords_segment; }
         void setkeywords_segment(keywordSpecList _keywords_segment){ this._keywords_segment = _keywords_segment; }

        KeywordsSeg(IToken leftIToken, IToken rightIToken,
                    keywordSpecList _keywords_segment)
            :super(leftIToken, rightIToken)

        {
            this._keywords_segment = _keywords_segment;
            (_keywords_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _keywords_segment)  list.add(_keywords_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitKeywordsSeg(this);
            if (checkChildren)
                _keywords_segment.accept(v);
            v.endVisitKeywordsSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 17:  LPG_item ::= NAMES_KEY$ names_segment END_KEY_OPT$
 *</b>
 */
class NamesSeg extends ASTNode implements ILPG_item
    {
         late nameSpecList _names_segment;

         nameSpecList getnames_segment(){ return _names_segment; }
         void setnames_segment(nameSpecList _names_segment){ this._names_segment = _names_segment; }

        NamesSeg(IToken leftIToken, IToken rightIToken,
                 nameSpecList _names_segment)
            :super(leftIToken, rightIToken)

        {
            this._names_segment = _names_segment;
            (_names_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _names_segment)  list.add(_names_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitNamesSeg(this);
            if (checkChildren)
                _names_segment.accept(v);
            v.endVisitNamesSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 18:  LPG_item ::= NOTICE_KEY$ notice_segment END_KEY_OPT$
 *</b>
 */
class NoticeSeg extends ASTNode implements ILPG_item
    {
         late action_segmentList _notice_segment;

         action_segmentList getnotice_segment(){ return _notice_segment; }
         void setnotice_segment(action_segmentList _notice_segment){ this._notice_segment = _notice_segment; }

        NoticeSeg(IToken leftIToken, IToken rightIToken,
                  action_segmentList _notice_segment)
            :super(leftIToken, rightIToken)

        {
            this._notice_segment = _notice_segment;
            (_notice_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _notice_segment)  list.add(_notice_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitNoticeSeg(this);
            if (checkChildren)
                _notice_segment.accept(v);
            v.endVisitNoticeSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 19:  LPG_item ::= RULES_KEY$ rules_segment END_KEY_OPT$
 *</b>
 */
class RulesSeg extends ASTNode implements ILPG_item
    {
         late rules_segment _rules_segment;

         rules_segment getrules_segment(){ return _rules_segment; }
         void setrules_segment(rules_segment _rules_segment){ this._rules_segment = _rules_segment; }

        RulesSeg(IToken leftIToken, IToken rightIToken,
                 rules_segment _rules_segment)
            :super(leftIToken, rightIToken)

        {
            this._rules_segment = _rules_segment;
            (_rules_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _rules_segment)  list.add(_rules_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitRulesSeg(this);
            if (checkChildren)
                _rules_segment.accept(v);
            v.endVisitRulesSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 20:  LPG_item ::= SOFT_KEYWORDS_KEY$ keywords_segment END_KEY_OPT$
 *</b>
 */
class SoftKeywordsSeg extends ASTNode implements ILPG_item
    {
         late keywordSpecList _keywords_segment;

         keywordSpecList getkeywords_segment(){ return _keywords_segment; }
         void setkeywords_segment(keywordSpecList _keywords_segment){ this._keywords_segment = _keywords_segment; }

        SoftKeywordsSeg(IToken leftIToken, IToken rightIToken,
                        keywordSpecList _keywords_segment)
            :super(leftIToken, rightIToken)

        {
            this._keywords_segment = _keywords_segment;
            (_keywords_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _keywords_segment)  list.add(_keywords_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitSoftKeywordsSeg(this);
            if (checkChildren)
                _keywords_segment.accept(v);
            v.endVisitSoftKeywordsSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 21:  LPG_item ::= START_KEY$ start_segment END_KEY_OPT$
 *</b>
 */
class StartSeg extends ASTNode implements ILPG_item
    {
         late start_symbolList _start_segment;

         start_symbolList getstart_segment(){ return _start_segment; }
         void setstart_segment(start_symbolList _start_segment){ this._start_segment = _start_segment; }

        StartSeg(IToken leftIToken, IToken rightIToken,
                 start_symbolList _start_segment)
            :super(leftIToken, rightIToken)

        {
            this._start_segment = _start_segment;
            (_start_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _start_segment)  list.add(_start_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitStartSeg(this);
            if (checkChildren)
                _start_segment.accept(v);
            v.endVisitStartSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 22:  LPG_item ::= TERMINALS_KEY$ terminals_segment END_KEY_OPT$
 *</b>
 */
class TerminalsSeg extends ASTNode implements ILPG_item
    {
         late terminals_segment_terminalList _terminals_segment;

         terminals_segment_terminalList getterminals_segment(){ return _terminals_segment; }
         void setterminals_segment(terminals_segment_terminalList _terminals_segment){ this._terminals_segment = _terminals_segment; }

        TerminalsSeg(IToken leftIToken, IToken rightIToken,
                     terminals_segment_terminalList _terminals_segment)
            :super(leftIToken, rightIToken)

        {
            this._terminals_segment = _terminals_segment;
            (_terminals_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _terminals_segment)  list.add(_terminals_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitTerminalsSeg(this);
            if (checkChildren)
                _terminals_segment.accept(v);
            v.endVisitTerminalsSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 23:  LPG_item ::= TRAILERS_KEY$ trailers_segment END_KEY_OPT$
 *</b>
 */
class TrailersSeg extends ASTNode implements ILPG_item
    {
         late action_segmentList _trailers_segment;

         action_segmentList gettrailers_segment(){ return _trailers_segment; }
         void settrailers_segment(action_segmentList _trailers_segment){ this._trailers_segment = _trailers_segment; }

        TrailersSeg(IToken leftIToken, IToken rightIToken,
                    action_segmentList _trailers_segment)
            :super(leftIToken, rightIToken)

        {
            this._trailers_segment = _trailers_segment;
            (_trailers_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _trailers_segment)  list.add(_trailers_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitTrailersSeg(this);
            if (checkChildren)
                _trailers_segment.accept(v);
            v.endVisitTrailersSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 24:  LPG_item ::= TYPES_KEY$ types_segment END_KEY_OPT$
 *</b>
 */
class TypesSeg extends ASTNode implements ILPG_item
    {
         late type_declarationsList _types_segment;

         type_declarationsList gettypes_segment(){ return _types_segment; }
         void settypes_segment(type_declarationsList _types_segment){ this._types_segment = _types_segment; }

        TypesSeg(IToken leftIToken, IToken rightIToken,
                 type_declarationsList _types_segment)
            :super(leftIToken, rightIToken)

        {
            this._types_segment = _types_segment;
            (_types_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _types_segment)  list.add(_types_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitTypesSeg(this);
            if (checkChildren)
                _types_segment.accept(v);
            v.endVisitTypesSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 25:  LPG_item ::= RECOVER_KEY$ recover_segment END_KEY_OPT$
 *</b>
 */
class RecoverSeg extends ASTNode implements ILPG_item
    {
         late SYMBOLList _recover_segment;

         SYMBOLList getrecover_segment(){ return _recover_segment; }
         void setrecover_segment(SYMBOLList _recover_segment){ this._recover_segment = _recover_segment; }

        RecoverSeg(IToken leftIToken, IToken rightIToken,
                   SYMBOLList _recover_segment)
            :super(leftIToken, rightIToken)

        {
            this._recover_segment = _recover_segment;
            (_recover_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _recover_segment)  list.add(_recover_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitRecoverSeg(this);
            if (checkChildren)
                _recover_segment.accept(v);
            v.endVisitRecoverSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 26:  LPG_item ::= DISJOINTPREDECESSORSETS_KEY$ predecessor_segment END_KEY_OPT$
 *</b>
 */
class PredecessorSeg extends ASTNode implements ILPG_item
    {
         late symbol_pairList _predecessor_segment;

         symbol_pairList getpredecessor_segment(){ return _predecessor_segment; }
         void setpredecessor_segment(symbol_pairList _predecessor_segment){ this._predecessor_segment = _predecessor_segment; }

        PredecessorSeg(IToken leftIToken, IToken rightIToken,
                       symbol_pairList _predecessor_segment)
            :super(leftIToken, rightIToken)

        {
            this._predecessor_segment = _predecessor_segment;
            (_predecessor_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _predecessor_segment)  list.add(_predecessor_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitPredecessorSeg(this);
            if (checkChildren)
                _predecessor_segment.accept(v);
            v.endVisitPredecessorSeg(this);
        }
    }

/**
 *<b>
*<li>Rule 27:  options_segment ::= %Empty
*<li>Rule 28:  options_segment ::= options_segment option_spec
 *</b>
 */
class option_specList extends AbstractASTNodeList implements Ioptions_segment
    {
         option_spec getoption_specAt(int i){ return getElementAt(i) as option_spec; }

        option_specList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static option_specList option_specListfromElement(option_spec element,bool leftRecursive )
        {
            var obj = option_specList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _option_spec)
        {
            super.addElement(_option_spec);
            _option_spec.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitoption_specList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getoption_specAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitoption_specList(this);
        }
    }

/**
 *<b>
*<li>Rule 29:  option_spec ::= OPTIONS_KEY$ option_list
 *</b>
 */
class option_spec extends ASTNode implements Ioption_spec
    {
         late optionList _option_list;

         optionList getoption_list(){ return _option_list; }
         void setoption_list(optionList _option_list){ this._option_list = _option_list; }

        option_spec(IToken leftIToken, IToken rightIToken,
                    optionList _option_list)
            :super(leftIToken, rightIToken)

        {
            this._option_list = _option_list;
            (_option_list as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _option_list)  list.add(_option_list);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitoption_spec(this);
            if (checkChildren)
                _option_list.accept(v);
            v.endVisitoption_spec(this);
        }
    }

/**
 *<b>
*<li>Rule 30:  option_list ::= option
*<li>Rule 31:  option_list ::= option_list ,$ option
 *</b>
 */
class optionList extends AbstractASTNodeList implements Ioption_list
    {
         option getoptionAt(int i){ return getElementAt(i) as option; }

        optionList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static optionList optionListfromElement(option element,bool leftRecursive )
        {
            var obj = optionList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _option)
        {
            super.addElement(_option);
            _option.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitoptionList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getoptionAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitoptionList(this);
        }
    }

/**
 *<b>
*<li>Rule 32:  option ::= SYMBOL option_value
 *</b>
 */
class option extends ASTNode implements Ioption
    {
         late ASTNodeToken _SYMBOL;
         late ASTNode? _option_value;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
         void setSYMBOL(ASTNodeToken _SYMBOL){ this._SYMBOL = _SYMBOL; }
        /**
         * The value returned by <b>getoption_value</b> may be <b>null</b>
         */
         ASTNode ?  getoption_value(){ return _option_value; }
         void setoption_value(ASTNode _option_value){ this._option_value = _option_value; }

        option(IToken leftIToken, IToken rightIToken,
               ASTNodeToken _SYMBOL,
               ASTNode? _option_value)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            this._option_value = _option_value;
            if (null != _option_value) (_option_value as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            if(null != _option_value)  list.add(_option_value);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitoption(this);
            if (checkChildren)
            {
                _SYMBOL.accept(v);
                if (null != _option_value) _option_value!.accept(v);
            }
            v.endVisitoption(this);
        }
    }

/**
 *<b>
*<li>Rule 36:  symbol_list ::= SYMBOL
*<li>Rule 37:  symbol_list ::= symbol_list ,$ SYMBOL
*<li>Rule 75:  drop_symbols ::= SYMBOL
*<li>Rule 76:  drop_symbols ::= drop_symbols SYMBOL
*<li>Rule 136:  barSymbolList ::= SYMBOL
*<li>Rule 137:  barSymbolList ::= barSymbolList |$ SYMBOL
*<li>Rule 141:  recover_segment ::= %Empty
*<li>Rule 142:  recover_segment ::= recover_segment recover_symbol
 *</b>
 */
class SYMBOLList extends AbstractASTNodeList implements Isymbol_list, Idrop_symbols, IbarSymbolList, Irecover_segment
    {
         ASTNodeToken getSYMBOLAt(int i){ return getElementAt(i) as ASTNodeToken; }

        SYMBOLList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static SYMBOLList SYMBOLListfromElement(ASTNodeToken element,bool leftRecursive )
        {
            var obj = SYMBOLList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _SYMBOL)
        {
            super.addElement(_SYMBOL);
            _SYMBOL.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitSYMBOLList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getSYMBOLAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitSYMBOLList(this);
        }
    }

/**
 *<b>
*<li>Rule 38:  alias_segment ::= aliasSpec
*<li>Rule 39:  alias_segment ::= alias_segment aliasSpec
 *</b>
 */
class aliasSpecList extends AbstractASTNodeList implements Ialias_segment
    {
         ASTNode getaliasSpecAt(int i){ return getElementAt(i) as ASTNode; }

        aliasSpecList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static aliasSpecList aliasSpecListfromElement(ASTNode element,bool leftRecursive )
        {
            var obj = aliasSpecList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _aliasSpec)
        {
            super.addElement(_aliasSpec);
            _aliasSpec.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitaliasSpecList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                    var element = getaliasSpecAt(i);
                    element.accept(v);
                }
            }
            v.endVisitaliasSpecList(this);
        }
    }

/**
 *<b>
*<li>Rule 46:  alias_lhs_macro_name ::= MACRO_NAME
 *</b>
 */
class alias_lhs_macro_name extends ASTNodeToken implements Ialias_lhs_macro_name
    {
         IToken getMACRO_NAME(){ return leftIToken; }

    alias_lhs_macro_name(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitalias_lhs_macro_name(this);
            v.endVisitalias_lhs_macro_name(this);
        }
    }

/**
 *<b>
*<li>Rule 55:  define_segment ::= defineSpec
*<li>Rule 56:  define_segment ::= define_segment defineSpec
 *</b>
 */
class defineSpecList extends AbstractASTNodeList implements Idefine_segment
    {
         defineSpec getdefineSpecAt(int i){ return getElementAt(i) as defineSpec; }

        defineSpecList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static defineSpecList defineSpecListfromElement(defineSpec element,bool leftRecursive )
        {
            var obj = defineSpecList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _defineSpec)
        {
            super.addElement(_defineSpec);
            _defineSpec.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitdefineSpecList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getdefineSpecAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitdefineSpecList(this);
        }
    }

/**
 *<b>
*<li>Rule 57:  defineSpec ::= macro_name_symbol macro_segment
 *</b>
 */
class defineSpec extends ASTNode implements IdefineSpec
    {
         late ASTNode _macro_name_symbol;
         late macro_segment _macro_segment;

         ASTNode getmacro_name_symbol(){ return _macro_name_symbol; }
         void setmacro_name_symbol(ASTNode _macro_name_symbol){ this._macro_name_symbol = _macro_name_symbol; }
         macro_segment getmacro_segment(){ return _macro_segment; }
         void setmacro_segment(macro_segment _macro_segment){ this._macro_segment = _macro_segment; }

        defineSpec(IToken leftIToken, IToken rightIToken,
                   ASTNode _macro_name_symbol,
                   macro_segment _macro_segment)
            :super(leftIToken, rightIToken)

        {
            this._macro_name_symbol = _macro_name_symbol;
            (_macro_name_symbol as ASTNode).setParent(this);
            this._macro_segment = _macro_segment;
            (_macro_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _macro_name_symbol)  list.add(_macro_name_symbol);
            if(null != _macro_segment)  list.add(_macro_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitdefineSpec(this);
            if (checkChildren)
            {
                _macro_name_symbol.accept(v);
                _macro_segment.accept(v);
            }
            v.endVisitdefineSpec(this);
        }
    }

/**
 *<b>
*<li>Rule 60:  macro_segment ::= BLOCK
 *</b>
 */
class macro_segment extends ASTNodeToken implements Imacro_segment
    {
         IToken getBLOCK(){ return leftIToken; }

    macro_segment(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitmacro_segment(this);
            v.endVisitmacro_segment(this);
        }
    }

/**
 *<b>
*<li>Rule 64:  export_segment ::= terminal_symbol
*<li>Rule 65:  export_segment ::= export_segment terminal_symbol
 *</b>
 */
class terminal_symbolList extends AbstractASTNodeList implements Iexport_segment
    {
         ASTNode getterminal_symbolAt(int i){ return getElementAt(i) as ASTNode; }

        terminal_symbolList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static terminal_symbolList terminal_symbolListfromElement(ASTNode element,bool leftRecursive )
        {
            var obj = terminal_symbolList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _terminal_symbol)
        {
            super.addElement(_terminal_symbol);
            _terminal_symbol.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitterminal_symbolList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                    var element = getterminal_symbolAt(i);
                    element.accept(v);
                }
            }
            v.endVisitterminal_symbolList(this);
        }
    }

/**
 *<b>
*<li>Rule 66:  globals_segment ::= action_segment
*<li>Rule 67:  globals_segment ::= globals_segment action_segment
*<li>Rule 96:  notice_segment ::= action_segment
*<li>Rule 97:  notice_segment ::= notice_segment action_segment
*<li>Rule 146:  action_segment_list ::= %Empty
*<li>Rule 147:  action_segment_list ::= action_segment_list action_segment
 *</b>
 */
class action_segmentList extends AbstractASTNodeList implements Iglobals_segment, Inotice_segment, Iaction_segment_list
    {
         action_segment getaction_segmentAt(int i){ return getElementAt(i) as action_segment; }

        action_segmentList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static action_segmentList action_segmentListfromElement(action_segment element,bool leftRecursive )
        {
            var obj = action_segmentList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _action_segment)
        {
            super.addElement(_action_segment);
            _action_segment.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitaction_segmentList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getaction_segmentAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitaction_segmentList(this);
        }
    }

/**
 *<b>
*<li>Rule 70:  import_segment ::= SYMBOL drop_command_list
 *</b>
 */
class import_segment extends ASTNode implements Iimport_segment
    {
         late ASTNodeToken _SYMBOL;
         late drop_commandList _drop_command_list;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
         void setSYMBOL(ASTNodeToken _SYMBOL){ this._SYMBOL = _SYMBOL; }
         drop_commandList getdrop_command_list(){ return _drop_command_list; }
         void setdrop_command_list(drop_commandList _drop_command_list){ this._drop_command_list = _drop_command_list; }

        import_segment(IToken leftIToken, IToken rightIToken,
                       ASTNodeToken _SYMBOL,
                       drop_commandList _drop_command_list)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            this._drop_command_list = _drop_command_list;
            (_drop_command_list as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            if(null != _drop_command_list)  list.add(_drop_command_list);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitimport_segment(this);
            if (checkChildren)
            {
                _SYMBOL.accept(v);
                _drop_command_list.accept(v);
            }
            v.endVisitimport_segment(this);
        }
    }

/**
 *<b>
*<li>Rule 71:  drop_command_list ::= %Empty
*<li>Rule 72:  drop_command_list ::= drop_command_list drop_command
 *</b>
 */
class drop_commandList extends AbstractASTNodeList implements Idrop_command_list
    {
         ASTNode getdrop_commandAt(int i){ return getElementAt(i) as ASTNode; }

        drop_commandList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static drop_commandList drop_commandListfromElement(ASTNode element,bool leftRecursive )
        {
            var obj = drop_commandList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _drop_command)
        {
            super.addElement(_drop_command);
            _drop_command.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitdrop_commandList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                    var element = getdrop_commandAt(i);
                    element.accept(v);
                }
            }
            v.endVisitdrop_commandList(this);
        }
    }

/**
 *<b>
*<li>Rule 77:  drop_rules ::= drop_rule
*<li>Rule 78:  drop_rules ::= drop_rules drop_rule
 *</b>
 */
class drop_ruleList extends AbstractASTNodeList implements Idrop_rules
    {
         drop_rule getdrop_ruleAt(int i){ return getElementAt(i) as drop_rule; }

        drop_ruleList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static drop_ruleList drop_ruleListfromElement(drop_rule element,bool leftRecursive )
        {
            var obj = drop_ruleList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _drop_rule)
        {
            super.addElement(_drop_rule);
            _drop_rule.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitdrop_ruleList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getdrop_ruleAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitdrop_ruleList(this);
        }
    }

/**
 *<b>
*<li>Rule 79:  drop_rule ::= SYMBOL optMacroName produces ruleList
 *</b>
 */
class drop_rule extends ASTNode implements Idrop_rule
    {
         late ASTNodeToken _SYMBOL;
         late optMacroName? _optMacroName;
         late ASTNode _produces;
         late ruleList _ruleList;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
         void setSYMBOL(ASTNodeToken _SYMBOL){ this._SYMBOL = _SYMBOL; }
        /**
         * The value returned by <b>getoptMacroName</b> may be <b>null</b>
         */
         optMacroName ?  getoptMacroName(){ return _optMacroName; }
         void setoptMacroName(optMacroName _optMacroName){ this._optMacroName = _optMacroName; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ruleList getruleList(){ return _ruleList; }
         void setruleList(ruleList _ruleList){ this._ruleList = _ruleList; }

        drop_rule(IToken leftIToken, IToken rightIToken,
                  ASTNodeToken _SYMBOL,
                  optMacroName? _optMacroName,
                  ASTNode _produces,
                  ruleList _ruleList)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            this._optMacroName = _optMacroName;
            if (null != _optMacroName) (_optMacroName as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._ruleList = _ruleList;
            (_ruleList as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            if(null != _optMacroName)  list.add(_optMacroName);
            if(null != _produces)  list.add(_produces);
            if(null != _ruleList)  list.add(_ruleList);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitdrop_rule(this);
            if (checkChildren)
            {
                _SYMBOL.accept(v);
                if (null != _optMacroName) _optMacroName!.accept(v);
                _produces.accept(v);
                _ruleList.accept(v);
            }
            v.endVisitdrop_rule(this);
        }
    }

/**
 *<em>
*<li>Rule 80:  optMacroName ::= %Empty
 *</em>
 *<p>
 *<b>
*<li>Rule 81:  optMacroName ::= MACRO_NAME
 *</b>
 */
class optMacroName extends ASTNodeToken implements IoptMacroName
    {
         IToken getMACRO_NAME(){ return leftIToken; }

    optMacroName(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitoptMacroName(this);
            v.endVisitoptMacroName(this);
        }
    }

/**
 *<b>
*<li>Rule 82:  include_segment ::= SYMBOL
 *</b>
 */
class include_segment extends ASTNodeToken implements Iinclude_segment
    {
         IToken getSYMBOL(){ return leftIToken; }

    include_segment(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitinclude_segment(this);
            v.endVisitinclude_segment(this);
        }
    }

/**
 *<b>
*<li>Rule 83:  keywords_segment ::= keywordSpec
*<li>Rule 84:  keywords_segment ::= keywords_segment keywordSpec
 *</b>
 */
class keywordSpecList extends AbstractASTNodeList implements Ikeywords_segment
    {
         ASTNode getkeywordSpecAt(int i){ return getElementAt(i) as ASTNode; }

        keywordSpecList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static keywordSpecList keywordSpecListfromElement(ASTNode element,bool leftRecursive )
        {
            var obj = keywordSpecList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _keywordSpec)
        {
            super.addElement(_keywordSpec);
            _keywordSpec.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitkeywordSpecList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                    var element = getkeywordSpecAt(i);
                    element.accept(v);
                }
            }
            v.endVisitkeywordSpecList(this);
        }
    }

/**
 *<em>
*<li>Rule 85:  keywordSpec ::= terminal_symbol
 *</em>
 *<p>
 *<b>
*<li>Rule 86:  keywordSpec ::= terminal_symbol produces name
 *</b>
 */
class keywordSpec extends ASTNode implements IkeywordSpec
    {
         late ASTNode _terminal_symbol;
         late ASTNode _produces;
         late ASTNode _name;

         ASTNode getterminal_symbol(){ return _terminal_symbol; }
         void setterminal_symbol(ASTNode _terminal_symbol){ this._terminal_symbol = _terminal_symbol; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getname(){ return _name; }
         void setname(ASTNode _name){ this._name = _name; }

        keywordSpec(IToken leftIToken, IToken rightIToken,
                    ASTNode _terminal_symbol,
                    ASTNode _produces,
                    ASTNode _name)
            :super(leftIToken, rightIToken)

        {
            this._terminal_symbol = _terminal_symbol;
            (_terminal_symbol as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._name = _name;
            (_name as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _terminal_symbol)  list.add(_terminal_symbol);
            if(null != _produces)  list.add(_produces);
            if(null != _name)  list.add(_name);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitkeywordSpec(this);
            if (checkChildren)
            {
                _terminal_symbol.accept(v);
                _produces.accept(v);
                _name.accept(v);
            }
            v.endVisitkeywordSpec(this);
        }
    }

/**
 *<b>
*<li>Rule 87:  names_segment ::= nameSpec
*<li>Rule 88:  names_segment ::= names_segment nameSpec
 *</b>
 */
class nameSpecList extends AbstractASTNodeList implements Inames_segment
    {
         nameSpec getnameSpecAt(int i){ return getElementAt(i) as nameSpec; }

        nameSpecList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static nameSpecList nameSpecListfromElement(nameSpec element,bool leftRecursive )
        {
            var obj = nameSpecList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _nameSpec)
        {
            super.addElement(_nameSpec);
            _nameSpec.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitnameSpecList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getnameSpecAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitnameSpecList(this);
        }
    }

/**
 *<b>
*<li>Rule 89:  nameSpec ::= name produces name
 *</b>
 */
class nameSpec extends ASTNode implements InameSpec
    {
         late ASTNode _name;
         late ASTNode _produces;
         late ASTNode _name3;

         ASTNode getname(){ return _name; }
         void setname(ASTNode _name){ this._name = _name; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getname3(){ return _name3; }
         void setname3(ASTNode _name3){ this._name3 = _name3; }

        nameSpec(IToken leftIToken, IToken rightIToken,
                 ASTNode _name,
                 ASTNode _produces,
                 ASTNode _name3)
            :super(leftIToken, rightIToken)

        {
            this._name = _name;
            (_name as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._name3 = _name3;
            (_name3 as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _name)  list.add(_name);
            if(null != _produces)  list.add(_produces);
            if(null != _name3)  list.add(_name3);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitnameSpec(this);
            if (checkChildren)
            {
                _name.accept(v);
                _produces.accept(v);
                _name3.accept(v);
            }
            v.endVisitnameSpec(this);
        }
    }

/**
 *<b>
*<li>Rule 98:  rules_segment ::= action_segment_list nonTermList
 *</b>
 */
class rules_segment extends ASTNode implements Irules_segment
    {
         late action_segmentList _action_segment_list;
         late nonTermList _nonTermList;

         action_segmentList getaction_segment_list(){ return _action_segment_list; }
         void setaction_segment_list(action_segmentList _action_segment_list){ this._action_segment_list = _action_segment_list; }
         nonTermList getnonTermList(){ return _nonTermList; }
         void setnonTermList(nonTermList _nonTermList){ this._nonTermList = _nonTermList; }

        rules_segment(IToken leftIToken, IToken rightIToken,
                      action_segmentList _action_segment_list,
                      nonTermList _nonTermList)
            :super(leftIToken, rightIToken)

        {
            this._action_segment_list = _action_segment_list;
            (_action_segment_list as ASTNode).setParent(this);
            this._nonTermList = _nonTermList;
            (_nonTermList as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _action_segment_list)  list.add(_action_segment_list);
            if(null != _nonTermList)  list.add(_nonTermList);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitrules_segment(this);
            if (checkChildren)
            {
                _action_segment_list.accept(v);
                _nonTermList.accept(v);
            }
            v.endVisitrules_segment(this);
        }
    }

/**
 *<b>
*<li>Rule 99:  nonTermList ::= %Empty
*<li>Rule 100:  nonTermList ::= nonTermList nonTerm
 *</b>
 */
class nonTermList extends AbstractASTNodeList implements InonTermList
    {
         nonTerm getnonTermAt(int i){ return getElementAt(i) as nonTerm; }

        nonTermList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static nonTermList nonTermListfromElement(nonTerm element,bool leftRecursive )
        {
            var obj = nonTermList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _nonTerm)
        {
            super.addElement(_nonTerm);
            _nonTerm.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitnonTermList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getnonTermAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitnonTermList(this);
        }
    }

/**
 *<b>
*<li>Rule 101:  nonTerm ::= ruleNameWithAttributes produces ruleList
 *</b>
 */
class nonTerm extends ASTNode implements InonTerm
    {
         late RuleName _ruleNameWithAttributes;
         late ASTNode _produces;
         late ruleList _ruleList;

         RuleName getruleNameWithAttributes(){ return _ruleNameWithAttributes; }
         void setruleNameWithAttributes(RuleName _ruleNameWithAttributes){ this._ruleNameWithAttributes = _ruleNameWithAttributes; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ruleList getruleList(){ return _ruleList; }
         void setruleList(ruleList _ruleList){ this._ruleList = _ruleList; }

        nonTerm(IToken leftIToken, IToken rightIToken,
                RuleName _ruleNameWithAttributes,
                ASTNode _produces,
                ruleList _ruleList)
            :super(leftIToken, rightIToken)

        {
            this._ruleNameWithAttributes = _ruleNameWithAttributes;
            (_ruleNameWithAttributes as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._ruleList = _ruleList;
            (_ruleList as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _ruleNameWithAttributes)  list.add(_ruleNameWithAttributes);
            if(null != _produces)  list.add(_produces);
            if(null != _ruleList)  list.add(_ruleList);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitnonTerm(this);
            if (checkChildren)
            {
                _ruleNameWithAttributes.accept(v);
                _produces.accept(v);
                _ruleList.accept(v);
            }
            v.endVisitnonTerm(this);
        }
    }

/**
 *<b>
*<li>Rule 102:  ruleNameWithAttributes ::= SYMBOL
*<li>Rule 103:  ruleNameWithAttributes ::= SYMBOL MACRO_NAME$className
*<li>Rule 104:  ruleNameWithAttributes ::= SYMBOL MACRO_NAME$className MACRO_NAME$arrayElement
 *</b>
 */
class RuleName extends ASTNode implements IruleNameWithAttributes
    {
         late ASTNodeToken _SYMBOL;
         ASTNodeToken ? _className;
         ASTNodeToken ? _arrayElement;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
        /**
         * The value returned by <b>getclassName</b> may be <b>null</b>
         */
         ASTNodeToken ?  getclassName(){ return _className; }
        /**
         * The value returned by <b>getarrayElement</b> may be <b>null</b>
         */
         ASTNodeToken ?  getarrayElement(){ return _arrayElement; }

         RuleName(IToken leftIToken, IToken rightIToken,
                  ASTNodeToken _SYMBOL,
                  ASTNodeToken? _className,
                  ASTNodeToken? _arrayElement)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            this._className = _className;
            if(null != _className) (_className as ASTNode).setParent(this);
            this._arrayElement = _arrayElement;
            if(null != _arrayElement) (_arrayElement as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            if(null != _className)  list.add(_className);
            if(null != _arrayElement)  list.add(_arrayElement);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitRuleName(this);
            if (checkChildren)
            {
                _SYMBOL.accept(v);
                if (null != _className) _className!.accept(v);
                if (null != _arrayElement) _arrayElement!.accept(v);
            }
            v.endVisitRuleName(this);
        }
    }

/**
 *<b>
*<li>Rule 105:  ruleList ::= rule
*<li>Rule 106:  ruleList ::= ruleList |$ rule
 *</b>
 */
class ruleList extends AbstractASTNodeList implements IruleList
    {
         rule getruleAt(int i){ return getElementAt(i) as rule; }

        ruleList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static ruleList ruleListfromElement(rule element,bool leftRecursive )
        {
            var obj = ruleList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _rule)
        {
            super.addElement(_rule);
            _rule.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitruleList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getruleAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitruleList(this);
        }
    }

/**
 *<b>
*<li>Rule 111:  rule ::= symWithAttrsList action_segment_list
 *</b>
 */
class rule extends ASTNode implements Irule
    {
         late symWithAttrsList _symWithAttrsList;
         late action_segmentList _action_segment_list;

         symWithAttrsList getsymWithAttrsList(){ return _symWithAttrsList; }
         void setsymWithAttrsList(symWithAttrsList _symWithAttrsList){ this._symWithAttrsList = _symWithAttrsList; }
         action_segmentList getaction_segment_list(){ return _action_segment_list; }
         void setaction_segment_list(action_segmentList _action_segment_list){ this._action_segment_list = _action_segment_list; }

        rule(IToken leftIToken, IToken rightIToken,
             symWithAttrsList _symWithAttrsList,
             action_segmentList _action_segment_list)
            :super(leftIToken, rightIToken)

        {
            this._symWithAttrsList = _symWithAttrsList;
            (_symWithAttrsList as ASTNode).setParent(this);
            this._action_segment_list = _action_segment_list;
            (_action_segment_list as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _symWithAttrsList)  list.add(_symWithAttrsList);
            if(null != _action_segment_list)  list.add(_action_segment_list);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitrule(this);
            if (checkChildren)
            {
                _symWithAttrsList.accept(v);
                _action_segment_list.accept(v);
            }
            v.endVisitrule(this);
        }
    }

/**
 *<b>
*<li>Rule 112:  symWithAttrsList ::= %Empty
*<li>Rule 113:  symWithAttrsList ::= symWithAttrsList symWithAttrs
 *</b>
 */
class symWithAttrsList extends AbstractASTNodeList implements IsymWithAttrsList
    {
         ASTNode getsymWithAttrsAt(int i){ return getElementAt(i) as ASTNode; }

        symWithAttrsList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static symWithAttrsList symWithAttrsListfromElement(ASTNode element,bool leftRecursive )
        {
            var obj = symWithAttrsList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _symWithAttrs)
        {
            super.addElement(_symWithAttrs);
            _symWithAttrs.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitsymWithAttrsList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                    var element = getsymWithAttrsAt(i);
                    element.accept(v);
                }
            }
            v.endVisitsymWithAttrsList(this);
        }
    }

/**
 *<b>
*<li>Rule 116:  optAttrList ::= %Empty
*<li>Rule 117:  optAttrList ::= MACRO_NAME
 *</b>
 */
class symAttrs extends ASTNode implements IoptAttrList
    {
         ASTNodeToken ? _MACRO_NAME;

        /**
         * The value returned by <b>getMACRO_NAME</b> may be <b>null</b>
         */
         ASTNodeToken ?  getMACRO_NAME(){ return _MACRO_NAME; }

         symAttrs(IToken leftIToken, IToken rightIToken,
                  ASTNodeToken? _MACRO_NAME)
            :super(leftIToken, rightIToken)

        {
            this._MACRO_NAME = _MACRO_NAME;
            if(null != _MACRO_NAME) (_MACRO_NAME as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _MACRO_NAME)  list.add(_MACRO_NAME);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitsymAttrs(this);
            if (checkChildren)
                if (null != _MACRO_NAME) _MACRO_NAME!.accept(v);
            v.endVisitsymAttrs(this);
        }
    }

/**
 *<b>
*<li>Rule 120:  action_segment ::= BLOCK
 *</b>
 */
class action_segment extends ASTNodeToken implements Iaction_segment
    {
         IToken getBLOCK(){ return leftIToken; }

    action_segment(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitaction_segment(this);
            v.endVisitaction_segment(this);
        }
    }

/**
 *<b>
*<li>Rule 121:  start_segment ::= start_symbol
*<li>Rule 122:  start_segment ::= start_segment start_symbol
 *</b>
 */
class start_symbolList extends AbstractASTNodeList implements Istart_segment
    {
         ASTNode getstart_symbolAt(int i){ return getElementAt(i) as ASTNode; }

        start_symbolList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static start_symbolList start_symbolListfromElement(ASTNode element,bool leftRecursive )
        {
            var obj = start_symbolList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _start_symbol)
        {
            super.addElement(_start_symbol);
            _start_symbol.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitstart_symbolList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                    var element = getstart_symbolAt(i);
                    element.accept(v);
                }
            }
            v.endVisitstart_symbolList(this);
        }
    }

/**
 *<b>
*<li>Rule 125:  terminals_segment ::= terminal
*<li>Rule 126:  terminals_segment ::= terminals_segment terminal
 *</b>
 */
class terminalList extends AbstractASTNodeList implements Iterminals_segment
    {
         terminal getterminalAt(int i){ return getElementAt(i) as terminal; }

        terminalList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static terminalList terminalListfromElement(terminal element,bool leftRecursive )
        {
            var obj = terminalList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _terminal)
        {
            super.addElement(_terminal);
            _terminal.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitterminalList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getterminalAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitterminalList(this);
        }
    }

/**
 *<b>
*<li>Rule 125:  terminals_segment ::= terminal
*<li>Rule 126:  terminals_segment ::= terminals_segment terminal
 *</b>
 */
class terminals_segment_terminalList extends terminalList
    {
         late LPGParser environment;
         LPGParser getEnvironment() { return environment; }

        terminals_segment_terminalList(LPGParser environment, IToken leftIToken, IToken rightIToken, bool leftRecursive )
        :super(leftIToken, rightIToken, leftRecursive)
        {
            this.environment = environment;
            initialize();
        }

        static  terminals_segment_terminalList terminals_segment_terminalListfromElement(LPGParser environment, terminal element,bool leftRecursive )
        {
            var obj = terminals_segment_terminalList(environment,element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

    }

/**
 *<b>
*<li>Rule 127:  terminal ::= terminal_symbol optTerminalAlias
 *</b>
 */
class terminal extends ASTNode implements Iterminal
    {
         late ASTNode _terminal_symbol;
         late optTerminalAlias? _optTerminalAlias;

         ASTNode getterminal_symbol(){ return _terminal_symbol; }
         void setterminal_symbol(ASTNode _terminal_symbol){ this._terminal_symbol = _terminal_symbol; }
        /**
         * The value returned by <b>getoptTerminalAlias</b> may be <b>null</b>
         */
         optTerminalAlias ?  getoptTerminalAlias(){ return _optTerminalAlias; }
         void setoptTerminalAlias(optTerminalAlias _optTerminalAlias){ this._optTerminalAlias = _optTerminalAlias; }

        terminal(IToken leftIToken, IToken rightIToken,
                 ASTNode _terminal_symbol,
                 optTerminalAlias? _optTerminalAlias)
            :super(leftIToken, rightIToken)

        {
            this._terminal_symbol = _terminal_symbol;
            (_terminal_symbol as ASTNode).setParent(this);
            this._optTerminalAlias = _optTerminalAlias;
            if (null != _optTerminalAlias) (_optTerminalAlias as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _terminal_symbol)  list.add(_terminal_symbol);
            if(null != _optTerminalAlias)  list.add(_optTerminalAlias);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitterminal(this);
            if (checkChildren)
            {
                _terminal_symbol.accept(v);
                if (null != _optTerminalAlias) _optTerminalAlias!.accept(v);
            }
            v.endVisitterminal(this);
        }
    }

/**
 *<em>
*<li>Rule 128:  optTerminalAlias ::= %Empty
 *</em>
 *<p>
 *<b>
*<li>Rule 129:  optTerminalAlias ::= produces name
 *</b>
 */
class optTerminalAlias extends ASTNode implements IoptTerminalAlias
    {
         late ASTNode _produces;
         late ASTNode _name;

         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getname(){ return _name; }
         void setname(ASTNode _name){ this._name = _name; }

        optTerminalAlias(IToken leftIToken, IToken rightIToken,
                         ASTNode _produces,
                         ASTNode _name)
            :super(leftIToken, rightIToken)

        {
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._name = _name;
            (_name as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _produces)  list.add(_produces);
            if(null != _name)  list.add(_name);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitoptTerminalAlias(this);
            if (checkChildren)
            {
                _produces.accept(v);
                _name.accept(v);
            }
            v.endVisitoptTerminalAlias(this);
        }
    }

/**
 *<b>
*<li>Rule 133:  types_segment ::= type_declarations
*<li>Rule 134:  types_segment ::= types_segment type_declarations
 *</b>
 */
class type_declarationsList extends AbstractASTNodeList implements Itypes_segment
    {
         type_declarations gettype_declarationsAt(int i){ return getElementAt(i) as type_declarations; }

        type_declarationsList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static type_declarationsList type_declarationsListfromElement(type_declarations element,bool leftRecursive )
        {
            var obj = type_declarationsList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _type_declarations)
        {
            super.addElement(_type_declarations);
            _type_declarations.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visittype_declarationsList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = gettype_declarationsAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisittype_declarationsList(this);
        }
    }

/**
 *<b>
*<li>Rule 135:  type_declarations ::= SYMBOL produces barSymbolList opt_action_segment
 *</b>
 */
class type_declarations extends ASTNode implements Itype_declarations
    {
         late ASTNodeToken _SYMBOL;
         late ASTNode _produces;
         late SYMBOLList _barSymbolList;
         late action_segment? _opt_action_segment;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
         void setSYMBOL(ASTNodeToken _SYMBOL){ this._SYMBOL = _SYMBOL; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         SYMBOLList getbarSymbolList(){ return _barSymbolList; }
         void setbarSymbolList(SYMBOLList _barSymbolList){ this._barSymbolList = _barSymbolList; }
        /**
         * The value returned by <b>getopt_action_segment</b> may be <b>null</b>
         */
         action_segment ?  getopt_action_segment(){ return _opt_action_segment; }
         void setopt_action_segment(action_segment _opt_action_segment){ this._opt_action_segment = _opt_action_segment; }

        type_declarations(IToken leftIToken, IToken rightIToken,
                          ASTNodeToken _SYMBOL,
                          ASTNode _produces,
                          SYMBOLList _barSymbolList,
                          action_segment? _opt_action_segment)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._barSymbolList = _barSymbolList;
            (_barSymbolList as ASTNode).setParent(this);
            this._opt_action_segment = _opt_action_segment;
            if (null != _opt_action_segment) (_opt_action_segment as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            if(null != _produces)  list.add(_produces);
            if(null != _barSymbolList)  list.add(_barSymbolList);
            if(null != _opt_action_segment)  list.add(_opt_action_segment);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visittype_declarations(this);
            if (checkChildren)
            {
                _SYMBOL.accept(v);
                _produces.accept(v);
                _barSymbolList.accept(v);
                if (null != _opt_action_segment) _opt_action_segment!.accept(v);
            }
            v.endVisittype_declarations(this);
        }
    }

/**
 *<b>
*<li>Rule 138:  predecessor_segment ::= %Empty
*<li>Rule 139:  predecessor_segment ::= predecessor_segment symbol_pair
 *</b>
 */
class symbol_pairList extends AbstractASTNodeList implements Ipredecessor_segment
    {
         symbol_pair getsymbol_pairAt(int i){ return getElementAt(i) as symbol_pair; }

        symbol_pairList(IToken leftToken, IToken rightToken , bool leftRecursive  ):super(leftToken, rightToken, leftRecursive)
        {}

        static symbol_pairList symbol_pairListfromElement(symbol_pair element,bool leftRecursive )
        {
            var obj = symbol_pairList(element.getLeftIToken(),element.getRightIToken(), leftRecursive);
            obj.list.add(element);
            (element as ASTNode).setParent(obj);
            return obj;
        }

          void addElement(ASTNode _symbol_pair)
        {
            super.addElement(_symbol_pair);
            _symbol_pair.setParent(this);
        }


        void accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }
         void enter(Visitor v)
        {
            var checkChildren = v.visitsymbol_pairList(this);
            if (checkChildren)
            {
                for (var i = 0; i < size(); i++)
                {
                     var element = getsymbol_pairAt(i);
                    if (! v.preVisit(element)) continue;
                    element.enter(v);
                    v.postVisit(element);
                }
            }
            v.endVisitsymbol_pairList(this);
        }
    }

/**
 *<b>
*<li>Rule 140:  symbol_pair ::= SYMBOL SYMBOL
 *</b>
 */
class symbol_pair extends ASTNode implements Isymbol_pair
    {
         late ASTNodeToken _SYMBOL;
         late ASTNodeToken _SYMBOL2;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
         void setSYMBOL(ASTNodeToken _SYMBOL){ this._SYMBOL = _SYMBOL; }
         ASTNodeToken getSYMBOL2(){ return _SYMBOL2; }
         void setSYMBOL2(ASTNodeToken _SYMBOL2){ this._SYMBOL2 = _SYMBOL2; }

        symbol_pair(IToken leftIToken, IToken rightIToken,
                    ASTNodeToken _SYMBOL,
                    ASTNodeToken _SYMBOL2)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            this._SYMBOL2 = _SYMBOL2;
            (_SYMBOL2 as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            if(null != _SYMBOL2)  list.add(_SYMBOL2);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitsymbol_pair(this);
            if (checkChildren)
            {
                _SYMBOL.accept(v);
                _SYMBOL2.accept(v);
            }
            v.endVisitsymbol_pair(this);
        }
    }

/**
 *<b>
*<li>Rule 143:  recover_symbol ::= SYMBOL
 *</b>
 */
class recover_symbol extends ASTNodeToken implements Irecover_symbol
    {
         IToken getSYMBOL(){ return leftIToken; }

    recover_symbol(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitrecover_symbol(this);
            v.endVisitrecover_symbol(this);
        }
    }

/**
 *<em>
*<li>Rule 144:  END_KEY_OPT ::= %Empty
 *</em>
 *<p>
 *<b>
*<li>Rule 145:  END_KEY_OPT ::= END_KEY
 *</b>
 */
class END_KEY_OPT extends ASTNodeToken implements IEND_KEY_OPT
    {
         IToken getEND_KEY(){ return leftIToken; }

    END_KEY_OPT(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitEND_KEY_OPT(this);
            v.endVisitEND_KEY_OPT(this);
        }
    }

/**
 *<b>
*<li>Rule 34:  option_value ::= =$ SYMBOL
 *</b>
 */
class option_value0 extends ASTNode implements Ioption_value
    {
         late ASTNodeToken _SYMBOL;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
         void setSYMBOL(ASTNodeToken _SYMBOL){ this._SYMBOL = _SYMBOL; }

        option_value0(IToken leftIToken, IToken rightIToken,
                      ASTNodeToken _SYMBOL)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitoption_value0(this);
            if (checkChildren)
                _SYMBOL.accept(v);
            v.endVisitoption_value0(this);
        }
    }

/**
 *<b>
*<li>Rule 35:  option_value ::= =$ ($ symbol_list )$
 *</b>
 */
class option_value1 extends ASTNode implements Ioption_value
    {
         late SYMBOLList _symbol_list;

         SYMBOLList getsymbol_list(){ return _symbol_list; }
         void setsymbol_list(SYMBOLList _symbol_list){ this._symbol_list = _symbol_list; }

        option_value1(IToken leftIToken, IToken rightIToken,
                      SYMBOLList _symbol_list)
            :super(leftIToken, rightIToken)

        {
            this._symbol_list = _symbol_list;
            (_symbol_list as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _symbol_list)  list.add(_symbol_list);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitoption_value1(this);
            if (checkChildren)
                _symbol_list.accept(v);
            v.endVisitoption_value1(this);
        }
    }

/**
 *<b>
*<li>Rule 40:  aliasSpec ::= ERROR_KEY produces alias_rhs
 *</b>
 */
class aliasSpec0 extends ASTNode implements IaliasSpec
    {
         late ASTNodeToken _ERROR_KEY;
         late ASTNode _produces;
         late ASTNode _alias_rhs;

         ASTNodeToken getERROR_KEY(){ return _ERROR_KEY; }
         void setERROR_KEY(ASTNodeToken _ERROR_KEY){ this._ERROR_KEY = _ERROR_KEY; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getalias_rhs(){ return _alias_rhs; }
         void setalias_rhs(ASTNode _alias_rhs){ this._alias_rhs = _alias_rhs; }

        aliasSpec0(IToken leftIToken, IToken rightIToken,
                   ASTNodeToken _ERROR_KEY,
                   ASTNode _produces,
                   ASTNode _alias_rhs)
            :super(leftIToken, rightIToken)

        {
            this._ERROR_KEY = _ERROR_KEY;
            (_ERROR_KEY as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._alias_rhs = _alias_rhs;
            (_alias_rhs as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _ERROR_KEY)  list.add(_ERROR_KEY);
            if(null != _produces)  list.add(_produces);
            if(null != _alias_rhs)  list.add(_alias_rhs);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitaliasSpec0(this);
            if (checkChildren)
            {
                _ERROR_KEY.accept(v);
                _produces.accept(v);
                _alias_rhs.accept(v);
            }
            v.endVisitaliasSpec0(this);
        }
    }

/**
 *<b>
*<li>Rule 41:  aliasSpec ::= EOL_KEY produces alias_rhs
 *</b>
 */
class aliasSpec1 extends ASTNode implements IaliasSpec
    {
         late ASTNodeToken _EOL_KEY;
         late ASTNode _produces;
         late ASTNode _alias_rhs;

         ASTNodeToken getEOL_KEY(){ return _EOL_KEY; }
         void setEOL_KEY(ASTNodeToken _EOL_KEY){ this._EOL_KEY = _EOL_KEY; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getalias_rhs(){ return _alias_rhs; }
         void setalias_rhs(ASTNode _alias_rhs){ this._alias_rhs = _alias_rhs; }

        aliasSpec1(IToken leftIToken, IToken rightIToken,
                   ASTNodeToken _EOL_KEY,
                   ASTNode _produces,
                   ASTNode _alias_rhs)
            :super(leftIToken, rightIToken)

        {
            this._EOL_KEY = _EOL_KEY;
            (_EOL_KEY as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._alias_rhs = _alias_rhs;
            (_alias_rhs as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _EOL_KEY)  list.add(_EOL_KEY);
            if(null != _produces)  list.add(_produces);
            if(null != _alias_rhs)  list.add(_alias_rhs);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitaliasSpec1(this);
            if (checkChildren)
            {
                _EOL_KEY.accept(v);
                _produces.accept(v);
                _alias_rhs.accept(v);
            }
            v.endVisitaliasSpec1(this);
        }
    }

/**
 *<b>
*<li>Rule 42:  aliasSpec ::= EOF_KEY produces alias_rhs
 *</b>
 */
class aliasSpec2 extends ASTNode implements IaliasSpec
    {
         late ASTNodeToken _EOF_KEY;
         late ASTNode _produces;
         late ASTNode _alias_rhs;

         ASTNodeToken getEOF_KEY(){ return _EOF_KEY; }
         void setEOF_KEY(ASTNodeToken _EOF_KEY){ this._EOF_KEY = _EOF_KEY; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getalias_rhs(){ return _alias_rhs; }
         void setalias_rhs(ASTNode _alias_rhs){ this._alias_rhs = _alias_rhs; }

        aliasSpec2(IToken leftIToken, IToken rightIToken,
                   ASTNodeToken _EOF_KEY,
                   ASTNode _produces,
                   ASTNode _alias_rhs)
            :super(leftIToken, rightIToken)

        {
            this._EOF_KEY = _EOF_KEY;
            (_EOF_KEY as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._alias_rhs = _alias_rhs;
            (_alias_rhs as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _EOF_KEY)  list.add(_EOF_KEY);
            if(null != _produces)  list.add(_produces);
            if(null != _alias_rhs)  list.add(_alias_rhs);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitaliasSpec2(this);
            if (checkChildren)
            {
                _EOF_KEY.accept(v);
                _produces.accept(v);
                _alias_rhs.accept(v);
            }
            v.endVisitaliasSpec2(this);
        }
    }

/**
 *<b>
*<li>Rule 43:  aliasSpec ::= IDENTIFIER_KEY produces alias_rhs
 *</b>
 */
class aliasSpec3 extends ASTNode implements IaliasSpec
    {
         late ASTNodeToken _IDENTIFIER_KEY;
         late ASTNode _produces;
         late ASTNode _alias_rhs;

         ASTNodeToken getIDENTIFIER_KEY(){ return _IDENTIFIER_KEY; }
         void setIDENTIFIER_KEY(ASTNodeToken _IDENTIFIER_KEY){ this._IDENTIFIER_KEY = _IDENTIFIER_KEY; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getalias_rhs(){ return _alias_rhs; }
         void setalias_rhs(ASTNode _alias_rhs){ this._alias_rhs = _alias_rhs; }

        aliasSpec3(IToken leftIToken, IToken rightIToken,
                   ASTNodeToken _IDENTIFIER_KEY,
                   ASTNode _produces,
                   ASTNode _alias_rhs)
            :super(leftIToken, rightIToken)

        {
            this._IDENTIFIER_KEY = _IDENTIFIER_KEY;
            (_IDENTIFIER_KEY as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._alias_rhs = _alias_rhs;
            (_alias_rhs as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _IDENTIFIER_KEY)  list.add(_IDENTIFIER_KEY);
            if(null != _produces)  list.add(_produces);
            if(null != _alias_rhs)  list.add(_alias_rhs);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitaliasSpec3(this);
            if (checkChildren)
            {
                _IDENTIFIER_KEY.accept(v);
                _produces.accept(v);
                _alias_rhs.accept(v);
            }
            v.endVisitaliasSpec3(this);
        }
    }

/**
 *<b>
*<li>Rule 44:  aliasSpec ::= SYMBOL produces alias_rhs
 *</b>
 */
class aliasSpec4 extends ASTNode implements IaliasSpec
    {
         late ASTNodeToken _SYMBOL;
         late ASTNode _produces;
         late ASTNode _alias_rhs;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
         void setSYMBOL(ASTNodeToken _SYMBOL){ this._SYMBOL = _SYMBOL; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getalias_rhs(){ return _alias_rhs; }
         void setalias_rhs(ASTNode _alias_rhs){ this._alias_rhs = _alias_rhs; }

        aliasSpec4(IToken leftIToken, IToken rightIToken,
                   ASTNodeToken _SYMBOL,
                   ASTNode _produces,
                   ASTNode _alias_rhs)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._alias_rhs = _alias_rhs;
            (_alias_rhs as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            if(null != _produces)  list.add(_produces);
            if(null != _alias_rhs)  list.add(_alias_rhs);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitaliasSpec4(this);
            if (checkChildren)
            {
                _SYMBOL.accept(v);
                _produces.accept(v);
                _alias_rhs.accept(v);
            }
            v.endVisitaliasSpec4(this);
        }
    }

/**
 *<b>
*<li>Rule 45:  aliasSpec ::= alias_lhs_macro_name produces alias_rhs
 *</b>
 */
class aliasSpec5 extends ASTNode implements IaliasSpec
    {
         late alias_lhs_macro_name _alias_lhs_macro_name;
         late ASTNode _produces;
         late ASTNode _alias_rhs;

         alias_lhs_macro_name getalias_lhs_macro_name(){ return _alias_lhs_macro_name; }
         void setalias_lhs_macro_name(alias_lhs_macro_name _alias_lhs_macro_name){ this._alias_lhs_macro_name = _alias_lhs_macro_name; }
         ASTNode getproduces(){ return _produces; }
         void setproduces(ASTNode _produces){ this._produces = _produces; }
         ASTNode getalias_rhs(){ return _alias_rhs; }
         void setalias_rhs(ASTNode _alias_rhs){ this._alias_rhs = _alias_rhs; }

        aliasSpec5(IToken leftIToken, IToken rightIToken,
                   alias_lhs_macro_name _alias_lhs_macro_name,
                   ASTNode _produces,
                   ASTNode _alias_rhs)
            :super(leftIToken, rightIToken)

        {
            this._alias_lhs_macro_name = _alias_lhs_macro_name;
            (_alias_lhs_macro_name as ASTNode).setParent(this);
            this._produces = _produces;
            (_produces as ASTNode).setParent(this);
            this._alias_rhs = _alias_rhs;
            (_alias_rhs as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _alias_lhs_macro_name)  list.add(_alias_lhs_macro_name);
            if(null != _produces)  list.add(_produces);
            if(null != _alias_rhs)  list.add(_alias_rhs);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitaliasSpec5(this);
            if (checkChildren)
            {
                _alias_lhs_macro_name.accept(v);
                _produces.accept(v);
                _alias_rhs.accept(v);
            }
            v.endVisitaliasSpec5(this);
        }
    }

/**
 *<b>
*<li>Rule 47:  alias_rhs ::= SYMBOL
 *</b>
 */
class alias_rhs0 extends ASTNodeToken implements Ialias_rhs
    {
         IToken getSYMBOL(){ return leftIToken; }

    alias_rhs0(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitalias_rhs0(this);
            v.endVisitalias_rhs0(this);
        }
    }

/**
 *<b>
*<li>Rule 48:  alias_rhs ::= MACRO_NAME
 *</b>
 */
class alias_rhs1 extends ASTNodeToken implements Ialias_rhs
    {
         IToken getMACRO_NAME(){ return leftIToken; }

    alias_rhs1(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitalias_rhs1(this);
            v.endVisitalias_rhs1(this);
        }
    }

/**
 *<b>
*<li>Rule 49:  alias_rhs ::= ERROR_KEY
 *</b>
 */
class alias_rhs2 extends ASTNodeToken implements Ialias_rhs
    {
         IToken getERROR_KEY(){ return leftIToken; }

    alias_rhs2(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitalias_rhs2(this);
            v.endVisitalias_rhs2(this);
        }
    }

/**
 *<b>
*<li>Rule 50:  alias_rhs ::= EOL_KEY
 *</b>
 */
class alias_rhs3 extends ASTNodeToken implements Ialias_rhs
    {
         IToken getEOL_KEY(){ return leftIToken; }

    alias_rhs3(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitalias_rhs3(this);
            v.endVisitalias_rhs3(this);
        }
    }

/**
 *<b>
*<li>Rule 51:  alias_rhs ::= EOF_KEY
 *</b>
 */
class alias_rhs4 extends ASTNodeToken implements Ialias_rhs
    {
         IToken getEOF_KEY(){ return leftIToken; }

    alias_rhs4(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitalias_rhs4(this);
            v.endVisitalias_rhs4(this);
        }
    }

/**
 *<b>
*<li>Rule 52:  alias_rhs ::= EMPTY_KEY
 *</b>
 */
class alias_rhs5 extends ASTNodeToken implements Ialias_rhs
    {
         IToken getEMPTY_KEY(){ return leftIToken; }

    alias_rhs5(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitalias_rhs5(this);
            v.endVisitalias_rhs5(this);
        }
    }

/**
 *<b>
*<li>Rule 53:  alias_rhs ::= IDENTIFIER_KEY
 *</b>
 */
class alias_rhs6 extends ASTNodeToken implements Ialias_rhs
    {
         IToken getIDENTIFIER_KEY(){ return leftIToken; }

    alias_rhs6(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitalias_rhs6(this);
            v.endVisitalias_rhs6(this);
        }
    }

/**
 *<b>
*<li>Rule 58:  macro_name_symbol ::= MACRO_NAME
 *</b>
 */
class macro_name_symbol0 extends ASTNodeToken implements Imacro_name_symbol
    {
         IToken getMACRO_NAME(){ return leftIToken; }

    macro_name_symbol0(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitmacro_name_symbol0(this);
            v.endVisitmacro_name_symbol0(this);
        }
    }

/**
 *<b>
*<li>Rule 59:  macro_name_symbol ::= SYMBOL
 *</b>
 */
class macro_name_symbol1 extends ASTNodeToken implements Imacro_name_symbol
    {
         IToken getSYMBOL(){ return leftIToken; }

    macro_name_symbol1(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitmacro_name_symbol1(this);
            v.endVisitmacro_name_symbol1(this);
        }
    }

/**
 *<b>
*<li>Rule 73:  drop_command ::= DROPSYMBOLS_KEY drop_symbols
 *</b>
 */
class drop_command0 extends ASTNode implements Idrop_command
    {
         late ASTNodeToken _DROPSYMBOLS_KEY;
         late SYMBOLList _drop_symbols;

         ASTNodeToken getDROPSYMBOLS_KEY(){ return _DROPSYMBOLS_KEY; }
         void setDROPSYMBOLS_KEY(ASTNodeToken _DROPSYMBOLS_KEY){ this._DROPSYMBOLS_KEY = _DROPSYMBOLS_KEY; }
         SYMBOLList getdrop_symbols(){ return _drop_symbols; }
         void setdrop_symbols(SYMBOLList _drop_symbols){ this._drop_symbols = _drop_symbols; }

        drop_command0(IToken leftIToken, IToken rightIToken,
                      ASTNodeToken _DROPSYMBOLS_KEY,
                      SYMBOLList _drop_symbols)
            :super(leftIToken, rightIToken)

        {
            this._DROPSYMBOLS_KEY = _DROPSYMBOLS_KEY;
            (_DROPSYMBOLS_KEY as ASTNode).setParent(this);
            this._drop_symbols = _drop_symbols;
            (_drop_symbols as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _DROPSYMBOLS_KEY)  list.add(_DROPSYMBOLS_KEY);
            if(null != _drop_symbols)  list.add(_drop_symbols);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitdrop_command0(this);
            if (checkChildren)
            {
                _DROPSYMBOLS_KEY.accept(v);
                _drop_symbols.accept(v);
            }
            v.endVisitdrop_command0(this);
        }
    }

/**
 *<b>
*<li>Rule 74:  drop_command ::= DROPRULES_KEY drop_rules
 *</b>
 */
class drop_command1 extends ASTNode implements Idrop_command
    {
         late ASTNodeToken _DROPRULES_KEY;
         late drop_ruleList _drop_rules;

         ASTNodeToken getDROPRULES_KEY(){ return _DROPRULES_KEY; }
         void setDROPRULES_KEY(ASTNodeToken _DROPRULES_KEY){ this._DROPRULES_KEY = _DROPRULES_KEY; }
         drop_ruleList getdrop_rules(){ return _drop_rules; }
         void setdrop_rules(drop_ruleList _drop_rules){ this._drop_rules = _drop_rules; }

        drop_command1(IToken leftIToken, IToken rightIToken,
                      ASTNodeToken _DROPRULES_KEY,
                      drop_ruleList _drop_rules)
            :super(leftIToken, rightIToken)

        {
            this._DROPRULES_KEY = _DROPRULES_KEY;
            (_DROPRULES_KEY as ASTNode).setParent(this);
            this._drop_rules = _drop_rules;
            (_drop_rules as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _DROPRULES_KEY)  list.add(_DROPRULES_KEY);
            if(null != _drop_rules)  list.add(_drop_rules);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitdrop_command1(this);
            if (checkChildren)
            {
                _DROPRULES_KEY.accept(v);
                _drop_rules.accept(v);
            }
            v.endVisitdrop_command1(this);
        }
    }

/**
 *<b>
*<li>Rule 90:  name ::= SYMBOL
 *</b>
 */
class name0 extends ASTNodeToken implements Iname
    {
         IToken getSYMBOL(){ return leftIToken; }

    name0(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitname0(this);
            v.endVisitname0(this);
        }
    }

/**
 *<b>
*<li>Rule 91:  name ::= MACRO_NAME
 *</b>
 */
class name1 extends ASTNodeToken implements Iname
    {
         IToken getMACRO_NAME(){ return leftIToken; }

    name1(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitname1(this);
            v.endVisitname1(this);
        }
    }

/**
 *<b>
*<li>Rule 92:  name ::= EMPTY_KEY
 *</b>
 */
class name2 extends ASTNodeToken implements Iname
    {
         IToken getEMPTY_KEY(){ return leftIToken; }

    name2(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitname2(this);
            v.endVisitname2(this);
        }
    }

/**
 *<b>
*<li>Rule 93:  name ::= ERROR_KEY
 *</b>
 */
class name3 extends ASTNodeToken implements Iname
    {
         IToken getERROR_KEY(){ return leftIToken; }

    name3(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitname3(this);
            v.endVisitname3(this);
        }
    }

/**
 *<b>
*<li>Rule 94:  name ::= EOL_KEY
 *</b>
 */
class name4 extends ASTNodeToken implements Iname
    {
         IToken getEOL_KEY(){ return leftIToken; }

    name4(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitname4(this);
            v.endVisitname4(this);
        }
    }

/**
 *<b>
*<li>Rule 95:  name ::= IDENTIFIER_KEY
 *</b>
 */
class name5 extends ASTNodeToken implements Iname
    {
         IToken getIDENTIFIER_KEY(){ return leftIToken; }

    name5(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitname5(this);
            v.endVisitname5(this);
        }
    }

/**
 *<b>
*<li>Rule 107:  produces ::= ::=
 *</b>
 */
class produces0 extends ASTNodeToken implements Iproduces
    {
         IToken getEQUIVALENCE(){ return leftIToken; }

    produces0(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitproduces0(this);
            v.endVisitproduces0(this);
        }
    }

/**
 *<b>
*<li>Rule 108:  produces ::= ::=?
 *</b>
 */
class produces1 extends ASTNodeToken implements Iproduces
    {
         IToken getPRIORITY_EQUIVALENCE(){ return leftIToken; }

    produces1(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitproduces1(this);
            v.endVisitproduces1(this);
        }
    }

/**
 *<b>
*<li>Rule 109:  produces ::= ->
 *</b>
 */
class produces2 extends ASTNodeToken implements Iproduces
    {
         IToken getARROW(){ return leftIToken; }

    produces2(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitproduces2(this);
            v.endVisitproduces2(this);
        }
    }

/**
 *<b>
*<li>Rule 110:  produces ::= ->?
 *</b>
 */
class produces3 extends ASTNodeToken implements Iproduces
    {
         IToken getPRIORITY_ARROW(){ return leftIToken; }

    produces3(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitproduces3(this);
            v.endVisitproduces3(this);
        }
    }

/**
 *<b>
*<li>Rule 114:  symWithAttrs ::= EMPTY_KEY
 *</b>
 */
class symWithAttrs0 extends ASTNodeToken implements IsymWithAttrs
    {
         IToken getEMPTY_KEY(){ return leftIToken; }

    symWithAttrs0(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitsymWithAttrs0(this);
            v.endVisitsymWithAttrs0(this);
        }
    }

/**
 *<b>
*<li>Rule 115:  symWithAttrs ::= SYMBOL optAttrList
 *</b>
 */
class symWithAttrs1 extends ASTNode implements IsymWithAttrs
    {
         late ASTNodeToken _SYMBOL;
         late symAttrs? _optAttrList;

         ASTNodeToken getSYMBOL(){ return _SYMBOL; }
         void setSYMBOL(ASTNodeToken _SYMBOL){ this._SYMBOL = _SYMBOL; }
        /**
         * The value returned by <b>getoptAttrList</b> may be <b>null</b>
         */
         symAttrs ?  getoptAttrList(){ return _optAttrList; }
         void setoptAttrList(symAttrs _optAttrList){ this._optAttrList = _optAttrList; }

        symWithAttrs1(IToken leftIToken, IToken rightIToken,
                      ASTNodeToken _SYMBOL,
                      symAttrs? _optAttrList)
            :super(leftIToken, rightIToken)

        {
            this._SYMBOL = _SYMBOL;
            (_SYMBOL as ASTNode).setParent(this);
            this._optAttrList = _optAttrList;
            if (null != _optAttrList) (_optAttrList as ASTNode).setParent(this);
            initialize();
        }

        /**
         * A list of all children of this node, don't including the null ones.
         */
            ArrayList getAllChildren() 
        {
            var list = new ArrayList();
            if(null != _SYMBOL)  list.add(_SYMBOL);
            if(null != _optAttrList)  list.add(_optAttrList);
            return list;
        }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            var checkChildren = v.visitsymWithAttrs1(this);
            if (checkChildren)
            {
                _SYMBOL.accept(v);
                if (null != _optAttrList) _optAttrList!.accept(v);
            }
            v.endVisitsymWithAttrs1(this);
        }
    }

/**
 *<b>
*<li>Rule 123:  start_symbol ::= SYMBOL
 *</b>
 */
class start_symbol0 extends ASTNodeToken implements Istart_symbol
    {
         IToken getSYMBOL(){ return leftIToken; }

    start_symbol0(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitstart_symbol0(this);
            v.endVisitstart_symbol0(this);
        }
    }

/**
 *<b>
*<li>Rule 124:  start_symbol ::= MACRO_NAME
 *</b>
 */
class start_symbol1 extends ASTNodeToken implements Istart_symbol
    {
         IToken getMACRO_NAME(){ return leftIToken; }

    start_symbol1(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitstart_symbol1(this);
            v.endVisitstart_symbol1(this);
        }
    }

/**
 *<b>
*<li>Rule 130:  terminal_symbol ::= SYMBOL
 *</b>
 */
class terminal_symbol0 extends ASTNodeToken implements Iterminal_symbol
    {
         IToken getSYMBOL(){ return leftIToken; }

    terminal_symbol0(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitterminal_symbol0(this);
            v.endVisitterminal_symbol0(this);
        }
    }

/**
 *<b>
*<li>Rule 131:  terminal_symbol ::= MACRO_NAME
 *</b>
 */
class terminal_symbol1 extends ASTNodeToken implements Iterminal_symbol
    {
         IToken getMACRO_NAME(){ return leftIToken; }

    terminal_symbol1(IToken token) :super(token){ initialize(); }

         void  accept(IAstVisitor v )
        {
            if (! v.preVisit(this)) return;
            enter(v as Visitor);
            v.postVisit(this);
        }

          void enter(Visitor v)
        {
            v.visitterminal_symbol1(this);
            v.endVisitterminal_symbol1(this);
        }
    }

abstract class Visitor implements IAstVisitor
    {
       bool visit(ASTNode n);
       void endVisit(ASTNode n);

       bool visitASTNodeToken(ASTNodeToken n);
       void endVisitASTNodeToken(ASTNodeToken n);

       bool visitLPG(LPG n);
       void endVisitLPG(LPG n);

       bool visitLPG_itemList(LPG_itemList n);
       void endVisitLPG_itemList(LPG_itemList n);

       bool visitAliasSeg(AliasSeg n);
       void endVisitAliasSeg(AliasSeg n);

       bool visitAstSeg(AstSeg n);
       void endVisitAstSeg(AstSeg n);

       bool visitDefineSeg(DefineSeg n);
       void endVisitDefineSeg(DefineSeg n);

       bool visitEofSeg(EofSeg n);
       void endVisitEofSeg(EofSeg n);

       bool visitEolSeg(EolSeg n);
       void endVisitEolSeg(EolSeg n);

       bool visitErrorSeg(ErrorSeg n);
       void endVisitErrorSeg(ErrorSeg n);

       bool visitExportSeg(ExportSeg n);
       void endVisitExportSeg(ExportSeg n);

       bool visitGlobalsSeg(GlobalsSeg n);
       void endVisitGlobalsSeg(GlobalsSeg n);

       bool visitHeadersSeg(HeadersSeg n);
       void endVisitHeadersSeg(HeadersSeg n);

       bool visitIdentifierSeg(IdentifierSeg n);
       void endVisitIdentifierSeg(IdentifierSeg n);

       bool visitImportSeg(ImportSeg n);
       void endVisitImportSeg(ImportSeg n);

       bool visitIncludeSeg(IncludeSeg n);
       void endVisitIncludeSeg(IncludeSeg n);

       bool visitKeywordsSeg(KeywordsSeg n);
       void endVisitKeywordsSeg(KeywordsSeg n);

       bool visitNamesSeg(NamesSeg n);
       void endVisitNamesSeg(NamesSeg n);

       bool visitNoticeSeg(NoticeSeg n);
       void endVisitNoticeSeg(NoticeSeg n);

       bool visitRulesSeg(RulesSeg n);
       void endVisitRulesSeg(RulesSeg n);

       bool visitSoftKeywordsSeg(SoftKeywordsSeg n);
       void endVisitSoftKeywordsSeg(SoftKeywordsSeg n);

       bool visitStartSeg(StartSeg n);
       void endVisitStartSeg(StartSeg n);

       bool visitTerminalsSeg(TerminalsSeg n);
       void endVisitTerminalsSeg(TerminalsSeg n);

       bool visitTrailersSeg(TrailersSeg n);
       void endVisitTrailersSeg(TrailersSeg n);

       bool visitTypesSeg(TypesSeg n);
       void endVisitTypesSeg(TypesSeg n);

       bool visitRecoverSeg(RecoverSeg n);
       void endVisitRecoverSeg(RecoverSeg n);

       bool visitPredecessorSeg(PredecessorSeg n);
       void endVisitPredecessorSeg(PredecessorSeg n);

       bool visitoption_specList(option_specList n);
       void endVisitoption_specList(option_specList n);

       bool visitoption_spec(option_spec n);
       void endVisitoption_spec(option_spec n);

       bool visitoptionList(optionList n);
       void endVisitoptionList(optionList n);

       bool visitoption(option n);
       void endVisitoption(option n);

       bool visitSYMBOLList(SYMBOLList n);
       void endVisitSYMBOLList(SYMBOLList n);

       bool visitaliasSpecList(aliasSpecList n);
       void endVisitaliasSpecList(aliasSpecList n);

       bool visitalias_lhs_macro_name(alias_lhs_macro_name n);
       void endVisitalias_lhs_macro_name(alias_lhs_macro_name n);

       bool visitdefineSpecList(defineSpecList n);
       void endVisitdefineSpecList(defineSpecList n);

       bool visitdefineSpec(defineSpec n);
       void endVisitdefineSpec(defineSpec n);

       bool visitmacro_segment(macro_segment n);
       void endVisitmacro_segment(macro_segment n);

       bool visitterminal_symbolList(terminal_symbolList n);
       void endVisitterminal_symbolList(terminal_symbolList n);

       bool visitaction_segmentList(action_segmentList n);
       void endVisitaction_segmentList(action_segmentList n);

       bool visitimport_segment(import_segment n);
       void endVisitimport_segment(import_segment n);

       bool visitdrop_commandList(drop_commandList n);
       void endVisitdrop_commandList(drop_commandList n);

       bool visitdrop_ruleList(drop_ruleList n);
       void endVisitdrop_ruleList(drop_ruleList n);

       bool visitdrop_rule(drop_rule n);
       void endVisitdrop_rule(drop_rule n);

       bool visitoptMacroName(optMacroName n);
       void endVisitoptMacroName(optMacroName n);

       bool visitinclude_segment(include_segment n);
       void endVisitinclude_segment(include_segment n);

       bool visitkeywordSpecList(keywordSpecList n);
       void endVisitkeywordSpecList(keywordSpecList n);

       bool visitkeywordSpec(keywordSpec n);
       void endVisitkeywordSpec(keywordSpec n);

       bool visitnameSpecList(nameSpecList n);
       void endVisitnameSpecList(nameSpecList n);

       bool visitnameSpec(nameSpec n);
       void endVisitnameSpec(nameSpec n);

       bool visitrules_segment(rules_segment n);
       void endVisitrules_segment(rules_segment n);

       bool visitnonTermList(nonTermList n);
       void endVisitnonTermList(nonTermList n);

       bool visitnonTerm(nonTerm n);
       void endVisitnonTerm(nonTerm n);

       bool visitRuleName(RuleName n);
       void endVisitRuleName(RuleName n);

       bool visitruleList(ruleList n);
       void endVisitruleList(ruleList n);

       bool visitrule(rule n);
       void endVisitrule(rule n);

       bool visitsymWithAttrsList(symWithAttrsList n);
       void endVisitsymWithAttrsList(symWithAttrsList n);

       bool visitsymAttrs(symAttrs n);
       void endVisitsymAttrs(symAttrs n);

       bool visitaction_segment(action_segment n);
       void endVisitaction_segment(action_segment n);

       bool visitstart_symbolList(start_symbolList n);
       void endVisitstart_symbolList(start_symbolList n);

       bool visitterminals_segment_terminalList(terminals_segment_terminalList n);
       void endVisitterminals_segment_terminalList(terminals_segment_terminalList n);

       bool visitterminalList(terminalList n);
       void endVisitterminalList(terminalList n);

       bool visitterminal(terminal n);
       void endVisitterminal(terminal n);

       bool visitoptTerminalAlias(optTerminalAlias n);
       void endVisitoptTerminalAlias(optTerminalAlias n);

       bool visittype_declarationsList(type_declarationsList n);
       void endVisittype_declarationsList(type_declarationsList n);

       bool visittype_declarations(type_declarations n);
       void endVisittype_declarations(type_declarations n);

       bool visitsymbol_pairList(symbol_pairList n);
       void endVisitsymbol_pairList(symbol_pairList n);

       bool visitsymbol_pair(symbol_pair n);
       void endVisitsymbol_pair(symbol_pair n);

       bool visitrecover_symbol(recover_symbol n);
       void endVisitrecover_symbol(recover_symbol n);

       bool visitEND_KEY_OPT(END_KEY_OPT n);
       void endVisitEND_KEY_OPT(END_KEY_OPT n);

       bool visitoption_value0(option_value0 n);
       void endVisitoption_value0(option_value0 n);

       bool visitoption_value1(option_value1 n);
       void endVisitoption_value1(option_value1 n);

       bool visitaliasSpec0(aliasSpec0 n);
       void endVisitaliasSpec0(aliasSpec0 n);

       bool visitaliasSpec1(aliasSpec1 n);
       void endVisitaliasSpec1(aliasSpec1 n);

       bool visitaliasSpec2(aliasSpec2 n);
       void endVisitaliasSpec2(aliasSpec2 n);

       bool visitaliasSpec3(aliasSpec3 n);
       void endVisitaliasSpec3(aliasSpec3 n);

       bool visitaliasSpec4(aliasSpec4 n);
       void endVisitaliasSpec4(aliasSpec4 n);

       bool visitaliasSpec5(aliasSpec5 n);
       void endVisitaliasSpec5(aliasSpec5 n);

       bool visitalias_rhs0(alias_rhs0 n);
       void endVisitalias_rhs0(alias_rhs0 n);

       bool visitalias_rhs1(alias_rhs1 n);
       void endVisitalias_rhs1(alias_rhs1 n);

       bool visitalias_rhs2(alias_rhs2 n);
       void endVisitalias_rhs2(alias_rhs2 n);

       bool visitalias_rhs3(alias_rhs3 n);
       void endVisitalias_rhs3(alias_rhs3 n);

       bool visitalias_rhs4(alias_rhs4 n);
       void endVisitalias_rhs4(alias_rhs4 n);

       bool visitalias_rhs5(alias_rhs5 n);
       void endVisitalias_rhs5(alias_rhs5 n);

       bool visitalias_rhs6(alias_rhs6 n);
       void endVisitalias_rhs6(alias_rhs6 n);

       bool visitmacro_name_symbol0(macro_name_symbol0 n);
       void endVisitmacro_name_symbol0(macro_name_symbol0 n);

       bool visitmacro_name_symbol1(macro_name_symbol1 n);
       void endVisitmacro_name_symbol1(macro_name_symbol1 n);

       bool visitdrop_command0(drop_command0 n);
       void endVisitdrop_command0(drop_command0 n);

       bool visitdrop_command1(drop_command1 n);
       void endVisitdrop_command1(drop_command1 n);

       bool visitname0(name0 n);
       void endVisitname0(name0 n);

       bool visitname1(name1 n);
       void endVisitname1(name1 n);

       bool visitname2(name2 n);
       void endVisitname2(name2 n);

       bool visitname3(name3 n);
       void endVisitname3(name3 n);

       bool visitname4(name4 n);
       void endVisitname4(name4 n);

       bool visitname5(name5 n);
       void endVisitname5(name5 n);

       bool visitproduces0(produces0 n);
       void endVisitproduces0(produces0 n);

       bool visitproduces1(produces1 n);
       void endVisitproduces1(produces1 n);

       bool visitproduces2(produces2 n);
       void endVisitproduces2(produces2 n);

       bool visitproduces3(produces3 n);
       void endVisitproduces3(produces3 n);

       bool visitsymWithAttrs0(symWithAttrs0 n);
       void endVisitsymWithAttrs0(symWithAttrs0 n);

       bool visitsymWithAttrs1(symWithAttrs1 n);
       void endVisitsymWithAttrs1(symWithAttrs1 n);

       bool visitstart_symbol0(start_symbol0 n);
       void endVisitstart_symbol0(start_symbol0 n);

       bool visitstart_symbol1(start_symbol1 n);
       void endVisitstart_symbol1(start_symbol1 n);

       bool visitterminal_symbol0(terminal_symbol0 n);
       void endVisitterminal_symbol0(terminal_symbol0 n);

       bool visitterminal_symbol1(terminal_symbol1 n);
       void endVisitterminal_symbol1(terminal_symbol1 n);

    }

abstract class AbstractVisitor implements Visitor
    {
         void unimplementedVisitor(String s)  ;

         bool preVisit(IAst element) { return true; }

         void postVisit(IAst element) {}

        bool visitASTNodeToken(ASTNodeToken n){ unimplementedVisitor("visit(ASTNodeToken)"); return true; }
        void endVisitASTNodeToken(ASTNodeToken n)  { unimplementedVisitor("endVisit(ASTNodeToken)"); }

        bool visitLPG(LPG n){ unimplementedVisitor("visit(LPG)"); return true; }
        void endVisitLPG(LPG n)  { unimplementedVisitor("endVisit(LPG)"); }

        bool visitLPG_itemList(LPG_itemList n){ unimplementedVisitor("visit(LPG_itemList)"); return true; }
        void endVisitLPG_itemList(LPG_itemList n)  { unimplementedVisitor("endVisit(LPG_itemList)"); }

        bool visitAliasSeg(AliasSeg n){ unimplementedVisitor("visit(AliasSeg)"); return true; }
        void endVisitAliasSeg(AliasSeg n)  { unimplementedVisitor("endVisit(AliasSeg)"); }

        bool visitAstSeg(AstSeg n){ unimplementedVisitor("visit(AstSeg)"); return true; }
        void endVisitAstSeg(AstSeg n)  { unimplementedVisitor("endVisit(AstSeg)"); }

        bool visitDefineSeg(DefineSeg n){ unimplementedVisitor("visit(DefineSeg)"); return true; }
        void endVisitDefineSeg(DefineSeg n)  { unimplementedVisitor("endVisit(DefineSeg)"); }

        bool visitEofSeg(EofSeg n){ unimplementedVisitor("visit(EofSeg)"); return true; }
        void endVisitEofSeg(EofSeg n)  { unimplementedVisitor("endVisit(EofSeg)"); }

        bool visitEolSeg(EolSeg n){ unimplementedVisitor("visit(EolSeg)"); return true; }
        void endVisitEolSeg(EolSeg n)  { unimplementedVisitor("endVisit(EolSeg)"); }

        bool visitErrorSeg(ErrorSeg n){ unimplementedVisitor("visit(ErrorSeg)"); return true; }
        void endVisitErrorSeg(ErrorSeg n)  { unimplementedVisitor("endVisit(ErrorSeg)"); }

        bool visitExportSeg(ExportSeg n){ unimplementedVisitor("visit(ExportSeg)"); return true; }
        void endVisitExportSeg(ExportSeg n)  { unimplementedVisitor("endVisit(ExportSeg)"); }

        bool visitGlobalsSeg(GlobalsSeg n){ unimplementedVisitor("visit(GlobalsSeg)"); return true; }
        void endVisitGlobalsSeg(GlobalsSeg n)  { unimplementedVisitor("endVisit(GlobalsSeg)"); }

        bool visitHeadersSeg(HeadersSeg n){ unimplementedVisitor("visit(HeadersSeg)"); return true; }
        void endVisitHeadersSeg(HeadersSeg n)  { unimplementedVisitor("endVisit(HeadersSeg)"); }

        bool visitIdentifierSeg(IdentifierSeg n){ unimplementedVisitor("visit(IdentifierSeg)"); return true; }
        void endVisitIdentifierSeg(IdentifierSeg n)  { unimplementedVisitor("endVisit(IdentifierSeg)"); }

        bool visitImportSeg(ImportSeg n){ unimplementedVisitor("visit(ImportSeg)"); return true; }
        void endVisitImportSeg(ImportSeg n)  { unimplementedVisitor("endVisit(ImportSeg)"); }

        bool visitIncludeSeg(IncludeSeg n){ unimplementedVisitor("visit(IncludeSeg)"); return true; }
        void endVisitIncludeSeg(IncludeSeg n)  { unimplementedVisitor("endVisit(IncludeSeg)"); }

        bool visitKeywordsSeg(KeywordsSeg n){ unimplementedVisitor("visit(KeywordsSeg)"); return true; }
        void endVisitKeywordsSeg(KeywordsSeg n)  { unimplementedVisitor("endVisit(KeywordsSeg)"); }

        bool visitNamesSeg(NamesSeg n){ unimplementedVisitor("visit(NamesSeg)"); return true; }
        void endVisitNamesSeg(NamesSeg n)  { unimplementedVisitor("endVisit(NamesSeg)"); }

        bool visitNoticeSeg(NoticeSeg n){ unimplementedVisitor("visit(NoticeSeg)"); return true; }
        void endVisitNoticeSeg(NoticeSeg n)  { unimplementedVisitor("endVisit(NoticeSeg)"); }

        bool visitRulesSeg(RulesSeg n){ unimplementedVisitor("visit(RulesSeg)"); return true; }
        void endVisitRulesSeg(RulesSeg n)  { unimplementedVisitor("endVisit(RulesSeg)"); }

        bool visitSoftKeywordsSeg(SoftKeywordsSeg n){ unimplementedVisitor("visit(SoftKeywordsSeg)"); return true; }
        void endVisitSoftKeywordsSeg(SoftKeywordsSeg n)  { unimplementedVisitor("endVisit(SoftKeywordsSeg)"); }

        bool visitStartSeg(StartSeg n){ unimplementedVisitor("visit(StartSeg)"); return true; }
        void endVisitStartSeg(StartSeg n)  { unimplementedVisitor("endVisit(StartSeg)"); }

        bool visitTerminalsSeg(TerminalsSeg n){ unimplementedVisitor("visit(TerminalsSeg)"); return true; }
        void endVisitTerminalsSeg(TerminalsSeg n)  { unimplementedVisitor("endVisit(TerminalsSeg)"); }

        bool visitTrailersSeg(TrailersSeg n){ unimplementedVisitor("visit(TrailersSeg)"); return true; }
        void endVisitTrailersSeg(TrailersSeg n)  { unimplementedVisitor("endVisit(TrailersSeg)"); }

        bool visitTypesSeg(TypesSeg n){ unimplementedVisitor("visit(TypesSeg)"); return true; }
        void endVisitTypesSeg(TypesSeg n)  { unimplementedVisitor("endVisit(TypesSeg)"); }

        bool visitRecoverSeg(RecoverSeg n){ unimplementedVisitor("visit(RecoverSeg)"); return true; }
        void endVisitRecoverSeg(RecoverSeg n)  { unimplementedVisitor("endVisit(RecoverSeg)"); }

        bool visitPredecessorSeg(PredecessorSeg n){ unimplementedVisitor("visit(PredecessorSeg)"); return true; }
        void endVisitPredecessorSeg(PredecessorSeg n)  { unimplementedVisitor("endVisit(PredecessorSeg)"); }

        bool visitoption_specList(option_specList n){ unimplementedVisitor("visit(option_specList)"); return true; }
        void endVisitoption_specList(option_specList n)  { unimplementedVisitor("endVisit(option_specList)"); }

        bool visitoption_spec(option_spec n){ unimplementedVisitor("visit(option_spec)"); return true; }
        void endVisitoption_spec(option_spec n)  { unimplementedVisitor("endVisit(option_spec)"); }

        bool visitoptionList(optionList n){ unimplementedVisitor("visit(optionList)"); return true; }
        void endVisitoptionList(optionList n)  { unimplementedVisitor("endVisit(optionList)"); }

        bool visitoption(option n){ unimplementedVisitor("visit(option)"); return true; }
        void endVisitoption(option n)  { unimplementedVisitor("endVisit(option)"); }

        bool visitSYMBOLList(SYMBOLList n){ unimplementedVisitor("visit(SYMBOLList)"); return true; }
        void endVisitSYMBOLList(SYMBOLList n)  { unimplementedVisitor("endVisit(SYMBOLList)"); }

        bool visitaliasSpecList(aliasSpecList n){ unimplementedVisitor("visit(aliasSpecList)"); return true; }
        void endVisitaliasSpecList(aliasSpecList n)  { unimplementedVisitor("endVisit(aliasSpecList)"); }

        bool visitalias_lhs_macro_name(alias_lhs_macro_name n){ unimplementedVisitor("visit(alias_lhs_macro_name)"); return true; }
        void endVisitalias_lhs_macro_name(alias_lhs_macro_name n)  { unimplementedVisitor("endVisit(alias_lhs_macro_name)"); }

        bool visitdefineSpecList(defineSpecList n){ unimplementedVisitor("visit(defineSpecList)"); return true; }
        void endVisitdefineSpecList(defineSpecList n)  { unimplementedVisitor("endVisit(defineSpecList)"); }

        bool visitdefineSpec(defineSpec n){ unimplementedVisitor("visit(defineSpec)"); return true; }
        void endVisitdefineSpec(defineSpec n)  { unimplementedVisitor("endVisit(defineSpec)"); }

        bool visitmacro_segment(macro_segment n){ unimplementedVisitor("visit(macro_segment)"); return true; }
        void endVisitmacro_segment(macro_segment n)  { unimplementedVisitor("endVisit(macro_segment)"); }

        bool visitterminal_symbolList(terminal_symbolList n){ unimplementedVisitor("visit(terminal_symbolList)"); return true; }
        void endVisitterminal_symbolList(terminal_symbolList n)  { unimplementedVisitor("endVisit(terminal_symbolList)"); }

        bool visitaction_segmentList(action_segmentList n){ unimplementedVisitor("visit(action_segmentList)"); return true; }
        void endVisitaction_segmentList(action_segmentList n)  { unimplementedVisitor("endVisit(action_segmentList)"); }

        bool visitimport_segment(import_segment n){ unimplementedVisitor("visit(import_segment)"); return true; }
        void endVisitimport_segment(import_segment n)  { unimplementedVisitor("endVisit(import_segment)"); }

        bool visitdrop_commandList(drop_commandList n){ unimplementedVisitor("visit(drop_commandList)"); return true; }
        void endVisitdrop_commandList(drop_commandList n)  { unimplementedVisitor("endVisit(drop_commandList)"); }

        bool visitdrop_ruleList(drop_ruleList n){ unimplementedVisitor("visit(drop_ruleList)"); return true; }
        void endVisitdrop_ruleList(drop_ruleList n)  { unimplementedVisitor("endVisit(drop_ruleList)"); }

        bool visitdrop_rule(drop_rule n){ unimplementedVisitor("visit(drop_rule)"); return true; }
        void endVisitdrop_rule(drop_rule n)  { unimplementedVisitor("endVisit(drop_rule)"); }

        bool visitoptMacroName(optMacroName n){ unimplementedVisitor("visit(optMacroName)"); return true; }
        void endVisitoptMacroName(optMacroName n)  { unimplementedVisitor("endVisit(optMacroName)"); }

        bool visitinclude_segment(include_segment n){ unimplementedVisitor("visit(include_segment)"); return true; }
        void endVisitinclude_segment(include_segment n)  { unimplementedVisitor("endVisit(include_segment)"); }

        bool visitkeywordSpecList(keywordSpecList n){ unimplementedVisitor("visit(keywordSpecList)"); return true; }
        void endVisitkeywordSpecList(keywordSpecList n)  { unimplementedVisitor("endVisit(keywordSpecList)"); }

        bool visitkeywordSpec(keywordSpec n){ unimplementedVisitor("visit(keywordSpec)"); return true; }
        void endVisitkeywordSpec(keywordSpec n)  { unimplementedVisitor("endVisit(keywordSpec)"); }

        bool visitnameSpecList(nameSpecList n){ unimplementedVisitor("visit(nameSpecList)"); return true; }
        void endVisitnameSpecList(nameSpecList n)  { unimplementedVisitor("endVisit(nameSpecList)"); }

        bool visitnameSpec(nameSpec n){ unimplementedVisitor("visit(nameSpec)"); return true; }
        void endVisitnameSpec(nameSpec n)  { unimplementedVisitor("endVisit(nameSpec)"); }

        bool visitrules_segment(rules_segment n){ unimplementedVisitor("visit(rules_segment)"); return true; }
        void endVisitrules_segment(rules_segment n)  { unimplementedVisitor("endVisit(rules_segment)"); }

        bool visitnonTermList(nonTermList n){ unimplementedVisitor("visit(nonTermList)"); return true; }
        void endVisitnonTermList(nonTermList n)  { unimplementedVisitor("endVisit(nonTermList)"); }

        bool visitnonTerm(nonTerm n){ unimplementedVisitor("visit(nonTerm)"); return true; }
        void endVisitnonTerm(nonTerm n)  { unimplementedVisitor("endVisit(nonTerm)"); }

        bool visitRuleName(RuleName n){ unimplementedVisitor("visit(RuleName)"); return true; }
        void endVisitRuleName(RuleName n)  { unimplementedVisitor("endVisit(RuleName)"); }

        bool visitruleList(ruleList n){ unimplementedVisitor("visit(ruleList)"); return true; }
        void endVisitruleList(ruleList n)  { unimplementedVisitor("endVisit(ruleList)"); }

        bool visitrule(rule n){ unimplementedVisitor("visit(rule)"); return true; }
        void endVisitrule(rule n)  { unimplementedVisitor("endVisit(rule)"); }

        bool visitsymWithAttrsList(symWithAttrsList n){ unimplementedVisitor("visit(symWithAttrsList)"); return true; }
        void endVisitsymWithAttrsList(symWithAttrsList n)  { unimplementedVisitor("endVisit(symWithAttrsList)"); }

        bool visitsymAttrs(symAttrs n){ unimplementedVisitor("visit(symAttrs)"); return true; }
        void endVisitsymAttrs(symAttrs n)  { unimplementedVisitor("endVisit(symAttrs)"); }

        bool visitaction_segment(action_segment n){ unimplementedVisitor("visit(action_segment)"); return true; }
        void endVisitaction_segment(action_segment n)  { unimplementedVisitor("endVisit(action_segment)"); }

        bool visitstart_symbolList(start_symbolList n){ unimplementedVisitor("visit(start_symbolList)"); return true; }
        void endVisitstart_symbolList(start_symbolList n)  { unimplementedVisitor("endVisit(start_symbolList)"); }

        bool visitterminals_segment_terminalList(terminals_segment_terminalList n){ unimplementedVisitor("visit(terminals_segment_terminalList)"); return true; }
        void endVisitterminals_segment_terminalList(terminals_segment_terminalList n)  { unimplementedVisitor("endVisit(terminals_segment_terminalList)"); }

        bool visitterminalList(terminalList n){ unimplementedVisitor("visit(terminalList)"); return true; }
        void endVisitterminalList(terminalList n)  { unimplementedVisitor("endVisit(terminalList)"); }

        bool visitterminal(terminal n){ unimplementedVisitor("visit(terminal)"); return true; }
        void endVisitterminal(terminal n)  { unimplementedVisitor("endVisit(terminal)"); }

        bool visitoptTerminalAlias(optTerminalAlias n){ unimplementedVisitor("visit(optTerminalAlias)"); return true; }
        void endVisitoptTerminalAlias(optTerminalAlias n)  { unimplementedVisitor("endVisit(optTerminalAlias)"); }

        bool visittype_declarationsList(type_declarationsList n){ unimplementedVisitor("visit(type_declarationsList)"); return true; }
        void endVisittype_declarationsList(type_declarationsList n)  { unimplementedVisitor("endVisit(type_declarationsList)"); }

        bool visittype_declarations(type_declarations n){ unimplementedVisitor("visit(type_declarations)"); return true; }
        void endVisittype_declarations(type_declarations n)  { unimplementedVisitor("endVisit(type_declarations)"); }

        bool visitsymbol_pairList(symbol_pairList n){ unimplementedVisitor("visit(symbol_pairList)"); return true; }
        void endVisitsymbol_pairList(symbol_pairList n)  { unimplementedVisitor("endVisit(symbol_pairList)"); }

        bool visitsymbol_pair(symbol_pair n){ unimplementedVisitor("visit(symbol_pair)"); return true; }
        void endVisitsymbol_pair(symbol_pair n)  { unimplementedVisitor("endVisit(symbol_pair)"); }

        bool visitrecover_symbol(recover_symbol n){ unimplementedVisitor("visit(recover_symbol)"); return true; }
        void endVisitrecover_symbol(recover_symbol n)  { unimplementedVisitor("endVisit(recover_symbol)"); }

        bool visitEND_KEY_OPT(END_KEY_OPT n){ unimplementedVisitor("visit(END_KEY_OPT)"); return true; }
        void endVisitEND_KEY_OPT(END_KEY_OPT n)  { unimplementedVisitor("endVisit(END_KEY_OPT)"); }

        bool visitoption_value0(option_value0 n){ unimplementedVisitor("visit(option_value0)"); return true; }
        void endVisitoption_value0(option_value0 n)  { unimplementedVisitor("endVisit(option_value0)"); }

        bool visitoption_value1(option_value1 n){ unimplementedVisitor("visit(option_value1)"); return true; }
        void endVisitoption_value1(option_value1 n)  { unimplementedVisitor("endVisit(option_value1)"); }

        bool visitaliasSpec0(aliasSpec0 n){ unimplementedVisitor("visit(aliasSpec0)"); return true; }
        void endVisitaliasSpec0(aliasSpec0 n)  { unimplementedVisitor("endVisit(aliasSpec0)"); }

        bool visitaliasSpec1(aliasSpec1 n){ unimplementedVisitor("visit(aliasSpec1)"); return true; }
        void endVisitaliasSpec1(aliasSpec1 n)  { unimplementedVisitor("endVisit(aliasSpec1)"); }

        bool visitaliasSpec2(aliasSpec2 n){ unimplementedVisitor("visit(aliasSpec2)"); return true; }
        void endVisitaliasSpec2(aliasSpec2 n)  { unimplementedVisitor("endVisit(aliasSpec2)"); }

        bool visitaliasSpec3(aliasSpec3 n){ unimplementedVisitor("visit(aliasSpec3)"); return true; }
        void endVisitaliasSpec3(aliasSpec3 n)  { unimplementedVisitor("endVisit(aliasSpec3)"); }

        bool visitaliasSpec4(aliasSpec4 n){ unimplementedVisitor("visit(aliasSpec4)"); return true; }
        void endVisitaliasSpec4(aliasSpec4 n)  { unimplementedVisitor("endVisit(aliasSpec4)"); }

        bool visitaliasSpec5(aliasSpec5 n){ unimplementedVisitor("visit(aliasSpec5)"); return true; }
        void endVisitaliasSpec5(aliasSpec5 n)  { unimplementedVisitor("endVisit(aliasSpec5)"); }

        bool visitalias_rhs0(alias_rhs0 n){ unimplementedVisitor("visit(alias_rhs0)"); return true; }
        void endVisitalias_rhs0(alias_rhs0 n)  { unimplementedVisitor("endVisit(alias_rhs0)"); }

        bool visitalias_rhs1(alias_rhs1 n){ unimplementedVisitor("visit(alias_rhs1)"); return true; }
        void endVisitalias_rhs1(alias_rhs1 n)  { unimplementedVisitor("endVisit(alias_rhs1)"); }

        bool visitalias_rhs2(alias_rhs2 n){ unimplementedVisitor("visit(alias_rhs2)"); return true; }
        void endVisitalias_rhs2(alias_rhs2 n)  { unimplementedVisitor("endVisit(alias_rhs2)"); }

        bool visitalias_rhs3(alias_rhs3 n){ unimplementedVisitor("visit(alias_rhs3)"); return true; }
        void endVisitalias_rhs3(alias_rhs3 n)  { unimplementedVisitor("endVisit(alias_rhs3)"); }

        bool visitalias_rhs4(alias_rhs4 n){ unimplementedVisitor("visit(alias_rhs4)"); return true; }
        void endVisitalias_rhs4(alias_rhs4 n)  { unimplementedVisitor("endVisit(alias_rhs4)"); }

        bool visitalias_rhs5(alias_rhs5 n){ unimplementedVisitor("visit(alias_rhs5)"); return true; }
        void endVisitalias_rhs5(alias_rhs5 n)  { unimplementedVisitor("endVisit(alias_rhs5)"); }

        bool visitalias_rhs6(alias_rhs6 n){ unimplementedVisitor("visit(alias_rhs6)"); return true; }
        void endVisitalias_rhs6(alias_rhs6 n)  { unimplementedVisitor("endVisit(alias_rhs6)"); }

        bool visitmacro_name_symbol0(macro_name_symbol0 n){ unimplementedVisitor("visit(macro_name_symbol0)"); return true; }
        void endVisitmacro_name_symbol0(macro_name_symbol0 n)  { unimplementedVisitor("endVisit(macro_name_symbol0)"); }

        bool visitmacro_name_symbol1(macro_name_symbol1 n){ unimplementedVisitor("visit(macro_name_symbol1)"); return true; }
        void endVisitmacro_name_symbol1(macro_name_symbol1 n)  { unimplementedVisitor("endVisit(macro_name_symbol1)"); }

        bool visitdrop_command0(drop_command0 n){ unimplementedVisitor("visit(drop_command0)"); return true; }
        void endVisitdrop_command0(drop_command0 n)  { unimplementedVisitor("endVisit(drop_command0)"); }

        bool visitdrop_command1(drop_command1 n){ unimplementedVisitor("visit(drop_command1)"); return true; }
        void endVisitdrop_command1(drop_command1 n)  { unimplementedVisitor("endVisit(drop_command1)"); }

        bool visitname0(name0 n){ unimplementedVisitor("visit(name0)"); return true; }
        void endVisitname0(name0 n)  { unimplementedVisitor("endVisit(name0)"); }

        bool visitname1(name1 n){ unimplementedVisitor("visit(name1)"); return true; }
        void endVisitname1(name1 n)  { unimplementedVisitor("endVisit(name1)"); }

        bool visitname2(name2 n){ unimplementedVisitor("visit(name2)"); return true; }
        void endVisitname2(name2 n)  { unimplementedVisitor("endVisit(name2)"); }

        bool visitname3(name3 n){ unimplementedVisitor("visit(name3)"); return true; }
        void endVisitname3(name3 n)  { unimplementedVisitor("endVisit(name3)"); }

        bool visitname4(name4 n){ unimplementedVisitor("visit(name4)"); return true; }
        void endVisitname4(name4 n)  { unimplementedVisitor("endVisit(name4)"); }

        bool visitname5(name5 n){ unimplementedVisitor("visit(name5)"); return true; }
        void endVisitname5(name5 n)  { unimplementedVisitor("endVisit(name5)"); }

        bool visitproduces0(produces0 n){ unimplementedVisitor("visit(produces0)"); return true; }
        void endVisitproduces0(produces0 n)  { unimplementedVisitor("endVisit(produces0)"); }

        bool visitproduces1(produces1 n){ unimplementedVisitor("visit(produces1)"); return true; }
        void endVisitproduces1(produces1 n)  { unimplementedVisitor("endVisit(produces1)"); }

        bool visitproduces2(produces2 n){ unimplementedVisitor("visit(produces2)"); return true; }
        void endVisitproduces2(produces2 n)  { unimplementedVisitor("endVisit(produces2)"); }

        bool visitproduces3(produces3 n){ unimplementedVisitor("visit(produces3)"); return true; }
        void endVisitproduces3(produces3 n)  { unimplementedVisitor("endVisit(produces3)"); }

        bool visitsymWithAttrs0(symWithAttrs0 n){ unimplementedVisitor("visit(symWithAttrs0)"); return true; }
        void endVisitsymWithAttrs0(symWithAttrs0 n)  { unimplementedVisitor("endVisit(symWithAttrs0)"); }

        bool visitsymWithAttrs1(symWithAttrs1 n){ unimplementedVisitor("visit(symWithAttrs1)"); return true; }
        void endVisitsymWithAttrs1(symWithAttrs1 n)  { unimplementedVisitor("endVisit(symWithAttrs1)"); }

        bool visitstart_symbol0(start_symbol0 n){ unimplementedVisitor("visit(start_symbol0)"); return true; }
        void endVisitstart_symbol0(start_symbol0 n)  { unimplementedVisitor("endVisit(start_symbol0)"); }

        bool visitstart_symbol1(start_symbol1 n){ unimplementedVisitor("visit(start_symbol1)"); return true; }
        void endVisitstart_symbol1(start_symbol1 n)  { unimplementedVisitor("endVisit(start_symbol1)"); }

        bool visitterminal_symbol0(terminal_symbol0 n){ unimplementedVisitor("visit(terminal_symbol0)"); return true; }
        void endVisitterminal_symbol0(terminal_symbol0 n)  { unimplementedVisitor("endVisit(terminal_symbol0)"); }

        bool visitterminal_symbol1(terminal_symbol1 n){ unimplementedVisitor("visit(terminal_symbol1)"); return true; }
        void endVisitterminal_symbol1(terminal_symbol1 n)  { unimplementedVisitor("endVisit(terminal_symbol1)"); }


        bool visit(ASTNode n)
        {
            if (n is ASTNodeToken) return visitASTNodeToken( n);
            else if (n is LPG) return visitLPG( n);
            else if (n is LPG_itemList) return visitLPG_itemList( n);
            else if (n is AliasSeg) return visitAliasSeg( n);
            else if (n is AstSeg) return visitAstSeg( n);
            else if (n is DefineSeg) return visitDefineSeg( n);
            else if (n is EofSeg) return visitEofSeg( n);
            else if (n is EolSeg) return visitEolSeg( n);
            else if (n is ErrorSeg) return visitErrorSeg( n);
            else if (n is ExportSeg) return visitExportSeg( n);
            else if (n is GlobalsSeg) return visitGlobalsSeg( n);
            else if (n is HeadersSeg) return visitHeadersSeg( n);
            else if (n is IdentifierSeg) return visitIdentifierSeg( n);
            else if (n is ImportSeg) return visitImportSeg( n);
            else if (n is IncludeSeg) return visitIncludeSeg( n);
            else if (n is KeywordsSeg) return visitKeywordsSeg( n);
            else if (n is NamesSeg) return visitNamesSeg( n);
            else if (n is NoticeSeg) return visitNoticeSeg( n);
            else if (n is RulesSeg) return visitRulesSeg( n);
            else if (n is SoftKeywordsSeg) return visitSoftKeywordsSeg( n);
            else if (n is StartSeg) return visitStartSeg( n);
            else if (n is TerminalsSeg) return visitTerminalsSeg( n);
            else if (n is TrailersSeg) return visitTrailersSeg( n);
            else if (n is TypesSeg) return visitTypesSeg( n);
            else if (n is RecoverSeg) return visitRecoverSeg( n);
            else if (n is PredecessorSeg) return visitPredecessorSeg( n);
            else if (n is option_specList) return visitoption_specList( n);
            else if (n is option_spec) return visitoption_spec( n);
            else if (n is optionList) return visitoptionList( n);
            else if (n is option) return visitoption( n);
            else if (n is SYMBOLList) return visitSYMBOLList( n);
            else if (n is aliasSpecList) return visitaliasSpecList( n);
            else if (n is alias_lhs_macro_name) return visitalias_lhs_macro_name( n);
            else if (n is defineSpecList) return visitdefineSpecList( n);
            else if (n is defineSpec) return visitdefineSpec( n);
            else if (n is macro_segment) return visitmacro_segment( n);
            else if (n is terminal_symbolList) return visitterminal_symbolList( n);
            else if (n is action_segmentList) return visitaction_segmentList( n);
            else if (n is import_segment) return visitimport_segment( n);
            else if (n is drop_commandList) return visitdrop_commandList( n);
            else if (n is drop_ruleList) return visitdrop_ruleList( n);
            else if (n is drop_rule) return visitdrop_rule( n);
            else if (n is optMacroName) return visitoptMacroName( n);
            else if (n is include_segment) return visitinclude_segment( n);
            else if (n is keywordSpecList) return visitkeywordSpecList( n);
            else if (n is keywordSpec) return visitkeywordSpec( n);
            else if (n is nameSpecList) return visitnameSpecList( n);
            else if (n is nameSpec) return visitnameSpec( n);
            else if (n is rules_segment) return visitrules_segment( n);
            else if (n is nonTermList) return visitnonTermList( n);
            else if (n is nonTerm) return visitnonTerm( n);
            else if (n is RuleName) return visitRuleName( n);
            else if (n is ruleList) return visitruleList( n);
            else if (n is rule) return visitrule( n);
            else if (n is symWithAttrsList) return visitsymWithAttrsList( n);
            else if (n is symAttrs) return visitsymAttrs( n);
            else if (n is action_segment) return visitaction_segment( n);
            else if (n is start_symbolList) return visitstart_symbolList( n);
            else if (n is terminals_segment_terminalList) return visitterminals_segment_terminalList( n);
            else if (n is terminalList) return visitterminalList( n);
            else if (n is terminal) return visitterminal( n);
            else if (n is optTerminalAlias) return visitoptTerminalAlias( n);
            else if (n is type_declarationsList) return visittype_declarationsList( n);
            else if (n is type_declarations) return visittype_declarations( n);
            else if (n is symbol_pairList) return visitsymbol_pairList( n);
            else if (n is symbol_pair) return visitsymbol_pair( n);
            else if (n is recover_symbol) return visitrecover_symbol( n);
            else if (n is END_KEY_OPT) return visitEND_KEY_OPT( n);
            else if (n is option_value0) return visitoption_value0( n);
            else if (n is option_value1) return visitoption_value1( n);
            else if (n is aliasSpec0) return visitaliasSpec0( n);
            else if (n is aliasSpec1) return visitaliasSpec1( n);
            else if (n is aliasSpec2) return visitaliasSpec2( n);
            else if (n is aliasSpec3) return visitaliasSpec3( n);
            else if (n is aliasSpec4) return visitaliasSpec4( n);
            else if (n is aliasSpec5) return visitaliasSpec5( n);
            else if (n is alias_rhs0) return visitalias_rhs0( n);
            else if (n is alias_rhs1) return visitalias_rhs1( n);
            else if (n is alias_rhs2) return visitalias_rhs2( n);
            else if (n is alias_rhs3) return visitalias_rhs3( n);
            else if (n is alias_rhs4) return visitalias_rhs4( n);
            else if (n is alias_rhs5) return visitalias_rhs5( n);
            else if (n is alias_rhs6) return visitalias_rhs6( n);
            else if (n is macro_name_symbol0) return visitmacro_name_symbol0( n);
            else if (n is macro_name_symbol1) return visitmacro_name_symbol1( n);
            else if (n is drop_command0) return visitdrop_command0( n);
            else if (n is drop_command1) return visitdrop_command1( n);
            else if (n is name0) return visitname0( n);
            else if (n is name1) return visitname1( n);
            else if (n is name2) return visitname2( n);
            else if (n is name3) return visitname3( n);
            else if (n is name4) return visitname4( n);
            else if (n is name5) return visitname5( n);
            else if (n is produces0) return visitproduces0( n);
            else if (n is produces1) return visitproduces1( n);
            else if (n is produces2) return visitproduces2( n);
            else if (n is produces3) return visitproduces3( n);
            else if (n is symWithAttrs0) return visitsymWithAttrs0( n);
            else if (n is symWithAttrs1) return visitsymWithAttrs1( n);
            else if (n is start_symbol0) return visitstart_symbol0( n);
            else if (n is start_symbol1) return visitstart_symbol1( n);
            else if (n is terminal_symbol0) return visitterminal_symbol0( n);
            else if (n is terminal_symbol1) return visitterminal_symbol1( n);
            throw  ArgumentError("visit(" + n.toString() + ")");
        }
       void endVisit(ASTNode n)
        {
            if (n is ASTNodeToken) endVisitASTNodeToken(n);
            else if (n is LPG) endVisitLPG(n);
            else if (n is LPG_itemList) endVisitLPG_itemList(n);
            else if (n is AliasSeg) endVisitAliasSeg(n);
            else if (n is AstSeg) endVisitAstSeg(n);
            else if (n is DefineSeg) endVisitDefineSeg(n);
            else if (n is EofSeg) endVisitEofSeg(n);
            else if (n is EolSeg) endVisitEolSeg(n);
            else if (n is ErrorSeg) endVisitErrorSeg(n);
            else if (n is ExportSeg) endVisitExportSeg(n);
            else if (n is GlobalsSeg) endVisitGlobalsSeg(n);
            else if (n is HeadersSeg) endVisitHeadersSeg(n);
            else if (n is IdentifierSeg) endVisitIdentifierSeg(n);
            else if (n is ImportSeg) endVisitImportSeg(n);
            else if (n is IncludeSeg) endVisitIncludeSeg(n);
            else if (n is KeywordsSeg) endVisitKeywordsSeg(n);
            else if (n is NamesSeg) endVisitNamesSeg(n);
            else if (n is NoticeSeg) endVisitNoticeSeg(n);
            else if (n is RulesSeg) endVisitRulesSeg(n);
            else if (n is SoftKeywordsSeg) endVisitSoftKeywordsSeg(n);
            else if (n is StartSeg) endVisitStartSeg(n);
            else if (n is TerminalsSeg) endVisitTerminalsSeg(n);
            else if (n is TrailersSeg) endVisitTrailersSeg(n);
            else if (n is TypesSeg) endVisitTypesSeg(n);
            else if (n is RecoverSeg) endVisitRecoverSeg(n);
            else if (n is PredecessorSeg) endVisitPredecessorSeg(n);
            else if (n is option_specList) endVisitoption_specList(n);
            else if (n is option_spec) endVisitoption_spec(n);
            else if (n is optionList) endVisitoptionList(n);
            else if (n is option) endVisitoption(n);
            else if (n is SYMBOLList) endVisitSYMBOLList(n);
            else if (n is aliasSpecList) endVisitaliasSpecList(n);
            else if (n is alias_lhs_macro_name) endVisitalias_lhs_macro_name(n);
            else if (n is defineSpecList) endVisitdefineSpecList(n);
            else if (n is defineSpec) endVisitdefineSpec(n);
            else if (n is macro_segment) endVisitmacro_segment(n);
            else if (n is terminal_symbolList) endVisitterminal_symbolList(n);
            else if (n is action_segmentList) endVisitaction_segmentList(n);
            else if (n is import_segment) endVisitimport_segment(n);
            else if (n is drop_commandList) endVisitdrop_commandList(n);
            else if (n is drop_ruleList) endVisitdrop_ruleList(n);
            else if (n is drop_rule) endVisitdrop_rule(n);
            else if (n is optMacroName) endVisitoptMacroName(n);
            else if (n is include_segment) endVisitinclude_segment(n);
            else if (n is keywordSpecList) endVisitkeywordSpecList(n);
            else if (n is keywordSpec) endVisitkeywordSpec(n);
            else if (n is nameSpecList) endVisitnameSpecList(n);
            else if (n is nameSpec) endVisitnameSpec(n);
            else if (n is rules_segment) endVisitrules_segment(n);
            else if (n is nonTermList) endVisitnonTermList(n);
            else if (n is nonTerm) endVisitnonTerm(n);
            else if (n is RuleName) endVisitRuleName(n);
            else if (n is ruleList) endVisitruleList(n);
            else if (n is rule) endVisitrule(n);
            else if (n is symWithAttrsList) endVisitsymWithAttrsList(n);
            else if (n is symAttrs) endVisitsymAttrs(n);
            else if (n is action_segment) endVisitaction_segment(n);
            else if (n is start_symbolList) endVisitstart_symbolList(n);
            else if (n is terminals_segment_terminalList) endVisitterminals_segment_terminalList(n);
            else if (n is terminalList) endVisitterminalList(n);
            else if (n is terminal) endVisitterminal(n);
            else if (n is optTerminalAlias) endVisitoptTerminalAlias(n);
            else if (n is type_declarationsList) endVisittype_declarationsList(n);
            else if (n is type_declarations) endVisittype_declarations(n);
            else if (n is symbol_pairList) endVisitsymbol_pairList(n);
            else if (n is symbol_pair) endVisitsymbol_pair(n);
            else if (n is recover_symbol) endVisitrecover_symbol(n);
            else if (n is END_KEY_OPT) endVisitEND_KEY_OPT(n);
            else if (n is option_value0) endVisitoption_value0(n);
            else if (n is option_value1) endVisitoption_value1(n);
            else if (n is aliasSpec0) endVisitaliasSpec0(n);
            else if (n is aliasSpec1) endVisitaliasSpec1(n);
            else if (n is aliasSpec2) endVisitaliasSpec2(n);
            else if (n is aliasSpec3) endVisitaliasSpec3(n);
            else if (n is aliasSpec4) endVisitaliasSpec4(n);
            else if (n is aliasSpec5) endVisitaliasSpec5(n);
            else if (n is alias_rhs0) endVisitalias_rhs0(n);
            else if (n is alias_rhs1) endVisitalias_rhs1(n);
            else if (n is alias_rhs2) endVisitalias_rhs2(n);
            else if (n is alias_rhs3) endVisitalias_rhs3(n);
            else if (n is alias_rhs4) endVisitalias_rhs4(n);
            else if (n is alias_rhs5) endVisitalias_rhs5(n);
            else if (n is alias_rhs6) endVisitalias_rhs6(n);
            else if (n is macro_name_symbol0) endVisitmacro_name_symbol0(n);
            else if (n is macro_name_symbol1) endVisitmacro_name_symbol1(n);
            else if (n is drop_command0) endVisitdrop_command0(n);
            else if (n is drop_command1) endVisitdrop_command1(n);
            else if (n is name0) endVisitname0(n);
            else if (n is name1) endVisitname1(n);
            else if (n is name2) endVisitname2(n);
            else if (n is name3) endVisitname3(n);
            else if (n is name4) endVisitname4(n);
            else if (n is name5) endVisitname5(n);
            else if (n is produces0) endVisitproduces0(n);
            else if (n is produces1) endVisitproduces1(n);
            else if (n is produces2) endVisitproduces2(n);
            else if (n is produces3) endVisitproduces3(n);
            else if (n is symWithAttrs0) endVisitsymWithAttrs0(n);
            else if (n is symWithAttrs1) endVisitsymWithAttrs1(n);
            else if (n is start_symbol0) endVisitstart_symbol0(n);
            else if (n is start_symbol1) endVisitstart_symbol1(n);
            else if (n is terminal_symbol0) endVisitterminal_symbol0(n);
            else if (n is terminal_symbol1) endVisitterminal_symbol1(n);
            else throw  ArgumentError("visit(" + n.toString() + ")");
        }
    }

