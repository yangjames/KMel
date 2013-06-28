function [maxR maxP] = getMaxAngles(s)
%this function calculates the maximum roll and pitch angles in a trajectory
angle_mags = zeros(2, length(s(1).a), 2);
for i=1:length(s)
    for j=1:length(s(1).a)
        [angle_mags(i, j, 1) angle_mags(i, j, 2)] = getAngles(s(i).a(:,j),s(i).yaw(j));
    end
end
maxR = max(max(angle_mags(:,:,1)));
maxP = max(max(angle_mags(:,:,2)));

end