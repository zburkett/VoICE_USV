if(.Platform$OS.type=="unix")
{
	comArgs <- commandArgs(TRUE)
	
	clusterTableCreateNoData = function(syntax)
	{
		clusters = unique(syntax)
		clusterTable = list()
		
		for (value in clusters)
		{
			tempClust = syntax[syntax==value]
			refs = names(tempClust)
			clusterTable[[value]] = refs
		}
		
		return(clusterTable)
	}
	
	load(paste(comArgs[1],"cluster_workspace.Rdata",sep=""))
	
	cTable.temp <- clusterTableCreateNoData(groups[,2])
	if(file.exists(paste(comArgs[1],"joined_clusters_pie",sep=""))){unlink(paste(comArgs[1],"joined_clusters_pie",sep=""),recursive=TRUE)}
	if(file.exists(paste(comArgs[1],"sorted_syllables_pie",sep="")))
	{unlink(paste(comArgs[1],"sorted_syllables_pie",sep=""),recursive=TRUE)}
	dir.create(paste(comArgs[1],"joined_clusters_pie",sep=""))
	dir.create(paste(comArgs[1],"sorted_syllables_pie",sep=""))
	maxNames <- max(nchar(gsub(".wav","",list.files(comArgs[1],pattern="*.wav$"))))
	
			for(group in names(cTable.temp))
			{
				#print(paste("Joining syllables for cluster: ",group))
				filename <- paste(comArgs[1],"joined_clusters_pie/",group,".wav",sep="")
				fn <- filename
				filename <- gsub(" ","\\\\ ",filename)
				namesIn <- cTable.temp[[group]]
				names <- vector()
				
				for (name in namesIn)
				{
					name.assign <- paste("%0",maxNames,"d",sep="")
					newName <- sprintf(name.assign,as.numeric(name))
					if(!Sys.info()['sysname']=="Darwin") {name.assign <- gsub(" ",0,newName)}
					names <- c(names,newName)
				}
			
				names <- paste(comArgs[1],names,".wav",sep="")
				names <- gsub(" ","\\\\ ",names)
			
				outwav <- paste(filename)
				tempoutwav <- paste(comArgs[1],"joined_clusters_pie/tempout.wav",sep="")
				tempoutwav <- gsub(" ","\\\\ ",tempoutwav)	
				loop <- 0
				tot <- length(names)-1
			
				if(length(names)==1)
				{
					file.copy(names,paste(comArgs[1],"joined_clusters_pie/",group,".wav",sep=""))
				}
			
				if(length(names)>1)
				{
					for (name in 1:tot)
					{
						loop <- loop + 1
						if (loop > 1)
						{
							system(paste("sox",tempoutwav,names[loop],filename))
						}
				
						if (loop==1)
						{
							system(paste("sox",names[1],names[2],filename))
							loop <- loop+1
						}
						file.copy(fn,paste(comArgs[1],"joined_clusters_pie/tempout.wav",sep=""),overwrite=TRUE)
					}
				unlink(paste(comArgs[1],"joined_clusters_pie/tempout.wav",sep=""))
				}
			}
			
			syntax <- groups[,2]
			names(syntax) <- grep(".",names(syntax))
			syntax[is.na(syntax)] <- "none"
			
			#dir.create(paste(comArgs[1],"sorted_syllables_pie/",sep=""))
			clusters = unique(syntax)
			all.files <- list.files(comArgs[1],pattern="*.wav$")
			
			for (name in clusters)
			{
				syls = subset(syntax,syntax==name)
				newnames <- vector()
				for (name2 in names(syls))
				{
					name.assign <- paste("%0",maxNames,"d",sep="")
					name.out <- sprintf(name.assign,as.numeric(name2))
					if(!Sys.info()['sysname']=="Darwin") {name.out <- gsub(" ",0,name.out)}
					newnames <- c(newnames,name.out)
				}
				names(syls) <- gsub('\\.',"-",names(syls))
			
				file2 = paste(newnames,"wav",sep=".")
		
				for (wav in file2)
				{
					if (!file.exists(paste(comArgs[1],"sorted_syllables_pie/",name,sep='')))
					{
						dir.create(paste(comArgs[1],"/sorted_syllables_pie/",name,sep=''))
					}
				
					file.copy(from=paste(comArgs[1],wav,sep=''),to=paste(comArgs[1],"sorted_syllables_pie/",name,sep=''))
				}		
			}
			
			cTable.temp <- clusterTableCreateNoData(groups[,1])
			if(file.exists(paste(comArgs[1],"joined_clusters_clusters",sep=""))){unlink(paste(comArgs[1],"joined_clusters_clusters",sep=""),recursive=TRUE)}
			if(file.exists(paste(comArgs[1],"sorted_syllables_clusters",sep=""))){unlink(paste(comArgs[1],"sorted_syllables_clusters",sep=""),recursive=TRUE)}
			dir.create(paste(comArgs[1],"joined_clusters_clusters",sep=""))
			dir.create(paste(comArgs[1],"sorted_syllables_clusters",sep=""))
			maxNames <- max(nchar(gsub(".wav","",list.files(comArgs[1],pattern="*.wav$"))))
			
			for(group in names(cTable.temp))
			{
				#print(paste("Joining syllables for cluster: ",group))
				filename <- paste(comArgs[1],"joined_clusters_clusters/",group,".wav",sep="")
				fn <- filename
				filename <- gsub(" ","\\\\ ",filename)
				namesIn <- cTable.temp[[group]]
				names <- vector()
				
				for (name in namesIn)
				{
					name.assign <- paste("%0",maxNames,"d",sep="")
					newName <- sprintf(name.assign,as.numeric(name))
					if(!Sys.info()['sysname']=="Darwin") {name.assign <- gsub(" ",0,newName)}
					names <- c(names,newName)
				}
				
				names <- paste(comArgs[1],names,".wav",sep="")
				names <- gsub(" ","\\\\ ",names)
				
				outwav <- paste(filename)
				tempoutwav <- paste(comArgs[1],"joined_clusters_clusters/tempout.wav",sep="")	
				tempoutwav <- gsub(" ","\\\\ ",tempoutwav)
				loop <- 0
				tot <- length(names)-1
				
				if(length(names)==1)
				{
					file.copy(names,paste(comArgs[1],"joined_clusters_clusters/",group,".wav",sep=""))
				}
				
				if(length(names)>1)
				{
					for (name in 1:tot)
					{
						loop <- loop + 1
						if (loop > 1)
						{
							system(paste("sox",tempoutwav,names[loop],filename))
						}
				
						if (loop==1)
						{
							system(paste("sox",names[1],names[2],filename))
							loop <- loop+1
						}
						file.copy(fn,paste(comArgs[1],"joined_clusters_clusters/tempout.wav",sep=""),overwrite=TRUE)
					}
				unlink(paste(comArgs[1],"joined_clusters_clusters/tempout.wav",sep=""))
				}
			}
			
			syntax <- groups[,1]
			names(syntax) <- grep(".",names(syntax))
			syntax[is.na(syntax)] <- "none"
		
			#dir.create(paste(comArgs[1],"sorted_syllables_clusters/",sep=""))
			clusters = unique(syntax)
			all.files <- list.files(comArgs[1],pattern="*.wav$")
			for (name in clusters)
			{
				syls = subset(syntax,syntax==name)
				newnames <- vector()
				for (name2 in names(syls))
				{
					name.assign <- paste("%0",maxNames,"d",sep="")
					name.out <- sprintf(name.assign,as.numeric(name2))
					if(!Sys.info()['sysname']=="Darwin") {name.out <- gsub(" ",0,name.out)}
					newnames <- c(newnames,name.out)
				}
				names(syls) <- gsub('\\.',"-",names(syls))
			
				file2 = paste(newnames,"wav",sep=".")
		
				for (wav in file2)
				{
					if (!file.exists(paste(comArgs[1],"sorted_syllables_clusters/",name,sep='')))
					{
						dir.create(paste(comArgs[1],"/sorted_syllables_clusters/",name,sep=''))
					}
				
				file.copy(from=paste(comArgs[1],wav,sep=''),to=paste(comArgs[1],"sorted_syllables_clusters/",name,sep=''))
				}		
			}
}else if(.Platform$OS.type=="windows"){
	comArgs <- commandArgs(TRUE)
	
	clusterTableCreateNoData = function(syntax)
	{
		clusters = unique(syntax)
		clusterTable = list()
		
		for (value in clusters)
		{
			tempClust = syntax[syntax==value]
			refs = names(tempClust)
			clusterTable[[value]] = refs
		}
		
		return(clusterTable)
	}
	
	load(paste(comArgs[1],"cluster_workspace.Rdata",sep=""))
	
	cTable.temp <- clusterTableCreateNoData(groups[,2])
	if(file.exists(paste(comArgs[1],"joined_clusters_pie",sep=""))){unlink(paste(comArgs[1],"joined_clusters_pie",sep=""),recursive=TRUE)}
	if(file.exists(paste(comArgs[1],"sorted_syllables_pie",sep="")))
	{unlink(paste(comArgs[1],"sorted_syllables_pie",sep=""),recursive=TRUE)}
	dir.create(paste(comArgs[1],"joined_clusters_pie",sep=""))
	dir.create(paste(comArgs[1],"sorted_syllables_pie",sep=""))
	maxNames <- max(nchar(gsub(".wav","",list.files(comArgs[1],pattern="*.wav$"))))
	
			for(group in names(cTable.temp))
			{
				#print(paste("Joining syllables for cluster: ",group))
				filename <- paste(comArgs[1],"joined_clusters_pie/",group,".wav",sep="")
				fn <- filename
				#filename <- gsub(" ","\\\\ ",filename)
				namesIn <- cTable.temp[[group]]
				names <- vector()
				
				for (name in namesIn)
				{
					name.assign <- paste("%0",maxNames,"d",sep="")
					newName <- sprintf(name.assign,as.numeric(name))
					if(!Sys.info()['sysname']=="Darwin") {name.assign <- gsub(" ",0,newName)}
					names <- c(names,newName)
				}
			
				names <- paste(comArgs[1],names,".wav",sep="")
				#names <- gsub(" ","\\\\ ",names)
			
				outwav <- paste(filename)
				tempoutwav <- paste(comArgs[1],"joined_clusters_pie/tempout.wav",sep="")
				#tempoutwav <- gsub(" ","\\\\ ",tempoutwav)	
				loop <- 0
				tot <- length(names)-1
			
				if(length(names)==1)
				{
					file.copy(names,paste(comArgs[1],"joined_clusters_pie/",group,".wav",sep=""))
				}
			
				if(length(names)>1)
				{
					for (name in 1:tot)
					{
						loop <- loop + 1
						if (loop > 1)
						{
							system(paste("sox",dQuote(tempoutwav),dQuote(names[loop]),dQuote(filename)))
						}
				
						if (loop==1)
						{
							system(paste("sox",dQuote(names[1]),dQuote(names[2]),dQuote(filename)))
							loop <- loop+1
						}
						file.copy(fn,paste(comArgs[1],"joined_clusters_pie/tempout.wav",sep=""),overwrite=TRUE)
					}
				unlink(paste(comArgs[1],"joined_clusters_pie/tempout.wav",sep=""))
				}
			}
			
			syntax <- groups[,2]
			names(syntax) <- grep(".",names(syntax))
			syntax[is.na(syntax)] <- "none"
			
			#dir.create(paste(comArgs[1],"sorted_syllables_pie/",sep=""))
			clusters = unique(syntax)
			all.files <- list.files(comArgs[1],pattern="*.wav$")
			
			for (name in clusters)
			{
				syls = subset(syntax,syntax==name)
				newnames <- vector()
				for (name2 in names(syls))
				{
					name.assign <- paste("%0",maxNames,"d",sep="")
					name.out <- sprintf(name.assign,as.numeric(name2))
					if(!Sys.info()['sysname']=="Darwin") {name.out <- gsub(" ",0,name.out)}
					newnames <- c(newnames,name.out)
				}
				names(syls) <- gsub('\\.',"-",names(syls))
			
				file2 = paste(newnames,"wav",sep=".")
		
				for (wav in file2)
				{
					if (!file.exists(paste(comArgs[1],"sorted_syllables_pie/",name,sep='')))
					{
						dir.create(paste(comArgs[1],"/sorted_syllables_pie/",name,sep=''))
					}
				
					file.copy(from=paste(comArgs[1],wav,sep=''),to=paste(comArgs[1],"sorted_syllables_pie/",name,sep=''))
				}		
			}
			
			cTable.temp <- clusterTableCreateNoData(groups[,1])
			if(file.exists(paste(comArgs[1],"joined_clusters_clusters",sep=""))){unlink(paste(comArgs[1],"joined_clusters_clusters",sep=""),recursive=TRUE)}
			if(file.exists(paste(comArgs[1],"sorted_syllables_clusters",sep=""))){unlink(paste(comArgs[1],"sorted_syllables_clusters",sep=""),recursive=TRUE)}
			dir.create(paste(comArgs[1],"joined_clusters_clusters",sep=""))
			dir.create(paste(comArgs[1],"sorted_syllables_clusters",sep=""))
			maxNames <- max(nchar(gsub(".wav","",list.files(comArgs[1],pattern="*.wav$"))))
			
			for(group in names(cTable.temp))
			{
				#print(paste("Joining syllables for cluster: ",group))
				filename <- paste(comArgs[1],"joined_clusters_clusters/",group,".wav",sep="")
				fn <- filename
				#filename <- gsub(" ","\\\\ ",filename)
				namesIn <- cTable.temp[[group]]
				names <- vector()
				
				for (name in namesIn)
				{
					name.assign <- paste("%0",maxNames,"d",sep="")
					newName <- sprintf(name.assign,as.numeric(name))
					if(!Sys.info()['sysname']=="Darwin") {name.assign <- gsub(" ",0,newName)}
					names <- c(names,newName)
				}
				
				names <- paste(comArgs[1],names,".wav",sep="")
				#names <- gsub(" ","\\\\ ",names)
				
				outwav <- paste(filename)
				tempoutwav <- paste(comArgs[1],"joined_clusters_clusters/tempout.wav",sep="")	
				#tempoutwav <- gsub(" ","\\\\ ",tempoutwav)
				loop <- 0
				tot <- length(names)-1
				
				if(length(names)==1)
				{
					file.copy(names,paste(comArgs[1],"joined_clusters_clusters/",group,".wav",sep=""))
				}
				
				if(length(names)>1)
				{
					for (name in 1:tot)
					{
						loop <- loop + 1
						if (loop > 1)
						{
							system(paste("sox",dQuote(tempoutwav),dQuote(names[loop]),dQuote(filename)))
						}
				
						if (loop==1)
						{
							system(paste("sox",dQuote(names[1]),dQuote(names[2]),dQuote(filename)))
							loop <- loop+1
						}
						file.copy(fn,paste(comArgs[1],"joined_clusters_clusters/tempout.wav",sep=""),overwrite=TRUE)
					}
				unlink(paste(comArgs[1],"joined_clusters_clusters/tempout.wav",sep=""))
				}
			}
			
			syntax <- groups[,1]
			names(syntax) <- grep(".",names(syntax))
			syntax[is.na(syntax)] <- "none"
		
			#dir.create(paste(comArgs[1],"sorted_syllables_clusters/",sep=""))
			clusters = unique(syntax)
			all.files <- list.files(comArgs[1],pattern="*.wav$")
			for (name in clusters)
			{
				syls = subset(syntax,syntax==name)
				newnames <- vector()
				for (name2 in names(syls))
				{
					name.assign <- paste("%0",maxNames,"d",sep="")
					name.out <- sprintf(name.assign,as.numeric(name2))
					if(!Sys.info()['sysname']=="Darwin") {name.out <- gsub(" ",0,name.out)}
					newnames <- c(newnames,name.out)
				}
				names(syls) <- gsub('\\.',"-",names(syls))
			
				file2 = paste(newnames,"wav",sep=".")
		
				for (wav in file2)
				{
					if (!file.exists(paste(comArgs[1],"sorted_syllables_clusters/",name,sep='')))
					{
						dir.create(paste(comArgs[1],"/sorted_syllables_clusters/",name,sep=''))
					}
				
				file.copy(from=paste(comArgs[1],wav,sep=''),to=paste(comArgs[1],"sorted_syllables_clusters/",name,sep=''))
				}		
			}

}
	
	
