function simpleGUI

% this function is used to visualize check trajectory information of
% multiple quadrotor trajectories.

%intializa and hide the GUI as it is being constructed
f = figure('Visible', 'off', 'Position', [360,500,450,285]);
%Construct the components
hsurf= uicontrol('Style','pushbutton','String','start', 'Position', [315,220,70,25],...
    'Callback',{@surfbutton_Callback});
hstop = uicontrol('Style','pushbutton','String','stop', 'Position', [315,180,70,25],...
    'Callback',{@meshbutton_Callback});
hpopup = uicontrol('Style','popupmenu','String',{'Peaks','Membrane','Sinc'},...
    'Position', [300,50,100,25],'Callback',{@popup_menu_Callback});


ha = axes('Units','pixels','Position',[50,60,200,185]);
align([hsurf,hstop,hpopup], 'Center','None');

%initialize GUI
set([f, hsurf, hstop, hpopup], 'Units','normalized');
%generate data to plot
peaks_data=peaks(35);
membrane_data=membrane;
[x,y]=meshgrid(-8:.5:8);
r=sqrt(x.^2+y.^2) + eps;
sinc_data = sin(r)./r;
current_data = peaks_data;
surf(current_data);
set(f, 'Name','Simple GUI');
movegui(f,'center');
set(f,'Visible','on');


%Call back stuffs
    function popup_menu_Callback(source,eventdata)
        %determine the selected dataset
        str = get(source, 'String')
        val = get(source, 'Value')
        %set current data
        switch str{val};
            case 'Peaks'
                current_data=peaks_data;
            case 'Membrane'
                current_data=membrane_data;
            case 'Sinc'
                current_data = sinc_data;
        end
    end
%pushbutton call backs
    function surfbutton_Callback(source, eventdata)
        surf(current_data);
    end
    function meshbutton_Callback(source,eventdata)
        mesh(current_data);
    end
    
                

end
