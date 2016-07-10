###################################################
### 3. Basic usage: Messages and descriptors
###################################################
library("RProtoBuf")
p <- new(tutorial.Person, id = 1, name = "Dirk")
p$name
p$name <- "Murray"
cat(as.character(p))
serialize(p, NULL)
class(p)

p <- new(tutorial.Person, name = "Murray", id = 1)

p$name
p$id
p$email <- "murray@stokely.org"

p[["name"]] <- "Murray Stokely"
p[[ 2 ]] <- 3
p[["email"]]
p

writeLines(as.character(p))

serialize(p, NULL)

tf1 <- tempfile()
serialize(p, tf1)
readBin(tf1, raw(0), 500)

msg <- read(tutorial.Person, tf1)
writeLines(as.character(msg))

###################################################
### 4. Under the hood: S4 classes and methods
###################################################
new(tutorial.Person)

tutorial.Person$email 
tutorial.Person$email$is_required()
tutorial.Person$email$type()
tutorial.Person$email$as.character()
class(tutorial.Person$email)

tutorial.Person$PhoneType
tutorial.Person$PhoneType$WORK
class(tutorial.Person$PhoneType)
tutorial.Person$PhoneType$value(1)
tutorial.Person$PhoneType$value(name = "HOME")
tutorial.Person$PhoneType$value(number = 1)
class(tutorial.Person$PhoneType$value(1))

f <- tutorial.Person$fileDescriptor()
f
f$Person

###################################################
### 5. Type coercion
###################################################

## a <- new(JSSPaper.Example1)
## a$optional_bool <- TRUE
## a$optional_bool <- FALSE
## a$optional_bool <- NA

readProtoFiles(file = "int64.proto")

as.integer(2^31-1)
as.integer(2^31 - 1) + as.integer(1)
2^31
class(2^31)

2^53 == (2^53 + 1)

###################################################
### 6. Converting R data structures into Protocol Buffers
###################################################
msg <- serialize_pb(iris, NULL)
identical(iris, unserialize_pb(msg))

datasets <- as.data.frame(data(package = "datasets")$results)
datasets$name <- sub("\\s+.*$", "", datasets$Item)
n <- nrow(datasets)

datasets$object.size <- unname(sapply(datasets$name, function(x) object.size(eval(as.name(x)))))
datasets$R.serialize.size <- unname(sapply(datasets$name, function(x) length(serialize(eval(as.name(x)), NULL))))
datasets$R.serialize.size <- unname(sapply(datasets$name, function(x) length(serialize(eval(as.name(x)), NULL))))
datasets$R.serialize.size.gz <- unname(sapply(datasets$name, function(x) length(memCompress(serialize(eval(as.name(x)), NULL), "gzip"))))
datasets$RProtoBuf.serialize.size <- unname(sapply(datasets$name, function(x) length(serialize_pb(eval(as.name(x)), NULL))))
datasets$RProtoBuf.serialize.size.gz <- unname(sapply(datasets$name, function(x) length(memCompress(serialize_pb(eval(as.name(x)), NULL), "gzip"))))

clean.df <- data.frame(dataset = datasets$name,
                       object.size = datasets$object.size,
                       "serialized" = datasets$R.serialize.size,
                       "gzipped serialized" = datasets$R.serialize.size.gz,
                       "RProtoBuf" = datasets$RProtoBuf.serialize.size,
                       "gzipped RProtoBuf" = datasets$RProtoBuf.serialize.size.gz,
		       "ratio.serialized" = datasets$R.serialize.size / datasets$object.size,
		       "ratio.rprotobuf" = datasets$RProtoBuf.serialize.size / datasets$object.size,
		       "ratio.serialized.gz" = datasets$R.serialize.size.gz / datasets$object.size,
		       "ratio.rprotobuf.gz" = datasets$RProtoBuf.serialize.size.gz / datasets$object.size,
		       "savings.serialized" = 1 - (datasets$R.serialize.size / datasets$object.size),
		       "savings.rprotobuf" = 1 - (datasets$RProtoBuf.serialize.size / datasets$object.size),
		       "savings.serialized.gz" = 1 - (datasets$R.serialize.size.gz / datasets$object.size),
		       "savings.rprotobuf.gz" = 1 - (datasets$RProtoBuf.serialize.size.gz / datasets$object.size),
                       check.names = FALSE)

all.df <- data.frame(dataset = "TOTAL", object.size = sum(datasets$object.size),
                   "serialized" = sum(datasets$R.serialize.size),
                   "gzipped serialized" = sum(datasets$R.serialize.size.gz),
                   "RProtoBuf" = sum(datasets$RProtoBuf.serialize.size),
                   "gzipped RProtoBuf" = sum(datasets$RProtoBuf.serialize.size.gz),
                   "ratio.serialized" = sum(datasets$R.serialize.size) / sum(datasets$object.size),
                   "ratio.rprotobuf" = sum(datasets$RProtoBuf.serialize.size) / sum(datasets$object.size),
                   "ratio.serialized.gz" = sum(datasets$R.serialize.size.gz) / sum(datasets$object.size),
                   "ratio.rprotobuf.gz" = sum(datasets$RProtoBuf.serialize.size.gz) / sum(datasets$object.size),
                   "savings.serialized" = 1 - (sum(datasets$R.serialize.size) / sum(datasets$object.size)),
                   "savings.rprotobuf" = 1 - (sum(datasets$RProtoBuf.serialize.size) / sum(datasets$object.size)),
                   "savings.serialized.gz" = 1 - (sum(datasets$R.serialize.size.gz) / sum(datasets$object.size)),
                   "savings.rprotobuf.gz" = 1 - (sum(datasets$RProtoBuf.serialize.size.gz) / sum(datasets$object.size)),
                   check.names = FALSE)
clean.df <- rbind(clean.df, all.df)

(sep.figure2 <- datasets[match(c("crimtab", "airquality", "faithful"), datasets$name), ])
(sep.perc.figure2 <- round((1 - sep.figure2[, grep("serialize", colnames(sep.figure2))] / sep.figure2[, "object.size"]) * 100, 1))

(all.figure2 <- colSums(datasets[, c("object.size", grep("serialize", colnames(datasets), value = TRUE))]))
(all.perc.figure2 <- round((1 - all.figure2[-1] / all.figure2[1]) * 100))

old.mar <- par("mar")
new.mar <- old.mar
new.mar[3] <- 0
new.mar[4] <- 0
my.cex <- 1.3
par("mar" = new.mar)
plot(clean.df$savings.serialized, clean.df$savings.rprotobuf, pch = 1, col = "red", las = 1,
     xlab = "Serialization Space Savings", ylab = "Protocol Buffer Space Savings",
     xlim = c(0, 1), ylim = c(0, 1), cex.lab = my.cex, cex.axis = my.cex)
points(clean.df$savings.serialized.gz, clean.df$savings.rprotobuf.gz, pch = 2, col = "blue")
# grey dotted diagonal
abline(a = 0, b = 1, col = "grey", lty = 2, lwd = 3)

# find point furthest off the X axis.
clean.df$savings.diff <- clean.df$savings.serialized - clean.df$savings.rprotobuf
clean.df$savings.diff.gz <- clean.df$savings.serialized.gz - clean.df$savings.rprotobuf.gz

# The one to label.
tmp.df <- clean.df[which(clean.df$savings.diff ==  min(clean.df$savings.diff)),]
# This minimum means most to the left of our line, so pos = 2 is label to the left
text(tmp.df$savings.serialized, tmp.df$savings.rprotobuf, labels = tmp.df$dataset, pos = 2, cex = my.cex)

# Some gziped version
# text(tmp.df$savings.serialized.gz, tmp.df$savings.rprotobuf.gz, labels = tmp.df$dataset, pos = 2, cex = my.cex)

# Second one is also an outlier
tmp.df <- clean.df[which(clean.df$savings.diff ==  sort(clean.df$savings.diff)[2]),]
# This minimum means most to the left of our line, so pos = 2 is label to the left
text(tmp.df$savings.serialized, tmp.df$savings.rprotobuf, labels = tmp.df$dataset, pos = 2, cex = my.cex)
# text(tmp.df$savings.serialized.gz, tmp.df$savings.rprotobuf.gz, labels = tmp.df$dataset, pos = my.cex)

tmp.df <- clean.df[which(clean.df$savings.diff ==  max(clean.df$savings.diff)),]
# This minimum means most to the right of the diagonal, so pos = 4 is label to the right
# Only show the gziped one.
# text(tmp.df$savings.serialized, tmp.df$savings.rprotobuf, labels = tmp.df$dataset, pos = 4, cex = my.cex)
text(tmp.df$savings.serialized.gz, tmp.df$savings.rprotobuf.gz, labels = tmp.df$dataset, pos = 4, cex = my.cex)

# outlier.dfs <- clean.df[c(which(clean.df$savings.diff ==  min(clean.df$savings.diff)),
legend("topleft", c("Raw", "Gzip Compressed"), pch = 1:2, col = c("red", "blue"), cex = my.cex)

interesting.df <- clean.df[unique(c(which(clean.df$savings.diff ==  min(clean.df$savings.diff)),
                                    which(clean.df$savings.diff ==  max(clean.df$savings.diff)),
                                    which(clean.df$savings.diff.gz ==  max(clean.df$savings.diff.gz)),
                                    which(clean.df$dataset ==  "TOTAL"))),
                           c("dataset", "object.size", "serialized", "gzipped serialized", "RProtoBuf",
                             "gzipped RProtoBuf", "savings.serialized", "savings.serialized.gz",
                             "savings.rprotobuf", "savings.rprotobuf.gz")]
# Print without .00 in xtable
interesting.df$object.size <- as.integer(interesting.df$object.size)
par("mar" = old.mar)

###################################################
### 7. Application: Distributed data collection with MapReduce
###################################################
library("HistogramTools")
readProtoFiles(package = "HistogramTools")
hist <- HistogramTools.HistogramState$read("hist.pb")
plot(as.histogram(hist), main = "")

###################################################
### 8. Application: Data interchange in web services
###################################################
library("RProtoBuf")
library("httr")

req <- GET("https://demo.ocpu.io/MASS/data/Animals/pb")
output <- unserialize_pb(req$content)

identical(output, MASS::Animals)

library("httr")
library("RProtoBuf")

args <- list(n = 42, mean = 100)
payload <- serialize_pb(args, NULL)

req <- POST (
  url = "https://demo.ocpu.io/stats/R/rnorm/pb",
  body = payload,
  add_headers (
    "Content-Type" = "application/x-protobuf"
  )
)

output <- unserialize_pb(req$content)
print(output)



