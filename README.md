VoICE_USV
========
Vocal Inventory Clustering Engine -- Ultrasonic Vocalizations

Zachary Burkett

http://www.nature.com/articles/srep10237

AUTHOR/SUPPORT
==============
Zachary Burkett, zburkett@ucla.edu

MANUAL
======
TBD

DIRECTORY CONTENTS
==================
  * TBD


INSTALLATION
=====================

Download this directory and unzip to a location in which you would like to store the software.

Add the unzipped directory with subfolders to your MATLAB path. Optionally, you may remove the .git/ subfolders.

Mac OS X
--------
VoICE_USV relies on external software that must be installed prior to running VoICE_USV. VoICE_USV will check for these programs and halt if they are not found. 

Instructions below will install Homebrew and then SoX. If you wish to install SoX by some other means, just be sure that it's accessible via the command line.

To install SoX:
```bash
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Once Homebrew installation is finished, install SoX
brew install sox
```

VoICE_USV also relies on R. R should be included with Mac OS X. If for some reason it is missing, please download and install R from https://cloud.r-project.org or by:
```bash
# Install Homebrew if not already done for SoX:
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install R
brew tap homebrew/science
brew install Caskroom/cask/xquartz
brew install r
```

Windows
-------
VoICE_USV relies on external software that must be installed prior to running VoICE_USV. VoICE_USV will check for these programs and halt if they are not found. If they are installed but not in the system path, VoICE_USV will attempt to add them.

SoX is available here: https://sourceforge.net/projects/sox/files/sox/

R is available here: https://cloud.r-project.org

Developers
==========

STAR developers with write access to https://github.com/alexdobin/STAR can update the `STAR-Fusion`
submodule to a specific tag by following these steps:

```bash
git clone --recursive https://github.com/alexdobin/STAR.git
cd STAR
# or:
#
# git clone //github.com/alexdobin/STAR.git
# cd STAR
# git git submodule update --init --recursive

# checkout a specific tag for the submodule
cd STAR-Fusion
git checkout v0.3.1

# Commit the change
cd ../
git add STAR-Fusion
git commit -m "Updated STAR-Fusion to v0.3.1"

# Push the change to GitHub
git push
```


HARDWARE/SOFTWARE REQUIREMENTS
==============================
  * x86-64 compatible processors
  * 64 bit Linux or Mac OS X 
  * 30GB of RAM for human genome 


LIMITATIONS
===========
This release was tested with the default parameters for human and mouse genomes.
Please contact the author for a list of recommended parameters for much larger or much smaller genomes.
