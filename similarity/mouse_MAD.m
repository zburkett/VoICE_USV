function [Sound1]=mouse_MAD

MADEnt(70000,1)=0;
medEnt(70000,1)=0;
MADFM(70000,1)=0;
medFM(70000,1)=0;
MADAM(70000,1)=0;
medAM(70000,1)=0;
MADPitch(70000,1)=0;
medPitch(70000,1)=0;

dfiles = dir;
files = [];

for i = 1:length(dfiles)
    if ~isempty(findstr(dfiles(i).name, '.wav')) && dfiles(i).isdir==0
        files = [files i];
    end;
end;
files = dfiles(files);

totwins_s=1;
allwin=0;

for i=1:length(files);
    fn=files(i).name
    wv=wavread(fn);
    
    
    [features,m_Entropy,m_FM,m_AM,m_Pitch]=deriv_mouse(wv);
    
    
    %size(m_spec_deriv)
    
    [window_specs,totwins]=binUSVwins(features);
    %[wvScaled]=scaleFeatures(m_Entropy,m_FM, m_AM, log(m_Pitch),log(m_PitchGoodness),m_amplitude);
    %totwins=length(wvScaled(:,1));
    
    %         [windows]=createTimeWindows(totwins,winsize);
    %
    %         m_EntropyS1=window_specs(:,1);
    %         m_FMS1=window_specs(:,2);
    %         m_AMS1=window_specs(:,3);
    %         m_PitchS1=window_specs(:,4);
    
    
    %get mean spectral feature values in windows;
    %[global_specs]=parseSpectralFeatures_mouse(windows,m_EntropyS1,m_FMS1, m_AMS1, m_PitchS1);
    totwins_e=totwins_s+length(window_specs(:,1))-1;
    totwins_i=totwins_s:totwins_e;
    
    allwin=allwin+length(window_specs(:,1));

    
    Entropy(totwins_s:totwins_e)=window_specs(:,1);
    FM(totwins_s:totwins_e)=window_specs(:,2);
    AM(totwins_s:totwins_e)=window_specs(:,3);
    Pitch(totwins_s:totwins_e)=window_specs(:,4);
    
    %     Sound1(filenum).fn=fn;
    %     Sound1(filenum).Ent=window_specs(:,1);
    %     Sound1(filenum).FM=window_specs(:,2);
    %     Sound1(filenum).AM=window_specs(:,3);
    %     Sound1(filenum).Pitch=window_specs(:,4);
    %
    %         Sound1(filenum).MADEnt=mad(window_specs(:,1));
    %         Sound1(filenum).medEnt=median(window_specs(:,1));
    %         Sound1(filenum).MADFM=mad(window_specs(:,2));
    %         Sound1(filenum).medFM=median(window_specs(:,2));
    %         Sound1(filenum).MADAM=mad(window_specs(:,3));
    %         Sound1(filenum).medAM=median(window_specs(:,3));
    %         Sound1(filenum).MADPitch=mad(window_specs(:,4));
    %         Sound1(filenum).medPitch=median(window_specs(:,4));
    
    %     Sound1(filenum).wavlen=length(wv)/250;
    %     Sound1(filenum).wins=length(window_specs);
    %     Sound1(filenum).totwins=totwins;
    

    
    totwins_s=totwins_e+1;
    
end

Entropy=Entropy(1:allwin);
FM=FM(1:allwin);
AM=AM(1:allwin);
Pitch=Pitch(1:allwin);

    MADEnt=mad(Entropy(1:allwin));
    medEnt=median(Entropy(1:allwin));
    MADFM=mad(FM(1:allwin));
    medFM=median(FM(1:allwin));
    MADAM=mad(AM(1:allwin));
    medAM=median(AM(1:allwin));
    MADPitch=mad(Pitch(1:allwin));
    medPitch=median(Pitch(1:allwin));
save('USVinfo', 'MADEnt','medEnt','MADFM','medFM','MADAM','medAM','MADPitch','medPitch','Entropy','FM','AM','Pitch');
