cd "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/Results/Multivariate"
keep redu year jobst1 statusx con fedu plv mark1mn mark3mn mark4mn cohort sex marev marevm age 
recode redu 1=0
recode jobst1 1=0
recode statusx 1=0
recode fedu 1=0
recode plv 2=0
quietly logit marev year c.year##c.year i.redu i.statusx con i.plv i.fedu mark1mn mark3mn mark4mn i.redu##c.year i.redu##c.year##c.year if cohort==3
est sto model1
quietly mlogit marevm year c.year##c.year i.redu i.statusx con i.plv i.fedu mark1mn  mark3mn mark4mn i.redu##c.year i.redu##c.year##c.year if marev ==1 & cohort==3
est sto model2
quietly logit marev year c.year##c.year i.redu i.statusx con i.plv i.fedu mark1mn mark3mn mark4mn i.redu##c.year i.redu##c.year##c.year if cohort==4
est sto model3
quietly mlogit marevm year c.year##c.year i.redu i.statusx con i.plv i.fedu mark1mn  mark3mn mark4mn i.redu##c.year i.redu##c.year##c.year if marev ==1 & cohort==4
est sto model4
quietly logit marev year c.year##c.year i.redu i.statusx con i.plv i.fedu mark1mn mark3mn mark4mn i.redu##c.year i.redu##c.year##c.year if cohort==5
est sto model5
quietly mlogit marevm year c.year##c.year i.redu i.statusx con i.plv i.fedu mark1mn  mark3mn mark4mn i.redu##c.year i.redu##c.year##c.year if marev ==1 & cohort==5, baseoutcome(1)
est sto model6
esttab model1 model2 model3 model4 model5 model6 using jss_regtable_Revision.csv, se scalar(N ll aic r2_p) star(† 0.1 * 0.05 ** 0.01 *** 0.001) b(3)  replace label  wide  noomitted title(Discrete time logit female)
fitstat
