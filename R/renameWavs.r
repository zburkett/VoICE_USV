comArgs <- commandArgs(TRUE)
files <- list.files(comArgs[1],pattern="*.wav$")
renamed <- files
name.assign <- paste("%0",nchar(length(files)),"s",sep="")
newNames <- c(1:length(files))
names.out <- sprintf(name.assign,newNames)
if(.Platform$OS.type=="unix")
{
	names.out <- paste(names.out,".wav",sep="")
}else if(.Platform$OS.type=="windows"){
	names.out <- gsub(" ","0",names.out)
	names.out <- paste(names.out,".wav",sep="")
}
renamed <- cbind(renamed,names.out)
colnames(renamed) <- c("old.name","new.name")
write.table(renamed,file=paste(comArgs[1],"/original_filenames.txt",sep=""),row.names=F)
for(row in 1:nrow(renamed))
{
	file.rename(from=paste(comArgs[1],"/",renamed[row,1],sep=""),to=paste(comArgs[1],"/",renamed[row,2],sep=""))
}