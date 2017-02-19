if(.Platform$OS.type=="windows" & file.exists("./.libraries")){.libPaths("./.libraries")}
library(WGCNA)
comArgs <- commandArgs(TRUE)

load(paste(comArgs[1],"cluster_workspace.Rdata",sep=""))

	callIndex <- c("complex","harmonic","two_syllable","upward","chevron","short","frequency_step","downward","flat","double","triple","misc")
	colorIndex <- c(labels2colors(1:11),"gray")
	ind <- rbind(callIndex,colorIndex)
	ind <- t(ind)
	
	piecolors <- subset(ind,ind[,1]%in%unique(groups[,2]))
	
	slices <- vector()
	for(calltype in unique(groups[,2]))
	{
		slices <- c(slices,sum(groups[,2]==calltype))
	}
	
	mycolors <- vector()
	for(group in unique(groups[,2])) {mycolors <- c(mycolors,subset(piecolors[,2],piecolors[,1]==group))}
	
	pct <- round(slices/sum(slices)*100)
	pct <- paste(pct,"%",sep="")
	paren <- paste("(",slices,")",sep="")
	pct <- paste(pct,paren)
	lbls <- paste(unique(groups[,2]),pct,sep=" ")
	
	pdf(file=paste(comArgs[1],"pieChart.pdf",sep=""))
	pie(slices,labels=lbls,col=mycolors,main=paste("USV frequency pie chart. Total calls = ", nrow(groups), ".",sep=""))
	dev.off()
	#pie(slices,labels=NA,col=mycolors)