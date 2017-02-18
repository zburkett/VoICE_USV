function [Sound1,Sound2,same]=createSimStructure_mouse(winsize,datadir,type)
%function [Sound1,Sound2,same]=createSimStructure_mouse(winsize,sounds1d,sounds2d,type)

filenum=0;
%cd(sounds1d);
cd(datadir)
% sortdir=cd;
% f=findstr('/',sounds1d);
% fldr=sortdir(f(end)+1:end);

% % dfiles = dir;
% % files = [];
% %
% % for i = 1:length(dfiles)
% %     if ~isempty(findstr(dfiles(i).name, '.wav')) && dfiles(i).isdir==0
% %         files = [files i];
% %     end;
% % end;
% % s1_files = dfiles(files);
%
% if strncmp(fldr,'sorted_syllables',2)==1;%this is a sorted_syllables folder
%     s1_files=0;
%     clusterdirs = dir(sortdir);
%     clusterdirs = clusterdirs([clusterdirs.isdir]);
%     clusterdirs = clusterdirs(arrayfun(@(x) x.name(1), clusterdirs) ~= '.');
%
%
%     for j=1:length(clusterdirs)
%         tocd=clusterdirs(j).name;
%         cd(tocd);
%
%
%         dfiles = dir;
%         files = [];
%         for i = 1:length(dfiles)
%             if ~isempty(findstr(dfiles(i).name, '.wav')) && dfiles(i).isdir==0
%                 files = [files i];
%             end;
%         end;
%         ss_files=dfiles(files);
%
%         for k=1:length(ss_files)
%             fn=ss_files(k).name;
%             wv=audioread(fn);
%             filenum=filenum+1;
%
%             [features,m_Entropy,m_FM,m_AM,m_Pitch]=deriv_mouse(wv);
%
%             %size(m_spec_deriv)
%
%             [window_specs,totwins]=binUSVwins(features); %turn small windows into bigger windows of ~1ms
%             [scaledOutput]=scaleFeatures_mouse(type,window_specs)%scale features
%
%             totwins=length(window_specs(:,1));
%
%             [windows]=createTimeWindows(totwins,winsize);
%
%             m_EntropyS1=wvScaled(:,1);
%             m_FMS1=wvScaled(:,2);
%             m_AMS1=wvScaled(:,3);
%             m_PitchS1=wvScaled(:,4);
%
%             %get mean spectral feature values in windows;
%             [global_specs]=parseSpectralFeatures(windows,m_EntropyS1,m_FMS1, m_AMS1, m_PitchS1);
%
%             Sound1(filenum).fn=fn;
%             %             Sound1(filenum).scaled=wvScaled;
%             %             Sound1(filenum).Dl=global_specs;
%             Sound1(filenum).wavlen=length(wv);
%             Sound1(filenum).totwins=totwins;
%             Sound1(filenum).wins=length(windows);
%         end
%         cd ..
%     end
%
% else
dfiles = dir;
files = [];

for i = 1:length(dfiles)
    if ~isempty(findstr(dfiles(i).name, '.wav')) && dfiles(i).isdir==0
        files = [files i];
    end;
end;
s1_files = dfiles(files);

    num=length(s1_files)
    if num>=10 && num<=99
        total_digits=2;
    elseif num>=100 && num<=999
        total_digits=3;
    else total_digits=4;
    end

if ~exist('originals','dir')
    mkdir('originals')
end

for i=1:length(s1_files);
    fn=s1_files(i).name;
    wv=audioread(fn);
    movefile(s1_files(i).name,'originals')
    wvname=sprintf('%0*d',total_digits,i);
    audiowrite(strcat([wvname,'.wav']),wv,250000);
    filenum=filenum+1;
    
    [features]=deriv_mouse(wv);
    
    %size(m_spec_deriv)
    
    [window_specs,totwins]=binUSVwins(features); %turn small windows into bigger windows of ~1ms
    %[scaledOutput]=scaleFeatures_mouse(type,window_specs);%scale features
    
    totwins=length(window_specs(:,1));
    [windows]=createTimeWindows(totwins,winsize); %winsize=10 -- looks to separate out shorts
    
    %         m_EntropyS1=window_specs(:,1);
    %         m_FMS1=window_specs(:,2);
    %         m_AMS1=window_specs(:,3);
    %         m_PitchS1=window_specs(:,4);
    
    
    %get mean spectral feature values in windows;
    %[global_specs]=parseSpectralFeatures_mouse(windows,scaledOutput);
    [global_specs]=parseSpectralFeatures_mouse(windows,window_specs);
    
    Sound1(i).fn=fn;
    Sound1(i).scaled=window_specs;
    Sound1(i).Dl=global_specs;
    Sound1(i).wavlen=length(wv)/250; %in milliseconds
    Sound1(i).wv=wv;
    
    
end
%    rename_USV(Sound1)
%end

% % Now, Sound Files
% %cd(sounds2d);
% cd(datadir)
% 
% dfiles = dir;
% files = [];
% 
% for i = 1:length(dfiles)
%     if ~isempty(findstr(dfiles(i).name, '.wav')) && dfiles(i).isdir==0
%         files = [files i];
%     end;
% end;
% s2_files = dfiles(files);
% 
% if ~isequal(s1_files,s2_files)%if structures aren't the same, read in second set of files; otherwise, skip to save time
%     same=0;
%     %        filenum=0;
%     for i=1:length(s1_files);
%         fn=s1_files(i).name;
%         wv=audioread(fn);
%         %            filenum=filenum+1;
%         
%         [features]=deriv_mouse(wv);
%         
%         %size(m_spec_deriv)
%         
%         [window_specs,totwins]=binUSVwins(features); %turn small windows into bigger windows of ~1ms
%         %[scaledOutput]=scaleFeatures_mouse(type,window_specs,m_amplitude);%scale features
%         
%         totwins=length(window_specs(:,1));
%         [windows]=createTimeWindows(totwins,winsize); %winsize=10 -- looks to separate out shorts
%         
%         %         m_EntropyS2=window_specs(:,1);
%         %         m_FMS2=window_specs(:,2);
%         %         m_AMS2=window_specs(:,3);
%         %         m_PitchS2=window_specs(:,4);
%         
%         
%         %get mean spectral feature values in windows;
%         %[global_specs]=parseSpectralFeatures_mouse(windows,scaledOutput);
%         [global_specs]=parseSpectralFeatures_mouse(windows,window_specs);
%         
%         Sound2(i).fn=fn;
%         Sound2(i).scaled=window_specs;
%         Sound2(i).Dl=global_specs;
%         Sound2(i).wavlen=length(wv)/250; %in milliseconds
%         Sound2(i).wv=wv;
%         
%         
%     end
%     %    rename_USV(Sound2)
% else
%     %sprintf('Sound1 and Sound2 files are the same')
    Sound2=Sound1;
    %same=1;
end

%save('loadthis','Sound1','Sound2')