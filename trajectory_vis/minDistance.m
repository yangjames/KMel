function [minXY, minXYZ] = minDistance(s, rotrad, width)

if ~isempty(s)
    numFrames = length(s(1).timer);
end
minimumsXY = zeros(1,numFrames);
minimumsXYZ = zeros(1,numFrames);
    %% minimum XY
        for i=1:numFrames
            for j=1:length(s)
                 for k=j+1:length(s)
                    minimumsXY(i) = norm(s(j).pos(1:2,i)-s(k).pos(1:2,i));
                 end
            end
        end
        minXY = min(minimumsXY) - (width + rotrad);
    %% minimum XYZ
        for i=1:numFrames
            for j=1:length(s)
                for k=j+1:length(s)
                    minimumsXYZ(i) = norm(s(j).pos(:,i)-s(k).pos(:,i));
                end
            end
        end
        minXYZ = min(minimumsXYZ) - (width + rotrad);
end
