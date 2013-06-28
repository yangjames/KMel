function compareVelocities(v1,v2)
%this function compares two arrays and if any corresponding values are too
%different the function will throw and error.
per_diff = zeros(1, length(v1));
per_thres = .8; % difference allowed
for i=1:length(v1)
    mag1 = norm(v1(:,i));
    mag2 = norm(v2(:,i));
    
    if mag1 > .1 && mag2 >.1 
        per_diff(1,i) = abs((norm(v1(:,i)) - norm(v2(:,i)))/norm(v2(:,i)));
    end
end

[max_diff, index] = max(per_diff)
if(max_diff > per_thres)
    error('velocities differ by more than %2d percent. Check input data', per_thres*100);
else
    % do nothing because the velocities are basically the same
end
end