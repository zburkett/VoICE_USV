function similarityColony_batch(winsizeDs,winsizeDl)

%initialize
fs=44100;


format compact
format short g


fs=44100;
if exist('winsizeDs','var')==0
    winsizeDs=7; %default winsize is 7ms per Tchernichovski et al., 2000
    
end
if exist('winsizeDl','var')==0
    winsizeDl=50; %default winsize is 50ms per Tchernichovski et al., 2000
end

ticID=tic;

%% find all .wav files

dfiles = dir;
files = [];


for i = 1:length(dfiles)
    if ~isempty(findstr(dfiles(i).name, '.wav')) && dfiles(i).isdir==0
        files = [files i];
    end;
end;

files = dfiles(files);

sim_all=cell(1,4,1);
%a{1,1,1}=[zeros(8)]%hint to Nancy for pre-allocation
% sim_all{1,1}=[];zeros(length(files)^2,1);
similarity=[];zeros(length(files)^2,1);
accuracy=[];zeros(length(files)^2,1);
fns1=[];%zeros(length(files)^2,1);
fns2=[];%zeros(length(files)^2,1);

SimilarityBatch=cell(1,6,1);
similarity=zeros(length(s1_files)*length(s2_files),1);
accuracy=zeros(length(s1_files)*length(s2_files),1);
SeqMatch=zeros(length(s1_files)*length(s2_files),1);
globalSim=zeros(length(s1_files)*length(s2_files),1);


accuracy_distanceALL=[];
similarity_distanceALL=[];


%% Start processing similarity
%for loop to process Sound 2, file A against all Sound 1 files

n=length(files);

for j=1:length(files)
    fn2=files(j).name;
    Progress=sprintf('******************Working on: %s ******************',fn2)
    if floor(rem(j,n))==5
        sprintf(['Overall Percent done: ' floor(num2str((j/n)*100))])
        pause(0.25)
    end;
    
    
    wv=wavread(fn2);
    
    %get spectral features from Sigal Saar's deriv.m function in SAMIII
    [m_spec_deriv , AM, FM ,Entropy , m_amplitude ,gravity_center, PitchGoodness , Pitch , Pitch_chose , Pitch_weight]=deriv2(wv);
    
    totwins2=length(AM);
    
    %get 7ms (and other winsize) windows
    [windows2Ds,windows2Dl]=determineSimWindows(totwins2,winsizeDs,winsizeDl);
    
    windows=windows2Ds;
    windowl=windows2Dl;
    
    %get spectral feature values in windows
    [window_specs2Ds,mwindow_specs2Dl]=parseSpectralFeatures1(windows,windowl,Entropy,FM, AM, Pitch,PitchGoodness);%accuracy
    %[ms2windowDl_specs]=parseSpectralFeatures1(windows2Dl,Entropy,FM, AM, Pitch,PitchGoodness);%similarity
    
    %read in Sound 1 files
    for i=1:length(files)
        
        %         if floor(rem(i,25))==0
        %             sprintf(['Percent done (Sound 1, %s): ' num2str((i/n)*100)],fn1)
        %             pause(0.25)
        %         end;
        
        
        
        fn1=files(i).name;
        wv1=wavread(fn1);
        
        %get spectral features from Sigal Saar's deriv.m function in SAMIII
        [m_spec_deriv , AM, FM ,Entropy , m_amplitude ,gravity_center, PitchGoodness , Pitch , Pitch_chose , Pitch_weight]=deriv2(wv1);
        
        totwins1=length(AM);%any feature will do
        
        %get 7ms (or other winsize) windows
        [windows1Ds,windows1Dl]=determineSimWindows(totwins1,winsizeDs,winsizeDl);
        
        %get spectral feature values in windows;;
        [window_specs1Ds,mwindow_specs1Dl]=parseSpectralFeatures1(windows1Ds,windows1Dl, Entropy,FM, AM, Pitch,PitchGoodness);
        %[ms1windowDl_specs]=parseSpectralFeatures(windows1Dl,Entropy,FM, AM, Pitch,PitchGoodness)
        
        
        %construct a matrix of mean differences for SIMILARITY & ACCURACY SCORES
        
        
        accuracy_distance=pdist2(window_specs1Ds,window_specs2Ds); %Euclidean
        if ~isvector(accuracy_distance)
            mean_Euclidean_accuracy=mean(diag(accuracy_distance));
        else  mean_Euclidean_accuracy=accuracy_distance(1,1);
        end
        
        similarity_distance=pdist2(mwindow_specs1Dl,mwindow_specs2Dl);
        if ~isvector(similarity_distance)
            mean_Euclidean_similarity=mean(diag(similarity_distance));
        else  mean_Euclidean_similarity=similarity_distance(1,1);
        end
        
        %reshape to vector
        acc_nums=numel(accuracy_distance);
        sim_nums=numel(similarity_distance);
        
        accuracy_distanceAll=reshape(accuracy_distance,acc_nums,1);
        similarity_distanceAll=reshape(similarity_distance,sim_nums,1);
        
        accuracy_distanceALL=[accuracy_distanceALL; accuracy_distanceAll];
        similarity_distanceALL=[similarity_distanceALL; similarity_distanceAll];
        
        
        %sprintf('The accuracy distance for %s vs. %s is: %g \n',fn1,fn2,mean_Euclidean_accuracy)
        %sprintf('The similarity distance for %s vs. %s is: %g \n',fn1,fn2,mean_Euclidean_similarity)
        
        %similarity(i)=mean_Euclidean_similarity';
        %accuracy(i)=mean_Euclidean_accuracy'
        fns1=[fns1; fn1];
        fns2=[fns2; fn2];
        similarity=[similarity; mean_Euclidean_similarity];
        accuracy=[accuracy; mean_Euclidean_accuracy];
        
    end
    
end
sim_all={fns1 fns2 similarity accuracy};


save('colonyDistances','sim_all','fns1', 'fns2')
toc(ticID)
%% %write file
% [nrows,ncols]= size(sim_all);
%
%
% filename = 'ColonyDistances.dat';
% fid = fopen(filename, 'w');
%
% for row=1:nrows
%     fprintf(fid, '%s, %s, %d, %d \n', sim_all{row,:});
% end
%
% fclose(fid);

