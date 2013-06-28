function new_s = checkFlips(s)
%this function creates a flipFlags filed for each quad and stores flip data
% for each frame in this field

numFlipFrames = .5/s(1).delT; % assuming a flip is .5s
n = length(s(1).yaw);

for i=1:length(s)
    s(i).flipFlags = zeros(1, n);
    for j=1:length(s(1).flip_cmd)
        if s(i).flip_cmd(j) ~= 0
            switch s(i).flip_cmd(j)
                case 1
                    %barrel roll left
                    s(i).flipFlags(j:j+numFlipFrames) = 1;
                case 3
                    %barrel roll right
                    s(i).flipFlags(j:j+numFlipFrames) = 3;
                case 5
                    %front flip
                    s(i).flipFlags(j:j+numFlipFrames) = 5;
                case 7
                    %back flip
                    s(i).flipFlags(j:j+numFlipFrames) = 7;
            end
        end
    end
end
new_s = s;
end