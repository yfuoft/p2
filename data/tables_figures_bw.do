********************************************************************************
********************************************************************************
*** Beaudry & Willems ("On the macroeconomic consequences of over-optimism") ***
********************************************************************************
********************************************************************************

use data_bw, clear
set matsize 10000
set more off
ssc install xtivreg2 //this line can be dropped in case xtivreg2 is pre-installed 
xtset ifscode year 

********************************************************************************
*********************************** FIGURE 1 ***********************************
************* Kernel density plot for forecast error variable F_3 **************
********************************************************************************
********************************************************************************

twoway histogram yr3_fe, color(*.5) || kdensity yr3_fe

********************************************************************************
*********************************** TABLE 1 ************************************
************** Estimating IMF Mission Chief fixed effects ("mu") ***************
********************************************************************************
********************************************************************************

*With Mission Chief fixed effects 
xtreg yr1_fe i.year imf_prog rgdpch dummy_*, fe vce(robust)
*outreg2 using Table1.xls, addstat(Adjusted R-squared, e(r2_a)) ctitle(with mc fe)

*Without Mission Chief fixed effects (estimated on the same sample as the regression with MC fixed effects)
xtreg yr1_fe i.year imf_prog rgdpch if e(sample)==1, fe vce(robust)
*outreg2 using Table1.xls, addstat(Adjusted R-squared, e(r2_a)) ctitle(no mc fe)

********************************************************************************
*********************************** FIGURE 3 ***********************************
********* Kernel density plot for Mission Chief fixed effects ("mu") ***********
********************************************************************************
********************************************************************************

twoway histogram mu, color(*.5) || kdensity mu

********************************************************************************
*********************************** TABLE 2 ************************************
******************* Instrumenting by MC fixed effects ("mu") *******************
********************************************************************************
********************************************************************************

*Column 1: Full sample, without covariates
xtivreg2 rgdp_gr d_19* d_20* (yr3_fe=L3.mu), fe first robust
*Column 2: Full sample, with covariates
xtivreg2 rgdp_gr tp_growth_3yavg ttt_growth_3yavg d_19* d_20* (yr3_fe=L3.mu), fe first robust
*Column 3: EME/DEV only, without covars
xtivreg2 rgdp_gr d_19* d_20* (yr3_fe=L3.mu) if adv==0, fe first robust
*Column 4: EME/DEV only, with covars
xtivreg2 rgdp_gr tp_growth_3yavg ttt_growth_3yavg d_19* d_20* (yr3_fe=L3.mu) if adv==0, fe first robust
*Column 5: ADV only, without covars
xtivreg2 rgdp_gr d_19* d_20* (yr3_fe=L3.mu) if adv==1, fe first robust
*Column 6: ADV only, with covars
xtivreg2 rgdp_gr tp_growth_3yavg ttt_growth_3yavg d_19* d_20* (yr3_fe=L3.mu) if adv==1, fe first robust

********************************************************************************
*********************************** TABLE 3 ************************************
*** Instrumenting by MC fixed effects ("mu") and oil-price instrument ("z") ****
********************************************************************************
********************************************************************************

*Column 1: Full sample, without covariates
xtivreg2 rgdp_gr d_19* d_20* (yr3_fe=L3.mu L3.z), fe first robust
*Column 2: Full sample, with covariates
xtivreg2 rgdp_gr tp_growth_3yavg ttt_growth_3yavg d_19* d_20* (yr3_fe=L3.mu L3.z), fe first robust
*Column 3: EME/DEV only, without covars
xtivreg2 rgdp_gr d_19* d_20* (yr3_fe=L3.mu L3.z) if adv==0, fe first robust
*Column 4: EME/DEV only, with covars
xtivreg2 rgdp_gr tp_growth_3yavg ttt_growth_3yavg d_19* d_20* (yr3_fe=L3.mu L3.z) if adv==0, fe first robust
*Column 5: ADV only, without covars
xtivreg2 rgdp_gr d_19* d_20* (yr3_fe=L3.mu L3.z) if adv==1, fe first robust
*Column 6: ADV only, with covars
xtivreg2 rgdp_gr tp_growth_3yavg ttt_growth_3yavg d_19* d_20* (yr3_fe=L3.mu L3.z) if adv==1, fe first robust

********************************************************************************
*********************************** TABLE 4 ************************************
*********** Analyzing the impact on the occurrence of various crises ***********
********************************************************************************
********************************************************************************

*Column 1: LHS = dummy capturing onset of fiscal crisis
ivprobit d_crisis_fiscal tp_growth_3yavg ttt_growth_3yavg (yr3_fe=L3.mu L3.z), vce(robust)
*Column 2: LHS = dummy capturing onset of fiscal crisis, controlling for the presence of a recession
ivprobit d_crisis_fiscal tp_growth_3yavg ttt_growth_3yavg d_recession (yr3_fe=L3.mu L3.z), vce(robust)
*Column 3: LHS = dummy capturing onset of banking/currency crisis
ivprobit d_crisis_bank_cur tp_growth_3yavg ttt_growth_3yavg (yr3_fe=L3.mu L3.z), vce(robust)
*Column 4: LHS = dummy capturing onset of banking/currency crisis, controlling for the presence of a recession
ivprobit d_crisis_bank_cur tp_growth_3yavg ttt_growth_3yavg d_recession (yr3_fe=L3.mu L3.z), vce(robust)
*Column 5: LHS = dummy capturing onset of IMF program
ivprobit d_imf_prog tp_growth_3yavg ttt_growth_3yavg (yr3_fe=L3.mu L3.z), vce(robust)
*Column 6: LHS = dummy capturing onset of IMF program, controlling for the presence of a recession
ivprobit d_imf_prog tp_growth_3yavg ttt_growth_3yavg d_recession (yr3_fe=L3.mu L3.z), vce(robust)

********************************************************************************
********************************** TABLE B1 ************************************
****** IV probit regression with a recession dummy as dependent variable *******
********************************************************************************
********************************************************************************

*Column 1: Full sample, without covars, one instrument
ivprobit d_recession (yr3_fe=L3.mu), vce(robust)
*Column 2: Full sample, with covars, one instrument
ivprobit d_recession tp_growth_3yavg ttt_growth_3yavg (yr3_fe=L3.mu), vce(robust)
*Column 3: Full sample, without covars, two instruments
ivprobit d_recession (yr3_fe=L3.mu L3.z), vce(robust)
*Column 4: Full sample, with covars, two instruments
ivprobit d_recession tp_growth_3yavg ttt_growth_3yavg (yr3_fe=L3.mu L3.z), vce(robust)

********************************************************************************
********************************** TABLE C2 ************************************
*********** OLS regressions when forecast error variable is lagged *************
********************************************************************************
********************************************************************************

*Column 1: k=3
xtreg rgdp_gr L3.yr3_fe i.year, fe vce(robust)
*Column 2: k=2
xtreg rgdp_gr L2.yr3_fe i.year, fe vce(robust) 
*Column 3: k=1
xtreg rgdp_gr L.yr3_fe i.year, fe vce(robust)

********************************************************************************
********************************** TABLE C3 ************************************
**** OLS regressions when forecast error variable is lagged, with covariates ***
********************************************************************************
********************************************************************************

*Column 1: k=3
xtreg rgdp_gr L3.yr3_fe tp_growth_3yavg ttt_growth_3yavg i.year, fe vce(robust)
*Column 2: k=2
xtreg rgdp_gr L2.yr3_fe tp_growth_3yavg ttt_growth_3yavg i.year, fe vce(robust)
*Column 3: k=1
xtreg rgdp_gr L.yr3_fe tp_growth_3yavg ttt_growth_3yavg i.year, fe vce(robust)
