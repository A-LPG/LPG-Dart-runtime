
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007 IBM Corporation.
// All rights reserved. This program and the accompanying materials
// are made available under the terms of the Eclipse Public License v1.0
// which accompanies this distribution, and is available at
// http://www.eclipse.org/legal/epl-v10.html
//
//Contributors:
//    Philippe Charles (pcharles@us.ibm.com) - initial API and implementation

////////////////////////////////////////////////////////////////////////////////


    //#line 24 "KeywordTemplateF.gi

import 'JavaKWLexerprs.dart';
import 'JavaKWLexersym.dart';
import 'JavaParsersym.dart';


    //#line 70 "KeywordTemplateF.gi

class JavaKWLexer extends JavaKWLexerprs
{
    late String inputChars;
    List<int> keywordKind  = List<int>.filled(88 + 1,0);

    List<int>  getKeywordKinds()  { return keywordKind; }

    int lexer(int curtok, int lasttok)  
    {
        var current_kind = JavaKWLexer.getKind(inputChars.codeUnitAt(curtok)),
            act=0;

        for (act = tAction(JavaKWLexerprs.START_STATE, current_kind);
             act > JavaKWLexerprs.NUM_RULES && act < JavaKWLexerprs.ACCEPT_ACTION;
             act = tAction(act, current_kind))
        {
            curtok++;
            current_kind = (curtok > lasttok
                                   ? JavaKWLexersym.Char_EOF
                                   : JavaKWLexer.getKind(inputChars.codeUnitAt(curtok)));
        }

        if (act > JavaKWLexerprs.ERROR_ACTION)
        {
            curtok++;
            act -= JavaKWLexerprs.ERROR_ACTION;
        }

        return keywordKind[ (act == JavaKWLexerprs.ERROR_ACTION  || curtok <= lasttok) ? 0 : act];
    }

    void setInputChars(String inputChars)  { this.inputChars = inputChars; }


    //#line 10 "KWLexerMapF.gi

   
    static  List<int> init_tokenKind() 
    {
        List<int> tokenKind =  List<int>.filled(128,0);
        tokenKind['\$'.codeUnitAt(0)] = JavaKWLexersym.Char_DollarSign;
        tokenKind['%'.codeUnitAt(0)] = JavaKWLexersym.Char_Percent;
        tokenKind['_'.codeUnitAt(0)] = JavaKWLexersym.Char__;

        tokenKind['a'.codeUnitAt(0)] = JavaKWLexersym.Char_a;
        tokenKind['b'.codeUnitAt(0)] = JavaKWLexersym.Char_b;
        tokenKind['c'.codeUnitAt(0)] = JavaKWLexersym.Char_c;
        tokenKind['d'.codeUnitAt(0)] = JavaKWLexersym.Char_d;
        tokenKind['e'.codeUnitAt(0)] = JavaKWLexersym.Char_e;
        tokenKind['f'.codeUnitAt(0)] = JavaKWLexersym.Char_f;
        tokenKind['g'.codeUnitAt(0)] = JavaKWLexersym.Char_g;
        tokenKind['h'.codeUnitAt(0)] = JavaKWLexersym.Char_h;
        tokenKind['i'.codeUnitAt(0)] = JavaKWLexersym.Char_i;
        tokenKind['j'.codeUnitAt(0)] = JavaKWLexersym.Char_j;
        tokenKind['k'.codeUnitAt(0)] = JavaKWLexersym.Char_k;
        tokenKind['l'.codeUnitAt(0)] = JavaKWLexersym.Char_l;
        tokenKind['m'.codeUnitAt(0)] = JavaKWLexersym.Char_m;
        tokenKind['n'.codeUnitAt(0)] = JavaKWLexersym.Char_n;
        tokenKind['o'.codeUnitAt(0)] = JavaKWLexersym.Char_o;
        tokenKind['p'.codeUnitAt(0)] = JavaKWLexersym.Char_p;
        tokenKind['q'.codeUnitAt(0)] = JavaKWLexersym.Char_q;
        tokenKind['r'.codeUnitAt(0)] = JavaKWLexersym.Char_r;
        tokenKind['s'.codeUnitAt(0)] = JavaKWLexersym.Char_s;
        tokenKind['t'.codeUnitAt(0)] = JavaKWLexersym.Char_t;
        tokenKind['u'.codeUnitAt(0)] = JavaKWLexersym.Char_u;
        tokenKind['v'.codeUnitAt(0)] = JavaKWLexersym.Char_v;
        tokenKind['w'.codeUnitAt(0)] = JavaKWLexersym.Char_w;
        tokenKind['x'.codeUnitAt(0)] = JavaKWLexersym.Char_x;
        tokenKind['y'.codeUnitAt(0)] = JavaKWLexersym.Char_y;
        tokenKind['z'.codeUnitAt(0)] = JavaKWLexersym.Char_z;

        tokenKind['A'.codeUnitAt(0)] = JavaKWLexersym.Char_A;
        tokenKind['B'.codeUnitAt(0)] = JavaKWLexersym.Char_B;
        tokenKind['C'.codeUnitAt(0)] = JavaKWLexersym.Char_C;
        tokenKind['D'.codeUnitAt(0)] = JavaKWLexersym.Char_D;
        tokenKind['E'.codeUnitAt(0)] = JavaKWLexersym.Char_E;
        tokenKind['F'.codeUnitAt(0)] = JavaKWLexersym.Char_F;
        tokenKind['G'.codeUnitAt(0)] = JavaKWLexersym.Char_G;
        tokenKind['H'.codeUnitAt(0)] = JavaKWLexersym.Char_H;
        tokenKind['I'.codeUnitAt(0)] = JavaKWLexersym.Char_I;
        tokenKind['J'.codeUnitAt(0)] = JavaKWLexersym.Char_J;
        tokenKind['K'.codeUnitAt(0)] = JavaKWLexersym.Char_K;
        tokenKind['L'.codeUnitAt(0)] = JavaKWLexersym.Char_L;
        tokenKind['M'.codeUnitAt(0)] = JavaKWLexersym.Char_M;
        tokenKind['N'.codeUnitAt(0)] = JavaKWLexersym.Char_N;
        tokenKind['O'.codeUnitAt(0)] = JavaKWLexersym.Char_O;
        tokenKind['P'.codeUnitAt(0)] = JavaKWLexersym.Char_P;
        tokenKind['Q'.codeUnitAt(0)] = JavaKWLexersym.Char_Q;
        tokenKind['R'.codeUnitAt(0)] = JavaKWLexersym.Char_R;
        tokenKind['S'.codeUnitAt(0)] = JavaKWLexersym.Char_S;
        tokenKind['T'.codeUnitAt(0)] = JavaKWLexersym.Char_T;
        tokenKind['U'.codeUnitAt(0)] = JavaKWLexersym.Char_U;
        tokenKind['V'.codeUnitAt(0)] = JavaKWLexersym.Char_V;
        tokenKind['W'.codeUnitAt(0)] = JavaKWLexersym.Char_W;
        tokenKind['X'.codeUnitAt(0)] = JavaKWLexersym.Char_X;
        tokenKind['Y'.codeUnitAt(0)] = JavaKWLexersym.Char_Y;
        tokenKind['Z'.codeUnitAt(0)] = JavaKWLexersym.Char_Z;
        return tokenKind;
    }
    static  final List<int> tokenKind =  init_tokenKind(); 
    
    static  int getKind(int c)
    {
        return (((c & 0xFFFFFF80) == 0) /* 0 <= c < 128? */ ? JavaKWLexer.tokenKind[c] : 0);
    }

    //#line 108 "KeywordTemplateF.gi


    JavaKWLexer(String inputChars, int identifierKind)
    {
        this.inputChars = inputChars;
        keywordKind[0] = identifierKind;

        //
        // Rule 1:  KeyWord ::= a b s t r a c t
        //

        keywordKind[1] = (JavaParsersym.TK_abstract);
      
    
        //
        // Rule 2:  KeyWord ::= a s s e r t
        //

        keywordKind[2] = (JavaParsersym.TK_assert);
      
    
        //
        // Rule 3:  KeyWord ::= b o o l e a n
        //

        keywordKind[3] = (JavaParsersym.TK_boolean);
      
    
        //
        // Rule 4:  KeyWord ::= b r e a k
        //

        keywordKind[4] = (JavaParsersym.TK_break);
      
    
        //
        // Rule 5:  KeyWord ::= b y t e
        //

        keywordKind[5] = (JavaParsersym.TK_byte);
      
    
        //
        // Rule 6:  KeyWord ::= c a s e
        //

        keywordKind[6] = (JavaParsersym.TK_case);
      
    
        //
        // Rule 7:  KeyWord ::= c a t c h
        //

        keywordKind[7] = (JavaParsersym.TK_catch);
      
    
        //
        // Rule 8:  KeyWord ::= c h a r
        //

        keywordKind[8] = (JavaParsersym.TK_char);
      
    
        //
        // Rule 9:  KeyWord ::= c l a s s
        //

        keywordKind[9] = (JavaParsersym.TK_class);
      
    
        //
        // Rule 10:  KeyWord ::= c o n s t
        //

        keywordKind[10] = (JavaParsersym.TK_const);
      
    
        //
        // Rule 11:  KeyWord ::= c o n t i n u e
        //

        keywordKind[11] = (JavaParsersym.TK_continue);
      
    
        //
        // Rule 12:  KeyWord ::= d e f a u l t
        //

        keywordKind[12] = (JavaParsersym.TK_default);
      
    
        //
        // Rule 13:  KeyWord ::= d o
        //

        keywordKind[13] = (JavaParsersym.TK_do);
      
    
        //
        // Rule 14:  KeyWord ::= d o u b l e
        //

        keywordKind[14] = (JavaParsersym.TK_double);
      
    
        //
        // Rule 15:  KeyWord ::= e l s e
        //

        keywordKind[15] = (JavaParsersym.TK_else);
      
    
        //
        // Rule 16:  KeyWord ::= e n u m
        //

        keywordKind[16] = (JavaParsersym.TK_enum);
      
    
        //
        // Rule 17:  KeyWord ::= e x t e n d s
        //

        keywordKind[17] = (JavaParsersym.TK_extends);
      
    
        //
        // Rule 18:  KeyWord ::= f a l s e
        //

        keywordKind[18] = (JavaParsersym.TK_false);
      
    
        //
        // Rule 19:  KeyWord ::= f i n a l
        //

        keywordKind[19] = (JavaParsersym.TK_final);
      
    
        //
        // Rule 20:  KeyWord ::= f i n a l l y
        //

        keywordKind[20] = (JavaParsersym.TK_finally);
      
    
        //
        // Rule 21:  KeyWord ::= f l o a t
        //

        keywordKind[21] = (JavaParsersym.TK_float);
      
    
        //
        // Rule 22:  KeyWord ::= f o r
        //

        keywordKind[22] = (JavaParsersym.TK_for);
      
    
        //
        // Rule 23:  KeyWord ::= g o t o
        //

        keywordKind[23] = (JavaParsersym.TK_goto);
      
    
        //
        // Rule 24:  KeyWord ::= i f
        //

        keywordKind[24] = (JavaParsersym.TK_if);
      
    
        //
        // Rule 25:  KeyWord ::= i m p l e m e n t s
        //

        keywordKind[25] = (JavaParsersym.TK_implements);
      
    
        //
        // Rule 26:  KeyWord ::= i m p o r t
        //

        keywordKind[26] = (JavaParsersym.TK_import);
      
    
        //
        // Rule 27:  KeyWord ::= i n s t a n c e o f
        //

        keywordKind[27] = (JavaParsersym.TK_instanceof);
      
    
        //
        // Rule 28:  KeyWord ::= i n t
        //

        keywordKind[28] = (JavaParsersym.TK_int);
      
    
        //
        // Rule 29:  KeyWord ::= i n t e r f a c e
        //

        keywordKind[29] = (JavaParsersym.TK_interface);
      
    
        //
        // Rule 30:  KeyWord ::= l o n g
        //

        keywordKind[30] = (JavaParsersym.TK_long);
      
    
        //
        // Rule 31:  KeyWord ::= n a t i v e
        //

        keywordKind[31] = (JavaParsersym.TK_native);
      
    
        //
        // Rule 32:  KeyWord ::= n e w
        //

        keywordKind[32] = (JavaParsersym.TK_new);
      
    
        //
        // Rule 33:  KeyWord ::= n u l l
        //

        keywordKind[33] = (JavaParsersym.TK_null);
      
    
        //
        // Rule 34:  KeyWord ::= p a c k a g e
        //

        keywordKind[34] = (JavaParsersym.TK_package);
      
    
        //
        // Rule 35:  KeyWord ::= p r i v a t e
        //

        keywordKind[35] = (JavaParsersym.TK_private);
      
    
        //
        // Rule 36:  KeyWord ::= p r o t e c t e d
        //

        keywordKind[36] = (JavaParsersym.TK_protected);
      
    
        //
        // Rule 37:  KeyWord ::= p u b l i c
        //

        keywordKind[37] = (JavaParsersym.TK_public);
      
    
        //
        // Rule 38:  KeyWord ::= r e t u r n
        //

        keywordKind[38] = (JavaParsersym.TK_return);
      
    
        //
        // Rule 39:  KeyWord ::= s h o r t
        //

        keywordKind[39] = (JavaParsersym.TK_short);
      
    
        //
        // Rule 40:  KeyWord ::= s t a t i c
        //

        keywordKind[40] = (JavaParsersym.TK_static);
      
    
        //
        // Rule 41:  KeyWord ::= s t r i c t f p
        //

        keywordKind[41] = (JavaParsersym.TK_strictfp);
      
    
        //
        // Rule 42:  KeyWord ::= s u p e r
        //

        keywordKind[42] = (JavaParsersym.TK_super);
      
    
        //
        // Rule 43:  KeyWord ::= s w i t c h
        //

        keywordKind[43] = (JavaParsersym.TK_switch);
      
    
        //
        // Rule 44:  KeyWord ::= s y n c h r o n i z e d
        //

        keywordKind[44] = (JavaParsersym.TK_synchronized);
      
    
        //
        // Rule 45:  KeyWord ::= t h i s
        //

        keywordKind[45] = (JavaParsersym.TK_this);
      
    
        //
        // Rule 46:  KeyWord ::= t h r o w
        //

        keywordKind[46] = (JavaParsersym.TK_throw);
      
    
        //
        // Rule 47:  KeyWord ::= t h r o w s
        //

        keywordKind[47] = (JavaParsersym.TK_throws);
      
    
        //
        // Rule 48:  KeyWord ::= t r a n s i e n t
        //

        keywordKind[48] = (JavaParsersym.TK_transient);
      
    
        //
        // Rule 49:  KeyWord ::= t r u e
        //

        keywordKind[49] = (JavaParsersym.TK_true);
      
    
        //
        // Rule 50:  KeyWord ::= t r y
        //

        keywordKind[50] = (JavaParsersym.TK_try);
      
    
        //
        // Rule 51:  KeyWord ::= v o i d
        //

        keywordKind[51] = (JavaParsersym.TK_void);
      
    
        //
        // Rule 52:  KeyWord ::= v o l a t i l e
        //

        keywordKind[52] = (JavaParsersym.TK_volatile);
      
    
        //
        // Rule 53:  KeyWord ::= w h i l e
        //

        keywordKind[53] = (JavaParsersym.TK_while);
      
    
        //
        // Rule 54:  KeyWord ::= $ bB eE gG iI nN aA cC tT iI oO nN
        //

        keywordKind[54] = (JavaParsersym.TK_BeginAction);
      
    
        //
        // Rule 55:  KeyWord ::= $ bB eE gG iI nN jJ aA vV aA
        //

        keywordKind[55] = (JavaParsersym.TK_BeginJava);
      
    
        //
        // Rule 56:  KeyWord ::= $ eE nN dD aA cC tT iI oO nN
        //

        keywordKind[56] = (JavaParsersym.TK_EndAction);
      
    
        //
        // Rule 57:  KeyWord ::= $ eE nN dD jJ aA vV aA
        //

        keywordKind[57] = (JavaParsersym.TK_EndJava);
      
    
        //
        // Rule 58:  KeyWord ::= $ nN oO aA cC tT iI oO nN
        //

        keywordKind[58] = (JavaParsersym.TK_NoAction);
      
    
        //
        // Rule 59:  KeyWord ::= $ nN uU lL lL aA cC tT iI oO nN
        //

        keywordKind[59] = (JavaParsersym.TK_NullAction);
      
    
        //
        // Rule 60:  KeyWord ::= $ bB aA dD aA cC tT iI oO nN
        //

        keywordKind[60] = (JavaParsersym.TK_BadAction);
      
    
    //#line 118 "KeywordTemplateF.gi

        for (var i = 0; i < keywordKind.length; i++)
        {
            if (keywordKind[i] == 0)
                keywordKind[i] = identifierKind;
        }
    }
}

