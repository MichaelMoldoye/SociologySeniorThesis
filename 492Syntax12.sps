* Encoding: UTF-8.
GET
  FILE='U:\SOC492\ZA5500_v2-0-0 - Copy.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

******Make WPE scale based on 12a/b/c (V29, V30. V31).
***WEP = Willingness to Protect the Environment.
Recode v29 v30 v31 (1=5)(2=4)(3=3)(4=2)(5=1)(else=9) into will1 will2 will3.
Missing Values will1 will2 will3 (9).
FORMATS    will1 will2 will3 (f2).
RELIABILITY  /VARIABLES=will1 will2 will3
   /SCALE('ALL VARIABLES') ALL  /MODEL=ALPHA.
Compute WPE=Sum.3(will1, will2, will3).
Compute WPE2 = ((Sum.3(will1, will2, will3))-3)/12.
DESCRIPTIVES VARIABLES=WPE WPE2
  /STATISTICS=MEAN STDDEV VARIANCE MIN MAX.

******Make standardized PEB scales based on 20a-22c (V55-V64).
***PEB = Pro-Environmental Behavior.
FACTOR
  /VARIABLES V55 V56 V57 V58 V59 V60 V61 V62 V63 V64
  /MISSING LISTWISE 
  /ANALYSIS  V55 V56 V57 V58 V59 V60 V61 V62 V63 V64
  /PRINT INITIAL EXTRACTION ROTATION
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.

RECODE    V55 V56 V57 V58 V59 V60 (1=4)(2=3)(3=2)(4=1)(else=9) into 
     P1 P2 P3 P4 P5 P6.
missing values  P1 P2 P3 P4 P5 P6 (9). 
RECODE    V61 V62 V63 V64 (1 = 1)(2 = 0)(else=9) into PEB7 PEB8 PEB9 PEB10.
MISSING VALUES    PEB7 PEB8 PEB9 PEB10 (9).
VALUE LABELS    PEB7 PEB8 PEB9 PEB10  0 'No' 1 'Yes'.
FORMATS    PEB7 PEB8 PEB9 PEB10 (f2).
compute pscale6=sum.6( P1, P2, P3, P4, P5, P6).
compute pscale4=sum.4( PEB7, PEB8, PEB9, PEB10).
compute pscale10=sum.10( P1, P2, P3, P4, P5, P6, PEB7, PEB8, PEB9, PEB10).

descriptives vars=P1 P2 P3 P4 P5 P6 PEB7 PEB8 PEB9 PEB10/save.
compute zpscale6=sum.6( ZP1, ZP2, ZP3, ZP4, ZP5, ZP6).
compute zpscale4=sum.4( ZPEB7, ZPEB8, ZPEB9, ZPEB10).
compute zpscale10=sum.10( ZP1, ZP2, ZP3, ZP4, ZP5, ZP6, ZPEB7, ZPEB8, ZPEB9, ZPEB10).
RELIABILITY  /VARIABLES=ZP1 ZP2 ZP3 ZP4 ZP5 ZP6
   /SCALE('ALL VARIABLES') ALL  /MODEL=ALPHA  /SUMMARY=TOTAL.
RELIABILITY  /VARIABLES= zPEB7 zPEB8 zPEB9 zPEB10
  /SCALE('ALL VARIABLES') ALL /MODEL=ALPHA /SUMMARY=TOTAL.
RELIABILITY  /VARIABLES= ZP1 ZP2 ZP3 ZP4 ZP5 ZP6 zPEB7 zPEB8 zPEB9 zPEB10
  /SCALE('ALL VARIABLES') ALL /MODEL=ALPHA /SUMMARY=TOTAL.

correlation wpe2 with zpscale6 zpscale4 zpscale10.

FACTOR
  /VARIABLES ZP1 ZP2 ZP3 ZP4 ZP5 ZP6 ZPEB7 ZPEB8 ZPEB9 ZPEB10
  /MISSING LISTWISE 
  /ANALYSIS ZP1 ZP2 ZP3 ZP4 ZP5 ZP6 ZPEB7 ZPEB8 ZPEB9 ZPEB10
  /PRINT INITIAL EXTRACTION
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /ROTATION NOROTATE
  /SAVE REG(ALL)
  /METHOD=CORRELATION.
FACTOR
  /VARIABLES ZP1 ZP2 ZP3 ZP4 ZP5 ZP6 
  /MISSING LISTWISE 
  /ANALYSIS ZP1 ZP2 ZP3 ZP4 ZP5 ZP6 
  /PRINT INITIAL EXTRACTION
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /ROTATION NOROTATE
  /SAVE REG(ALL)
  /METHOD=CORRELATION.
FACTOR
  /VARIABLES  ZPEB7 ZPEB8 ZPEB9 ZPEB10
  /MISSING LISTWISE 
  /ANALYSIS ZPEB7 ZPEB8 ZPEB9 ZPEB10
  /PRINT INITIAL EXTRACTION
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /ROTATION NOROTATE
  /SAVE REG(ALL)
  /METHOD=CORRELATION.

* factor 6 loadings    .56 .625 .702 .776 .720 .766 .
do repeat x=ZP1 ZP2 ZP3 ZP4 ZP5 ZP6/y=fZP1 fZP2 fZP3 fZP4 fZP5 fZP6
    /z=.56 .625 .702 .776 .720 .766 .
compute y=x*z.
end repeat.
RELIABILITY /VARIABLES= fZP1 fZP2 fZP3 fZP4 fZP5 fZP6
  /SCALE('ALL VARIABLES') ALL /MODEL=ALPHA /SUMMARY=TOTAL.
compute fzpscale6=sum.6(fZP1, fZP2, fZP3, fZP4, fZP5, fZP6).

* factor 4 loadings   .667 .715  .719 .594 .
do repeat x= ZPEB7 ZPEB8 ZPEB9 ZPEB10/y=fZPEB7 fZPEB8 fZPEB9 fZPEB10
    /z=.667 .715 .719 .594 .
compute y=x*z.
end repeat.
RELIABILITY /VARIABLES= fZPEB7 fZPEB8 fZPEB9 fZPEB10
  /SCALE('ALL VARIABLES') ALL /MODEL=ALPHA /SUMMARY=TOTAL.
compute fzpscale4=sum.4(fZPEB7, fZPEB8, fZPEB9, fZPEB10).

correlation wpe2 with fzpscale6 zpscale6 fzpscale4 zpscale4 zpscale10.

******Make PDE scale based on 14a-14g (V39-V45).
***PDE = Perceived Danger to Environment.
Recode v39 v40 v41 v42 v43 v44 v45 (1=5)(2=4)(3=3)(4=2)(5=1)(else=9) into
pde1 pde2 pde3 pde4 pde5 pde6 pde7.
MISSING VALUES  pde1 pde2 pde3 pde4 pde5 pde6 pde7  (9).
FORMATS   pde1 pde2 pde3 pde4 pde5 pde6 pde7  (f2).
Compute PDEscale=Sum.7(pde1, pde2, pde3, pde4, pde5, pde6, pde7).
descriptives vars=pde1 pde2 pde3 pde4 pde5 pde6 pde7/save.
RELIABILITY  /VARIABLES=zpde1 zpde2 zpde3 zpde4 zpde5 zpde6 zpde7
   /SCALE('ALL VARIABLES') ALL  /MODEL=ALPHA.
Compute zPDEscale=Sum.7(zpde1, zpde2, zpde3, zpde4, zpde5, zpde6, zpde7).

****** Recodes of other demographic and control variables.

***Recode v13, Trust in Govt:
To what extent do you agree or disagree with the following statements:
"Most of the time we can trust people in government to do what is right.".
Freq v13.
Recode v13 (1=5)(2=4)(3=3)(4=2)(5=1)(else=9) into trustgov.
Missing Values trustgov (9).
FORMATS    trustgov (f2).

***Recode for Male.
RECODE    sex (1 = 1)(2 = 0)(else=9) into male.
MISSING VALUES    male (9).
VALUE LABELS    male 1 'Male' 0 'Female'.
formats male (f2).

***Recodes for right-leaning political orientation.
freq PARTY_LR.
RECODE    PARTY_LR (4,5=1)(1,2,3,6,7=0)(else=9) into polright.
MISSING VALUES    polright (9).
VALUE LABELS    polright 1 'Right' 0 'Not Right'.
formats polright (f2).
freq polright.

***Recode for Number of Years of Education
*Provides conservative year estimates for most repondents who declared degrees yet did not report years of educ.
freq educyrs degree.
recode educyrs (21 thru 70 = 20) (95,96=97)(else=copy) into xeduc.
missing values xeduc (97,98,99).
freq xeduc.
do repeat x=0 5 8 12 14 16/y=0 to 5.
if (degree=y) xdeg=x.
end repeat.
freq xdeg.
do if (not(missing(xeduc))).
compute zeduc=xeduc.
else if (missing(xeduc)).
compute zeduc=xdeg.
end if.
freq zeduc.
RECODE     educyrs (95,96 = 99).
DESCRIPTIVES VARIABLES=educyrs zeduc
  /STATISTICS=MEAN STDDEV MIN MAX.

***Recode for Married.
freq marital.
RECODE    marital (1=1)(2 thru 6 = 0)(else=9) into xmar.
MISSING VALUES    xmar (9).
FORMATS    xmar (f2).
freq xmar.

***Recode for Catholic.
freq religgrp.
Recode religgrp (1=1)(0,2 thru 10 = 0)(else=99) into xrelig.
MISSING VALUES    xrelig (99).
FORMATS    xrelig (f2).
Freq xrelig.

***Recode for Urban.
freq urbrural.
Recode urbrural (1=1)(2 thru 5 = 0)(else=9) into xurban.
MISSING VALUES    xurban (9).
FORMATS    xurban (f2).
Freq xurban.

***Recode for Working.
freq mainstat.
Recode mainstat (1=1)(2 thru 10 = 0) (else=99) into xwork.
MISSING VALUES    xwork (99).
Formats xwork (f2).
freq xwork.

***Recode for Non-Manual Labor.
recode isco88 (110 thru 3999 = 1) (4000 thru 9333 = 0) (else=9) into nonman.
MISSING VALUES    nonman (9).
Formats nonman (f2).
freq nonman.

***Recode age, setting everyone older than 89 to 89.
Recode age (90 thru 99 = 89).
freq age.

correlation wpe2 with fzpscale6 zpscale6 fzpscale4 zpscale4 zpscale10 zpdescale age male nonman xwork 
xurban xrelig xmar zeduc polright trustgov.

compute pscale62=((sum.6( P1, P2, P3, P4, P5, P6))-6)/3.
Compute PDEscale2=((Sum.7(pde1, pde2, pde3, pde4, pde5, pde6, pde7))-7)/7.
DESCRIPTIVES VARIABLES= wpe2 pscale4 pscale6 pscale62 PDEscale PDEscale2  
  /STATISTICS=MEAN STDDEV MIN MAX.

***Descriptives: 4 countries together - excluding Japan, including "xmar".
compute cc2=0.
if (any(v4,276,578,826,840)) cc2=1.
TEMPORARY.
select if (cc2=1).
DESCRIPTIVES VARIABLES= wpe2 pscale4 pscale62 PDEscale2 trustgov male age xmar
zeduc xrelig polright nonman xwork xurban  
  /STATISTICS=MEAN STDDEV MIN MAX.

***Comparing variable means between the 4 countries.
TEMPORARY.
select if (cc2=1).
ONEWAY WPE2 pscale4 pscale62 PDEscale2 trustgov male AGE xmar zeduc xrelig polright nonman 
    xwork xurban BY V4
  /STATISTICS DESCRIPTIVES 
  /PLOT MEANS
  /MISSING ANALYSIS
  /POSTHOC=LSD ALPHA(0.05).

***Regression: WPE2.
compute cc2=0.
if (any(v4,276,578,826,840)) cc2=1.
TEMPORARY.
select if (cc2=1).
SPLIT FILE BY V4.
REGRESSION  /MISSING LISTWISE  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)  /NOORIGIN 
  /DEPENDENT WPE2  /METHOD=ENTER  fzpscale4 fzpscale6 zPDEscale trustgov male age xmar zeduc
xrelig polright nonman xwork xurban .
SPLIT FILE OFF.

-----------------------------------------------------------------------------------------------------------------

descriptives vars=will1 will2 will3/save.
RELIABILITY  /VARIABLES=zwill1 zwill2 zwill3
   /SCALE('ALL VARIABLES') ALL  /MODEL=ALPHA  /SUMMARY=TOTAL.
compute zWPE=sum.3( zwill1, zwill2, zwill3).
DESCRIPTIVES VARIABLES=zWPE
  /STATISTICS=MEAN STDDEV VARIANCE MIN MAX.

***Regression: zWPE.
SPLIT FILE BY V4.
REGRESSION  /MISSING LISTWISE  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)  /NOORIGIN 
  /DEPENDENT zWPE  /METHOD=ENTER  fzpscale4 fzpscale6 zPDEscale male trustgov
polright zeduc xmar xrelig xurban age xwork.
SPLIT FILE OFF.

***Descriptives: 5 countries - including Japan, excluding "xmar".
compute cc=0.
if (any(v4,276,392,578,826,840)) cc=1.
TEMPORARY.
select if (cc=1).
SPLIT FILE BY V4.
DESCRIPTIVES VARIABLES= wpe2 pscale4 pscale62 pscale102 PDEscale2 male age trustgov
zeduc xrelig polright  xurban xwork
  /STATISTICS=MEAN STDDEV MIN MAX.
SPLIT FILE    OFF.

compute cc3=0.
if (any(v4,826)) cc3=1.
TEMPORARY.
select if (cc3=1).
freq topbot.

RECODE    V55 V56 V57 V58 V59 V60 (1,2 = 1)(3,4 = 0)(else=9) into 
PEB1 PEB2 PEB3 PEB4 PEB5 PEB6.
MISSING VALUES   PEB1 PEB2 PEB3 PEB4 PEB5 PEB6 (9).
VALUE LABELS    PEB1 PEB2 PEB3 PEB4 PEB5 PEB6
0 'Less Often / Never' 1 'More Often / Always'.
FORMATS    PEB1 PEB2 PEB3 PEB4 PEB5 PEB6 (f2).

RECODE    PARTY_LR (7 = 0)(1 thru 6 = 1)(else=9) into PolParty.
MISSING VALUES    PolParty (9).
VALUE LABELS    PolParty 0 'No Party Affiliation' 1 'Party Affiliation'.
formats PolParty (f2).
freq PolParty.
