function H=getHomTran(x,y,z,yaw,pitch,roll)
    R_0=getRot(yaw,pitch,roll);
    H=[R_0 [x;y;z] ;[0 0 0 1]];
end