function Tether(port,baud)

    GOAL_SPEED=32; %start address of goal speed
    CURR_SPEED=38; %start address of current speed
    CURR_LOAD=40; %start address of current load
    
    % initialize serial port
    SetSerialPath;
    status=SerialDeviceAPI('connect',port,baud)
    if (SerialDeviceAPI('connect',port, baud) ~= 0)
        out=-1
        return
    end
    
    % setup servo for tethering
    TetherInit;
    
    status=setSpeed(1,0)
    prev_t=0;
    t=0;
    Kp=3;
    while(1)
        a=makeReadable(getCurrLoad(1));
        if ~isempty(a)
            if a(1)~=0
                if length(a)==3
                    t=getTorque(a(3));
                    d_t=t-prev_t;
                    spd=-Kp*d_t;
                    setSpeed(1,spd);
                    prev_t=t;
                end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % communication functions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ret=getTorque(val)
        if val>1023
            ret=-(double(val)-1024);
        else
            ret=double(val);
        end
    end
    
    function ret=makeReadable(payload)
        id=[];
        err=[];
        if ~isempty(payload)
            id=uint16(payload(1));
            err=uint16(payload(2));
        end
        if length(payload)>3
            package=payload(3:end);
            val=uint16(package(2))*256+uint16(package(1));
            ret=[id err val];
            return
        end
        if length(payload)>2
            val=payload(3);
            ret=[id err val];
            return
        end
        ret=[id err];
    end
    
    % set Tether to constant rotation mode with 0 initial speed
    % returns id and error. empty matrix if no return
    function out=TetherInit
        payload=uint8([6 0 0 0 0]);
        packet=uint8([255 255 1 length(payload)+2 3 payload]);
        chk=setCheckSum(packet);
        packet=[packet chk];
        
        SerialDeviceAPI('write',packet);
        pause(0.001);
        out=processReturnPacket(SerialDeviceAPI('read',10000,10))
    end

    % sets speed for servo with specified id
    % outputs id and error. empty matrix if no return
    function out=setSpeed(id,speed)
        if id > 255 || id<0
            out=-1;
            return
        end
        if speed>1023 || speed<-1024
            out=-1;
            return
        end
        spd=typecast(uint16(speed+1024),'uint8');
        payload=uint8([GOAL_SPEED spd]);
        packet=uint8([255 255 uint8(id)  length(payload)+2 3 payload]);
        chk=setCheckSum(packet);
        packet=[packet chk];
        SerialDeviceAPI('write',packet);
        pause(0.001);
        out=processReturnPacket(SerialDeviceAPI('read',10000,10));
    end

    % requests current load on servo with specified id
    % returns id, error, and load. empty matrix if no return
    function out=getCurrLoad(id)
        if id > 255 || id<0
            out=-1;
            return
        end
        payload=uint8([CURR_LOAD 2]);
        packet=uint8([255 255 1 length(payload)+2 2 payload]);
        c=setCheckSum(packet);
        packet=[packet c];
        SerialDeviceAPI('write',packet);
        pause(0.001); % wait for packet to arrive
        out=processReturnPacket(SerialDeviceAPI('read',10000,10));
    end
    
    % input return packet from Dynamixel Servo
    % returns id, error, and additional payload
    function out=processReturnPacket(packet)
        idx=1;
        eidx=length(packet);
        pos=0;
        
        id=0;
        len=0;
        err=0;
        payload=[];
        
        out=[];
        prob=0;
        while idx<eidx
            switch pos
                case 0  % if first header byte, fall through
                    if packet(idx)==255
                        pos=pos+1;
                    end
                    idx=idx+1;
                case 1  % if second header byte, fall through
                    if packet(idx)==255
                        pos=pos+1;
                    else
                        pos=0;
                    end
                    idx=idx+1;
                case 2  % store id, fall through
                    if packet(idx)<255 && packet(idx)>=0
                        id=packet(idx);
                        idx=idx+1;
                        pos=pos+1;
                    else
                        pos=1;
                    end
                case 3  % if length is appropriate, check the checksum store payload and fall through
                    len=packet(idx);
                    if eidx-idx>=len
                        chk=setCheckSum(packet(idx-3:idx+len-1));
                        if chk == packet(idx+len)
                            err=packet(idx+1);
                            payload=packet(idx+2:idx+len-1);
                            idx=eidx;
                        else
                            prob=1;
                            pos=0;
                            idx=idx+1;
                        end
                    else
                        prob=1;
                        pos=0;
                        idx=idx+1;
                    end
                otherwise
                    pos=0;
                    idx=idx+1;
            end
        end
        if prob==0
            out=[id err payload];
        elseif prob~=0
            out=[];
        end
    end
end