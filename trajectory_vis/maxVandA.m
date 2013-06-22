function [maxV, maxA] = maxVandA(s)

if ~isempty(s)
    
    for i=1:length(s)
        
        vel_mags=zeros(length(s), length(s(1).vel));
        for j = 1:length(s(1).vel)
            vel_mags(i,j) = norm(s(i).vel(:,j));
        end
        acc_mags=zeros(length(s), length(s(1).a));
        for j = 1:length(s(1).a)
            acc_mags(i,j) = norm(s(i).a(:,j));
        end
        maxV = max(max(vel_mags));
        maxA = max(max(acc_mags));
    end
end
end
