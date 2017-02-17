function similarity_batch
format compact
format short g

%initialize
fs=44100;

winsize=40; %size of windows for SIMILARITY (~50 ms)
mindur=12; %# deviations from diagonal (feature windows are not directly proportional to ms)

ticID=tic;

savedir='~/Documents/SimilarityResults';
if exist(savedir,'dir')==0
    cd ~/Documents
    mkdir('SimilarityResults');
end

% read in sound a
sounds1d=uigetdir('','Select the directory with files for Sound 1');
sound1ID=input('Name this set of sounds (e.g. BirdX_Pre):','s');

sounds2d=uigetdir('','Select the directory with files for Sound 2');
sound2ID=input('Name this set of sounds (e.g. BirdX_Post)','s');

%p tables; located in matlab_functions/similarity
load ptables
load MADs

%% find all .wav files in Sound 1/Sound 2 directories
% save in structure to save time

[Sound1,Sound2]=createSimStructure(mindur,winsize,sounds1d,sounds2d);


%% preallocate various matrices
%sim_all=cell(1,3,1);
%a{1,1,1}=[zeros(8)]%hint to Nancy for pre-allocation

fns=cell(1,2,1);

msize=length(Sound1)*length(Sound2);
msizeBIG=1e10;

fns1(msize,1)=0;
fns2(msize,1)=0;

localDistance(msize,1)=0;
meanLocalDist(msize,1)=0;
globalDistance(msize,1)=0;
meanDistG(msize,1)=0;

alldist(msizeBIG,1)=0;
allGDdist(msizeBIG,1)=0;


diffs=cell(1,5,1);
Entropy_diff(msize,1)=0;
AM_diff(msize,1)=0;
FM_diff(msize,1)=0;
Pitch_diff(msize,1)=0;
PGood_diff(msize,1)=0;
%
% oferCalcs=cell(1,5,1);
% ofer=[];
% oferEnt=[];
% oferAM=[];
% oferFM=[];
% oferPitch=[];
% oferPGood=[];

% SimilarityBatch=cell(1,6,1);
similarity(msize,1)=0;
accuracy(msize,1)=0;
SeqMatch(msize,1)=0;
globalSim(msize,1)=0;

calcnum=0;
szLDist=1;
szGDist=1;

%% Start processing similarity
%for loop to process Sound 2, file j against all Sound 1 files(i)

ext='.wav';

o=randperm(463, 10);
for j=o%length(Sound2)
    fn2=Sound2(j).fn;
    cut=strfind(fn2(1,:),ext);
    filenum2=str2num(fn2(1:cut-1));
    
    Progress=sprintf('*************Working on all Sound 1 files vs. %s *************',fn2)
      
    %% read in Sound 1 files and scale by MAD
    for i=1:300%length(Sound1)
        
        calcnum=calcnum+1;
        fn1=Sound1(1).fn;
        cut=strfind(fn1(1,:),ext);
        filenum1=str2num(fn1(1:cut-1));
        
        %% calculate local distance using matlab's pdist2
        
        localDist=pdist2(Sound1(i).scaled,Sound2(j).scaled);
        
        Entropy_dist=pdist2(Sound1(i).scaled(:,1),Sound2(j).scaled(:,1));
        AM_dist=pdist2(Sound1(i).scaled(:,2),Sound2(j).scaled(:,2));
        FM_dist=pdist2(Sound1(i).scaled(:,3),Sound2(j).scaled(:,3));
        Pitch_dist=pdist2(Sound1(i).scaled(:,4),Sound2(j).scaled(:,4));
        PGood_dist=pdist2(Sound1(i).scaled(:,5),Sound2(j).scaled(:,5));
        
        [localDistScore,feature_diffs]=calculateDistance(localDist,mindur,1,Entropy_dist,AM_dist,FM_dist,Pitch_dist,PGood_dist);
        
        
        %accuracy distance
        localDistance(calcnum)=localDistScore;
        
        %         % save lots of window by window distance measurements to calculate p value
                szLD=numel(localDist);
                allLDist=reshape(localDist,szLD,1);
                alldist(szLDist:szLDist+szLD-1)=allLDist;
                szLDist=szLDist+szLD;
        
        %         % Keep track of  feature distances
        Entropy_diff(calcnum)=feature_diffs{1};
        AM_diff(calcnum)=feature_diffs{2};
        FM_diff(calcnum)=feature_diffs{3};
        Pitch_diff(calcnum)=feature_diffs{4};
        PGood_diff(calcnum)=feature_diffs{5};
        %
        %% calculate global distance
        
        globalDist=pdist2(Sound1(i).Dl,Sound2(i).Dl);
        
        [globalDistScore]=calculateDistance(globalDist,mindur,0,Entropy_dist,AM_dist,FM_dist,Pitch_dist,PGood_dist);
        
        %similarity distance
        globalDistance(calcnum)=globalDistScore;
        
        %         %save lots of window by window distance measurements to calculate p value
                szGD=numel(globalDist);
                allGDist=reshape(globalDist,szGD,1);
                allGDdist(szGDist:szGDist+szGD-1)=allGDist;
                szGDist=szGDist+szGD;
        
        %% Assign p-value to distance scores & calculate global similarity
        
%         overallDistanceACC=p_accuracy(:,1);
%         %distance score corresponding to p-value table
%         %[C I] = min(abs(a - k)); %ignore C %k=Euclidean distance score
%         [C I] = min(abs(overallDistanceACC-localDistScore));
%         acc=1-p_accuracy(I,2);
%         
%         overallDistanceSIM=p_similarity(:,1);
%         [C I] = min(abs(overallDistanceSIM-globalDistScore));
%         sim=1-p_similarity(I,2);
%         
%         % Determine sequential match score % ratio of Sound 1 to Sound 2
%         
%         maxwv=max(Sound1(i).wavlen-396,Sound2(j).wavlen-396);
%         minwv=min(Sound1(i).wavlen-396,Sound2(j).wavlen-396);
%         SequentialMatch=minwv/maxwv;
%         
%         %Determine global similarity
%         gloSim=acc*sim*SequentialMatch;
%         
%         %% stuff to save
%         fns1(calcnum)=filenum1;
%         fns2(calcnum)=filenum2;
%         
%         %the good stuff
%         similarity(calcnum)=sim;
%         accuracy(calcnum)=acc;
%         SeqMatch(calcnum)=SequentialMatch;
%         
%         globalSim(calcnum)=gloSim;
        
    end
end
%% Save!

toc(ticID)

save('inprogress.mat')

sprintf('Saving!')
cd(savedir);
savenameSB=strcat('SimilarityBatch_',sound1ID,'_', sound2ID);
savenameInfo=strcat('Info_',sound1ID,'_', sound2ID);

alldist=alldist(1:szLDist,:);   % remove excess
allGDdist=allGDdist(1:szGDist,:);   % remove excess

fns1=fns1(1:calcnum,:);
fns2=fns2(1:calcnum,:);
globalDistance=globalDistance(1:calcnum,:);
localDistance=localDistance(1:calcnum,:);
similarity=similarity(1:calcnum,:);
accuracy=accuracy(1:calcnum,:);
SeqMatch=SeqMatch(1:calcnum,:);
globalSim=globalSim(1:calcnum,:).*100;

diffs={Entropy_diff AM_diff FM_diff Pitch_diff PGood_diff};

SimilarityBatch={fns1 fns2 similarity accuracy SeqMatch globalSim};

save('Distances','globalDistance','localDistance','alldist','allGDdist')%,'diffs')
save(savenameSB,'SimilarityBatch','fns1','fns2','similarity','accuracy' ,'SeqMatch', 'globalSim');
tosave=[fns1 fns2 similarity accuracy SeqMatch globalSim];% Entropy_diff AM_diff FM_diff Pitch_diff PGood_diff];
save(savenameInfo,'globalDistance','localDistance','fns1', 'fns2','diffs','calcnum','mindur','winsize','tosave')%'alldist','allGDdist','szLDist','szGDist',
%save('OferStyle','ofer','oferEnt','oferAM','oferFM','oferPitch','oferPGood')
toc(ticID)

csvwrite(savenameSB,tosave);
%delete inprogress.mat
end


%% functions that similarity_batch calls

function [scaledOutput]=scaleFeatures(m_Entropy,m_FM, m_AM, m_Pitch,m_PitchGoodness,m_amplitude)

load MADs

% discard windows with low amplitude (less than 18.5)
amp_cut=min(m_amplitude);%18.5; %anything lower likely signals silence
amplitude=m_amplitude;
windowstouse=find(amplitude(:,1)>=amp_cut);

%to scale features, subtract median and then multiply by MAD
features=[m_Entropy(windowstouse)  m_FM(windowstouse)  m_AM(windowstouse)  m_Pitch(windowstouse)  m_PitchGoodness(windowstouse)];

totwins=length(m_Entropy); %any feature will do

for j=1:size(features,2)
    for i=1:totwins
        window_Scaled(i,j)=(features(i,j)-median_allsyllsOfer(j))/mad_allsyllsOfer(j);
    end
end

m_EntropyS=window_Scaled(:,1);
m_FMS=window_Scaled(:,2);
m_AMS=window_Scaled(:,3);
m_PitchS=window_Scaled(:,4);
m_PitchGoodnessS=window_Scaled(:,5);

scaledOutput=[m_EntropyS m_FMS m_AMS m_PitchS m_PitchGoodnessS];
end

function [windows]=createTimeWindows(totwins, winsize,mindur)

winNum=totwins-(winsize-1);
windows=[];

if totwins>winsize
    for i=1:winNum
        window=[i i+(winsize-1)];
        windows=[windows; window];
    end
else
    windows=[1 totwins];
end
end

function [mwindow_specs]=parseSpectralFeatures(windows,m_Entropy,m_FM, m_AM, m_Pitch,m_PitchGoodness)

features={m_Entropy; m_FM; m_AM; m_Pitch; m_PitchGoodness};

for j=1:length(features)
    for i=1:length(windows(:,1))
        window_specs{i,j}=features{j}(windows(i,1):windows(i,2));
        mwindow_specs(i,j)=mean(window_specs{i,j});
    end
end
end


