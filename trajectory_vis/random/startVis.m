function startVis(traj_data)

% this function is used to visualize check trajectory information of
% multiple quadrotor trajectories.
close all;
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Manipulate the trajectory data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%the data:
t = 0:0.1:10;
x1 = 5*cos(t);
y1 = 5*sin(t);
z1 = sin(t)+cos(t)+t;
x2 = 10*cos(t);
y2 = 5*sin(t);
z2 = sin(t)+cos(t);
x=0;
y=0;
z=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Construct the GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%intialize and hide the GUI as it is being constructed
f = figure('Visible', 'off', 'Position', [50,500,750,750]);

%Construct the components
hstartstop = uicontrol('Style','pushbutton',...
    'String','Start/Stop',...
    'Position', [300,180,100,40],...
    'Callback',{@startstopbutton_Callback});
hstepf = uicontrol('Style','pushbutton',...
    'String','Step Forward',...
    'Position', [410,180,100,40],...
    'Callback',{@stepfbutton_Callback});
hstepb = uicontrol('Style','pushbutton',...
    'String','Step Backward',...
    'Position', [190,180,100,40],...
    'Callback',{@stepbbutton_Callback});
hslowf = uicontrol('Style','pushbutton',...
    'String','Slow Forward',...
    'Position', [520,180,100,40],...
    'Callback',{@slowfbutton_Callback});
hslowb = uicontrol('Style','pushbutton',...
    'String','Slow Backward',...
    'Position', [80,180,100,40],...
    'Callback',{@slowbbutton_Callback});

%slider for slow play
hslowspeed = uicontrol('Style','slider',...
    'Position', [80, 130, 300, 20],...
    'Callback', {@slider_Callback},...
    'String','Slow Speed');

%popup menu to select file
possible_trajectories = dir('./trajectories');
fprintf(possible_trajectories(3).name);
hselectfile = uicontrol('Style','popupmenu',...
    'String',{possible_trajectories(3:end).name},...
    'Position', [80,80,400,25],...
    'Callback',{@popup_menu_Callback});

handles = [hstartstop hstepf hstepb hslowf hslowb];

ha = axes('Units','pixels','Position',[0,300,800,400],'PlotBoxAspectRatioMode','manual');
align(handles, 'None','Middle');

%%%%%Initalize the GUI%%%%%%%%%
set(f, 'Name','Quadrotor Visualization');
movegui(f,'center');
plot3(0,0,0);
axis equal;
set(ha, 'XLim',[-20 20],'YLim',[-20 20],'ZLim',[0 15]);
grid(ha);
set(f,'Visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Plotting Computations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
traj_data = [];
playSpeed = slider_val;
current_index = 0; %variable to keep track of current place in the trajectory
stop_flag=1;


    function plotTraj(current_index)
            plot3(x(i),y(i),z(i), '.r');
            axis equal;
            set(ha, 'XLim',[-20 20],'YLim',[-20 20],'ZLim',[0 15]);
            grid(ha);
            hold on;
            pause(0.01);
            delete(temp);
            %temp = plot3(x(i),y(i),z(i),'*b');
            temp = surf(X+x(i),Y+y(i),Z+z(i));
            drawnow;
            
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function selectfile_Callback(source,eventdata)
        %determine the selected dataset
        str = get(source, 'String');
        val = get(source, 'Value');
        %select the file from a list of files
        possible_trajs = dir('./trajectories');
        for i=3:length(possible_trajs)
            if str{val}==possible_trajs(i).name
                traj_data = importdata(str{val});
            end
        end
    end

    function startstopbutton_Callback(source, eventdata)
        stop_flag = abs(stop_flag -1);
        if stop_flag == 0
            playSpeed = 1;
            while( ) %execute until anoth button  is pressed.
            end
        elseif stop_flag==1
            %stop the loop
        end
            
      
    end
    
    function stepfbutton_Callback(source, eventdata)
        playSpeed = 0;
    end

    function stepbbutton_Callback(source, eventdata)

    end

    function slowfbutton_Callback(source, eventdata)
        
    end

    function slowbbutton_Callback(source, eventdata)

    end

    function slider_Callback(source, eventdata)
        slider_val = get(source, 'Value');
    end
    
                

end
