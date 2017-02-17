function varargout = voice_usv_assign(varargin)
% VOICE_USV_ASSIGN MATLAB code for voice_usv_assign.fig
%      VOICE_USV_ASSIGN, by itself, creates a new VOICE_USV_ASSIGN or raises the existing
%      singleton*.
%
%      H = VOICE_USV_ASSIGN returns the handle to a new VOICE_USV_ASSIGN or the handle to
%      the existing singleton*.
%
%      VOICE_USV_ASSIGN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOICE_USV_ASSIGN.M with the given input arguments.
%
%      VOICE_USV_ASSIGN('Property','Value',...) creates a new VOICE_USV_ASSIGN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voice_usv_assign_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voice_usv_assign_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voice_usv_assign

% Last Modified by GUIDE v2.5 08-Jan-2015 12:05:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @voice_usv_assign_OpeningFcn, ...
                   'gui_OutputFcn',  @voice_usv_assign_OutputFcn, ...
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


% --- Executes just before voice_usv_assign is made visible.
function voice_usv_assign_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voice_usv_assign (see VARARGIN)

% Choose default command line output for voice_usv_assign
handles.output = hObject;
handles.f1 = varargin{1}{1};
%handles.f1 = '~/Desktop/05F/cut_syllables';
handles.f2 = varargin{2}{1};
%handles.f2 = '~/Desktop/05F/cut_syllables';
handles.thresh = varargin{3}{1};
%handles.thresh = '0.8';
handles.minsize = varargin{4}{1};

handles.f1n = strrep(handles.f1,' ','\ ');
handles.f2n = strrep(handles.f2,' ','\ ');

%Cluster syllables
[status,result]=system(['/usr/local/bin/R --slave --args' ' ' handles.f1n ' < clusterUSV_pub.r']);
[status,result]=system(['/usr/local/bin/R --slave --args' ' ' handles.f2n ' < clusterUSV_pub.r']);

%Generate .wav files for cohesive and split clusters
system(['/usr/local/bin/R --slave --args' ' ' handles.f1n ' ' 'wavs' ' ' handles.thresh ' ' handles.minsize ' < getClusterCenterUSV_pub.r']);
system(['/usr/local/bin/R --slave --args' ' ' handles.f2n ' ' 'wavs' ' ' handles.thresh ' ' handles.minsize ' < getClusterCenterUSV_pub.r']);

f = findstr('/',handles.f1);
handles.f1d = strcat(handles.f1(1:f(length(f))),'matlab_wavs/');
f = findstr('/',handles.f2);
handles.f2d = strcat(handles.f2(1:f(length(f))),'matlab_wavs/');

handles.count = 1;

pattern1 = fullfile(handles.f1d,'*.wav');
%f = findstr('/',pattern1);
%handles.dir1 = strcat(pattern1(1:f(length(f)-1)));
%pattern1 = strcat(pattern1(1:f(length(f)-1)),'*.wav');
handles.directory1 = dir(pattern1);
handles.sz1 = size(handles.directory1);
for i = 1:handles.sz1(1);
    handles.directory1(i).name = strcat(handles.f1d,handles.directory1(i).name);
end

pattern2 = fullfile(handles.f2d,'*.wav');
%f = findstr('/',pattern2);
%handles.dir2 = strcat(pattern2(1:f(length(f)-1)));
%pattern2 = strcat(pattern2(1:f(length(f)-1)),'*.wav');
handles.directory2 = dir(pattern2);
handles.sz2 = size(handles.directory2);
for i = 1:handles.sz2(1);
    handles.directory2(i).name = strcat(handles.f2d,handles.directory2(i).name);
end

totalSize = handles.sz1(1)+handles.sz2(1);
handles.order = randsample(totalSize,totalSize);

if handles.order(handles.count) > handles.sz1(1);
    fileToDraw = handles.directory2(handles.order(1)-handles.sz1(1)).name;
else
    fileToDraw = handles.directory1(handles.order(1)).name;
end

sp = audioread(fileToDraw);
axes(handles.axes1);
specgram(sp,[],250000);

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
else
    set(handles.pushbutton16,'Enable','on');
    set(handles.pushbutton17,'Visible','on');
    set(handles.text4,'Visible','on');
end
    
set(handles.text8,'String',sum(handles.sz1(1)+handles.sz2(1)));
set(handles.text7,'String','1');
set(handles.pushbutton18,'Visible','off');
set(handles.pushbutton19,'Visible','off');
set(handles.pushbutton20,'Visible','off');
set(handles.text9,'Visible','off');
set(handles.text12,'Visible','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voice_usv_assign wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = voice_usv_assign_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'co';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'co';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end
    
if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);
    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
    
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'h';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'h';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);

    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
    
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'ts';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'ts';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);

    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end

    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'u';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'u';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);

    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end

    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    
    sp = audioread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'ch';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'ch';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);

    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 's';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 's';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);
    
    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'fs';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'fs';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);

    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'd';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'd';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);
    
    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'f';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'f';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.text7,'String',handles.count);

    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'db';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'db';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    set(handles.text7,'String',handles.count);

    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'tp';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'tp';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    set(handles.text7,'String',handles.count);

    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.order(handles.count) <= handles.sz1(1)
    handles.directory1(handles.order(handles.count)).classification = 'm';
else
    handles.directory2(handles.order(handles.count)-handles.sz1(1)).classification = 'm';
end

handles.count = handles.count+1;

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    set(handles.text7,'String',handles.count);
    
    if handles.order(handles.count) > handles.sz1(1)
        fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
    else
        fileToDraw = handles.directory1(handles.order(handles.count)).name;
    end
    
    sp = wavread(fileToDraw);
    axes(handles.axes1);
    specgram(sp,[],250000);
end

guidata(hObject,handles);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.count = handles.count-1;
set(handles.text7,'String',handles.count);

if handles.order(handles.count) > handles.sz1(1)
    fileToDraw = handles.directory2(handles.order(handles.count)-handles.sz1(1)).name;
else
    fileToDraw = handles.directory1(handles.order(handles.count)).name;
end

if handles.count == 1
    set(handles.pushbutton16,'Enable','off');
else
    set(handles.pushbutton16,'Enable','on');
end

if handles.count == handles.sz1(1)+handles.sz2(1)+1
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton8,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.pushbutton11,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton17,'Visible','on');
    set(handles.pushbutton17,'BackgroundColor','red');
    set(handles.text4,'Visible','on');
else
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton4,'Enable','on');
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
    set(handles.pushbutton8,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
    set(handles.pushbutton12,'Enable','on');
    set(handles.pushbutton13,'Enable','on');
    set(handles.pushbutton14,'Enable','on');
    set(handles.pushbutton17,'Visible','off');
    set(handles.text4,'Visible','off');
    set(handles.pushbutton18,'Visible','off');
    set(handles.pushbutton19,'Visible','off');
    set(handles.text9,'Visible','off');
end

sp = wavread(fileToDraw);
axes(handles.axes1);
specgram(sp,[],250000);
guidata(hObject,handles);


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = findstr('/',handles.f1d);
handles.f1p = handles.f1d(1:f(length(f)-1));
handles.dir1 = handles.f1d(1:f(length(f)));
handles.dir1u = strrep(handles.f1p,' ','\ ');
f = findstr('/',handles.f2d);
handles.f2p = handles.f2d(1:f(length(f)-1));
handles.dir2 = handles.f2d(1:f(length(f)));
handles.dir2u = strrep(handles.f2p,' ','\ ');

classifications1 = [];
for i = 1:handles.sz1(1)
    classifications1 = char(classifications1, handles.directory1(i).classification);
end
dlmwrite(strcat(handles.f1p,'assignments.csv'),classifications1);

classifications2 = [];
for i = 1:handles.sz2(1)
    classifications2 = char(classifications2, handles.directory2(i).classification);
end
dlmwrite(strcat(handles.f2p,'assignments.csv'),classifications2);

% f = findstr('/',handles.dir1n);
% handles.dir1 = handles.dir1n(1:f(length(f)-1));
system(['/usr/local/bin/R --slave --args ' handles.dir1u ' < applyClassifications_pub.r']);

% f = findstr('/',handles.dir2n);
% handles.dir2 = handles.dir2n(1:f(length(f)-1));
system(['/usr/local/bin/R --slave --args ' handles.dir2u ' < applyClassifications_pub.r']);

set(handles.pushbutton17,'BackgroundColor','green');
set(handles.pushbutton18,'Visible','on');
set(handles.pushbutton18,'BackgroundColor','red');
set(handles.pushbutton19,'Visible','on');
set(handles.pushbutton19,'BackgroundColor','red');
set(handles.pushbutton20,'Visible','on');
set(handles.text12,'Visible','on');
set(handles.text9,'Visible','on');


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Run an R script to join and sort WAV files
set(handles.pushbutton18,'BackgroundColor','yellow');
pause(0.00000000001);
setenv('PATH', [getenv('PATH') ':/usr/local/bin']);
f = findstr('/',handles.f1d);
handles.f1parent = handles.f1d(1:f(length(f)-1));
handles.f1parent = strrep(handles.f1parent,' ','\ ');
[status,response]=system(['/usr/local/bin/R --slave --args' ' ' handles.f1parent  ' < sortWavs.r']);
f = findstr('/',handles.f1d);
handles.f2parent = handles.f2d(1:f(length(f)-1));
handles.f2parent = strrep(handles.f2parent,' ','\ ');
[status,response]=system(['/usr/local/bin/R --slave --args' ' ' handles.f2parent  ' < sortWavs.r']);
set(handles.pushbutton18,'BackgroundColor','green');



% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton19,'BackgroundColor','yellow');
pause(0.00000000001);
f = findstr('/',handles.f1d);
handles.f1parent = handles.f1d(1:f(length(f)-1));
handles.f1parent = strrep(handles.f1parent,' ','\ ');
[status,response]=system(['/usr/local/bin/R --slave --args' ' ' handles.f1parent  ' < usvPieChart.r']);
f = findstr('/',handles.f2d);
handles.f2parent = handles.f2d(1:f(length(f)-1));
handles.f2parent = strrep(handles.f2parent,' ','\ ');
[status,response]=system(['/usr/local/bin/R --slave --args' ' ' handles.f2parent  ' < usvPieChart.r']);
set(handles.pushbutton19,'BackgroundColor','green');


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
