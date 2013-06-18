function [roll,pitch]=getAngles(a,yaw)
    a=a+[0;0;9.81];
    yawrot=[cos(yaw) -sin(yaw) 0;
            sin(yaw) cos(yaw) 0;
            0 0 1];
    orientation=yawrot^-1*a/norm(a);
    
    pitch=asin(orientation(1));
    roll=atan2(-orientation(2),orientation(3));
    %fprintf('acceleration vector: <%f %f %f>\n',a(1),a(2),a(3)-9.81)
    %disp(a)
    %R=yawrot*[1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)]*[cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
    %fprintf('rotation matrix: \n')
    %disp(R*[0;0;1])
end