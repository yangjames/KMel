function plotQuads(handles, FRAME)
%this function plots one frame in the quadrotor simulation
    global traj_data pa pb pc pd shafta shaftb orientation downwashscale downwashsize
    
    cyl_flag = traj_data(1).cyl_flag;
    if FRAME==1        
        axes(handles.mainaxes);
        cla;
        grid on;
        box on;
        hold on;

        for id=1:length(traj_data)
            traj_data(id).rotaplot=plot3(0,0,0,'b');
            traj_data(id).rotbplot=plot3(0,0,0,'r');
            traj_data(id).rotcplot=plot3(0,0,0,'r');
            traj_data(id).rotdplot=plot3(0,0,0,'r');
            traj_data(id).shaftaplot=plot3(0,0,0,'k');
            traj_data(id).shaftbplot=plot3(0,0,0,'k');
            traj_data(id).orientation=plot3(0,0,0,'k');
            traj_data(id).projection=surf([0 0],[0 0],[0 0;0 0]);
        end
    end
    
    for i=1:length(traj_data)
        %get rotation matrix
        [roll,pitch]=getAngles(traj_data(i).a(:,FRAME),traj_data(i).yaw(FRAME));
        % add in the extra roll and pitch angles
        roll = roll + traj_data(i).extra_roll(FRAME);
        pitch = pitch + traj_data(i).extra_pitch(FRAME);
        
        R=getRot(traj_data(i).yaw(FRAME),roll,pitch); % the rotation matrix
        % get new orientations
        tpa=R*pa';
        tpb=R*pb';
        tpc=R*pc';
        tpd=R*pd';
        tshafta=R*shafta';
        tshaftb=R*shaftb';
        torientation=R*orientation';
        if cyl_flag
            % plot a cylinder to model downwash
            [x1,y1,z1]=cylinder([1 1],8);
            refpos=traj_data(i).pos(:,FRAME);
            x=reshape(x1*downwashscale,1,size(x1,1)*size(x1,2));
            y=reshape(y1*downwashscale,1,size(y1,1)*size(y1,2));
            z=reshape((z1-1)*downwashsize,1,size(z1,1)*size(z1,2));
            vec=R*[x;y;z];
            newx=reshape(vec(1,:),2,length(vec(1,:))/2);
            newy=reshape(vec(2,:),2,length(vec(2,:))/2);
            newz=reshape(vec(3,:),2,length(vec(3,:))/2);

            addvecx=repmat([refpos(1); refpos(1)],1,size(newx,2));
            addvecy=repmat([refpos(2); refpos(2)],1,size(newy,2));
            addvecz=repmat([refpos(3); refpos(3)],1,size(newz,2));
            set(traj_data(i).projection,'XData',newx+addvecx, ...
                                    'YData',newy+addvecy, ...
                                    'ZData',newz+addvecz, ...
                                    'FaceAlpha',0.5, ...
                                    'EdgeColor','red', ...
                                    'EdgeAlpha',0.6, ...
                                    'DiffuseStrength',1, ...
                                    'AmbientStrength',1);
        else
            set(traj_data(i).projection,'XData',[0 0], ...
                                    'YData',[0 0], ...
                                    'ZData',[0 0; 0 0])
        end
        
        % replot quadrotor blades
        set(traj_data(i).rotaplot,'XData',tpa(1,:)+traj_data(i).pos(1,FRAME), ...
                            'YData',tpa(2,:)+traj_data(i).pos(2,FRAME), ...
                            'ZData',tpa(3,:)+traj_data(i).pos(3,FRAME));

        set(traj_data(i).rotbplot,'XData',tpb(1,:)+traj_data(i).pos(1,FRAME), ...
                            'YData',tpb(2,:)+traj_data(i).pos(2,FRAME), ...
                            'ZData',tpb(3,:)+traj_data(i).pos(3,FRAME));

        set(traj_data(i).rotcplot,'XData',tpc(1,:)+traj_data(i).pos(1,FRAME), ...
                            'YData',tpc(2,:)+traj_data(i).pos(2,FRAME), ...
                            'ZData',tpc(3,:)+traj_data(i).pos(3,FRAME));

        set(traj_data(i).rotdplot,'XData',tpd(1,:)+traj_data(i).pos(1,FRAME), ...
                            'YData',tpd(2,:)+traj_data(i).pos(2,FRAME), ...
                            'ZData',tpd(3,:)+traj_data(i).pos(3,FRAME));
        % replot quadrotor body
        set(traj_data(i).shaftaplot,'XData',tshafta(1,:)+traj_data(i).pos(1,FRAME), ...
                                'YData',tshafta(2,:)+traj_data(i).pos(2,FRAME), ...
                                'ZData',tshafta(3,:)+traj_data(i).pos(3,FRAME));

        set(traj_data(i).shaftbplot,'XData',tshaftb(1,:)+traj_data(i).pos(1,FRAME), ...
                                'YData',tshaftb(2,:)+traj_data(i).pos(2,FRAME), ...
                                'ZData',tshaftb(3,:)+traj_data(i).pos(3,FRAME));
        % replot orientation vector
        set(traj_data(i).orientation,'XData',torientation(1,:)+traj_data(i).pos(1,FRAME), ...
                                'YData',torientation(2,:)+traj_data(i).pos(2,FRAME), ...
                                'ZData',torientation(3,:)+traj_data(i).pos(3,FRAME));
    end
    

end