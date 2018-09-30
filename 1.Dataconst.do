use "/Users/fumiyau/Desktop/SSM/Rawdata/2015ssm_v050a0827.dta",clear
gen marriage = q25
gen marage1 = q26 
gen marspage1 = q28
gen spedu1 = q30
gen remarriage = q33
gen sex = q1_1
gen jobssm1 = q8_f
gen second = q30 if remarriage == 2

/*出生年/出生コーホート*/
gen birth = q1_2_1
replace birth = 1925 + q1_2_3 if birth == 9999 & q1_2_2 == 1
replace birth = 1989 + q1_2_3 if birth == 9999 & q1_2_2 == 2
gen cohort = birth
recode cohort 1935/1944 = 1 1945/1954=2 1955/1964=3 1965/1974=4 1975/1984=5 1985/1995=6

/*1989年以降出生で学生は削除*/
drop if birth > 1989 & q2_a == 12 & birth ~=.
/*初職についたことのない人は分析から除く*/
*drop if q8==3
/*初職情報不明の人も除く*/
drop if q8_a==999 | q8_a==99
/*企業規模に関しては「わからない」のみ許容する*/
drop if q8_c == q8_c==999
drop if q8_f == 9999
/*高校在学中のケースは除く、何歳で高校に入学したか不明のため*/
drop if q19_d == 3 | q19_d == 9
/*初職開始年齢の欠損と14歳以下は削除*/
drop if q8_h_1 == 999 | q8_h_1 == 13/14

/*remarriage(q33)で非該当（8）が離死別になる。*/
/*現在の婚姻状況未婚2205人のうち、離別が425人、死別が466人、不明が2名。不明を含めると1314人の学歴は自動的に非該当になる。*/
/*問38：かつての配偶者の最終学歴は上述の非該当1314名に、無回答15人を除いた876ケース（全サンプルの11.2%）の情報が取れている。*/
/*かつ、「その他(8)」「わからない(9)」である33ケース（無回答を足すと48ケース）を除くと、843ケース（離別が399、死別が444）の元配偶者の学歴がわかる。*/
/*有効回答率は、843/891ケース=94.6%である。*/
/*離死別かどうかで、元配偶者学歴の回答率が異なるかをカイ二乗検定*/
gen missing = q38 < 8
tab missing q25 if q38 ~= 88, chi
/*Pr = 0.356で有意差なし。*/
/*再婚者は217ケース*/
/*したがって、初婚継続が5390、再婚が217、離婚が425、死別が466、純粋な未婚が1312ケース_tabq25 q33*/
gen spedu2 = q38
gen marage2 = q34
gen marspage2 = q36

recode spedu1 8/99=.
recode spedu2 8/99=.

/*再婚者の初婚相手*/
gen spedu3 = sq5
gen marage3 = sq1
gen marspage3 = sq3
recode spedu3 8/99=.

/*初婚相手の学歴*/
gen spedu = spedu1
replace spedu = spedu2 if spedu == .
replace spedu = spedu3 if remarriage == 2

*初婚相手の結婚時年齢
gen spmarage=marspage1-(q1_2_5-marage1)
replace spmarage=marspage2 if spedu == .
replace spmarage=marspage3 if remarriage == 2
recode spmar 888=. 999=. 99=.
gen agedif=spmarage-marage1

/*q25とq33を組み合わせた変数の作成*/
/*未婚1　初婚継続2 再婚3 離別4 死別5 7ケースが除外*/
/*6379/6498=98.2%の回答率*/
gen marsta = .
recode marsta . = 1 if marriage == 1 & remarriage == 8
recode marsta . = 2 if marriage == 2 & remarriage == 1
recode marsta . = 3 if marriage == 2 & remarriage == 2
recode marsta . = 4 if marriage == 3 & remarriage == 8
recode marsta . = 5 if marriage == 4 & remarriage == 8

/*q26とq34を組み合わせた本人初婚年齢（厳密には再婚者を除く必要あり）変数の作成*/
/*q28とq36を組み合わせた配偶者初婚年齢（厳密には再婚者を除く必要あり）変数の作成*/
/*配偶者年齢の男女反転はやや慎重な対応を要する（相手が初婚かわからないので）*/
/*本人初婚年齢は6485ケースが回答*/
recode marage1 888/999=. 99=.
recode marage2 888/999=. 99=.
recode marage3 888/999=. 99=.

gen marage = marage1
replace marage = marage2 if marage ==.
replace marage = marage3 if remarriage == 2

/*marstaを使ってmarflagを立てる。flagが立っていないのは生存と捉えるので、本人の現在の年齢を代入*/
gen marflag = marsta > 1 & marsta ~=.
gen surv = marage
replace surv = q1_2_5 if marflag == 0

/*結婚可能年齢を基準として期間を算出、70歳代になっての結婚もちらほら
0が9ケースあるが、これは結婚可能年齢と同時に結婚したということ。*/
*結婚前年の職業情報を使うため1歳ずらす
gen period = surv - 17 if q1_1 == 1
replace period = surv - 15 if q1_1 == 2
recode period 0=.

*専門学校を考慮した新SSM学歴
*専門学校（専修学校専門課程）に進学した者で，高専・短大・大学・大学院に進学しなかった者を「7 専門学校」とした。
gen edssmx = 0
replace edssmx = 88 if q18_4 == 0
replace edssmx = 4 if q18_4 == 1 & q18_5 == 0 & q18_9 == 0 & q18_8 == 0 & q18_10 == 0 & q18_11 == 0
replace edssmx = 5 if q18_5 == 1 & q18_9 == 0 & q18_8 == 0 & q18_10 == 0 & q18_11 == 0
replace edssmx = 7 if q18_7 == 1 & q18_9 == 0 & q18_8 == 0 & q18_10 == 0 & q18_11 == 0
replace edssmx = 9 if q18_9 == 1 & q18_8 == 0 & q18_10 == 0 & q18_11 == 0
replace edssmx = 8 if q18_8 == 1 & q18_10 == 0 & q18_11 == 0
replace edssmx = 10 if q18_10 == 1 & q18_11 == 0
replace edssmx = 11 if q18_11 == 1
replace edssmx = 99 if q18_99 == 1
replace edssmx = 99 if q18_4 == 9  | q18_5 == 9 | q18_9 == 9 | q18_8 == 9 | q18_10 == 9 | q18_11 == 9

lab def edssmxlab 4 "中学" 5 "高校" 7 "専門学校" 8 "短大" 9 "高専" 10 "大学" 11 "大学院" 88 "学歴なし "99 "不明"
lab val edssmx edssmxlab

gen grad=.
replace grad=15 if edssmx==4
/*高校最終進学者：高校中退の場合は15歳に卒業とするので、リスクセットの開始から在学していないことになる*/
replace grad=15 if q19_d == 2
replace grad=18 if q19_d==1 & edssmx==5

forvalue i=1/3{
gen enter`i'=q20_`i'_b_1
recode enter`i' (888=.)(999=.)
gen duration`i'=q20_`i'_b_2
recode duration`i' (888=.)(999=.)
gen grad`i'=enter`i'+duration`i'

}

gen redu=edssmx
recode redu 4=1 5=2 7/9=3 10/11=4 88/99=.

drop if redu==.
recode redu 1=1 2=1 3=2 4=3

/*職業変数*/
/*初職情報*/
gen jobst1 = q8_a
recode jobst1 (1/2=1) (3/6=2) (7/9=3) (888=3) (99=.) (999=.)
recode jobst1 1=1 2/3=2
label variable jobst1   "本人初職従業上の地位"
label define stat1 0"初職従業上の地位（ref: 正規雇用）" 1"正規雇用" 2"非正規雇用・自営業"3"無業", replace
label values jobst1 stat1

/*初職内容*/
/* SSM 8 classification (including no-job) */
recode jobssm1 (501/544 = 1)(609/610 = 1)(615 = 1)(703 = 1) (545/553 = 2)(608 = 2)(554/565 = 3)(586 = 3)(590 = 3)(593/598 = 3)(616/619 = 3)(701 = 3) (566/577 = 4)(582/585 = 4)(587/589 = 4) (579 = 5)(581 = 5)(623/624 = 5)(626 = 5)(628 = 5)(631 = 5)(633 = 5)(635/644 = 5)(647 = 5)(651 = 5)(654/656 = 5)(658 = 5)(660/666= 5)(668 = 5)(670/675 = 5)(677/681 = 5)(684 = 5)(702 = 5) (580 = 6)(606/607 = 6)(611/614 = 6)(625 = 6)(627 = 6)(629/630 = 6)(632 = 6)(634 = 6)(645/646 = 6)(648/650 = 6)(652/653 = 6)(657 = 6)(659 = 6)(667 = 6)(669 = 6)(672 = 6)(676 = 6)(704 = 6)(706=6) (578 = 7)(591/592 = 7)(620/622 = 7)(682/683 = 7)(685/688 = 7)(599/605 = 8)(998 =9)(689 =.)(987 =.)(999 =.)(988=.)(701 = 4)(702 = 5)(703 = 2)(704 = 7)(705 =.)(706 = 8)(707 =.)(801 = 4)(802 = 4)(803 = 4)(804 = 4)(805=1)(806=4)
recode jobssm1 (8888=.)(9999=.)
gen job5ssm1 = jobssm1
recode job5ssm1 (1/2=1)(3=2)(4=3)(5=4)(6/8=5)
label define ssm1 0"本人職業（ref: 事務）"1"専門管理"2"事務" 3"販売"4"熟練"5"半非熟練・農業"6"無業", replace
label values job5ssm1 ssm1

/*本人・配偶者学歴のリコード*/
recode spedu 3/5=3 6/7=4 9/99=.
drop if spedu==. & marriage~=1

/*15歳時の暮らしむき*/
gen con = q13
recode con 9=. 99=.
replace con = 6-con

/*初職企業規模*/
gen numcom1=q8_c
recode numcom1 888/999=.
/*内職は小企業に分類　99は独立のカテゴリとする*/
recode numcom1 98=1 99=11
recode numcom1 1/5=1 6/8=2 9=3 10=4 11=5
label define kibo 0"初職企業規模（ref: 小企業（1-99人））" 1"小企業（1-99人）" 2"中企業（100-999人）" 3"大企業（1000人以上）"4"官公庁"5"わからない"6"無業", replace
label values numcom1 kibo

/*初職就業年齢*/
gen age1 = q8_h_1
recode age1 888/999=.
recode age1 13/14=.

*父学歴
gen fedu = q22_a
recode fedu (1/2=1)(3=2)(4/5=3)(6/7=4)(8=1)(9=2)(10/11=3)(12/13=4)(14=.)(99/999=5)

label variable redu   "本人学歴"
label variable job5ssm1   "本人初職"
label variable con   "15歳時点の生活水準"
label variable fedu   "父親学歴"
label define reduc 0"本人学歴（ref:中学・高校）"1"中学・高校" 2"短大・高専・専門" 3"四大以上", replace
label define cor 1"1935-44" 2"1945-54" 3"1955-64" 4"1965-74" 5"1975-84" 6"1985-95", replace
label define con15 1"貧しい" 2"やや貧しい" 3"ふつう" 4"やや豊か" 5"豊か" ,replace
recode fedu 4=3 5=4
label define father 0"父親学歴（ref: 中学校）" 1"中学校" 2"高等学校" 3"高等教育" 4"わからない", replace
label values fedu father
label values redu reduc
label values cohort cor
label values job5ssm1 ssm1
label values con con15

drop if sex == 1
drop if birth < 1955

/*パーソンイヤーデータの作成*/
expand period
bysort id: gen age = surv - period + _n - 1
bysort id: gen year= _n
gen marev=0
by id: replace marev=marflag if _n == _N
quietly stset year, failure(marev==1) id(id)

label variable year   "リスク経過年"

gen yearlog = log(year)
gen yearlog2 = log(year)*log(year)

gen risk = age - 25
gen risk2 = risk*risk

gen yearc = year - 25
gen year2 = year*year
label variable year2   "リスク経過年（2乗）"

/*新変数*/
gen marevm = marev
recode marevm 1=1 if spedu==1 & redu~=. & spedu~=.
recode marevm 1=2 if spedu==2 & redu~=. & spedu~=.
recode marevm 1=3 if spedu==3 & redu~=. & spedu~=.
recode marevm 1=4 if spedu==4 & redu~=. & spedu~=.
recode marevm 1=. if spedu==.
label define spouse 0"未婚" 1"結婚（中学・高校）" 2"結婚（短大・高専・専門）" 3"結婚（四大以上）", replace
label values marevm spouse

/*在学ダミーの作成
age1で13、14歳の人と非該当の人は除外されている*/
gen enroll=0
replace enroll=1 if age <= grad & q19_d==1 & edssmx==5 & grad ~=.
forvalue i=1/3{
replace enroll=1 if enter`i'>=age & grad`i'>=age & enter`i'~=. & grad`i' ~=.
}

gen start=1 if age1>0 & age1 ~=.
replace start = 0 if age1>age & age1 ~=.
replace start = 0 if q8 == 3
replace numcom1 = 6 if start==0
replace jobst1 = 3 if start==0
replace job5ssm1 =6 if start==0

/*就業をすでに開始した経験があるのに在学になっている場合は、enrollを優先
ほとんどがage==18となっているほか、なによりも就業しているかどうかの時変はまだ作れないので、この変数は就業を経験したダミーである*/
gen unseem=0
replace unseem=1 if enroll==0 & start==0
replace enroll=0 if enroll==1 & start==1
/*以上より、互いに独立な在学中ダミー、間断ダミー、就業経験ありダミーが作られる。
あくまで、分析対象は一度は就業したことのある人*/

drop if start==.

/*親同居 1:離家経験あり、2:なし, 3:なくなるまで一緒に住んでいた*/

gen plv = q24_1
recode plv 9=. 999990=. 
/*前年親と同居していたか*/
replace plv = 2 if plv == 1 & age ~=. & age > q24_2_1 & q24_2_1 < 99
replace plv = 1 if q24_1 == 2
/*暫定的に死ぬまで一緒に住んでいたは前年同居*/
recode plv 3=1
label values plv parl
label variable plv   "前年の親同居"
label define parl 1"同居"2"非同居"0"前年の親同居（ref: 非同居）", replace

/*1950年から2014年までの結婚市場の変数を入れる*/
keep if age < 41
gen time = age + birth 

recode marevm 1/2=1 3=2 4=3

/*異性中学、高校、高専、四大絶対数*/
gen mark3mn=.		
replace mark3mn=	47	 if time ==1971 & sex ==2
replace mark3mn=	54	 if time ==1972 & sex ==2
replace mark3mn=	61	 if time ==1973 & sex ==2
replace mark3mn=	64	 if time ==1974 & sex ==2
replace mark3mn=	65	 if time ==1975 & sex ==2
replace mark3mn=	66	 if time ==1976 & sex ==2
replace mark3mn=	70	 if time ==1977 & sex ==2
replace mark3mn=	76	 if time ==1978 & sex ==2
replace mark3mn=	71	 if time ==1979 & sex ==2
replace mark3mn=	67	 if time ==1980 & sex ==2
replace mark3mn=	72	 if time ==1981 & sex ==2
replace mark3mn=	79	 if time ==1982 & sex ==2
replace mark3mn=	80	 if time ==1983 & sex ==2
replace mark3mn=	91	 if time ==1984 & sex ==2
replace mark3mn=	94	 if time ==1985 & sex ==2
replace mark3mn=	96	 if time ==1986 & sex ==2
replace mark3mn=	102	 if time ==1987 & sex ==2
replace mark3mn=	116	 if time ==1988 & sex ==2
replace mark3mn=	124	 if time ==1989 & sex ==2
replace mark3mn=	129	 if time ==1990 & sex ==2
replace mark3mn=	143	 if time ==1991 & sex ==2
replace mark3mn=	150	 if time ==1992 & sex ==2
replace mark3mn=	159	 if time ==1993 & sex ==2
replace mark3mn=	155	 if time ==1994 & sex ==2
replace mark3mn=	160	 if time ==1995 & sex ==2
replace mark3mn=	166	 if time ==1996 & sex ==2
replace mark3mn=	165	 if time ==1997 & sex ==2
replace mark3mn=	172	 if time ==1998 & sex ==2
replace mark3mn=	177	 if time ==1999 & sex ==2
replace mark3mn=	182	 if time ==2000 & sex ==2
replace mark3mn=	184	 if time ==2001 & sex ==2
replace mark3mn=	172	 if time ==2002 & sex ==2
replace mark3mn=	174	 if time ==2003 & sex ==2
replace mark3mn=	180	 if time ==2004 & sex ==2
replace mark3mn=	165	 if time ==2005 & sex ==2
replace mark3mn=	154	 if time ==2006 & sex ==2
replace mark3mn=	147	 if time ==2007 & sex ==2
replace mark3mn=	140	 if time ==2008 & sex ==2
replace mark3mn=	135	 if time ==2009 & sex ==2
replace mark3mn=	131	 if time ==2010 & sex ==2
replace mark3mn=	125	 if time ==2011 & sex ==2
replace mark3mn=	118	 if time ==2012 & sex ==2
replace mark3mn=	116	 if time ==2013 & sex ==2
replace mark3mn=	108	 if time ==2014 & sex ==2
replace mark3mn=	102	 if time ==2015 & sex ==2

gen mark4mn=.		
replace mark4mn=	237	 if time ==1971 & sex ==2
replace mark4mn=	224	 if time ==1972 & sex ==2
replace mark4mn=	220	 if time ==1973 & sex ==2
replace mark4mn=	232	 if time ==1974 & sex ==2
replace mark4mn=	249	 if time ==1975 & sex ==2
replace mark4mn=	267	 if time ==1976 & sex ==2
replace mark4mn=	266	 if time ==1977 & sex ==2
replace mark4mn=	282	 if time ==1978 & sex ==2
replace mark4mn=	276	 if time ==1979 & sex ==2
replace mark4mn=	268	 if time ==1980 & sex ==2
replace mark4mn=	266	 if time ==1981 & sex ==2
replace mark4mn=	263	 if time ==1982 & sex ==2
replace mark4mn=	264	 if time ==1983 & sex ==2
replace mark4mn=	256	 if time ==1984 & sex ==2
replace mark4mn=	256	 if time ==1985 & sex ==2
replace mark4mn=	256	 if time ==1986 & sex ==2
replace mark4mn=	261	 if time ==1987 & sex ==2
replace mark4mn=	274	 if time ==1988 & sex ==2
replace mark4mn=	276	 if time ==1989 & sex ==2
replace mark4mn=	281	 if time ==1990 & sex ==2
replace mark4mn=	289	 if time ==1991 & sex ==2
replace mark4mn=	301	 if time ==1992 & sex ==2
replace mark4mn=	306	 if time ==1993 & sex ==2
replace mark4mn=	315	 if time ==1994 & sex ==2
replace mark4mn=	319	 if time ==1995 & sex ==2
replace mark4mn=	325	 if time ==1996 & sex ==2
replace mark4mn=	337	 if time ==1997 & sex ==2
replace mark4mn=	341	 if time ==1998 & sex ==2
replace mark4mn=	343	 if time ==1999 & sex ==2
replace mark4mn=	340	 if time ==2000 & sex ==2
replace mark4mn=	338	 if time ==2001 & sex ==2
replace mark4mn=	337	 if time ==2002 & sex ==2
replace mark4mn=	333	 if time ==2003 & sex ==2
replace mark4mn=	331	 if time ==2004 & sex ==2
replace mark4mn=	323	 if time ==2005 & sex ==2
replace mark4mn=	315	 if time ==2006 & sex ==2
replace mark4mn=	301	 if time ==2007 & sex ==2
replace mark4mn=	291	 if time ==2008 & sex ==2
replace mark4mn=	283	 if time ==2009 & sex ==2
replace mark4mn=	276	 if time ==2010 & sex ==2
replace mark4mn=	273	 if time ==2011 & sex ==2
replace mark4mn=	271	 if time ==2012 & sex ==2
replace mark4mn=	259	 if time ==2013 & sex ==2
replace mark4mn=	245	 if time ==2014 & sex ==2
replace mark4mn=	242	 if time ==2015 & sex ==2

gen mark1mn=.		
replace mark1mn=	498	 if time ==1971 & sex ==2
replace mark1mn=	481	 if time ==1972 & sex ==2
replace mark1mn=	458	 if time ==1973 & sex ==2
replace mark1mn=	436	 if time ==1974 & sex ==2
replace mark1mn=	415	 if time ==1975 & sex ==2
replace mark1mn=	382	 if time ==1976 & sex ==2
replace mark1mn=	367	 if time ==1977 & sex ==2
replace mark1mn=	366	 if time ==1978 & sex ==2
replace mark1mn=	356	 if time ==1979 & sex ==2
replace mark1mn=	342	 if time ==1980 & sex ==2
replace mark1mn=	347	 if time ==1981 & sex ==2
replace mark1mn=	356	 if time ==1982 & sex ==2
replace mark1mn=	349	 if time ==1983 & sex ==2
replace mark1mn=	345	 if time ==1984 & sex ==2
replace mark1mn=	347	 if time ==1985 & sex ==2
replace mark1mn=	356	 if time ==1986 & sex ==2
replace mark1mn=	367	 if time ==1987 & sex ==2
replace mark1mn=	357	 if time ==1988 & sex ==2
replace mark1mn=	371	 if time ==1989 & sex ==2
replace mark1mn=	390	 if time ==1990 & sex ==2
replace mark1mn=	398	 if time ==1991 & sex ==2
replace mark1mn=	399	 if time ==1992 & sex ==2
replace mark1mn=	388	 if time ==1993 & sex ==2
replace mark1mn=	389	 if time ==1994 & sex ==2
replace mark1mn=	375	 if time ==1995 & sex ==2
replace mark1mn=	372	 if time ==1996 & sex ==2
replace mark1mn=	362	 if time ==1997 & sex ==2
replace mark1mn=	354	 if time ==1998 & sex ==2
replace mark1mn=	351	 if time ==1999 & sex ==2
replace mark1mn=	346	 if time ==2000 & sex ==2
replace mark1mn=	337	 if time ==2001 & sex ==2
replace mark1mn=	330	 if time ==2002 & sex ==2
replace mark1mn=	323	 if time ==2003 & sex ==2
replace mark1mn=	312	 if time ==2004 & sex ==2
replace mark1mn=	306	 if time ==2005 & sex ==2
replace mark1mn=	305	 if time ==2006 & sex ==2
replace mark1mn=	291	 if time ==2007 & sex ==2
replace mark1mn=	272	 if time ==2008 & sex ==2
replace mark1mn=	255	 if time ==2009 & sex ==2
replace mark1mn=	249	 if time ==2010 & sex ==2
replace mark1mn=	235	 if time ==2011 & sex ==2
replace mark1mn=	220	 if time ==2012 & sex ==2
replace mark1mn=	223	 if time ==2013 & sex ==2
replace mark1mn=	205	 if time ==2014 & sex ==2
replace mark1mn=	194	 if time ==2015 & sex ==2

label variable mark1mn   "未婚異性（中学・高校）"
label variable mark3mn   "未婚異性（短大・高専・専門）"
label variable mark4mn   "未婚異性（四大以上）"

mark nomiss
markout nomiss marev marevm year year2 redu jobst1 con fedu mark1mn mark3mn mark4mn start enroll unseem plv
drop if nomiss ==0 | sex == 1
quietly stset year, failure(marev==1) id(id)
drop if cohort == 6

merge 1:1 id age using "/Users/fumiyau/Desktop/SSM/Edited_data/ssm2015_pymulti_v020RHed.dta"
recode status (1/2=1)(3/6=2)(7/9=3)(888=3)(99=.)(999=.)(777777/888888=3)(999999=.)
label define stat1 0"初職従業上の地位（ref: 正規雇用）" 1"正規雇用" 2"非正規雇用・自営業"3"無業", replace
label values status stat1
drop _merge
drop if nomiss==.
bysort id: gen statusx=status[_n-1]
label values statusx stat1
label variable statusx "初職従業上の地位(t-1)"
drop if age == 15
replace year=year-1
drop year2

bysort id: egen max=max(marevm)

