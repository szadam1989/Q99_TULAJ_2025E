library("stringr")
library("roperators")
# source("Main.r")

options(scipen = 999) #rögzített jelölésű számok használata tudományos helyett
getOption("scipen")

Q99 <- data.frame(matrix(NA, nrow = nrow(TULAJ_LIST),  ncol = 1))

uploading_Date <- c(paste0("2025", "05", "07"))
uploadRow <- 1
KSH <- "15302724"
sending_Date <- paste0(substr(Sys.Date(), 1, 4), substr(Sys.Date(), 6, 7), substr(Sys.Date(), 9, 10))
SZERV <- 1
lastInsertRow <- 0

for(i in 1:nrow(TULAJ_LIST)){

    Q99[i, 1] <- paste("Q99", uploading_Date[uploadRow], KSH, sending_Date, "E,SZERV", paste0("@SZERV", str_pad(SZERV, 7, pad = "0")), TULAJ_LIST[i, "M003"], ",K,TOBBTULAJD", TULAJ_LIST[i, "TOKE"], TULAJ_LIST[i, "ALAKDAT"], sep = ",")

    if (i %% 100000 == 0){
      
      lastInsertRow <- i
      write.table(Q99[max(1, (i - 100000)):i, ], paste0("Q99", str_sub(uploading_Date[uploadRow], start = -5), KSH), quote = FALSE, row.names = FALSE, col.names = FALSE, append = FALSE)
      uploadRow %+=% 1
      SZERV <- 0
      
    }
    
    SZERV %+=% 1
        
}

write.table(Q99[(lastInsertRow + 1):nrow(Q99), ], paste0("Q99", str_sub(sending_Date, start = -5), KSH), quote = FALSE, row.names = FALSE, col.names = FALSE, append = FALSE)