%% CIRCLES AROUND EACH OTHER


clear all
close all

%% PARAMETERS

xdis=1;
ydis=1.25;
zdis=0.25;
L=.2;
delT = 0.01;
numquads = 6;

tcycle = 8;
%mdis=0.5;

th = -atan2(ydis/4, xdis/2); 
Ax=sqrt(xdis*xdis/4+ydis*ydis/16);
Ay=Ax/3;
Az=zdis/2;


w=2*pi/(tcycle/2);


%% TRAJECTORY
% traj_xF,traj_yF are for front row; traj_xB,traj_yB are for back row

t=0.01:delT:tcycle;

traj_xF = Ax.*cos(w.*t);
traj_xdF = -Ax*w.*sin(w.*t);
traj_yF = Ay.*sin(w.*t);
traj_ydF = Ay*w.*cos(w.*t);
traj_zF = Az.*sin(w*2.*t-pi/2)+Az;
traj_zdF = Az*w*2.*cos(w*2.*t-pi/2);
traj_yawF = 0.*traj_xF;

traj_xB = Ax.*cos(w.*t+pi);
traj_xdB = -Ax*w.*sin(w.*t+pi);
traj_yB = Ay.*sin(w.*t+pi);
traj_ydB = Ay*w.*cos(w.*t+pi);
traj_zB = Az.*sin(w*2.*t+pi/2)-Az;
traj_zdB = Az*w*2.*cos(w*2.*t+pi/2);
traj_yawB = 0.*traj_xF;


%% ROTATE ELLIPSE
% traj_xFr -> rotated traj_xF

for k=1:length(traj_xF)
    traj_xFr(k) = [traj_xF(k) traj_yF(k)]*[cos(th); -sin(th)];
    traj_yFr(k) = [traj_xF(k) traj_yF(k)]*[sin(th); cos(th)];
    traj_xBr(k) = [traj_xB(k) traj_yB(k)]*[cos(th); -sin(th)];
    traj_yBr(k) = [traj_xB(k) traj_yB(k)]*[sin(th); cos(th)];
    traj_xdFr(k) = [traj_xdF(k) traj_ydF(k)]*[cos(th); -sin(th)];
    traj_ydFr(k) = [traj_xdF(k) traj_ydF(k)]*[sin(th); cos(th)];
    traj_xdBr(k) = [traj_xdB(k) traj_ydB(k)]*[cos(th); -sin(th)];
    traj_ydBr(k) = [traj_xdB(k) traj_ydB(k)]*[sin(th); cos(th)];
end

traj_xF = traj_xFr;
traj_yF = traj_yFr;
traj_xB = traj_xBr;
traj_yB = traj_yBr;
traj_xdF = traj_xdFr;
traj_ydF = traj_ydFr;
traj_xdB = traj_xdBr;
traj_ydB = traj_ydBr;

%% TRANSLATE AND ASSIGN TRAJECTORIES

% Center of Ellipse
xcent = repmat([-xdis/2 -xdis/2 -xdis/2  -xdis/2  -xdis/2 xdis/2 xdis/2 xdis/2 xdis/2 xdis/2], length(traj_xF), 1)';
ycent = repmat([ydis/4 ydis/4 ydis/4 ydis/4 ydis/4 -ydis/4 -ydis/4 -ydis/4 -ydis/4 -ydis/4], length(traj_xF), 1)';
zcent = repmat(zdis, length(traj_xF), 10)';

% Starting point for each quad
xhome = repmat([0 0 0 0 0 -xdis -xdis -xdis -xdis -xdis], length(traj_xF), 1)';
yhome = repmat([0 ydis 2*ydis 3*ydis 4*ydis 0.5*ydis 1.5*ydis 2.5*ydis 3.5*ydis 4.5*ydis], length(traj_yF), 1)';
zhome = repmat([0 0 0 0 0 zdis zdis zdis zdis zdis], length(traj_zF), 1)';

% Add Trajectories
x = xcent + xhome + [traj_xF; traj_xF; traj_xF; traj_xF; traj_xF; traj_xB; traj_xB; traj_xB; traj_xB; traj_xB;];
y = ycent + yhome + [traj_yF; traj_yF; traj_yF; traj_yF; traj_yF; traj_yB; traj_yB; traj_yB; traj_yB; traj_yB;];
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

save ./trajectories/move6_traj s 


% Quad_Vis2
%% PLOTTING
% figure;
% plot(traj_xF, traj_yF);



