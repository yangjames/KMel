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
            disp([idx eidx])
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
                    fprintf('eidx-idx=%d\n',eidx-idx)
                    if eidx-idx>=len
                        chk=setCheckSum(packet(idx-3:idx+len-1));
                        if chk == packet(idx+len)
                            err=packet(idx+1);
                            payload=packet(idx+2:idx+len-1);
                            idx=eidx;
                        else
                            prob=1;
                            pos=0;
                            idx=idx+1
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
        disp([idx pos prob])
        if prob==0
            out=[id err payload];
        elseif prob~=0
            out=[];
        end
        out
    end