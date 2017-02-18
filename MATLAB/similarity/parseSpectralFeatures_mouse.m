function [mwindow_specs]=parseSpectralFeatures_mouse(windows,window_specs)


m_Entropy=window_specs(:,1);%scaledOutput(:,1);
m_FM=window_specs(:,2);%scaledOutput(:,2);
m_AM=window_specs(:,3);%scaledOutput(:,3);
m_Pitch=window_specs(:,4);%scaledOutput(:,4);

features={m_Entropy; m_FM; m_AM; m_Pitch};

for j=1:length(features)
    for i=1:length(windows(:,1))
        window_specs2{i,j}=features{j}(windows(i,1):windows(i,2));
        mwindow_specs(i,j)=mean(window_specs2{i,j});
    end
end

