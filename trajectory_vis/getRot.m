function R=getRot(yaw, roll,pitch)
%{
%PRY

    R= [1 0 0;
        0 cos(pitch) -sin(pitch);
        0 sin(pitch) cos(pitch)]* ...
        ...
        [cos(-roll) 0 sin(-roll);
        0 1 0;
        -sin(-roll) 0 cos(-roll)]* ...
        ...
        [cos(yaw) -sin(yaw) 0;
        sin(yaw) cos(yaw) 0;
        0 0 1];
%}

%RPY
%{
    R= [cos(yaw) -sin(yaw) 0;
        sin(yaw) cos(yaw) 0;
        0 0 1]* ...
        ...
        [cos(pitch) 0 sin(pitch);
        0 1 0;
        -sin(pitch) 0 cos(pitch)] * ...
        ...
        [1 0 0;
        0 cos(-roll) -sin(-roll);
        0 sin(-roll) cos(-roll)];
   %}
R=[cos(yaw) -sin(yaw) 0;
    sin(yaw) cos(yaw) 0;
    0 0 1]* ...
    ...
    [1 0 0;
    0 cos(roll) -sin(roll);
    0 sin(roll) cos(roll)]* ...
    ...
    [cos(pitch) 0 sin(pitch);
    0 1 0;
    -sin(pitch) 0 cos(pitch)];
end