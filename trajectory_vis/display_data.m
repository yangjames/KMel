function display_data(traj_data, handles)
% this function simply displays data collected about the trajectories

set(handles.max_vel_text, 'String', [num2str(traj_data(1).maxV), ' m/s']);
set(handles.max_acc_text, 'String', [num2str(traj_data(1).maxA),' m2/s']);
set(handles.minxydist_text, 'String', [num2str(traj_data(1).minXY), ' m']);
set(handles.minxyzdist_text, 'String', [num2str(traj_data(1).minXYZ), ' m']);
set(handles.minthrust_text, 'String', [num2str(traj_data(1).minThrust), ' mg']);
set(handles.maxthrust_text, 'String', [num2str(traj_data(1).maxThrust), ' mg']);
set(handles.maxroll_text, 'String', [num2str(traj_data(1).maxRoll*(180/pi)), ' deg']);
set(handles.maxpitch_text, 'String', [num2str(traj_data(1).maxPitch*(180/pi)), ' deg']);

end