%% MOVE, TWITCH, and SPIN

clear all
close all

%% PARAMETERS

xdis=1;
ydis=1.25;
zdis=0.25;
L=.2;
delT = 0.01;
numquads = 6;

tf = 15;
mdis=0.5;
A=mdis/2;
w=2*pi/tf;

t_snap=2;

%% TRAJECTORY CREATION

t=0.01:delT:tf;

t1=0.01:delT:2;

x0 = [0,0,0,0]';  %pos, vel, acc, jerk
xf = [mdis,0,0,0]';
y0 = [0,0,0,0]';
yf = [0,0,0,0]';
remap = diag([1,t_snap,t_snap^2,t_snap^3]);
x0 = remap*x0;
xf = remap*xf;
y0 = remap*y0;
yf = remap*yf;
fixed0 = [1,1,1,1]';
fixedf = [1,1,1,1]';
[params_x,H] = minsnap(x0,xf,fixed0,fixedf);
[params_y,H] = minsnap(y0,yf,fixed0,fixedf);
remap2 = diag([1/t_snap^7,1/t_snap^6,1/t_snap^5,1/t_snap^4,1/t_snap^3,1/t_snap^2,1/t_snap^1,1]);
params_x2 = remap2*params_x;
params_y2 = remap2*params_y;

x1 = polyval(params_x2,t1);
y1 = polyval(params_y2,t1);
xd1 = polyval(polyder(params_x2),t1);
yd1 = polyval(polyder(params_y2),t1);
xdd1 = polyval(polyder(polyder(params_x2)),t1);
ydd1 = polyval(polyder(polyder(params_y2)),t1);
yaw1 = 0.*x1;


t2 = 0.01:delT:4;
x2 = 0.*t2+mdis;
y2 = 0.*t2;
xd2 = 0.*t2;
yd2 = 0.*t2;
xdd2 = 0.*t2;
ydd2 = 0.*t2;
yaw2=t2.*(pi/2);

t3 = 0.01:delT:1.5;
x3 = 0.*t3+mdis;
y3 = 0.*t3;
xd3 = 0.*t3;
yd3 = 0.*t3;
xdd3 = 0.*t3;
ydd3 = 0.*t3;
yaw3=0.*t3;

t4 = 0.01:delT:4;
x4 = 0.*t4+mdis;
y4 = 0.*t4;
xd4 = 0.*t4;
yd4 = 0.*t4;
xdd4 = 0.*t4;
ydd4 = 0.*t4;
yaw4=-t4.*(pi/2);

t5 = 0.01:delT:1.5;
x5 = 0.*t5+mdis;
y5 = 0.*t5;
xd5 = 0.*t5;
yd5 = 0.*t5;
xdd5 = 0.*t5;
ydd5 = 0.*t5;
yaw5=0.*t5;

t6 = 0.01:delT:2;
x6 = -x1+mdis;
y6 = 0.*t6;
xd6 = -xd1;
yd6 = 0.*t6;
xdd6 = -xdd1;
ydd6 = 0.*t6;
yaw6=0.*t6;

z=0.*t;
zd=0.*t;

traj_x = [x1 x2 x3 x4 x5 x6];
traj_y = [y1 y2 y3 y4 y5 y6];
traj_z = [z];

traj_xd = [xd1 xd2 xd3 xd4 xd5 xd6];
traj_yd = [yd1 yd2 yd3 yd4 yd5 yd6];
traj_zd = [zd];

% traj_xdd = 0.*t;
% traj_ydd = 0.*t;
% traj_zdd = 0.*t;

traj_yaw=[yaw1 yaw2 yaw3 yaw4 yaw5 yaw6];

tfinal=t;


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

yaw = [traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw; traj_yaw;];


n_points = length(tfinal);

roll_extra  = zeros(10,n_points);
pitch_extra = zeros(10,n_points);
flip_cmd = zeros(10,n_points);

start_time = [0,0,0,0,0,0,0,0,0,0];
del_angle = 10*pi/180;


tr=tfinal;

for i = 1:n_points
   for k=1:10
       if( t(i)>=start_time(k))
           if((tr(i)>0 && tr(i)<0.05) || ...
                   (tr(i)>0.5 && tr(i)<0.55) || ...
                   (tr(i)>1.0 && tr(i)<1.05) || ...
                   (tr(i)>1.5 && tr(i)<1.55) || ...
                   (tr(i)>6.5 && tr(i)<6.55) || ...
                   (tr(i)>7 && tr(i)<7.05) || ...
                   (tr(i)>12 && tr(i)<12.05) || ...
                   (tr(i)>12.5 && tr(i)<12.55) || ...
                   (tr(i)>13 && tr(i)<13.05) || ...
                   (tr(i)>13.5 && tr(i)<13.55) || ...
                   (tr(i)>14 && tr(i)<14.05) || ...
                   (tr(i)>14.5 && tr(i)<14.55))
               roll_extra(k,i) = -del_angle;
               pitch_extra(k,i) = del_angle;
           else
               roll_extra(k,i) = 0;
               pitch_extra(k,i) = 0;
           end
       end
   end
end


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

save ./trajectories/move3_traj s 




%% PLOTTING

%plot(t, traj_yaw)