VoICE_USV
========
Vocal Inventory Clustering Engine -- Ultrasonic Vocalizations

Zachary Burkett

http://www.nature.com/articles/srep10237

VoICE_USV is for analysis of rodent ultrasonic vocalizations. If you're interested in analyzing bird songs, go to [VoICE](https://github.com/zburkett/VoICE).

Author/Support
==============
Zachary Burkett, zburkett@ucla.edu

Manual
======
Coming Soon.

Directory Contents
==================
  * MATLAB: Contains all MATLAB functions
  * R: Contains all R functions
  * sample_data: Contains 20 .wav files of ultrasonic vocalizations, see walkthrough in the Manual
  * README.md: README, you're looking at it

Installation
=====================
Download this directory and unzip to a location in which you would like to store the software.

Typing 'voice_usv' at the MATLAB command prompt will launch the software following installation. Please see installation instructions for your operating system.

Add the unzipped directory with subfolders to your MATLAB path. Optionally, you may remove the .git/ subfolders.

Mac OS X
--------
VoICE_USV relies on free external software (SoX and R) that must be installed prior to running VoICE_USV. VoICE_USV will check for these programs and halt if they are not found. If they are installed but not in the system path, VoICE_USV will attempt to add them.

Instructions below will install Homebrew and then SoX. If you wish to install SoX by some other means, just be sure that it's accessible via the command line.

To install SoX:
```bash
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Once Homebrew installation is finished, install SoX
brew install sox
```

VoICE_USV also relies on R. R should be included with Mac OS X. If it is missing, please download and install R from https://cloud.r-project.org or by:
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
VoICE_USV relies on external software (SoX and R) that must be installed prior to running VoICE_USV. VoICE_USV will check for these programs and halt if they are not found. If they are installed but not in the system path, VoICE_USV will attempt to add them.

SoX is available here: https://sourceforge.net/projects/sox/files/sox/

R is available here: https://cloud.r-project.org

Software Requirements
=====================
  * MATLAB (Tested up through R2015a; unsure of support for more recent versions)
  * MATLAB Signal Processing Toolbox
  * R (See installation, above)
  * SoX (See installation, above)

Limitations
===========
Input calls must be provided as a single call per .wav file. We do not offer software to accomplish this since it is highly specific to the recording setup. Manual cutting of .wav files can be accomplished using any number of audio manipulation tools, such as Audacity (http://www.audacityteam.org).

Developers
==========

Pull requests are welcomed!