cd "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/"
log using `"`path'RirontoHoho-EAM-Replication`=subinstr("`c(current_date)'"," ","",.)'.log"', replace
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/1.Dataconst.do"
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/2.Desc.do"
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/3.Analysis.do"
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/4.Prediction-c3.do" 
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/5.Prediction-c3obs.do" 
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/6.Prediction-c4.do"
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/7.Prediction-c4obs.do" 
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/8.Prediction-c5.do" 
do "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/9.Prediction-c5obs.do"
cd "/Users/fumiyau/Documents/GitHub/RirontoHoho-EAM/"
log close
