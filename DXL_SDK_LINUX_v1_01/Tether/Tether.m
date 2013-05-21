function out=Tether(port,baud)
    class(port)
    SerialDeviceAPI('connect',port, baud)
    
    a=uint8([255 255 1 4 2 36 2]);
    chk=setCheckSum(a);
    a=[a chk];
    while(1)
        SerialDeviceAPI('write',a);
        pause(0.1)
        q=SerialDeviceAPI('read',10000,10)
        if length(q)>8
            break
        end
    end
    out=1;
end