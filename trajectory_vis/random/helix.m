clear all
close all

%%helix param
R = 0.5;
v = 1.0; %1.3
n_loops = 3;
h_total = 0.8;
r_center = [0,0,0]';
start_ang = -pi;
acc = 1;
d_start = 1.0;
d_stop  = 1.0;

acc_in = v^2/R

delT = 0.01;

% calculate the helix
d_min = v^2/(2*acc); %min distance to get up to speed
t_min = v/acc;

if(d_start<d_min | d_stop<d_min)
    fprintf('distances too small\n');
end

t_start = v/acc + (d_start-d_min)/v;
t_stop  = v/acc + (d_stop-d_min)/v;

t_helix = 2*pi*R*n_loops/v;

omega = v/R

time_helix = (0:delT:t_helix)';
n_helix = length(time_helix);
x_helix = zeros(1,n_helix);
y_helix = zeros(1,n_helix);
z_helix = zeros(1,n_helix);
yaw_helix = zeros(1,n_helix);

r = roots([-acc,acc*t_helix,-h_total]);

t1 = min(r);
v_z = t1*acc;
t2 = t_helix - 2*t1;
d1 = 1/2*acc*t1^2;

for i =1:n_helix
    tnow = time_helix(i);
    
    x_helix(i) = R*cos(omega*time_helix(i)+start_ang) + r_center(1);
    y_helix(i) = R*sin(omega*time_helix(i)+start_ang) + r_center(2);
    
    if(tnow<t1)  
      z_helix(i) = r_center(3) + 1/2*acc*tnow^2;
    elseif(tnow<t1+t2)
      z_helix(i) = r_center(3) + 1/2*acc*t1^2 + v_z*(tnow-t1);
    else
      z_helix(i) = r_center(3) + 1/2*acc*t1^2 + v_z*(t2) + ...
          v_z*(tnow-t2-t1) - 1/2*acc*(tnow-t2-t1)^2;
    end
    
    yaw_helix(i) = omega*time_helix(i);
    while(yaw_helix(i)>pi)
        yaw_helix(i) = yaw_helix(i) - 2*pi;
    end
    while(yaw_helix(i)<-pi)
        yaw_helix(i) = yaw_helix(i) + 2*pi;
    end
end


uvec = [-sin(start_ang),cos(start_ang),0]'; %tangent vector at start
startpos = [R*cos(start_ang),R*sin(start_ang),0]'+r_center;
stoppos = [R*cos(start_ang),R*sin(start_ang),h_total]'+r_center;

time_start = (0:delT:t_start)';
n_start    = length(time_start);
x_start    = zeros(1,n_start);
y_start    = zeros(1,n_start);
z_start    = zeros(1,n_start);
yaw_start  = zeros(1,n_start);

for i = 1:n_start
    tnow = time_start(i);
    if(tnow <t_min)
        dnow = 1/2*acc*tnow^2;
    else
        dnow = d_min + v*(tnow-t_min);
    end
    posnow = startpos - uvec*(d_start-dnow);
    
    x_start(i) = posnow(1); 
    y_start(i) = posnow(2); 
    z_start(i) = posnow(3); 
end

time_stop = (0:delT:t_stop)';
n_stop    = length(time_stop);
x_stop    = zeros(1,n_stop);
y_stop    = zeros(1,n_stop);
z_stop    = zeros(1,n_stop);
yaw_stop  = zeros(1,n_stop);

for i = 1:n_stop
    tnow = time_stop(i);
    if(tnow < (t_stop-t_min))
        dnow = v*tnow;
    else
        dnow = d_stop - 1/2*acc*(t_stop-tnow)^2;

    end
    posnow = stoppos + uvec*(dnow);
    
    x_stop(i) = posnow(1); 
    y_stop(i) = posnow(2); 
    z_stop(i) = posnow(3); 
end

figure
plot3(x_start,y_start,z_start,'r.')
hold on
plot3(x_helix,y_helix,z_helix,'g.')
plot3(x_stop,y_stop,z_stop,'b.')
xlabel('x')

ylabel('y')
grid on
axis equal
    

x_total = [x_start,x_helix,x_stop];
y_total = [y_start,y_helix,y_stop];
z_total = [z_start,z_helix,z_stop];
yaw_total = [yaw_start,yaw_helix,yaw_stop];
time_total = [time_start;t_start+1e-5 + time_helix;t_start+t_helix+3e-5 + time_stop];
t_total = t_start + t_helix + t_stop

time_final = (0:delT:t_total)';

x_final = interp1(time_total',x_total,time_final,'linear','extrap');
y_final = interp1(time_total',y_total,time_final,'linear','extrap');
z_final = interp1(time_total',z_total,time_final,'linear','extrap');
yaw_final = interp1(time_total',yaw_total,time_final,'linear','extrap');

x_vel = diff(x_final)/delT;
x_vel(end+1) = 0;
y_vel = diff(y_final)/delT;
y_vel(end+1) = 0;
z_vel = diff(z_final)/delT;
z_vel(end+1) = 0;


figure
subplot(311)
hold on
plot(time_final,x_final,'r.')
plot(time_final,x_vel,'k.')
title('position and velocity')
subplot(312)
hold on
plot(time_final,y_final,'g.')
plot(time_final,y_vel,'k.')
subplot(313)
hold on
plot(time_final,z_final,'b.')
plot(time_final,z_vel,'k.')

timer = time_final';
pos = [x_final,y_final,z_final]';
vel = [x_vel,y_vel,z_vel]';
yaw = yaw_final;

save helix1 timer pos vel yaw delT










