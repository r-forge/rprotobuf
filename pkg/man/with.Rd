\name{with.protobufMessage}
\alias{with.protobufMessage}
\alias{within.protobufMessage}
\title{
with and within methods for protocol buffer messages
}
\description{
Convenience wrapper that allow getting and setting 
fields of protocol buffer messages from within the object
}
\usage{
\S3method{with}{protobufMessage}(data, expr, ...)
\S3method{within}{protobufMessage}(data, expr, ...)
}
\arguments{
	\item{data}{A protocol buffer message, instance of \linkS4class{protobufMessage} }
	\item{expr}{R expression to evaluate}
	\item{\dots}{ignored}
}
\details{
The expression is evaluated in an environment 
that allows to set and get fields of the message

The fields of the message are mapped to active bindings
(see \link{makeActiveBinding}) so that they can be accessed
and modified from within the environment. 
}
\value{
	\code{with} returns the value of the expression and 
	\code{within} returns the \code{data} argument.
}
\author{
Romain Francois <francoisromain@free.fr>
}
\examples{
\dontrun{
proto.file <- system.file( "proto", "addressbook.proto", package = "RProtoBuf" ) 
Person <- P( "tutorial.Person", file = proto.file )
romain <- within( new( Person ), {
	email <- "francoisromain@free.fr"
	id <- 10L
} )
}
}
\keyword{ classes }