/**PREDICTION OBS MLOGIT 機会構造制約**/
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/1.Dataconst.do"
cd "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/Results/Margins/Controlled"
keep redu year jobst1 statusx con fedu plv mark1mn mark3mn mark4mn cohort sex marev marevm age 
recode redu 1=0
recode jobst1 1=0
recode statusx 1=0
recode fedu 1=0
recode plv 2=0
drop if cohort ~=4
quietly logit marev year c.year##c.year i.redu i.statusx con i.plv i.fedu mark1mn mark3mn mark4mn i.redu##c.year i.redu##c.year##c.year 
quietly estpost margins redu , at(year=(1(1)25) (means) mark1mn mark3mn mark4mn) 
quietly esttab . using cohort4_disc_const_revise.csv, replace r(b) label wide nostar
quietly mlogit marevm year c.year##c.year i.redu i.statusx con i.fedu i.plv mark1mn  mark3mn mark4mn i.redu##c.year i.redu##c.c.year##c.year if marev ==1
quietly estpost margins redu, at(year=(1(1)25) (means) mark1mn mark3mn mark4mn) predict(outcome(1))
quietly esttab . using cohort4_1_const_revise.csv, replace r(b) label wide nostar
quietly mlogit marevm year c.year##c.year i.redu i.statusx con i.fedu i.plv mark1mn  mark3mn mark4mn i.redu##c.year i.redu##c.c.year##c.year if marev ==1
quietly estpost margins redu, at(year=(1(1)25) (means) mark1mn mark3mn mark4mn) predict(outcome(2))
quietly esttab . using cohort4_2_const_revise.csv, replace r(b) label wide nostar
quietly mlogit marevm year c.year##c.year i.redu i.statusx con i.fedu i.plv mark1mn  mark3mn mark4mn i.redu##c.year i.redu##c.c.year##c.year if marev ==1
quietly estpost margins redu, at(year=(1(1)25) (means) mark1mn mark3mn mark4mn) predict(outcome(3))
quietly esttab . using cohort4_3_const_revise.csv, replace r(b) label wide nostar
