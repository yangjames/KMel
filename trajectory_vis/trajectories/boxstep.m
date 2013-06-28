%% BOX STEP


clear all
close all

%% PARAMETERS

xdis=1;
ydis=1.25;
zdis=0.25;


L=.2;
delT = 0.01;
numquads = 10;

tf=2;
tcycle = 8;
%mdis=0.5;


%% TRAJECTORY CREATION
% traj_xF,traj_yF are for front row; traj_xB,traj_yB are for back row

x0 = [0,0,0,0]';  %pos, vel, acc, jerk
xf = [-xdis,0,0,0]';
y0 = [0,0,0,0]';
yf = [0,0,0,0]';

remap = diag([1,tf,tf^2,tf^3]);
x0 = remap*x0;
xf = remap*xf;
y0 = remap*y0;
yf = remap*yf;

fixed0 = [1,1,1,1]';
fixedf = [1,1,1,1]';
[params_x,H] = minsnap(x0,xf,fixed0,fixedf);
[params_y,H] = minsnap(y0,yf,fixed0,fixedf);

remap2 = diag([1/tf^7,1/tf^6,1/tf^5,1/tf^4,1/tf^3,1/tf^2,1/tf^1,1]);
params_x2 = remap2*params_x;
params_y2 = remap2*params_y;

t = 0.01:delT:tf; 

x1 = polyval(params_x2,t);
y1 = polyval(params_y2,t);

xd1 = polyval(polyder(params_x2),t);
yd1 = polyval(polyder(params_y2),t);

xdd1 = polyval(polyder(polyder(params_x2)),t);
ydd1 = polyval(polyder(polyder(params_y2)),t);

%%%%%%

x0 = [-xdis,0,0,0]';  %pos, vel, acc, jerk
xf = [-xdis,0,0,0]';
y0 = [0,0,0,0]';
yf = [ydis/2,0,0,0]';

remap = diag([1,tf,tf^2,tf^3]);
x0 = remap*x0;
xf = remap*xf;
y0 = remap*y0;
yf = remap*yf;

fixed0 = [1,1,1,1]';
fixedf = [1,1,1,1]';
[params_x,H] = minsnap(x0,xf,fixed0,fixedf);
[params_y,H] = minsnap(y0,yf,fixed0,fixedf);

remap2 = diag([1/tf^7,1/tf^6,1/tf^5,1/tf^4,1/tf^3,1/tf^2,1/tf^1,1]);
params_x2 = remap2*params_x;
params_y2 = remap2*params_y;

t = 0.01:delT:tf; 

x2 = polyval(params_x2,t);
y2 = polyval(params_y2,t);

xd2 = polyval(polyder(params_x2),t);
yd2 = polyval(polyder(params_y2),t);

xdd2 = polyval(polyder(polyder(params_x2)),t);
ydd2 = polyval(polyder(polyder(params_y2)),t);




t=[t t(length(t))+t t(length(t))+t(length(t))+t t(length(t))+t(length(t))+t(length(t))+t];

traj_xF = [x1 x2 -x1-xdis -x2-xdis];
traj_xdF = [xd1 xd2 -xd1 -xd2];
traj_yF = [y1 y2 -y1+ydis/2 -y2+ydis/2];
traj_ydF = [yd1 yd2 -yd1 -yd2];
traj_zF = 0.*traj_xF;
traj_zdF = 0.*traj_xF;
traj_yawF = 0.*traj_xF;

traj_xB = [-x1 -x2 x1+xdis x2+xdis];
traj_xdB = [-xd1 -xd2 xd1 xd2];
traj_yB = [-y1 -y2 y1-ydis/2 y2-ydis/2];
traj_ydB = [-yd1 -yd2 yd1 yd2];   
traj_zB = 0.*traj_xF;
traj_zdB = 0.*traj_xF;
traj_yawB = 0.*traj_xF;


%% TRANSLATE AND ASSIGN TRAJECTORIES

% Starting point for each quad
xhome = repmat([0 0 0 0 0 -xdis -xdis -xdis -xdis -xdis], length(traj_xF), 1)';
yhome = repmat([0 ydis 2*ydis 3*ydis 4*ydis 0.5*ydis 1.5*ydis 2.5*ydis 3.5*ydis 4.5*ydis], length(traj_yF), 1)';
zhome = repmat([0 0 0 0 0 zdis zdis zdis zdis zdis], length(traj_zF), 1)';

% Add Trajectories
x = xhome + [traj_xF; traj_xF; traj_xF; traj_xF; traj_xF; traj_xB; traj_xB; traj_xB; traj_xB; traj_xB;];
y = yhome + [traj_yF; traj_yF; traj_yF; traj_yF; traj_yF; traj_yB; traj_yB; traj_yB; traj_yB; traj_yB;];
z = zhome + [traj_zF; traj_zF; traj_zF; traj_zF; traj_zF; traj_zB; traj_zB; traj_zB; traj_zB; traj_zB;];

xd = [traj_xdF; traj_xdF; traj_xdF; traj_xdF; traj_xdF; traj_xdB; traj_xdB; traj_xdB; traj_xdB; traj_xdB;];
yd = [traj_ydF; traj_ydF; traj_ydF; traj_ydF; traj_ydF; traj_ydB; traj_ydB; traj_ydB; traj_ydB; traj_ydB;];
zd = [traj_zdF; traj_zdF; traj_zdF; traj_zdF; traj_zdF; traj_zdB; traj_zdB; traj_zdB; traj_zdB; traj_zdB;];

yaw = [traj_yawF; traj_yawF; traj_yawF; traj_yawF; traj_yawF; traj_yawB; traj_yawB; traj_yawB; traj_yawB; traj_yawB;];

yaw = yaw +pi/4;
tfinal = t;

n_points = length(tfinal);

roll_extra  = zeros(10,n_points);
pitch_extra = zeros(10,n_points);
flip_cmd = zeros(10,n_points);


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

save ./trajectories/box_traj s 


% Quad_Vis2
%% PLOTTING
% figure;
% plot(traj_xF, traj_yF);