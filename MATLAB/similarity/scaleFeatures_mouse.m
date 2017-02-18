function [scaledOutput]=scaleFeatures_mouse(type,window_specs,m_amplitude)

if type==2; %Bgal
    median_sylls=[-3.8201 32.9182 0.0088 11.291]; 
    mad_sylls=[1.0618 18.4978 0.0981 0.14009];
else type==1; %AV
    median_sylls=[-3.9812 31.1847 -0.0106 11.133]; 
    mad_sylls=[1.3015 18.1691 0.0974 0.014324];
end

            m_Entropy=window_specs(:,1);
            m_FM=window_specs(:,2);
            m_AM=window_specs(:,3);
            m_Pitch=window_specs(:,4);
            m_amplitude=window_specs(:,5);

% discard windows with low amplitude (less than 18.5)
    amp_cut=min(m_amplitude);%18.5; %anything lower likely signals silence
    amplitude=m_amplitude;
    windowstouse=find(amplitude(:,1)>=amp_cut);

%to scale features, subtract median and then multiply by MAD
features=[m_Entropy(windowstouse)  m_FM(windowstouse)  m_AM(windowstouse)  m_Pitch(windowstouse)];

totwins=length(m_Entropy); %any feature will do

for j=1:size(features,2)
    for i=1:totwins
    window_Scaled(i,j)=(features(i,j)-median_sylls(j))/mad_sylls(j);
    end
end

m_Entropy=window_Scaled(:,1);
m_FM=window_Scaled(:,2);
m_AM=window_Scaled(:,3);
m_Pitch=window_Scaled(:,4);

scaledOutput=[m_Entropy m_FM m_AM m_Pitch];