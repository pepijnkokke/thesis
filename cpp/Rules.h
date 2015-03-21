/*****************************
 * Jeroen Bransen            *
 * Jeroen.Bransen@phil.uu.nl *
 * Master's Thesis           *
 * Utrecht University        *
 * May 2010                  *
 *****************************/
#ifndef RULES_H
#define RULES_H

#include "Settings.h"
#include "Representation.h"
#include <vector>

using namespace std;

/* For shorter notation of the rules */
#define TWOWAY_RULE(name1, name2, latexName1, latexName2, premisse, conclusion) \
    rules.push_back(new Rule(name1, latexName1, premisse, conclusion));\
    rules.push_back(new Rule(name2, latexName2, conclusion, premisse));

/* List of mapping from string to binary connectives */
vector<Rule*> createRules()
{
    vector<Rule*> rules;

    /* Axioms */
    rules.push_back(new Rule("ax⁻", "",
        new Sequent(new Formula('*', CHECK_NEGATIVE), new Structure(new Formula('*', CHECK_NEGATIVE)))));
    rules.push_back(new Rule("ax⁺", "",
        new Sequent(new Structure(new Formula('*', CHECK_POSITIVE)), new Formula('*', CHECK_POSITIVE))));

    /* Focus left */
    rules.push_back(new Rule("↽", "\\leftharpoondown",
        new Sequent(              new Formula('A', CHECK_POSITIVE) , new Structure('X')),
        new Sequent(new Structure(new Formula('A', CHECK_POSITIVE)), new Structure('X'))));

    /* Focus right */
    rules.push_back(new Rule("⇁", "\\rightharpoondown",
        new Sequent(new Structure('X'),               new Formula('A', CHECK_NEGATIVE) ),
        new Sequent(new Structure('X'), new Structure(new Formula('A', CHECK_NEGATIVE)))));

    /* Defocus left */
    rules.push_back(new Rule("↼", "\\leftharpoonup",
        new Sequent(new Structure(new Formula('A', CHECK_NEGATIVE)), new Structure('X')),
        new Sequent(              new Formula('A', CHECK_NEGATIVE) , new Structure('X'))));

    /* Defocus right */
    rules.push_back(new Rule("⇀", "\\rightharpoonup",
        new Sequent(new Structure('X'), new Structure(new Formula('A', CHECK_POSITIVE))),
        new Sequent(new Structure('X'),               new Formula('A', CHECK_POSITIVE) )));


    /* ₁ᴿ */
    rules.push_back(new Rule("₁ᴿ", "_1^R",
        new Sequent(new Structure(ONE, new Structure('Y')), new Formula(ONE, new Formula  ('A'))),
        new Sequent(                   new Formula  ('A') ,                  new Structure('Y'))));
    /* ₁ᴸ */
    rules.push_back(new Rule("₁ᴸ", "_1^L",
        new Sequent(new Structure(new Formula(ONE,               new Formula('A'))), new Structure('Y')),
        new Sequent(new Structure(            ONE, new Structure(new Formula('A'))), new Structure('Y'))));
    /* ¹ᴸ */
    rules.push_back(new Rule("¹ᴸ", "^{1L}",
        new Sequent(new Structure(new Formula  (new Formula('A') , ONE)), new Structure('Y')),
        new Sequent(new Structure(new Structure(new Formula('A')), ONE) , new Structure('Y'))));
    /* ¹ᴿ */
    rules.push_back(new Rule("¹ᴿ", "^{1R}",
        new Sequent(new Structure(new Structure('Y'), ONE), new Formula(new Formula  ('A'), ONE)),
        new Sequent(              new Formula  ('A')      ,             new Structure('Y')      )));
    /* r¹₁ , r₁¹ */
    TWOWAY_RULE("r¹₁", "r₁¹", "r^1\\vphantom{}_1", "r_1\\vphantom{}^1",
        new Sequent(new Structure(ONE, new Structure('Y')), new Structure('X')),
        new Sequent(new Structure(new Structure('X'), ONE), new Structure('Y')));


    /* ₀ᴸ */
    rules.push_back(new Rule("₀ᴸ", "_0^L",
        new Sequent(new Formula(ZERO, new Formula  ('A')), new Structure(ZERO, new Structure('X'))),
        new Sequent(                  new Structure('X') ,                     new Formula  ('A'))));
    /* ₀ᴿ */
    rules.push_back(new Rule("₀ᴿ", "_0^R",
        new Sequent(new Structure('X'), new Structure(            ZERO, new Structure(new Formula('A')))),
        new Sequent(new Structure('X'), new Structure(new Formula(ZERO,               new Formula('A'))))));
    /* ⁰ᴸ */
    rules.push_back(new Rule("⁰ᴸ", "^{0L}",
        new Sequent(new Formula(new Formula  ('A'), ZERO), new Structure(new Structure('X'), ZERO)),
        new Sequent(            new Structure('X')       ,               new Formula  ('A'))));
    /* ⁰ᴿ */
    rules.push_back(new Rule("⁰ᴿ", "^{0R}",
        new Sequent(new Structure('X'), new Structure(new Formula  (new Formula('A') , ZERO))),
        new Sequent(new Structure('X'), new Structure(new Structure(new Formula('A')), ZERO))));
    /* r⁰₀ , r₀⁰ */
    TWOWAY_RULE("r⁰₀", "r₀⁰", "r^0\\vphantom{}_0", "r_0\\vphantom{}^0",
        new Sequent(new Structure('Y'), new Structure(ZERO, new Structure('X'))),
        new Sequent(new Structure('X'), new Structure(new Structure('Y'), ZERO)));


    /* ◇ᴸ */
    rules.push_back(new Rule("◇ᴸ", "\\Diamond^L",
        new Sequent(new Structure(new Formula(DIAMOND,               new Formula('A'))), new Structure('Y')),
        new Sequent(new Structure(            DIAMOND, new Structure(new Formula('A'))), new Structure('Y'))));
    /* ◇ᴿ */
    rules.push_back(new Rule("◇ᴿ", "\\Diamond^R",
        new Sequent(new Structure(DIAMOND, new Structure('X')), new Formula(DIAMOND, new Formula('B'))),
        new Sequent(                       new Structure('X') ,                      new Formula('B') )));
    /* □ᴸ */
    rules.push_back(new Rule("□ᴸ", "\\Box^L",
        new Sequent(new Formula(BOX, new Formula('A')), new Structure(BOX, new Structure('Y'))),
        new Sequent(                 new Formula('A') ,                    new Structure('Y') )));
    /* □ᴿ */
    rules.push_back(new Rule("□ᴿ", "\\Box^R",
        new Sequent(new Structure('X'), new Structure(new Formula(BOX,               new Formula('A')))),
        new Sequent(new Structure('X'), new Structure(            BOX, new Structure(new Formula('A'))))));
    /* r□◇ , r◇□ */
    //TWOWAY_RULE("r□◇", "r◇□", "r \\Box \\Diamond", "r \\Diamond \\Box",
    //    new Sequent(new Structure(DIAMOND, new Structure('X')),                    new Structure('Y') ),
    //    new Sequent(                       new Structure('X') , new Structure(BOX, new Structure('Y'))));

    /* ⊗ᴸ */
    rules.push_back(new Rule("⊗ᴸ", "\\otimes^L",
        new Sequent(
            new Structure(new Formula(new Formula('A'), OTIMES, new Formula('B'))),
            new Structure('Y')),
        new Sequent(
            new Structure(new Structure(new Formula('A')), OTIMES, new Structure(new Formula('B'))),
            new Structure('Y'))));
    /* ⊗ᴿ */
    rules.push_back(new Rule("⊗ᴿ", "\\Rrightarrow^R",
        new Sequent(
            new Structure(new Structure('X'), OTIMES, new Structure('Y')),
            new Formula  (new Formula  ('A'), OTIMES, new Formula  ('B'))),
        new Sequent(new Structure('X'), new Formula('A')),
        new Sequent(new Structure('Y'), new Formula('B'))));
    /* ⇒ᴸ */
    rules.push_back(new Rule("⇒ᴸ", "\\Rightarrow^L",
        new Sequent(
            new Formula  (new Formula  ('A'), BACKSLASH, new Formula  ('B')),
            new Structure(new Structure('X'), BACKSLASH, new Structure('Y'))),
        new Sequent(new Structure('X'), new Formula  ('A')),
        new Sequent(new Formula  ('B'), new Structure('Y'))));
    /* ⇒ᴿ */
    rules.push_back(new Rule("⇒ᴿ", "\\Rightarrow^R",
        new Sequent(
            new Structure('X'),
            new Structure(new Formula(new Formula('A'), BACKSLASH, new Formula('B')))),
        new Sequent(
            new Structure('X'),
            new Structure(new Structure(new Formula('A')), BACKSLASH, new Structure(new Formula('B'))))));
    /* ⇐ᴸ */
    rules.push_back(new Rule("⇐ᴸ", "\\Leftarrow^L",
        new Sequent(
            new Formula  (new Formula  ('B'), SLASH, new Formula  ('A')),
            new Structure(new Structure('Y'), SLASH, new Structure('X'))),
        new Sequent(new Structure('X'), new Formula  ('A')),
        new Sequent(new Formula  ('B'), new Structure('Y'))));
    /* ⇐ᴿ */
    rules.push_back(new Rule("⇐ᴿ", "\\Leftarrow^R",
        new Sequent(
            new Structure('X'),
            new Structure(new Formula(new Formula('B'), SLASH, new Formula('A')))),
        new Sequent(
            new Structure('X'),
            new Structure(new Structure(new Formula('B')), SLASH, new Structure(new Formula('A'))))));
    /* r⇐⊗ , r⊗⇐ */
    TWOWAY_RULE("r⇐⊗", "r⊗⇐", "r \\Leftarrow \\otimes", "r \\otimes \\Leftarrow",
        new Sequent(new Structure(new Structure('X'), OTIMES, new Structure('Y')), new Structure('P')),
        new Sequent(new Structure('X'), new Structure(new Structure('P'), SLASH, new Structure('Y'))));
    /* r⇒⊗ , r⊗⇒ */
    TWOWAY_RULE("r⇒⊗", "r⊗⇒", "r \\Rightarrow \\otimes", "r \\otimes \\Rightarrow",
        new Sequent(new Structure(new Structure('X'), OTIMES, new Structure('Y')), new Structure('P')),
        new Sequent(new Structure('Y'), new Structure(new Structure('X'), BACKSLASH, new Structure('P'))));


    /* ⊕ᴸ */
    rules.push_back(new Rule("⊕ᴸ", "\\oplus^L",
        new Sequent(
            new Formula  (new Formula  ('B'), OPLUS, new Formula  ('A')),
            new Structure(new Structure('Y'), OPLUS, new Structure('X'))),
        new Sequent(new Formula('B'), new Structure('Y')),
        new Sequent(new Formula('A'), new Structure('X'))));
    /* ⊕ᴿ */
    rules.push_back(new Rule("⊕ᴿ", "\\oplus^R",
        new Sequent(
            new Structure('X'),
            new Structure(new Formula(new Formula('B'), OPLUS, new Formula('A')))),
        new Sequent(
            new Structure('X'),
            new Structure(new Structure(new Formula('B')), OPLUS, new Structure(new Formula('A'))))));
    /* ⇚ᴸ */
    rules.push_back(new Rule("⇚ᴸ", "\\Lleftarrow^L",
        new Sequent(
            new Structure(new Formula(new Formula('A'), OSLASH, new Formula('B'))),
            new Structure('Y')),
        new Sequent(
            new Structure(new Structure(new Formula('A')), OSLASH, new Structure(new Formula('B'))),
            new Structure('Y'))));
    /* ⇛ᴸ */
    rules.push_back(new Rule("⇛ᴸ", "\\Rrightarrow^L",
        new Sequent(
            new Structure(new Formula(new Formula('B'), OBACKSLASH, new Formula('A'))),
            new Structure('X')),
        new Sequent(
            new Structure(new Structure(new Formula('B')), OBACKSLASH, new Structure(new Formula('A'))),
            new Structure('X'))));
    /* ⇚ᴿ */
    rules.push_back(new Rule("⇚ᴿ", "\\Lleftarrow^R",
        new Sequent(
            new Structure(new Structure('X'), OSLASH, new Structure('Y')),
            new Formula  (new Formula  ('A'), OSLASH, new Formula  ('B'))),
        new Sequent(new Structure('X'), new Formula  ('A')),
        new Sequent(new Formula  ('B'), new Structure('Y'))));
    /* ⇛ᴿ */
    rules.push_back(new Rule("⇛ᴿ", "\\Rrightarrow^R",
        new Sequent(
            new Structure(new Structure('Y'), OBACKSLASH, new Structure('X')),
            new Formula  (new Formula  ('B'), OBACKSLASH, new Formula  ('A'))),
        new Sequent(new Structure('X'), new Formula  ('A')),
        new Sequent(new Formula  ('B'), new Structure('Y'))));
    /* r⇚⊕ , r⊕⇚ */
    TWOWAY_RULE("r⇚⊕", "r⊕⇚", "r \\Lleftarrow \\oplus", "r \\oplus \\Lleftarrow",
        new Sequent(new Structure('X'), new Structure(new Structure('P'), OPLUS, new Structure('Q'))),
        new Sequent(new Structure(new Structure('X'), OSLASH, new Structure('Q')), new Structure('P')));
    /* r⇛⊕ , r⊕⇛ */
    TWOWAY_RULE("r⇛⊕", "r⊕⇛", "r \\Rrightarrow \\oplus", "r \\oplus \\Rrightarrow",
        new Sequent(new Structure('X'), new Structure(new Structure('P'), OPLUS, new Structure('Q'))),
        new Sequent(new Structure(new Structure('P'), OBACKSLASH, new Structure('X')), new Structure('Q')));


    /* Grishin interaction principles */
    rules.push_back(new Rule("d⇚⇐", "d \\Lleftarrow \\Leftarrow",
        new Sequent(new Structure(new Structure('X'), OSLASH, new Structure('Q')), new Structure(new Structure('P'), SLASH, new Structure('Y'))),
        new Sequent(new Structure(new Structure('X'), OTIMES, new Structure('Y')), new Structure(new Structure('P'), OPLUS, new Structure('Q')))));
    rules.push_back(new Rule("d⇚⇒", "d \\Lleftarrow \\Rightarrow",
        new Sequent(new Structure(new Structure('Y'), OSLASH, new Structure('Q')), new Structure(new Structure('X'), BACKSLASH, new Structure('P'))),
        new Sequent(new Structure(new Structure('X'), OTIMES, new Structure('Y')), new Structure(new Structure('P'), OPLUS, new Structure('Q')))));
    rules.push_back(new Rule("d⇛⇐", "d \\Rrightarrow \\Leftarrow",
        new Sequent(new Structure(new Structure('P'), OBACKSLASH, new Structure('X')), new Structure(new Structure('Q'), SLASH, new Structure('Y'))),
        new Sequent(new Structure(new Structure('X'), OTIMES, new Structure('Y')), new Structure(new Structure('P'), OPLUS, new Structure('Q')))));
    rules.push_back(new Rule("d⇛⇒", "d \\Rrightarrow \\Rightarrow",
        new Sequent(new Structure(new Structure('P'), OBACKSLASH, new Structure('Y')), new Structure(new Structure('X'), BACKSLASH, new Structure('Q'))),
        new Sequent(new Structure(new Structure('X'), OTIMES, new Structure('Y')), new Structure(new Structure('P'), OPLUS, new Structure('Q')))));

    return rules;
}
vector<Rule*> allRules = createRules();

#endif