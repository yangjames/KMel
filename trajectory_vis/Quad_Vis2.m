function varargout = Quad_Vis2(varargin)
% QUAD_VIS2 MATLAB code for Quad_Vis2.fig
%      QUAD_VIS2, by itself, creates a new QUAD_VIS2 or raises the existing
%      singleton*.
%
%      H = QUAD_VIS2 returns the handle to a new QUAD_VIS2 or the handle to
%      the existing singleton*.
%
%      QUAD_VIS2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUAD_VIS2.M with the given input arguments.
%
%      QUAD_VIS2('Property','Value',...) creates a new QUAD_VIS2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Quad_Vis2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Quad_Vis2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Quad_Vis2

% Last Modified by GUIDE v2.5 28-Jun-2013 10:27:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Quad_Vis2_OpeningFcn, ...
                   'gui_OutputFcn',  @Quad_Vis2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Quad_Vis2 is made visible.
function Quad_Vis2_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Quad_Vis2 (see VARARGIN)
    global traj_data rotrad quadwidth FRAME FLAGS pa pb pc pd shafta shaftb orientation downwashscale downwashsize
    traj_data = NaN;
    FRAME=1;
    PLAYFLAG=0;
    FFLAG=0;
    RFLAG=0;
    FLAGS = [PLAYFLAG, FFLAG, RFLAG];
    possible_trajectories=dir('./trajectories');
    set(handles.trajectorylist,'String',['Select Quad Trajectory' {possible_trajectories(3:end).name}]);
    
    quadtypelist={'Select Vehicle','Nano+','Toy'};
    set(handles.quadtype,'String',quadtypelist);
    
    %% QUAD PLOT VARIABLES
    rotrad=2*0.0254;
    quadwidth=5*sqrt(2)*0.0254;
    % circle for the rotors
    thetad=(0:0.1:2*pi)';
    rotorx=rotrad*sin(thetad);
    rotory=rotrad*cos(thetad);
    rotorz=zeros(length(thetad),1);
    % position of all the rotors
    pa=[quadwidth/2+rotorx rotory rotorz];
    pb=[-quadwidth/2+rotorx rotory rotorz];
    pc=[rotorx quadwidth/2+rotory rotorz];
    pd=[rotorx -quadwidth/2+rotory rotorz];
    % body frame vals
    shaft=(-quadwidth/2:0.1:quadwidth/2)';
    shaft1=zeros(length(shaft),1);
    % body frame points
    shafta=[shaft shaft1 shaft1];
    shaftb=[shaft1 shaft shaft1];
    % orientation vector
    orientation=[[0 0]' [0 0]' [0 .2]'];
    downwashscale=(quadwidth/2+rotrad);
    downwashsize=1;
    
    
    % Choose default command line output for Quad_Vis
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes Quad_Vis wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Quad_Vis2_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on selection change in trajlist.
function trajlist_Callback(hObject, eventdata, handles)
    % hObject    handle to trajlist (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns trajlist contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from trajlist


% --- Executes during object creation, after setting all properties.
function trajlist_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to trajlist (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in deletetrajbutton.
function deletetrajbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to deletetrajbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global traj_data
    cla reset;
    names=get(handles.trajlist,'string');
    value=get(handles.trajlist,'value');
    temp=char(names);
    temp(value,:)=[];
    if isempty(temp)
        temp={''};
    end
    if value>size(temp,1)
        set(handles.trajlist,'string',cellstr(temp),'value',size(temp,1))
        if ~isempty(traj_data)
            traj_data(value)=[];
        end
    else
        set(handles.trajlist,'string',cellstr(temp))
        if ~isempty(traj_data)
            traj_data(value)=[];
        end
    end
    axes(handles.mainaxes);
        grid on;
        box on;
        hold on;
% --- Executes on button press in playbutton.
function playbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to playbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global traj_data numFrames pauseVal FLAGS FRAME pa pb pc pd shafta shaftb orientation
    if ~any(FLAGS);
        FLAGS = [1,0,0];
        pauseVal = traj_data(1).delT;
    end
    FRAME = play(handles, FRAME);
    


% --- Executes on button press in framebackbutton.
function framebackbutton_Callback(hObject, eventdata, handles)
% hObject    handle to framebackbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FRAME FLAGS traj_data numFrames
    FLAGS = [0,0,0];
    if(FRAME >= 2)
        FRAME = FRAME -1;
        plotQuads(handles, FRAME);
            displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);
    elseif(FRAME==1)
        displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);
    end


% --- Executes on button press in framefwdbutton.
function framefwdbutton_Callback(hObject, eventdata, handles)
% hObject    handle to framefwdbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FRAME FLAGS traj_data numFrames
    FLAGS = [0,0,0];
    if(FRAME < numFrames-2)
        FRAME = FRAME +1;
        plotQuads(handles, FRAME);
        displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);
    elseif(FRAME>=numFrames-2)
        displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);
    end

% --- Executes on button press in reversebutton.
function reversebutton_Callback(hObject, eventdata, handles)
% hObject    handle to reversebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FLAGS pauseVal sliderVal traj_data FRAME
        if ~isempty(traj_data)
            FLAGS = [0,0,1];
            pauseVal = (1-sliderVal)*traj_data(1).delT*2;
            FRAME = play(handles, FRAME);
        end

% --- Executes on button press in forwardbutton.
function forwardbutton_Callback(hObject, eventdata, handles)
% hObject    handle to forwardbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FLAGS pauseVal sliderVal traj_data FRAME
    if ~isempty(traj_data)
        FLAGS = [0,1,0];
        pauseVal = (1-sliderVal)*traj_data(1).delT*2;
        FRAME = play(handles, FRAME);
    end

% --- Executes on slider movement.
function Tracker_Callback(hObject, eventdata, handles)
% hObject    handle to Tracker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global sliderVal;
    sliderVal = get(hObject, 'Value');

% --- Executes during object creation, after setting all properties.
function Tracker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tracker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in beginningbutton.
function beginningbutton_Callback(hObject, eventdata, handles)
% hObject    handle to beginningbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FRAME traj_data numFrames
    FRAME=1;
    plotQuads(handles, FRAME);
    displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);

% --- Executes on selection change in trajectorylist.
function trajectorylist_Callback(hObject, eventdata, handles)
% hObject    handle to trajectorylist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trajectorylist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trajectorylist


% --- Executes during object creation, after setting all properties.
function trajectorylist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadtrajbutton.
function loadtrajbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadtrajbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global traj_data numFrames
cla reset;
menu_list=get(handles.trajectorylist,'String');
menu_val=get(handles.trajectorylist,'Value');
if ~isequal(menu_list{menu_val},'Select Quad Trajectory')
    %load data and initalize other fields
    traj_data = load_traj_data(menu_list{menu_val});
    numFrames = length(traj_data(1).timer);
    
    display_data(traj_data, handles)%display traj info
    
    
    %set up axes
    xmin = zeros(1,length(traj_data));
    xmax = zeros(1,length(traj_data));
    ymin = zeros(1,length(traj_data));
    ymax = zeros(1,length(traj_data));
    zmin = zeros(1,length(traj_data));
    zmax = zeros(1,length(traj_data));
    for i=1:length(traj_data)
        xmin(i) = min(traj_data(i).pos(1,:));
        xmax(i) = max(traj_data(i).pos(1,:));
        ymin(i) = min(traj_data(i).pos(2,:));
        ymax(i) = max(traj_data(i).pos(2,:));
        zmin(i) = min(traj_data(i).pos(3,:));
        zmax(i) = max(traj_data(i).pos(3,:));
    end
    XMIN = min(xmin);
    XMAX = max(xmax);
    YMIN = min(ymin);
    YMAX = max(ymax);
    ZMIN = min(zmin);
    ZMAX = max(zmax);
    
    axes(handles.mainaxes);
    axis([XMIN-1 XMAX+1 YMIN-1 YMAX+1 ZMIN-1 ZMAX+1])
    axis equal
    
    %plot starting positions
    beginningbutton_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in pausebutton.
function pausebutton_Callback(hObject, eventdata, handles)
% hObject    handle to pausebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FLAGS
    FLAGS = [0,0,0];

function new_delT_text_Callback(hObject, eventdata, handles)
% hObject    handle to new_delT_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global traj_data 
    new_delT = str2double(get(hObject,'String')); %returns contents of new_delT_text as a double
    traj_data = load_traj_data(traj_data, new_delT);
    display_data(traj_data, handles)%display traj info

% --- Executes during object creation, after setting all properties.
function new_delT_text_CreateFcn(hObject, eventdata, handles)
global traj_data
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cylindersbutton.
function cylindersbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cylindersbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global traj_data FRAME
for i=1:length(traj_data)
    if traj_data(i).cyl_flag == 0
        traj_data(i).cyl_flag = 1;
    elseif traj_data(i).cyl_flag == 1
        traj_data(i).cyl_flag = 0;
    end
end
plotQuads(handles, FRAME);


% --- Executes on selection change in quadtype.
function quadtype_Callback(hObject, eventdata, handles)
% hObject    handle to quadtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns quadtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from quadtype
global pa pb pc pd shafta shaftb downwashscale downwashsize rotrad quadwidth FRAME

menu_list=get(handles.quadtype,'String');
menu_val=get(handles.quadtype,'Value');
if isequal(menu_list{menu_val},'Toy')
    rotrad=8.5/2*0.0254;
    quadwidth=10*sqrt(2)*0.0254;
    downwashscale=(quadwidth/2+rotrad);
    downwashsize=1;
elseif isequal(menu_list{menu_val},'Nano+')
    rotrad=2*0.0254;
    quadwidth=5*sqrt(2)*0.0254;
    downwashscale=(quadwidth/2+rotrad);
    downwashsize=1;
else
%     rotrad=2*0.0254;
%     quadwidth=5*sqrt(2)*0.0254;
%     downwashscale=(quadwidth/2+rotrad);
%     downwashsize=1;
end
thetad=(0:0.1:2*pi)';
rotorx=rotrad*sin(thetad);
rotory=rotrad*cos(thetad);
rotorz=zeros(length(thetad),1);
% position of all the rotors
pa=[quadwidth/2+rotorx rotory rotorz];
pb=[-quadwidth/2+rotorx rotory rotorz];
pc=[rotorx quadwidth/2+rotory rotorz];
pd=[rotorx -quadwidth/2+rotory rotorz];
shaft=(-quadwidth/2:0.1:quadwidth/2)';
shaft1=zeros(length(shaft),1);
shafta=[shaft shaft1 shaft1];
shaftb=[shaft1 shaft shaft1];
plotQuads(handles, FRAME);

% --- Executes during object creation, after setting all properties.
function quadtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quadtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function frameslider_Callback(hObject, eventdata, handles)
% hObject    handle to frameslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global FLAGS numFrames FRAME traj_data

FLAGS = [0 0 0];
val = get(hObject, 'Value'); %between 0 and 1
FRAME = round(val*(numFrames-4)) + 1;
plotQuads(handles, FRAME);
displayFrameInfo(handles, traj_data(1).delT, numFrames, FRAME);

% --- Executes during object creation, after setting all properties.
function frameslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
