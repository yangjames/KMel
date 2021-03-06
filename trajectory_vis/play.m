function new_frame = play(handles, FRAME)
%this function facilitates the plotting of multiple frames, considering the
%timestep and any other interuptions in playing the trajectory

    global traj_data numFrames pauseVal FLAGS

    new_delay = 0;
    timeToPlot = 0.002; %this value was assigned using guess and check.
    tic;
    if FLAGS == [1,0,0] %normal play
            while (FLAGS==[1,0,0]) & (FRAME<=numFrames-2)
                prePlotTime=toc-new_delay;
                if pauseVal - prePlotTime > timeToPlot
                    plotQuads(handles, FRAME);
                    %disp('plotted');
                else
                    %disp('notplotted');
                end
                
                displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);
                timeToLoop=toc-new_delay;
                new_delay = pauseVal - timeToLoop;
                tic;
                pause(new_delay);
                
                %account for FRAME edge case
                if FRAME>=numFrames-2
                    FLAGS = [0,0,0];
                    %Quad_Vis2('beginningbutton_Callback',0,0,handles);
                else
                    FRAME=FRAME+1;
                end
                    
            end
        elseif FLAGS == [0,0,1] %reverse play
            while any(FLAGS) & FRAME >= 2
                prePlotTime=toc-new_delay;
                if pauseVal - prePlotTime > timeToPlot
                    plotQuads(handles, FRAME);
                end
                displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);
                timeToLoop=toc-new_delay;
                new_delay = pauseVal - timeToLoop;
                tic;
                pause(new_delay);
                
                % FRAME edge case
                FRAME=FRAME-1;
                if(FRAME==1)
                    displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);
                    FLAGS=[0,0,0];
                end
                    
            end
        elseif FLAGS == [0,1,0] %forward play
            while any(FLAGS) & FRAME < numFrames -2
                prePlotTime=toc-new_delay;
                if pauseVal - prePlotTime > timeToPlot
                    plotQuads(handles, FRAME);
                end
                displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);
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
    new_frame = FRAME;
end