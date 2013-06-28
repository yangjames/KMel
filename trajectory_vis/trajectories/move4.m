%% SPIN

clear all
close all

%% PARAMETERS

xdis=1;
ydis=1.25;
zdis=0.25;
L=.2;
delT = 0.01;
numquads = 6;

tf = 12;
mdis=0;
A=mdis/2;
w=2*pi/tf;


%% TRAJECTORY CREATION

t=0.01:delT:tf;

traj_x = 0.*t;
traj_y = 0.*t;
traj_z = 0.*t;

traj_xd = 0.*t;
traj_yd = 0.*t;
traj_zd = 0.*t;

% traj_xdd = 0.*t;
% traj_ydd = 0.*t;
% traj_zdd = 0.*t;

t1=0.01:delT:4;
yaw1 = t1.*(pi/2);

t2=0.01:delT:1;
yaw2 = -t2.*(pi/2);

yaw3 = t2.*0-pi/2;

yaw4 = -t2.*(pi/2) - (pi/2);

yaw5 = t2.*0-pi;

yaw6 = t2.*(pi/2) - (pi);

yaw7 = t2.*0-pi/2;

yaw8 = t2.*(pi/2) - (pi/2);

yaw9 = t2.*0;

traj_yawF=[yaw1 yaw2 yaw3 yaw4 yaw5 yaw6 yaw7 yaw8 yaw9];
traj_yawB=-traj_yawF;

%% TRAJECTORY ASSIGNMENTS

xhome = repmat([0 0 0 0 0 -xdis -xdis -xdis -xdis -xdis], length(traj_x), 1)';
yhome = repmat([0 ydis 2*ydis 3*ydis 4*ydis 0.5*ydis 1.5*ydis 2.5*ydis 3.5*ydis 4.5*ydis], length(traj_y), 1)';
zhome = repmat([0 0 0 0 0 zdis zdis zdis zdis zdis], length(traj_z), 1)';

x = xhome + [traj_x; traj_x; traj_x; traj_x; traj_x; traj_x; traj_x; traj_x; traj_x; traj_x;];
y = yhome + [traj_y; traj_y; traj_y; traj_y; traj_y; traj_y; traj_y; traj_y; traj_y; traj_y;];
z = zhome + [traj_z; traj_z; traj_z; traj_z; traj_z; traj_z; traj_z; traj_z; traj_z; traj_z;];

xd = [traj_xd; traj_xd; traj_xd; traj_xd; traj_xd; traj_xd; traj_xd; traj_xd; traj_xd; traj_xd;];
yd = [traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd; traj_yd;];
zd = [traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd; traj_zd;];

yaw = [traj_yawF; traj_yawF; traj_yawF; traj_yawF; traj_yawF; traj_yawB; traj_yawB; traj_yawB; traj_yawB; traj_yawB;];


tfinal=t;



n_points = length(tfinal);

roll_extra  = zeros(10,n_points);
pitch_extra = zeros(10,n_points);
flip_cmd = zeros(10,n_points);


%% STRUCTURE

for k=1:10
    
    s(k).timer = tfinal;
    s(k).pos   = [x(k,:);y(k,:);z(k,:)];
    s(k).vel   = [xd(k,:);yd(k,:);zd(k,:)];
    s(k).yaw   = yaw(k,:)+pi/4;
    s(k).roll_extra  = roll_extra(k,:);
    s(k).pitch_extra = pitch_extra(k,:);
    s(k).flip_cmd = flip_cmd(k,:);
    s(k).delT  = delT;
end

save ./trajectories/move4_traj s 


%% PLOTTING

plot(t,traj_yawF)

