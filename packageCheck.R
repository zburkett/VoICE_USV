chooseCRANmirror(ind=1)
print('Checking to see if you have all the required R packages...')
deps = tools::package_dependencies("WGCNA",recursive=T)[[1]]
inst = installed.packages()
toInstall = deps[!deps%in%inst[,1]]

if(length(toInstall)>0)
{
	print('Installing missing R packages. Please wait. You should only have to do this once.')
	for(pkg in toInstall)
	{
		print(pkg)
		source("https://bioconductor.org/biocLite.R")
		res = try(install.packages(pkg))
		if(class(res)=="try-error")
		{
			res2 = biocLite(pkg)
		}

		if (class(res2)=="try-error")
		{
			stop(paste('Unable to install R package', pkg,". Please try to troubleshoot this yourself."))
		}
	}
}else{
	print('All packages found. Proceeding.')
}

