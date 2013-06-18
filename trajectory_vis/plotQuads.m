function plotQuads(handles)
%this function plots one frame in the quadrotor simulation
    global QUAD FRAME pa pb pc pd shafta shaftb orientation

    if FRAME==1        
        axes(handles.mainaxes);
        cla;
        grid on;
        box on;
        hold on;
        for id=1:length(QUAD)
            QUAD{id}.rotaplot=plot3(0,0,0,'b');
            QUAD{id}.rotbplot=plot3(0,0,0,'r');
            QUAD{id}.rotcplot=plot3(0,0,0,'r');
            QUAD{id}.rotdplot=plot3(0,0,0,'r');
            QUAD{id}.shaftaplot=plot3(0,0,0,'k');
            QUAD{id}.shaftbplot=plot3(0,0,0,'k');
            QUAD{id}.orientation=plot3(0,0,0,'k');
        end
    end
    for i=1:length(QUAD)
        %get rotation matrix
        [roll,pitch]=getAngles(QUAD{i}.a(:,FRAME),QUAD{i}.yaw(FRAME));
        R=getRot(QUAD{i}.yaw(FRAME),roll,pitch);
        % get new orientations
        tpa=R*pa';
        tpb=R*pb';
        tpc=R*pc';
        tpd=R*pd';
        tshafta=R*shafta';
        tshaftb=R*shaftb';
        torientation=R*orientation';

        % replot quadrotor blades
        set(QUAD{i}.rotaplot,'XData',tpa(1,:)+QUAD{i}.pos(1,FRAME), ...
                            'YData',tpa(2,:)+QUAD{i}.pos(2,FRAME), ...
                            'ZData',tpa(3,:)+QUAD{i}.pos(3,FRAME));

        set(QUAD{i}.rotbplot,'XData',tpb(1,:)+QUAD{i}.pos(1,FRAME), ...
                            'YData',tpb(2,:)+QUAD{i}.pos(2,FRAME), ...
                            'ZData',tpb(3,:)+QUAD{i}.pos(3,FRAME));

        set(QUAD{i}.rotcplot,'XData',tpc(1,:)+QUAD{i}.pos(1,FRAME), ...
                            'YData',tpc(2,:)+QUAD{i}.pos(2,FRAME), ...
                            'ZData',tpc(3,:)+QUAD{i}.pos(3,FRAME));

        set(QUAD{i}.rotdplot,'XData',tpd(1,:)+QUAD{i}.pos(1,FRAME), ...
                            'YData',tpd(2,:)+QUAD{i}.pos(2,FRAME), ...
                            'ZData',tpd(3,:)+QUAD{i}.pos(3,FRAME));
        % replot quadrotor body
        set(QUAD{i}.shaftaplot,'XData',tshafta(1,:)+QUAD{i}.pos(1,FRAME), ...
                                'YData',tshafta(2,:)+QUAD{i}.pos(2,FRAME), ...
                                'ZData',tshafta(3,:)+QUAD{i}.pos(3,FRAME));

        set(QUAD{i}.shaftbplot,'XData',tshaftb(1,:)+QUAD{i}.pos(1,FRAME), ...
                                'YData',tshaftb(2,:)+QUAD{i}.pos(2,FRAME), ...
                                'ZData',tshaftb(3,:)+QUAD{i}.pos(3,FRAME));
        % replot orientation vector
        set(QUAD{i}.orientation,'XData',torientation(1,:)+QUAD{i}.pos(1,FRAME), ...
                                'YData',torientation(2,:)+QUAD{i}.pos(2,FRAME), ...
                                'ZData',torientation(3,:)+QUAD{i}.pos(3,FRAME));
    end
    

end