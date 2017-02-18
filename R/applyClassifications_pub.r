comArgs <- commandArgs(TRUE)
options(stringsAsFactors=FALSE)
options(warn=-1)

load(paste(comArgs[1],"cluster_workspace.rdata",sep=""))
comArgs <- commandArgs(TRUE)
classifications <- read.csv(paste(comArgs[1],"assignments.csv",sep=""),row.names=NULL)
classifications <- subset(classifications,!is.na(classifications[,1]))
if(ncol(classifications)>1)
{
	x <- paste(classifications[,1],classifications[,2],sep="")
	x <- gsub(" ","",x)
	classifications <- as.matrix(x)
	classifications <- cbind(1:nrow(classifications),classifications)
	rm(x)
}else
{
	classifications <- cbind(c(1:nrow(classifications)),classifications)
}
colnames(classifications) <- c(1,2)

classifications[,1] <- gsub(".wav","",list.files(paste(comArgs[1],"matlab_wavs/",sep="")))

if(is.matrix(groups))
{
	groups <- groups[,1]
}

category <- groups

for(row in 1:nrow(classifications))
{
	if(is.na(as.numeric(classifications[row,1])))
	{
		if (classifications[row,2] == "co") {name = "complex"}
		if (classifications[row,2] == "h") {name = "harmonic"}
		if (classifications[row,2] == "ts") {name = "two_syllable"}
		if (classifications[row,2] == "u") {name = "upward"}
		if (classifications[row,2] == "ch") {name = "chevron"}
		if (classifications[row,2] == "s") {name = "short"}
		if (classifications[row,2] == "fs") {name = "frequency_step"}
		if (classifications[row,2] == "d") {name = "downward"}
		if (classifications[row,2] == "f") {name = "flat"}
		if (classifications[row,2] == "db") {name = "double"}
		if (classifications[row,2] == "tp") {name = "triple"}
		if (classifications[row,2] == "m") {name = "misc"}
		
		category[category==classifications[row,1]]=name
	}
	
	if(!is.na(as.numeric(classifications[row,1])))
	{
		if (classifications[row,2] == "co") {name = "complex"}
		if (classifications[row,2] == "h") {name = "harmonic"}
		if (classifications[row,2] == "ts") {name = "two_syllable"}
		if (classifications[row,2] == "u") {name = "upward"}
		if (classifications[row,2] == "ch") {name = "chevron"}
		if (classifications[row,2] == "s") {name = "short"}
		if (classifications[row,2] == "fs") {name = "frequency_step"}
		if (classifications[row,2] == "d") {name = "downward"}
		if (classifications[row,2] == "f") {name = "flat"}
		if (classifications[row,2] == "db") {name = "double"}
		if (classifications[row,2] == "tp") {name = "triple"}
		if (classifications[row,2] == "m") {name = "misc"}
		
		category[as.numeric(classifications[row,1])] = name
	}
}

groups <- cbind(groups,category)

save(list=ls(),file=paste(comArgs[1],'cluster_workspace.rdata',sep=""))