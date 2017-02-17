%function [localDistance,Entropy,FM,AM,Pitch,PGoodness]=local_dist(localDist,mindur)
function [localDistance]=local_dist(localDist,mindur)


%% initialize
count=0;
localDistsize=size(localDist);%note: change to localDist
lds1=localDistsize(1);
lds2=localDistsize(2);
mindim=min(lds1,lds2);
localmins=zeros(mindim,1);

% Entropy=zeros(mindim,1);
% FM=zeros(mindim,1);
% AM=zeros(mindim,1);
% Pitch=zeros(mindim,1);
% PGoodness=zeros(mindim,1);

%% main for loop for mindur/tolerance
for k=1:mindim%length(diag(localDist));
    maxIl_1=min(lds1,mindim);
    maxIl_2=min(lds2,mindim);
    max_indices=k:k+mindur-1;
%     mat_chunk=[k:k+mindur-1];
    
    if maxIl_1 >= max_indices & maxIl_2 >= max_indices %ok, proceed
        m=localDist(k:k+mindur-1,k:k+mindur-1);
        mat_chunka=k:k+mindur-1;mat_chunkb=k:k+mindur-1;
        count=count+1;
    elseif maxIl_1 >= max_indices & maxIl_2 <= max_indices
        m=localDist(k:k+mindur-1,k:maxIl_2);
        count=count+1
        matchunk_a=[k:k+mindur-1]; matchunk_b=[k:maxIl_2];
    elseif maxIl_1 <= max_indices & maxIl_2 >= max_indices
        m=localDist(k:maxIl_1,k:k+mindur-1)
        count=count+1;
        matchunk_a=[k:maxIl_1]; matchunk_b=[k:k+mindur-1];
    else
        m=localDist(k:mindim,k:mindim);
        count=count+1;
        matchunk_a=[k:mindim]; matchunk_b=[k:mindim];
    end
    
    % calculates minimum distance within mindur (default: 9 windows)
    meanDistL=[];

    for t=-mindur:mindur;
        diagonal=diag(m,t);
        diagDistL=mean(diag(m,t));
        if size(diagDistL,1)<size(diagDistL,2);
            diagDistL=nanmean(diagDistL,2);
        end
        if k==length(diag(localDist))%end
            diagDistL=m(1,1);
        end
        meanDistL=[meanDistL; diagDistL];
    end %calculates tolerance
    min(meanDistL)
    [minDistL, ILD]=min(meanDistL)
    localmins(count)=mean(minDistL);
    localDistance=mean(localmins);
    
    %return index of min diagonal for feature
    tolsLD=-mindur:mindur;
    tolILD=tolsLD(ILD);
    
    %feature measurements...
%     Entropy=mean(diag(Entropy_dist(mat_chunka, mat_chunkb),tolILD));
%     AM=mean(diag(AM_dist(mat_chunka, mat_chunkb),tolILD));
%     FM=mean(diag(FM_dist(mat_chunka, mat_chunkb),tolILD));
%     Pitch=mean(diag(Pitch_dist(mat_chunka, mat_chunkb),tolILD));
%     PGood=mean(diag(PGood_dist(mat_chunka, mat_chunkb),tolILD));
    
    
   
end
end

