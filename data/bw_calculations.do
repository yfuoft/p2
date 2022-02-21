* Christopher L. Gilbert
* Comment on Beaudry and Willems

use data_bw_rv, clear
log using "bw_calcs.smcl", replace

gen yr3_fc_rv = (L2.f1+L.f2+f3)/3
replace yr3_fe_rv = (L2.e1+L.e2+e3)/3
gen gav3 = ( L.rgdp_gr+L2.rgdp_gr+L3.rgdp_gr)/3
gen gav2 = ( L.rgdp_gr+L2.rgdp_gr)/2
gen g1 = L.rgdp_gr 

* Correlations
correl rgdp_gr rgdp_gr_rv yr1_fe e1 yr3_fe yr3_fe_rv

* Table 3, Column 1: Full sample, without covariates
* Three year ahead forecast errors
* Beaudry-Willems data
xtivreg2 rgdp_gr d_19* d_20* (yr3_fe=L3.mu L3.z), fe robust
estat ic
gen inBWeqn3 = e(sample)

* Revised
xtivreg2 rgdp_gr_rv d_19* d_20* (yr3_fe_rv= L3.mu L3.z) if inBWeqn3==1, fe robust
estat ic

* Disaggregated
xtivreg2 rgdp_gr_rv L.e2 L2.e1 d_19* d_20* (e3 = L3.mu L3.z) if inBWeqn3==1, fe robust
estat ic

* Just three year errors
xtivreg2 rgdp_gr_rv d_19* d_20* (e3 = L3.mu L3.z) if inBWeqn3==1, fe robust
estat ic

* Just two year errors
xtivreg2 rgdp_gr_rv d_19* d_20* (e2 = L3.mu L3.z) if inBWeqn3==1, fe robust
estat ic

* With additional instrument
xtivreg2 rgdp_gr_rv d_19* d_20* (e2 = L3.mu L3.z L2.e1) if inBWeqn3==1, fe robust
estat ic

* Growth autoregression
xtreg rgdp_gr L.rgdp_gr i.year, fe vce(robust)
estat ic

* Table C2, column 1
xtreg rgdp_gr gav3 L3.yr3_fe i.year, fe vce(robust)
estat ic
gen inBWeqnC1 = e(sample)

xtreg rgdp_gr L3.yr3_fe i.year if inBWeqnC1==1, fe vce(robust)
estat ic
xtivreg2 rgdp_gr L3.yr3_fe d_19* d_20* (gav3 = L3.rgdp_gr) if inBWeqnC1==1, fe 
estat ic


* Table C2, column 2
xtreg rgdp_gr gav2 L2.yr3_fe i.year, fe vce(robust) 
estat ic
gen inBWeqnC2 = e(sample)

xtreg rgdp_gr L2.yr3_fe i.year if inBWeqnC2==1, fe vce(robust)
estat ic

xtivreg2 rgdp_gr L2.yr3_fe d_19* d_20* (gav2 = L3.rgdp_gr) if inBWeqnC2==1, fe robust
estat ic


* Table C2, column 3
xtreg rgdp_gr L.rgdp_gr L.yr3_fe i.year, fe vce(robust) 
estat ic
gen inBWeqnC3 = e(sample)

xtreg rgdp_gr L.yr3_fe i.year if inBWeqnC3==1, fe vce(robust)
estat ic

xtivreg2 rgdp_gr L.yr3_fe d_19* d_20* (g1 = L3.rgdp_gr) if inBWeqnC3==1, fe robust
estat ic

* Granger-style causality analysis (2 lags)
xtreg rgdp_gr_rv L(1/2).rgdp_gr_rv L(1/2).e1, fe vce(robust)
test (L.e1 L2.e1)
xtreg rgdp_gr_rv L(1/2).rgdp_gr_rv L(1/2).f1, fe vce(robust)
test (L.f1 L2.f1)

xtreg rgdp_gr_rv L(1/2).rgdp_gr_rv L(1/2).e2, fe vce(robust)
test (L.e2 L2.e2)
xtreg rgdp_gr_rv L(1/2).rgdp_gr_rv L(1/2).f2, fe vce(robust)
test (L.f2 L2.f2)

xtreg rgdp_gr_rv L(1/2).rgdp_gr_rv L(1/2).e3, fe vce(robust)
test (L.e3 L2.e3)
xtreg rgdp_gr_rv L(1/2).rgdp_gr_rv L(1/2).f3, fe vce(robust)
test (L.f3 L2.f3)


* Granger-style causality analysis (1 lag)
xtreg rgdp_gr_rv L.rgdp_gr_rv L.e1, fe vce(robust)
test (L.e1)
xtreg rgdp_gr_rv L.rgdp_gr_rv L.f1, fe vce(robust)
test (L.f1)

xtreg rgdp_gr_rv L.rgdp_gr_rv L.e2, fe vce(robust)
test (L.e2)
xtreg rgdp_gr_rv L.rgdp_gr_rv L.f2, fe vce(robust)
test (L.f2)

xtreg rgdp_gr_rv L.rgdp_gr_rv L.e3, fe vce(robust)
test (L.e3)
xtreg rgdp_gr_rv L.rgdp_gr_rv L.f3, fe vce(robust)
test (L.f3)



log close
