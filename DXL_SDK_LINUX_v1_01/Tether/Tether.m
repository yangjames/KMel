function load_data=Tether(port,baud)
    
    

    GOAL_SPEED_ADDR=32; %start address of goal speed
    CURR_SPEED_ADDR=38; %start address of current speed
    CURR_LOAD_ADDR=40; %start address of current load
    
    
    % initialize serial port
    SetSerialPath;
    status=SerialDeviceAPI('connect',port,baud)
    if (SerialDeviceAPI('connect',port, baud) ~= 0)
        out=-1
        return
    end
    
    % setup servo for tethering
    TetherInit;
    
    %some initializations
    ID=1;
    %current_load=0;
    desired_load=5;
    error_p = 0;
    error_i = 0;
    error_d = 0;
    Kp=3;
    Ki=0;
    Kd=0;
    counter = 0;
    status=setSpeed(1,0);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %    The main script
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    speed = input('please enter a speed');
    setSpeed(1, speed);
    tic; %start the timer
    while(toc <= 5)
       counter = counter + 1;
       curr_packet=makeReadable(getCurrLoad(1));
       cur_load = curr_packet(3);
       disp(['load: ' num2str(getCurrLoad(1))]);
       load_data(counter) = cur_load;
       if toc >= 2.5
          setSpeed(1, 1023);
       end
       
    end
    setSpeed(1, 0);
    
    
%     while(1)
%         %PID controller to control the torque
%         packet=makeReadable(getCurrLoad(1));
%         if ~isempty(packet)
%             if packet(1)==ID
%                 if length(packet)==3
%                   current_load = packet(3);
%                   dt = toc; tic;
%                   prev_error = error_p;
%                   error_p = desired_load - current_load;
%                   error_d = (error_p-prev_error)/dt;
%                   error_i = error_i + (error_p*dt);
%                   control_command = Kp*error_p + Ki*error_i + Kd*error_d;
%                 end
%             end
%         end
%         % use the control command to control the speed (and direction) of the motor
%         %
%         
%     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % communication functions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %function to parse the current load registers into meaniful numbers
    %a positive value is CCW torque and negative value is CW torque
    function ret=getLoad(val)
        if val>1023
            ret=-(double(val)-1024);
        else
            ret=double(val);
        end
    end
    
    % function to parse payload data into convenient variables
    function ret=makeReadable(payload)
        id=[];
        err=[];
        if ~isempty(payload)
            id=uint16(payload(1));
            err=uint16(payload(2));
        else
            disp('the packet is empty');
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
        if length(payload)==2
            disp('there is no payload');
            ret=[id err];
            return
        end
        ret = -1;
    end
    
    % set Tether to wheel mode with 0 initial speed
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
        payload=uint8([GOAL_SPEED_ADDR spd]);
        packet=uint8([255 255 uint8(id)  length(payload)+2 3 payload]);
        chk=setCheckSum(packet);
        packet=[packet chk];
        SerialDeviceAPI('write',packet);
        pause(0.004);
        out=processReturnPacket(SerialDeviceAPI('read',10000,10));
    end

    % requests current load on servo with specified id
    % returns id, error, and load. empty matrix if no return. load 
    function out=getCurrLoad(id)
        if id > 255 || id<0
            out=-1;
            return
        end
        %send instruction to READ back the current load
        payload=uint8([CURR_LOAD_ADDR 2]);
        packet=uint8([255 255 1 length(payload)+2 2 payload]);
        c=setCheckSum(packet);
        packet=[packet c];
        SerialDeviceAPI('write',packet);
        pause(0.002); % wait for packet to arrive
        out=processReturnPacket(SerialDeviceAPI('read',10000,10)); % return the packet returned by the Dynamixel
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