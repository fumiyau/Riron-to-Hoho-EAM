cd "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/Results/Desc"
*figure1
forvalue i=3/4{
quietly estpost tabulate redu max if sex==2 & cohort == `i' & year == 1, nototal
quietly esttab . using graph_female`i'.csv, replace cell(b(fmt(2))) unstack noobs
}
quietly estpost tabulate redu max if sex==2 & cohort == 5 & year == 1 & q1_2_5 >34, nototal
quietly esttab . using graph_female5.csv, replace cell(b(fmt(2))) unstack noobs
*記述統計
quietly estpost tabulate marevm sex, nototal
quietly esttab . using rev_desc1.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate redu sex, nototal
quietly esttab . using rev_desc2.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate statusx sex, nototal
quietly esttab . using rev_desc4.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate jobst1 sex, nototal
quietly esttab . using rev_desc5.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate fedu sex, nototal
quietly esttab . using rev_desc6.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate cohort sex, nototal
quietly esttab . using rev_desc7.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate plv sex, nototal
quietly esttab . using rev_desc8.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabstat year con mark1mn mark3mn mark4mn, statistics(mean sd) columns(statistics) 
quietly esttab . using rev_desc9.csv, replace main(mean) aux(sd) nostar unstack noobs nonote label
