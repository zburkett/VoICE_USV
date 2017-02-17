function similarity_batch_parallel2
format compact
format short g

sz=matlabpool('size');
if sz~=0
    matlabpool('close')
end
%initialize
fs=44100;

winsize=41; %size of windows for SIMILARITY (~50 ms)
mindur=6; %# deviations from diagonal (feature windows are not directly proportional to ms)


ticID=tic;

savedir='~/Documents/SimilarityResults';
if exist(savedir,'dir')==0
    cd ~/Documents
    mkdir('SimilarityResults');
end

% read in sound a
sounds1d=uigetdir('','Select the directory with files for Sound 1');
sound1ID=input('Name this set of sounds (e.g. BirdX_Pre): ','s');

sounds2d=uigetdir('','Select the directory with files for Sound 2');
sound2ID=input('Name this set of sounds (e.g. BirdX_Post): ','s');

%p tables; located in matlab_functions/similarity
%load ptables
%load MADs

%% find all .wav files in Sound 1/Sound 2 directories
% save in structure to save time

[Sound1,Sound2]=createSimStructure(mindur,winsize,sounds1d,sounds2d);


%% preallocate various matrices
fns=zeros(length(Sound1),length(Sound2));
fns2=zeros(length(Sound1),length(Sound2));

localDistance=zeros(length(Sound1),length(Sound2));
globalDistance=zeros(length(Sound1),length(Sound2));

Entropy_diff=zeros(length(Sound1),length(Sound2));
AM_diff=zeros(length(Sound1),length(Sound2));
FM_diff=zeros(length(Sound1),length(Sound2));
Pitch_diff=zeros(length(Sound1),length(Sound2));
PGood_diff=zeros(length(Sound1),length(Sound2));

similarity=zeros(length(Sound1),length(Sound2));
accuracy=zeros(length(Sound1),length(Sound2));
SeqMatch=zeros(length(Sound1),length(Sound2));
globalSim=zeros(length(Sound1),length(Sound2));

allGDist = [];
allLdist = [];

%% Start processing similarity
%for loop to process Sound 2, file j against all Sound 1 files(i)

ext='.wav';

matlabpool %spawn workers, equal to WorkNum dictated in P
%o=randperm(463, 10);
%o=randperm(453,50);
%N=floor(length(Sound2)/2);
N=6;
parfor_progress(N);
parfor j=1:N
    fn2=Sound2(j).fn;
    cut=strfind(fn2(1,:),ext);
    filenum2=str2num(fn2(1:cut-1));
    totwins2 = length(Sound2(j).scaled);
%     allGDdist = [];
%     alldist = [];
    
    %create temporary storage within parfor loop
    tmpLocalDistance = zeros(length(Sound1),1);
    tmpEntropy_diff = zeros(length(Sound1),1);
    tmpAM_diff = zeros(length(Sound1),1);
    tmpFM_diff = zeros(length(Sound1),1);
    tmpPitch_diff = zeros(length(Sound1),1);
    tmpPGood_diff = zeros(length(Sound1),1);
    tmpfns1 = zeros(length(Sound1),1);
    tmpfns2 = zeros(length(Sound1),1);
    tmpSimilarity = zeros(length(Sound1),1);
    tmpAccuracy = zeros(length(Sound1),1);
    tmpSeqMatch = zeros(length(Sound1),1);
    tmpGlobalSim = zeros(length(Sound1),1);
    tmpGlobalDistance = zeros(length(Sound1),1);
    tmpallGdist=[];
    tmpalldist=[];
    szLDist=1;
    szGDist=1;
    
    %% read in Sound 1 files and scale by MAD
    for i=1:length(Sound1)
        
        
        fn1=Sound1(1).fn;
        cut=strfind(fn1(1,:),ext);
        filenum1=str2num(fn1(1:cut-1));
        totwins1 = length(Sound1(i).scaled)
        
        %% calculate local distance using matlab's pdist2
        
        localDist=pdist2(Sound1(i).scaled,Sound2(j).scaled);
        Entropy_dist=pdist2(Sound1(i).scaled(:,1),Sound2(j).scaled(:,1));
        AM_dist=pdist2(Sound1(i).scaled(:,2),Sound2(j).scaled(:,2));
        FM_dist=pdist2(Sound1(i).scaled(:,3),Sound2(j).scaled(:,3));
        Pitch_dist=pdist2(Sound1(i).scaled(:,4),Sound2(j).scaled(:,4));
        PGood_dist=pdist2(Sound1(i).scaled(:,5),Sound2(j).scaled(:,5));
        
        [localDistScore,feature_diffs]=calculateDistance(localDist,mindur,1,Entropy_dist,AM_dist,FM_dist,Pitch_dist,PGood_dist);
        
        %accuracy distance
        tmpLocalDistance(i,1)=localDistScore;
        
        % save lots of window by window distance measurements to calculate p value
        szLD=numel(localDist);
        allLDist=reshape(localDist,szLD,1);
        %tmpalldist(szLDist:szLDist+szLD-1)=allLDist;
        %szLDist=szLDist+szLD;
        tmpalldist = [tmpalldist; allLDist];
        
        %         % Keep track of  feature distances
        %         tmpEntropy_diff(i,1)=feature_diffs{1};
        %         tmpAM_diff(i,1)=feature_diffs{2};
        %         tmpFM_diff(i,1)=feature_diffs{3};
        %         tmpPitch_diff(i,1)=feature_diffs{4};
        %         tmpPGood_diff(i,1)=feature_diffs{5};
        %
        %% calculate global distance
        
        globalDist=pdist2(Sound1(i).Dl,Sound2(j).Dl);
        
        [globalDistScore]=calculateDistance(globalDist,mindur,0,Entropy_dist,AM_dist,FM_dist,Pitch_dist,PGood_dist);
        
        %similarity distance
        tmpGlobalDistance(i,1)=globalDistScore;
        
        %save lots of window by window distance measurements to calculate p value
        szGD=numel(globalDist);
        allGDist=reshape(globalDist,szGD,1);
        %tmpallGDdist(szGDist:szGDist+szGD-1)=allGDist;
        %szGDist=szGDist+szGD;
        
        tmpallGdist = [tmpallGdist; allGDist];
        
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
        %         tmpfns1(i,1)=i;
        %         tmpfns2(i,1)=j;
        %
        %         %the good stuff
        %         tmpSimilarity(i,1)=sim;
        %         tmpAccuracy(i,1)=acc;
        %         tmpSeqMatch(i,1)=SequentialMatch;
        %
        %         tmpGlobalSim(i,1)=gloSim;
        %
    end
    %     similarity(:,j) = tmpSimilarity;
    %     accuracy(:,j) = tmpAccuracy;
    %     SeqMatch(:,j) = tmpSeqMatch;
    %     globalSim(:,j) = tmpGlobalSim;
    %     Entropy_diff(:,j) = tmpEntropy_diff;
    %     AM_diff(:,j) = tmpAM_diff;
    %     FM_diff(:,j) = tmpFM_diff;
    %     Pitch_diff(:,j) = tmpPitch_diff;
    %     PGood_diff(:,j) = tmpPGood_diff;
    %     fns(:,j) = tmpfns1;
    %     fns2(:,j) = tmpfns2;
    %     localDistance(:,j) = tmpLocalDistance;
    %     globalDistance(:,j) = tmpGlobalDistance;
    
    %save('distnums','alldist','allGDdist','-append','alldist','allGDdist');
     allGDist= [allGDdist; tmpallGdist];
     allLdist = [alldist; tmpalldist];
parfor_progress;
end
parfor_progress(0);
matlabpool close %close all spawned workers

%% Save!

toc(ticID)

save('inprogress.mat')
sprintf('Saving!')
cd(savedir);
save('Distances','allGDist','allLdist')
outmatrix = [transpose(fns(:)') transpose(fns2(:)') transpose(similarity(:)') transpose(accuracy(:)') transpose(SeqMatch(:)') transpose(globalSim(:)') transpose(Pitch_diff(:)') transpose(FM_diff(:)') transpose(Entropy_diff(:)') transpose(PGood_diff(:)') transpose(AM_diff(:)') transpose(localDistance(:)') transpose(globalDistance(:)')];

savenameSB=strcat('SimilarityBatch_',sound1ID,'_', sound2ID);
csvwrite(savenameSB,outmatrix)

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


