comArgs <- commandArgs(T)
options(stringsAsFactors=FALSE)

if(!file.exists(paste(comArgs[1],"assignments.csv",sep="")))
{
	color <- gsub(".wav","",comArgs[3])
	classification <- comArgs[2]
	out <- cbind(color,classification)
	write.csv(out,paste(comArgs[1],"assignments.csv",sep=""))
}else
{
	out <- read.csv(paste(comArgs[1],"assignments.csv",sep=""),row.names=1)
	color <- gsub(".wav","",comArgs[3])
	classification <- comArgs[2]
	newrow <- c(color,classification)
	out <- rbind(out,newrow)
	write.csv(out,paste(comArgs[1],"assignments.csv",sep=""))	
}
