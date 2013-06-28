
clear all
close all

%% PARAMETERS

xdis=1;
ydis=1.25;
zdis=0.25;
L=.2;
delT = 0.01;
numquads = 6;

tcycle = 2;
mdis=0.5;
A=mdis/2;
w=2*pi/tcycle;


%% TRAJECTORY

t=0.01:delT:tcycle;

traj_x = -A.*cos(w.*t)+A;
traj_xd = A*w.*sin(w.*t);

traj_y=0.*traj_x;
traj_yd=0.*traj_x;

traj_z=0.*traj_x;
traj_zd=0.*traj_x;

traj_yaw=0.*traj_x;


xhome = repmat([0 0 0 0 0 -xdis -xdis -xdis -xdis -xdis], length(traj_x), 1)';
yhome = repmat([0 ydis 2*ydis 3*ydis 4*ydis 0.5*ydis 1.5*ydis 2.5*ydis 3.5*ydis 4.5*ydis], length(traj_y), 1)';
zhome = repmat([0 0 0 0 0 zdis zdis zdis zdis zdis], length(traj_z), 1)';

x = xhome + [traj_x; traj_x; traj_x; traj_x; traj_x; -traj_x; -traj_x; -traj_x; -traj_x; -traj_x;];
y = yhome + [traj_y; traj_y; traj_y; traj_y; traj_y; traj_y; traj_y; traj_y; traj_y; traj_y;];
z = zhome + [traj_z; traj_z; traj_z; traj_z; traj_z; traj_z; traj_z; traj_z; traj_z; traj_z;];

xd = [traj_xd; traj_xd; traj_xd; traj_xd; traj_xd; -traj_xd; -traj_xd; -traj_xd; -traj_xd; -traj_xd;];
yd = [traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd;];
zd = [traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd;];

yaw = [traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw;];

yaw=yaw+pi/4;
tfinal = t;

n_points = length(tfinal);

roll_extra  = zeros(10,n_points);
pitch_extra = zeros(10,n_points);
flip_cmd = zeros(10,n_points);
flip_cmd(5, 50) = 1;

%% STRUCTURE

for k=1:10
    
    s(k).timer = tfinal;
    s(k).pos   = [x(k,:);y(k,:);z(k,:)];
    s(k).vel   = [xd(k,:);yd(k,:);zd(k,:)];
    s(k).yaw   = yaw(k,:);
    s(k).roll_extra  = roll_extra(k,:);
    s(k).pitch_extra = pitch_extra(k,:);
    s(k).flip_cmd = flip_cmd(k,:);
    s(k).delT  = delT;
end

save ./trajectories/swingaway_traj s 

%% PLOTTING



