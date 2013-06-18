function [minXY, minXYZ] = minDistance(s)

if ~isempty(s)
    numFrames = length(s{1}.timer);
end
minimumsXY = zeros(1,numFrames);
minimumsXYZ = zeros(1,numFrames);
    %% minimum XY
        for i=1:numFrames
            for j=1:length(QUAD)
                 for k=j+1:length(QUAD)
                    minimumsXY(i) = norm(QUAD{j}.pos(1:2,i)-QUAD{k}.pos(1:2,i));
                 end
            end
        end
        minXY = min(minimumXY);
    %% minimum XYZ
        for i=1:numFrames
            for j=1:length(QUAD)
                for k=j+1:length(QUAD)
                    minimumsXYZ(i) = norm(QUAD{j}.pos(:,i)-QUAD{k}.pos(:,i));
                end
            end
        end
        minXYZ = min(minimumXYZ);
