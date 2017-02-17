function [alldist,allGDdist]=similaritybatch_mouse(type)
format compact
format short g

%initialize
fs=250000;

if exist('type','var')==0;
    type=input('Please enter AV or Bgal (in single quotes):')
end

%p tables; located in matlab_functions/similarity
%load ptables
%load MADs

if strcmp('AV',type)==1 || exist('AV','var')==1;
    type=1;
    load AVptables
elseif strcmp('Bgal',type)==1 || exist('Bgal','var')==1
    type=2;
    load Bgalptables
end


winsize=10; %size of windows for SIMILARITY (~10 ms)
mindur=4; %# deviations from diagonal (feature windows are not directly proportional to ms)

ticID=tic;

savedir='~/Documents/SimilarityResults_Mouse';
if exist(savedir,'dir')==0
    cd ~/Documents
    mkdir('SimilarityResults_Mouse');
end


sounds1d=uigetdir('','Select the directory with files for Sound 1');
sound1ID=input('Name this set of sounds (e.g. MouseX_Pre): ','s');

sounds2d=uigetdir('','Select the directory with files for Sound 2');
sound2ID=input('Name this set of sounds (e.g. MouseX_Post): ','s');



%% find all .wav files in Sound 1/Sound 2 directories
% save in structure to save time

[Sound1,Sound2]=createSimStructure_mouse(winsize,sounds1d,sounds2d,type);
 save('loadthis')
%load loadthis
%% preallocate various matrices
%sim_all=cell(1,3,1);
%a{1,1,1}=[zeros(8)]%hint to Nancy for pre-allocation

fns=cell(1,2,1);

 msize=length(Sound1)*length(Sound2);
% msizeBIG=1e10;

fns1(msize,1)=0;
fns2(msize,1)=0;

localDistance(msize,1)=0;
meanLocalDist(msize,1)=0;
globalDistance(msize,1)=0;
meanDistG(msize,1)=0;

% alldist(msizeBIG,1)=0;
% allGDdist(msizeBIG,1)=0;


diffs=cell(1,5,1);
Entropy_diff(msize,1)=0;
AM_diff(msize,1)=0;
FM_diff(msize,1)=0;
Pitch_diff(msize,1)=0;


SimilarityBatch=cell(1,6,1);
similarity(msize,1)=0;
accuracy(msize,1)=0;
SeqMatch(msize,1)=0;
globalSim(msize,1)=0;

calcnum=0;
% szLDist=1;
% szGDist=1;

%% Start processing similarity
%for loop to process Sound 2, file j against all Sound 1 files(i)

ext='.wav';
%  b=length(Sound2);
%  o=randperm(b, 10);
for j=1:length(Sound2)
    fn2=Sound2(j).fn;
    cut=strfind(fn2(1,:),ext);
    filenum2=str2num(fn2(1:cut-1));
    
    Progress=sprintf('*************Working on all Sound 1 files vs. %s *************',fn2)
    
    %% read in Sound 1 files and scale by MAD
    for i=1:length(Sound1)
        ticID=tic;
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
        
        
        [localDistScore,feature_diffs]=calculateDistance_mouse(localDist,mindur,1,Entropy_dist,AM_dist,FM_dist,Pitch_dist);
        
        
        %accuracy distance
        localDistance(calcnum)=localDistScore;
        
        %                 % save lots of window by window distance measurements to calculate p value
        %                 szLD=numel(localDist);
        %                 allLDist=reshape(localDist,szLD,1);
        %                 alldist(szLDist:szLDist+szLD-1)=allLDist;
        %                 szLDist=szLDist+szLD;
        
        % Keep track of  feature distances
        Entropy_diff(calcnum)=feature_diffs{1};
        AM_diff(calcnum)=feature_diffs{2};
        FM_diff(calcnum)=feature_diffs{3};
        Pitch_diff(calcnum)=feature_diffs{4};

        %
        %% calculate global distance
        
        globalDist=pdist2(Sound1(i).Dl,Sound2(j).Dl);
        %globalDistScore=mean(diag(globalDist))
        
        [globalDistScore]=calculateDistance_mouse(globalDist,mindur,0,Entropy_dist,AM_dist,FM_dist,Pitch_dist);
        
        %similarity distance
        globalDistance(calcnum)=globalDistScore;
        
        %save lots of window by window distance measurements to calculate p value
        %         szGD=numel(globalDist);
        %         allGDist=reshape(globalDist,szGD,1);
        %         allGDdist(szGDist:szGDist+szGD-1)=allGDist;
        %         szGDist=szGDist+szGD;
        
        %% Assign p-value to distance scores & calculate global similarity
        
        overallDistanceACC=p_accuracy(:,1);
        %distance score corresponding to p-value table
        %[C I] = min(abs(a - k)); %ignore C %k=Euclidean distance score
        [C I] = min(abs(overallDistanceACC-localDistScore));
        acc=1-p_accuracy(I,2);
        
        overallDistanceSIM=p_similarity(:,1);
        [C I] = min(abs(overallDistanceSIM-globalDistScore));
        sim=1-p_similarity(I,2);
        
        % Determine sequential match score % ratio of Sound 1 to Sound 2
        
        maxwv=max(Sound1(i).wavlen,Sound2(j).wavlen);
        minwv=min(Sound1(i).wavlen,Sound2(j).wavlen);
        SequentialMatch=minwv/maxwv;
        
        %Determine global similarity
        gloSim=acc*sim*SequentialMatch;
        
        %% stuff to save
        fns1(calcnum)=i;
        fns2(calcnum)=j;
        
        %the good stuff
        similarity(calcnum)=sim;
        accuracy(calcnum)=acc;
        SeqMatch(calcnum)=SequentialMatch;
        
        globalSim(calcnum)=gloSim;
        %toc(ticID)
        
    end
end
%% Save!
sprintf('Saving!')
save('inprogress.mat','-v7.3')
%alldist=alldist(1:szLDist,:);   % remove excess
%AllGDdist=allGDdist(1:szGDist,:);   % remove excess
globalDistance=globalDistance(1:calcnum,:);
localDistance=localDistance(1:calcnum,:);
%save('Distances','alldist','allGDdist','-v7.3')%'globalDistance','localDistance',)%,'diffs')


cd(savedir);
savenameSB=strcat('SimilarityBatch_',sound1ID,'_', sound2ID);
savenameInfo=strcat('Info_',sound1ID,'_', sound2ID);



fns1=fns1(1:calcnum);
fns2=fns2(1:calcnum);

similarity=similarity(1:calcnum,:);
accuracy=accuracy(1:calcnum,:);
SeqMatch=SeqMatch(1:calcnum,:);
globalSim=globalSim(1:calcnum,:).*100;

diffs={Entropy_diff AM_diff FM_diff Pitch_diff};

SimilarityBatch={fns1 fns2 similarity accuracy SeqMatch globalSim};


save(savenameSB,'SimilarityBatch','fns1','fns2','similarity','accuracy' ,'SeqMatch', 'globalSim');
tosave=[fns1 fns2 similarity accuracy SeqMatch globalSim];% Entropy_diff AM_diff FM_diff Pitch_diff PGood_diff];
save(savenameInfo,'globalDistance','localDistance','fns1', 'fns2','diffs','calcnum','mindur','winsize'),%'tosave')%'alldist','allGDdist','szLDist','szGDist',
%save('OferStyle','ofer','oferEnt','oferAM','oferFM','oferPitch','oferPGood')
toc(ticID)

dlmwrite(savenameSB,tosave);
%delete inprogress.mat
end
