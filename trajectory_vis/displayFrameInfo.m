function displayFrameInfo(handles, delT, numFrames, FRAME)
%this function is used to display info about a certain frame and update the
%GUI accordingly

set(handles.timetext, 'String', strcat(num2str(delT*(FRAME-1), '%5.3f'), 's/', num2str((numFrames-3)*delT, '%5.3f'), 's'));
set(handles.frametext, 'String', strcat(num2str(FRAME), '/', num2str(numFrames-2)));
set(handles.frameslider, 'Value', FRAME/(numFrames -2));

end