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

% Last Modified by GUIDE v2.5 18-Jun-2013 14:43:07

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
    global QUAD FRAME FLAGS pa pb pc pd shafta shaftb orientation
    QUAD={};
    FRAME=1;
    PLAYFLAG=0;
    FFLAG=0;
    RFLAG=0;
    FLAGS = [PLAYFLAG, FFLAG, RFLAG];
    handles
    possible_trajectories=dir('./trajectories');
    set(handles.trajectorylist,'String',['Select Quad Trajectory' {possible_trajectories(3:end).name}]);
    
    %% QUAD PLOT VARIABLES
    quadwidth=12*0.0254; % in inches

    % circle for the rotors
    thetad=(0:0.1:2*pi)';
    rotrad=3*0.0254; % in inches
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
    global QUAD
    cla reset;
    names=get(handles.trajlist,'string')
    value=get(handles.trajlist,'value');
    temp=char(names);
    temp(value,:)=[];
    if isempty(temp)
        temp={''};
    end
    if value>size(temp,1)
        set(handles.trajlist,'string',cellstr(temp),'value',size(temp,1))
        if ~isempty(QUAD)
            QUAD(value)=[];
        end
    else
        set(handles.trajlist,'string',cellstr(temp))
        if ~isempty(QUAD)
            QUAD(value)=[];
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
    global QUAD numFrames pauseVal FLAGS FRAME pa pb pc pd shafta shaftb orientation
    if ~any(FLAGS);
        FLAGS = [1,0,0];
        pauseVal = QUAD{1}.delT;
    end
    play(handles)
    


% --- Executes on button press in framebackbutton.
function framebackbutton_Callback(hObject, eventdata, handles)
% hObject    handle to framebackbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FRAME FLAGS QUAD
    FLAGS = [0,0,0];
    if(FRAME >= 2)
        FRAME = FRAME -1;
        plotQuads(handles);
        set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
        set(handles.frametext, 'String', num2str(FRAME));
    elseif(FRAME==1)
        set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
        set(handles.frametext, 'String', num2str(FRAME));
    end


% --- Executes on button press in framefwdbutton.
function framefwdbutton_Callback(hObject, eventdata, handles)
% hObject    handle to framefwdbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FRAME FLAGS QUAD numFrames
    FLAGS = [0,0,0];
    if(FRAME < numFrames-2)
        FRAME = FRAME -1;
        plotQuads(handles);
        set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
        set(handles.frametext, 'String', num2str(FRAME));
    elseif(FRAME>=numFrames-2)
        set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
        set(handles.frametext, 'String', num2str(FRAME));
    end

% --- Executes on button press in reversebutton.
function reversebutton_Callback(hObject, eventdata, handles)
% hObject    handle to reversebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FLAGS pauseVal sliderVal QUAD
        if ~isempty(QUAD)
            FLAGS = [0,0,1];
            pauseVal = (1-sliderVal)*QUAD{1}.delT*2;
            play(handles);
        end

% --- Executes on button press in forwardbutton.
function forwardbutton_Callback(hObject, eventdata, handles)
% hObject    handle to forwardbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FLAGS pauseVal sliderVal QUAD
    if ~isempty(QUAD)
        FLAGS = [0,1,0];
        pauseVal = (1-sliderVal)*QUAD{1}.delT*2;
        play(handles);
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
    global FRAME QUAD
    FRAME=1;
    plotQuads(handles);
    set(handles.timetext, 'String', strcat(num2str(QUAD{1}.delT*(FRAME-1)), 's'));
    set(handles.frametext, 'String', num2str(FRAME));

% --- Executes on selection change in trajectorylist.
function trajectorylist_Callback(hObject, eventdata, handles)
% hObject    handle to trajectorylist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trajectorylist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trajectorylist


% --- Executes during object creation, after setting all properties.
function trajectorylist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trajectorylist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadtrajbutton.
function loadtrajbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadtrajbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global QUAD numFrames
QUAD={};
cla reset;
menu_list=get(handles.trajectorylist,'String');
menu_val=get(handles.trajectorylist,'Value');
if ~isequal(menu_list{menu_val},'Select Quad Trajectory')
    data = load(['trajectories/' menu_list{menu_val}]); %loads traj_data as struct 's' (not robust to assume this)
    for id=1:length(data.s)
        QUAD{id}=data.s(id);
        QUAD{id}.a=(QUAD{id}.vel(:,2:end)-QUAD{id}.vel(:,1:end-1))/QUAD{id}.delT;
        numFrames = length(QUAD{id}.timer);
    end
    %set up axes
    xmin = zeros(1,length(QUAD));
    xmax = zeros(1,length(QUAD));
    ymin = zeros(1,length(QUAD));
    ymax = zeros(1,length(QUAD));
    zmin = zeros(1,length(QUAD));
    zmax = zeros(1,length(QUAD));
    for i=1:length(QUAD)
        xmin(i) = min(data.s(i).pos(1,:));
        xmax(i) = max(data.s(i).pos(1,:));
        ymin(i) = min(data.s(i).pos(2,:));
        ymax(i) = max(data.s(i).pos(2,:));
        zmin(i) = min(data.s(i).pos(3,:));
        zmax(i) = max(data.s(i).pos(3,:));
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
    
    
    names=get(handles.trajlist,'string');
    temp=char(names);
    newname=strvcat(temp,[num2str(id),' ',menu_list{menu_val}]);
    set(handles.trajlist,'string',cellstr(newname))
end


% --- Executes on button press in pausebutton.
function pausebutton_Callback(hObject, eventdata, handles)
% hObject    handle to pausebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FLAGS
    FLAGS = [0,0,0];
