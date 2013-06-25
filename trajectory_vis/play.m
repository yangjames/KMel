function play(handles)
%this function facilitates the plotting of multiple frames, considering the
%timestep and any other interuptions in playing the trajectory

    global traj_data numFrames pauseVal FLAGS FRAME pa pb pc pd shafta shaftb orientation

    new_delay = 0;
    timeToPlot = 0.002; %this value was assigned using guess and check.
    tic;
    if FLAGS == [1,0,0] %normal play
            while (FLAGS==[1,0,0]) & (FRAME<=numFrames-2)
                prePlotTime=toc-new_delay;
                if pauseVal - prePlotTime > timeToPlot
                    plotQuads(handles);
                    %disp('plotted');
                else
                    %disp('notplotted');
                end
                set(handles.timetext, 'String', strcat(num2str(traj_data(1).delT*(FRAME-1)), 's'));
                set(handles.frametext, 'String', num2str(FRAME));
                timeToLoop=toc-new_delay;
                new_delay = pauseVal - timeToLoop;
                tic;
                pause(new_delay);
                
                %account for FRAME edge case
                if FRAME==numFrames-2
                    FLAGS = [0,0,0];
                    Quad_Vis2('beginningbutton_Callback',0,0,handles) 
                else
                    FRAME=FRAME+1;
                end
                    
            end
        elseif FLAGS == [0,0,1] %reverse play
            while any(FLAGS) & FRAME >= 2
                prePlotTime=toc-new_delay;
                if pauseVal - prePlotTime > timeToPlot
                    plotQuads(handles);
                    disp('plotted');
                else
                    disp('notplotted');
                end
                set(handles.timetext, 'String', strcat(num2str(traj_data(1).delT*(FRAME-1)), 's'));
                set(handles.frametext, 'String', num2str(FRAME));
                timeToLoop=toc-new_delay;
                new_delay = pauseVal - timeToLoop;
                tic;
                pause(new_delay);
                
                % FRAME edge case
                FRAME=FRAME-1;
                if(FRAME==1)
                    set(handles.timetext, 'String', strcat(num2str(traj_data(1).delT*(FRAME-1)), 's'));
                    set(handles.frametext, 'String', num2str(FRAME));
                    FLAGS=[0,0,0];
                end
                    
            end
        elseif FLAGS == [0,1,0] %forward play
            while any(FLAGS) & FRAME < numFrames -2
                prePlotTime=toc-new_delay;
                if pauseVal - prePlotTime > timeToPlot
                    plotQuads(handles);
                    disp('plotted');
                else
                    disp('notplotted');
                end
                set(handles.timetext, 'String', strcat(num2str(traj_data(1).delT*(FRAME-1)), 's'));
                set(handles.frametext, 'String', num2str(FRAME));
                timeToLoop=toc-new_delay;
                new_delay = pauseVal - timeToLoop;
                tic;
                pause(new_delay);
                
                % FRAME edge case
                if FRAME==numFrames-2
                    FLAGS = [0,0,0];
                    Quad_Vis2('beginningbutton_Callback',0,0,handles) 
                else
                    FRAME=FRAME+1;
                end
            end
    else
    end
    
end