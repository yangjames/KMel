function play(handles)
global QUAD numFrames pauseVal FLAGS FRAME pa pb pc pd shafta shaftb orientation
    
%     get(handles.timetext)
%     get(handles.frametext)
    tic;
    if FLAGS == [1,0,0] %normal play
            while FLAGS==[1,0,0] & FRAME < numFrames -2
                plotQuads(handles);
                set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
                set(handles.frametext, 'String', num2str(FRAME));
                t2=toc;
%                 while(t2<pauseVal)
%                     t2=toc;
%                     drawnow;
%                 end
                %timeP = pauseVal-t2;
                if(t2<pauseVal)
                    pause(pauseVal-t2);
                end
                %pause(.001);
                tic;
                FRAME=FRAME+1;
            end
        elseif FLAGS == [0,0,1] %reverse play
            while any(FLAGS) && FRAME >= 2
                plotQuads(handles);
                set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
                set(handles.frametext, 'String', num2str(FRAME));
                t2=toc;
                if(t2<pauseVal)
                    pause(pauseVal-t2);
                end
                tic;
                FRAME=FRAME-1;
                if(FRAME==1)
                    set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
                    set(handles.frametext, 'String', num2str(FRAME));
                    FLAGS=[0,0,0];
                end
                    
            end
        elseif FLAGS == [0,1,0] %forward play
            while any(FLAGS) && FRAME < numFrames -2
                plotQuads(handles);
                set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
                set(handles.frametext, 'String', num2str(FRAME));
                t2=toc;
                if(t2<pauseVal)
                    pause(pauseVal-t2);
                end
                tic;
                FRAME=FRAME+1;
            end
    else
    end
    
end