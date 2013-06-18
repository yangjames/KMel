function [yaw,pitch,roll]=QuatToEuler(q)
    qw=q(:,1);
    qx=q(:,2);
    qy=q(:,3);
    qz=q(:,4);
    
    t=qx.*qy+qz.*qw;
    
    yaw=atan((2*qy.*qw-2*qx.*qz)./ (1-2*qy.^2-2*qz.^2)).*(t~=0.5 & t~=-0.5) + 2*atan(qx./qw).*(t==0.5)+ -2*atan(qx./qw).*(t==-0.5);
    pitch=asin(2*qx.*qy+2*qz.*qw);
    roll=atan((2*qx.*qw-2*qy.*qz)./( 1-qw.*qx.^2-qw.*qz.^2)).*(t~=0.5);