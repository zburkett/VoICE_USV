function similarity_colonyMAD

%this function determines the MAD across time windows for each feature
%all syllables must be in the same directory for this to run

median_allsyllsOfer=[-1.810 44.1 0 6.534 5.386];
mad_allsyllsOfer=[0.937 22.6 0.127 0.687 0.540];


format compact;
format short g;

fs=44100;
if exist('winsizes','var')==0
    winsizes=7; %default winsize is 7ms per Tchernichovski et al., 2000
    
end
if exist('winsizel','var')==0
    winsizel=50; %default winsize is 50ms per Tchernichovski et al., 2000
end



allsylls=[];
allsylls_s=[];
allsylls_l=[];


%% find all .wav files
dfiles = dir;
files = [];


for i = 1:length(dfiles)
    if ~isempty(findstr(dfiles(i).name, '.wav')) && dfiles(i).isdir==0
        files = [files i];
    end;
end;

files = dfiles(files);

for i=1:length(files)
    fn=files(i).name;
    
    wv=wavread(fn);
    
    [wv]=LPFilter(wv);
    
    %% Get spectral features from Sigal Saar's deriv.m function in SAMIII
    [m_spec_deriv , m_AM, m_FM ,m_Entropy , m_amplitude ,gravity_center, m_PitchGoodness , m_Pitch , Pitch_chose , Pitch_weight]=deriv2(wv);
    %{m_Entropy; m_FM; m_AM; m_Pitch; m_PitchGoodness}
    
    mean_syll=[mean(m_Entropy);mean(m_FM);mean(m_AM);log(mean(m_Pitch));log(mean(m_PitchGoodness))]';
    
    totwins=length(m_AM);%or any other feature
    
    %     %get 7ms (or other winsize) windows
    %     [windows,windowl]=determineSimWindows(totwins,winsizes,winsizel);
    %
    %     %get spectral feature values in windows
    %     [mwindow_specss,mwindow_specsl]=parseSpectralFeatures1(windows,windowl,m_Entropy,m_FM, m_AM, m_Pitch,m_PitchGoodness);%output is mean for feature in each window
    %
    
    %allsylls_s=[allsylls_s; mwindow_specss];
    %allsylls_l=[allsylls_l; mwindow_specsl];
    allsylls=[allsylls;mean_syll];
    
end

% mad_allsylls_s=mad(allsylls_s);
% mad_allsylls_l=mad(allsylls_l);
mad_allsylls=mad(allsylls); %for White Lab Colony
median_allsylls=median(allsylls);

save ('MADs', 'mad_allsylls', 'median_allsylls', 'mad_allsyllsOfer','median_allsyllsOfer')




