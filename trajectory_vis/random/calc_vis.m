%This script is used to calculate the data needed by the visual trjaecotry
%checker.
clear all
close all

%import data
data=(importdata('dat.mat'))'; 

t=data.time;
x=data.xsave(:,1); 
y=data.xsave(:,2);
z=data.xsave(:,3);
q=data.xsave(:,7:10);

%get the velocity and acceleration from the position data





[yaw,pitch,roll]=QuatToEuler(q);

H_0=getHomTran(x(1),y(1),z(1),yaw(1),pitch(1),roll(1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAPHICS START HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf;
axis equal;
grid on;
box on;

hold on;
axis([0 1.5 1 2.5 .5 3])

% Title
title('Sample Vis')
xlabel('x(m)')
ylabel('y(m)')
zlabel('z(m)')
%original config
quadwidth=12*0.0254; % in inches

thetad=(0:0.01:2*pi)';
rotrad=3*0.0254; % in inches
rotorx=rotrad*sin(thetad);
rotory=rotrad*cos(thetad);
rotorz=zeros(length(thetad),1);

pa=[quadwidth/2+rotorx rotory rotorz];
pb=[-quadwidth/2+rotorx rotory rotorz];
pc=[rotorx quadwidth/2+rotory rotorz];
pd=[rotorx -quadwidth/2+rotory rotorz];

shaft=(-quadwidth/2:0.001:quadwidth/2)';
shaft1=zeros(length(shaft),1);

shafta=[shaft shaft1 shaft1];
shaftb=[shaft1 shaft shaft1];

rotaplot=plot3(pa(:,1)+x(1),pa(:,2)+y(1),pa(:,3)+z(1),'b');
rotbplot=plot3(pb(:,1)+x(1),pb(:,2)+y(1),pb(:,3)+z(1),'r');
rotcplot=plot3(pc(:,1)+x(1),pc(:,2)+y(1),pc(:,3)+z(1),'r');
rotdplot=plot3(pd(:,1)+x(1),pd(:,2)+y(1),pd(:,3)+z(1),'r');
shaftaplot=plot3(shafta(:,1)+x(1),shafta(:,2)+y(1),shafta(:,3)+z(1),'k');
shaftbplot=plot3(shaftb(:,1)+x(1),shaftb(:,2)+y(1),shaftb(:,3)+z(1),'k');

orientation=[[0 0]' [0 0]' [0 .2]'];
orienplot=plot3(orientation(:,1)+x(1),orientation(:,2)+y(1),orientation(:,3)+z(1),'k');

for i=2:length(t)
    R=getRot(yaw(i),pitch(i),roll(i));
    pa1=(R*pa')';
    pb1=(R*pb')';
    pc1=(R*pc')';
    pd1=(R*pd')';
    shafta1=(R*shafta')';
    shaftb1=(R*shaftb')';
    orientation1=(R*orientation')';
    fprintf('roll=%f\n',roll(i));
    set(rotaplot,'XData',pa1(:,1)+x(i),'YData',pa1(:,2)+y(i),'ZData',pa1(:,3)+z(i));
    set(rotbplot,'XData',pb1(:,1)+x(i),'YData',pb1(:,2)+y(i),'ZData',pb1(:,3)+z(i));
    set(rotcplot,'XData',pc1(:,1)+x(i),'YData',pc1(:,2)+y(i),'ZData',pc1(:,3)+z(i));
    set(rotdplot,'XData',pd1(:,1)+x(i),'YData',pd1(:,2)+y(i),'ZData',pd1(:,3)+z(i));
    set(shaftaplot,'XData',shafta1(:,1)+x(i),'YData',shafta1(:,2)+y(i),'ZData',shafta1(:,3)+z(i));
    set(shaftbplot,'XData',shaftb1(:,1)+x(i),'YData',shaftb1(:,2)+y(i),'ZData',shaftb1(:,3)+z(i));
    set(orienplot,'XData',orientation1(:,1)+x(i),'YData',orientation1(:,2)+y(i),'ZData',orientation(:,3)+z(i));
    pause((t(i)-t(i-1)))
end
