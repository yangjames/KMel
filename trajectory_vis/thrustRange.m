function [minT maxT] = thrustRange(s)
%calcualtes the minimum and maximum thrust requires durring a trajectory

    if ~isempty(s)
        acc_mags = zeros(length(s), length(s(1).a));
        for i=1:length(s)
            acc_g = s(i).a + 9.8.*[zeros(1,length(s(i).a)); zeros(1,length(s(i).a)); ones(1,length(s(i).a))];
            for j = 1:length(acc_g)
                acc_mags(i,j) = norm(acc_g(:,j));
            end
            
        end
        maxA = max(max(acc_mags));
        maxT = maxA/9.8;

        minA = min(min(acc_mags)); % we need to take into account the direction
        minT = minA/9.8;
    end

end
