function [mwindow_specs,totwins]=binUSVwins(features)
% for given length of sound chop up into windows of winsize (default 7msec)
% winss/winsa - windows for similarity (7ms) and accuracy (50), repectively
% feature order: %features={m_Entropy; m_FM; m_AM; m_Pitch};

%% SIMILARITY

totwins=length(features{1});
winsize=5; %6 windows per bin (~1ms at 250000 fs )

%identify indices of interest for ACCURACY
nwins=floor(totwins/winsize);
if nwins==0
    nwins=1;
end
winss=(1:nwins).*winsize;

windowss=zeros(nwins,2);
windowss(1,1)=1;
windowss(1,2)=winss(1,1);

if totwins>winsize
    for i=2:length(winss)
        if i<=length(winss)
            windowss(i,1)=windowss(i-1,2)+1;
            windowss(i,2)=winss(i);
        end
    end
else windowss=[1 totwins];
end


for j=1:length(features)
    
    for i=1:length(windowss(:,1))
        window_specs{i,j}=features{j}(windowss(i,1):windowss(i,2));
        mwindow_specs(i,j)=median(window_specs{i,j});
        %window_specsScaled(i,j)=mwindow_specs(i,j)/mad_allsylls(j);
    end
    
    
end