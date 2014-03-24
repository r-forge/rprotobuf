### R code from vignette source 'article.Rnw'

###################################################
### code chunk number 1: article.Rnw:125-131
###################################################
## cf http://www.jstatsoft.org/style#q12
options(prompt = "R> ", 
        continue = "+  ", 
        width = 70, 
        useFancyQuotes = FALSE, 
        digits = 4)


###################################################
### code chunk number 2: article.Rnw:313-321
###################################################
library("RProtoBuf")
p <- new(tutorial.Person, id=1,
         name="Dirk")
p$name
p$name <- "Murray"
cat(as.character(p))
serialize(p, NULL)
class(p)


###################################################
### code chunk number 3: article.Rnw:376-377
###################################################
ls("RProtoBuf:DescriptorPool")


###################################################
### code chunk number 4: article.Rnw:391-393
###################################################
p1 <- new(tutorial.Person)
p <- new(tutorial.Person, name = "Murray", id = 1)


###################################################
### code chunk number 5: article.Rnw:402-405
###################################################
p$name
p$id
p$email <- "murray@stokely.org"


###################################################
### code chunk number 6: article.Rnw:413-416
###################################################
p[["name"]] <- "Murray Stokely"
p[[ 2 ]] <- 3
p[["email"]]


###################################################
### code chunk number 7: article.Rnw:429-430
###################################################
p


###################################################
### code chunk number 8: article.Rnw:437-438
###################################################
writeLines(as.character(p))


###################################################
### code chunk number 9: article.Rnw:451-452
###################################################
serialize(p, NULL)


###################################################
### code chunk number 10: article.Rnw:457-460
###################################################
tf1 <- tempfile()
serialize(p, tf1)
readBin(tf1, raw(0), 500)


###################################################
### code chunk number 11: article.Rnw:465-470
###################################################
tf2 <- tempfile()
con <- file(tf2, open = "wb")
serialize(p, con)
close(con)
readBin(tf2, raw(0), 500)


###################################################
### code chunk number 12: article.Rnw:476-480
###################################################
p$serialize(tf1)
con <- file(tf2, open = "wb")
p$serialize(con)
close(con)


###################################################
### code chunk number 13: article.Rnw:500-502
###################################################
msg <- read(tutorial.Person, tf1)
writeLines(as.character(msg))


###################################################
### code chunk number 14: article.Rnw:508-512
###################################################
con <- file(tf2, open = "rb")
message <- read(tutorial.Person, con)
close(con)
writeLines(as.character(message))


###################################################
### code chunk number 15: article.Rnw:517-519
###################################################
payload <- readBin(tf1, raw(0), 5000)
message <- read(tutorial.Person, payload)


###################################################
### code chunk number 16: article.Rnw:526-531
###################################################
message <- tutorial.Person$read(tf1)
con <- file(tf2, open = "rb")
message <- tutorial.Person$read(con)
close(con)
message <- tutorial.Person$read(payload)


###################################################
### code chunk number 17: article.Rnw:610-611
###################################################
new(tutorial.Person)


###################################################
### code chunk number 18: article.Rnw:675-682
###################################################
tutorial.Person$email 

tutorial.Person$PhoneType 

tutorial.Person$PhoneNumber 

tutorial.Person.PhoneNumber


###################################################
### code chunk number 19: article.Rnw:798-800
###################################################
tutorial.Person$PhoneType
tutorial.Person$PhoneType$WORK


###################################################
### code chunk number 20: article.Rnw:849-852
###################################################
tutorial.Person$PhoneType$value(1)
tutorial.Person$PhoneType$value(name="HOME")
tutorial.Person$PhoneType$value(number=1)


###################################################
### code chunk number 21: article.Rnw:921-924
###################################################
f <- tutorial.Person$fileDescriptor()
f
f$Person


###################################################
### code chunk number 22: article.Rnw:987-990
###################################################
if (!exists("JSSPaper.Example1", "RProtoBuf:DescriptorPool")) {
    readProtoFiles(file="int64.proto")
}


###################################################
### code chunk number 23: article.Rnw:1012-1016
###################################################
as.integer(2^31-1)
as.integer(2^31 - 1) + as.integer(1)
2^31
class(2^31)


###################################################
### code chunk number 24: article.Rnw:1027-1028
###################################################
2^53 == (2^53 + 1)


###################################################
### code chunk number 25: article.Rnw:1040-1043
###################################################
test <- new(JSSPaper.Example1)
test$repeated_int64 <- c(2^53, 2^53+1)
length(unique(test$repeated_int64))


###################################################
### code chunk number 26: article.Rnw:1050-1051
###################################################
test$repeated_int64 <- c("9007199254740992", "9007199254740993")


###################################################
### code chunk number 27: article.Rnw:1062-1068
###################################################
options("RProtoBuf.int64AsString" = FALSE)
test$repeated_int64
length(unique(test$repeated_int64))
options("RProtoBuf.int64AsString" = TRUE)
test$repeated_int64
length(unique(test$repeated_int64))


###################################################
### code chunk number 28: article.Rnw:1071-1072
###################################################
options("RProtoBuf.int64AsString" = FALSE)


###################################################
### code chunk number 29: article.Rnw:1089-1091
###################################################
msg <- serialize_pb(iris, NULL)
identical(iris, unserialize_pb(msg))


###################################################
### code chunk number 30: article.Rnw:1122-1125
###################################################
datasets <- as.data.frame(data(package="datasets")$results)
datasets$name <- sub("\\s+.*$", "", datasets$Item)
n <- nrow(datasets)


###################################################
### code chunk number 31: article.Rnw:1135-1136
###################################################
m <- sum(sapply(datasets$name, function(x) can_serialize_pb(get(x))))


###################################################
### code chunk number 32: article.Rnw:1149-1156
###################################################
attr(CO2, "formula")
msg <- serialize_pb(CO2, NULL)
object <- unserialize_pb(msg)
identical(CO2, object)
identical(class(CO2), class(object))
identical(dim(CO2), dim(object))
attr(object, "formula")


###################################################
### code chunk number 33: article.Rnw:1172-1191
###################################################
datasets$object.size <- unname(sapply(datasets$name, function(x) object.size(eval(as.name(x)))))

datasets$R.serialize.size <- unname(sapply(datasets$name, function(x) length(serialize(eval(as.name(x)), NULL))))

datasets$R.serialize.size <- unname(sapply(datasets$name, function(x) length(serialize(eval(as.name(x)), NULL))))

datasets$R.serialize.size.gz <- unname(sapply(datasets$name, function(x) length(memCompress(serialize(eval(as.name(x)), NULL), "gzip"))))

datasets$RProtoBuf.serialize.size <- unname(sapply(datasets$name, function(x) length(serialize_pb(eval(as.name(x)), NULL))))

datasets$RProtoBuf.serialize.size.gz <- unname(sapply(datasets$name, function(x) length(memCompress(serialize_pb(eval(as.name(x)), NULL), "gzip"))))

clean.df <- data.frame(dataset=datasets$name,
                       object.size=datasets$object.size,
                       "serialized"=datasets$R.serialize.size,
                       "gzipped serialized"=datasets$R.serialize.size.gz,
                       "RProtoBuf"=datasets$RProtoBuf.serialize.size,
                       "gzipped RProtoBuf"=datasets$RProtoBuf.serialize.size.gz,
                       check.names=FALSE)


###################################################
### code chunk number 34: article.Rnw:1399-1404
###################################################
require(RProtoBuf)
require(HistogramTools)
readProtoFiles(package="HistogramTools")
hist <- HistogramTools.HistogramState$read("hist.pb")
plot(as.histogram(hist))


###################################################
### code chunk number 35: article.Rnw:1472-1479 (eval = FALSE)
###################################################
## library("RProtoBuf")
## library("httr")
## 
## req <- GET('https://public.opencpu.org/ocpu/library/MASS/data/Animals/pb')
## output <- unserialize_pb(req$content)
## 
## identical(output, MASS::Animals)


###################################################
### code chunk number 36: article.Rnw:1538-1554 (eval = FALSE)
###################################################
## library("httr")       
## library("RProtoBuf")
## 
## args <- list(n=42, mean=100)
## payload <- serialize_pb(args, NULL)
## 
## req <- POST (
##   url = "https://public.opencpu.org/ocpu/library/stats/R/rnorm/pb",
##   body = payload,
##   add_headers (
##     "Content-Type" = "application/x-protobuf"
##   )
## )
## 
## output <- unserialize_pb(req$content)
## print(output)


###################################################
### code chunk number 37: article.Rnw:1558-1561 (eval = FALSE)
###################################################
## fnargs <- unserialize_pb(inputmsg)
## val <- do.call(stats::rnorm, fnargs)
## outputmsg <- serialize_pb(val)


