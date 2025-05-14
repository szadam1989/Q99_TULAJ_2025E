library("RODBC")

channelOracle <- odbcDriverConnect(paste("DRIVER={Oracle in OraClient18Home1};DBQ=EMERALD.KSH.HU;UID=", Sys.getenv("userid"), ";PWD=", Sys.getenv("pwd")))

TULAJ_LIST <- sqlQuery(channelOracle, paste("select gszr.M003, tulaj.TOKE, to_char(greatest(to_date('20230101', 'YYYYMMDD'), alakdat), 'YYYYMMDD') ALAKDAT
from VB.F003 gszr, VB23.M039_2023E tulaj 
where gszr.M003 = tulaj.M003 and substr(tulaj.M003, 1, 1) between '1' and '9' and substr(gszr.M0491, 1, 2) != '23' and gszr.M0491 != '961'
and (nvl(gszr.TOKE, -1) != nvl(tulaj.TOKE, -1) --változott a tőkéje
and (gszr.M040 not in ('0', '9')  --élő
or (gszr.M040 in ('0', '9') and to_char(gszr.M040K, 'yyyy') >= '2023')) --vagy még éltek 2023-ban
and to_char(gszr.ALAKDAT, 'yyyy') < '2024' and tulaj.TOKE is not null) --és 2024 előtt alakult
order by gszr.M003"), as.is = TRUE)
dim(TULAJ_LIST) #35847 sor

# View(TULAJ_LIST)

odbcClose(channelOracle)
