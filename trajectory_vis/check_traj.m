function [] = check_traj(s)

%PARAMS
max_accel    = 5;  %m/s/s
max_vel      = 5;  %m/s
max_yaw_rate = 3;  %rad/s


min_sep     = .5; %min distance between vehicles (m)
z_safe_zone = 0.1; %if vehicles are this far away in z then they can collide

check = 0;

numquads = size(s,2);
n = size(s(1).pos,2);
dt = s(1).delT;

%check the size of all vectors
for i =1:numquads
    if(size(s(i).vel,2)~=n-1)
        check = 1;
        fprintf('velocity is not the correct length: %d\n',i)
    end
    if(size(s(i).a, 2)~=n-2)
        check=1;
        fprintf('acceleration is not the correct length: %d\n', i)
    end
    if(size(s(i).pos,2)~=n)
        check = 1;
        fprintf('position is not the correct length: %d\n',i)
    end
    if(size(s(i).yaw,2)~=n)
        check = 1;
        fprintf('yaw is not the correct length: %d\n',i)
    end
    if(size(s(i).roll_extra,2)~=n)
        check = 1;
        fprintf('roll_extra is not the correct length: %d\n',i)
    end
    if(size(s(i).pitch_extra,2)~=n)
        check = 1;
        fprintf('pitch_extra is not the correct length: %d\n',i)
    end
    if(size(s(i).flip_cmd,2)~=n)
        check = 1;
        fprintf('flip_cmd is not the correct length: %d\n',i)
    end
end


% 
max_pos_diff = max_vel*dt;
max_vel_diff = max_accel*dt;
max_yaw_diff = max_yaw_rate*dt;

%check the large position change for all quads
for i=1:numquads
    [cur_max_pos_diff frame] = max(max(abs(s(i).pos(:,2:end)-s(i).pos(:,1:end-1))));
    if( cur_max_pos_diff > max_pos_diff)
        check = 2;
        fprintf('position jump too large: quad:%d pos frame:%d\n',i, frame)
    end
end
%check for large velocity change
for i=1:numquads
    [cur_max_vel_diff frame] = max(max(abs(s(i).vel(:,2:end)-s(i).vel(:,1:end-1))));
    if( cur_max_vel_diff > max_vel_diff)
        check = 2;
        fprintf('velocity jump too large: quad:%d frame:%d\n',i, frame)
    end
end

%check for large yaw change on all quads
for i=1:numquads
    yawdiff = abs(s(i).yaw(2:end)-s(i).yaw(1:end-1));
    yawdiff = yawdiff + (yawdiff>6)*(-2*pi); 
    yawdiff = yawdiff + (yawdiff<-6)*(2*pi);
    
    [cur_max frame] = max(abs(yawdiff));
    if(cur_max > max_yaw_diff )
        check = 2;
        fprintf('yaw jump too large: quad:%d dyaw=%drad/s frame:%d\n',i,cur_max/dt, frame)
    end
end

%check the magnitude of the velocities
for i=1:numquads
    [cur_max frame] = max(max(s(i).vel));
    if(cur_max>max_vel)
        check = 3;
        fprintf('velocity too large: quad:%d, v=%dm/s, frame:%d\n',i,cur_max, frame)
    end
end

%check the magnitude of the accelerations
for i=1:numquads
    [cur_max_acc frame] = max(max(s(i).a));
    if(cur_max_acc>max_accel)
        check = 3;
        fprintf('acceleration too large: quad:%d, a=%dm/s/s, frame:%d\n',i,cur_max_acc, frame)
    end
end


%check for potential collisions between vehicles
for i=1:numquads
    for j=i+1:numquads
        pos_diff = s(i).pos-s(j).pos;
        idx_check = find(abs(pos_diff(3,:))<=z_safe_zone);
        
        [min_lateral_dist index] = min(sqrt(sum(pos_diff(1:2,idx_check).^2)));
        
        if(min_lateral_dist<=min_sep)
            check = 4;
            fprintf('vehicles too close: quads:%d and %d, d=%f, frame=%d\n',i,j,min_lateral_dist, idx_check(index))
        end
    end
end

minx = inf; maxx = -inf;
miny = inf; maxy = -inf;
minz = inf; maxz = -inf;

for i=1:numquads
    minx = min([s(i).pos(1,:),minx]);
    maxx = max([s(i).pos(1,:),maxx]);

    miny = min([s(i).pos(2,:),miny]);
    maxy = max([s(i).pos(2,:),maxy]);
    
    minz = min([s(i).pos(3,:),minz]);
    maxz = max([s(i).pos(3,:),maxz]);
end

if (maxx-minx) > 4 || (maxy-miny) > 8 || (maxz-minz) > 4
    check=5;
    fprintf('vehicles outside bounds\n')
    fprintf('x bounds: %f, %f\n',minx,maxx);
    fprintf('y bounds: %f, %f\n',miny,maxy);
    fprintf('z bounds: %f, %f\n',minz,maxz);
end


if(check==0)
    fprintf('TRAJECTORY PASSED\n')
    fprintf('numquads: %d\n',numquads);
    fprintf('number of points: %d\n',n-2);
    fprintf('x bounds: %f, %f\n',minx,maxx);
    fprintf('y bounds: %f, %f\n',miny,maxy);
    fprintf('z bounds: %f, %f\n',minz,maxz);
else
    fprintf('TRAJ FAILED\n')
end
end
