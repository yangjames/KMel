%% ROCK AND TWIST

clear all
close all

%% PARAMETERS

xdis=1.0;
ydis=1.25;
zdis=0.25;

L=.2;
delT = 0.01;
numquads = 6;

tf = 4;
mdis=0;
A=mdis/2;
w=2*pi/tf;


%% TRAJECTORY CREATION

t=0.01:delT:tf;

traj_x = 0.*t;
traj_y = 0.*traj_x;
traj_z = 0.*traj_x;

traj_xd = 0.*traj_x;
traj_yd = 0.*traj_x;
traj_zd = 0.*traj_x;

traj_xdd = 0.*traj_x;
traj_ydd = 0.*traj_x;
traj_zdd = 0.*traj_x;

tb=0.01:delT:tf/4;
traj_yaw1 = 0.*tb;
traj_yaw2 = tb.*(pi/2);
traj_yaw3 = -tb.*(pi/2)+pi/2;
traj_yaw4 = 0.*tb;

traj_yaw=[traj_yaw1 traj_yaw2 traj_yaw3 traj_yaw4];


%% TRAJECTORY ASSIGNMENTS

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


%% REPEAT


x = [x x];
y = [y y];
z = [z z];
xd = [xd xd];
yd = [yd yd];
zd = [zd zd];
yaw = [yaw -yaw];

yaw = yaw+pi/4;

tfinal = [t t+t(length(t))];


%% ROCK

n_points = length(tfinal);
tr=tfinal;

roll_extra  = zeros(10,n_points);
pitch_extra = zeros(10,n_points);
flip_cmd = zeros(10,n_points);

start_time = [0,0,0,0,0,0,0,0,0,0];
del_angle = 5*pi/180;

for i = 1:n_points
   for k=1:10
       if( tr(i)>=start_time(k))
           if(tr(i)<0.5)
               roll_extra(k,i) = -del_angle;
               pitch_extra(k,i) = del_angle;
           elseif (tr(i)>4 && tr(i)<4.5)
               roll_extra(k,i) = del_angle;
               pitch_extra(k,i) = -del_angle;
           end
       end
   end
end

% colorlist = {'ro','go','bo','y.','k.','c.'} ;   
% figure
% hold on
% for k=1:10
%     plot(tr,roll_extra(k,:),colorlist{k})
% end

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

save ./trajectories/move2_traj s 



%% PLOTTING

