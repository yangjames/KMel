function error = compareVelocities(v1,v2)
    %this function compares two arrays and if any corresponding values are too
    %different the function will throw and error.
    count = 0;
    per_diff = zeros(1, length(v1));
    diff = zeros(1, length(v1));
    %per_thres = .8; % percent difference allowed
    diff_thres = .1; %difference allowed at each timestep
    for i=1:length(v1)
        mag1 = norm(v1(:,i));
        mag2 = norm(v2(:,i));

        if mag1 > .1 && mag2 >.1 
            %per_diff(i) = abs((norm(v1(:,i)) - norm(v2(:,i)))/norm(v2(:,i)));
            diff(i) = abs(norm(v1(:,i)) - norm(v2(:,i)));
        end
        if(diff(i) > diff_thres)
            count = count + 1;
            %fprintf('velocity differs by %dm/s at frame %d\n', diff(i), i);
        end
    end
    if count == 0
        error = 0;
    else
        error = 1;
    end
 
end