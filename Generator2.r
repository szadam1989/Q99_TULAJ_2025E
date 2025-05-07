library("stringr")
library("roperators")
# source("Main.r")

options(scipen = 999) #rögzített jelölésű számok használata tudományos helyett
getOption("scipen")

Q99 <- data.frame(matrix(NA, nrow = nrow(TULAJ_LIST),  ncol = 13))

uploading_Date <- c(paste0("2025", "05", "07"))
KSH <- "15302724"
sending_Date <- paste0(substr(Sys.Date(), 1, 4), substr(Sys.Date(), 6, 7), substr(Sys.Date(), 9, 10))
SZERV <- str_pad(c(1:100000), 7, pad = "0")

Q99[, 1] <- "Q99"

start <- 1
stop <- 100000
for(i in 1:length(uploading_Date)){

    if(i == length(uploading_Date)){

        Q99[start:(start + nrow(TULAJ_LIST) - 1), 2] <- uploading_Date[i]
        Q99[start:(start + nrow(TULAJ_LIST) - 1), 7] <- paste0("@SZERV", SZERV[1:nrow(TULAJ_LIST)])
        
    }
    else{
        
        Q99[start:stop, 2] <- uploading_Date[i]
        Q99[start:stop, 7] <- paste0("@SZERV", SZERV[1:100000])
        
    }

    start %+=% 100000
    stop %+=% 100000
    
}

Q99[, 3] <- KSH
Q99[, 4] <- sending_Date
Q99[, 5] <- "E"
Q99[, 6] <- "SZERV"
Q99[, 8] <- TULAJ_LIST[, 1]
Q99[, 9] <- ""
Q99[, 10] <- "K"
Q99[, 11] <- "TOBBTULAJD"
Q99[, 12] <- TULAJ_LIST[, 2]
Q99[, 13] <- TULAJ_LIST[, 3]

write.table(Q99, paste0("Q99", str_sub(sending_Date, start = -5), KSH, "UJ"), sep = ",", quote = FALSE, row.names = FALSE, col.names = FALSE, append = FALSE)
