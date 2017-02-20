function varargout = voice_usv(varargin)
% VOICE_USV MATLAB code for voice_usv.fig
%      VOICE_USV, by itself, creates a new VOICE_USV or raises the existing
%      singleton*.
%
%      H = VOICE_USV returns the handle to a new VOICE_USV or the handle to
%      the existing singleton*.
%
%      VOICE_USV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOICE_USV.M with the given input arguments.
%
%      VOICE_USV('Property','Value',...) creates a new VOICE_USV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voice_usv_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voice_usv_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voice_usv

% Last Modified by GUIDE v2.5 08-Jan-2015 12:04:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @voice_usv_OpeningFcn, ...
                   'gui_OutputFcn',  @voice_usv_OutputFcn, ...
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


% --- Executes just before voice_usv is made visible.
function voice_usv_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voice_usv (see VARARGIN)

% Choose default command line output for voice_usv
if isunix
	PATH = getenv('PATH');
	setenv('PATH',[PATH ':/usr/local/bin']);
	handles.startdir = cd;
	handles.output = hObject;
	handles.edit5 = '0.80';
	handles.edit6 = '5';
    
    %check for R installation
    [status,result] = system('which Rscript');
    if ~exist(strcat(result))
        error('No R installation detected.')
    end
    
    %check for SoX installation
    [status,result] = system('which sox');
    if ~exist(strcat(result))
        error('No SoX installation detected.')
    end

	handles.installdir = which('voice_usv.m');
	f = findstr('/',handles.installdir);
	handles.installdir = handles.installdir(1:max(f));
	set(handles.text22,'Visible','off');
	cd(handles.installdir);
    cd('..');
    handles.installdir = pwd;
    system(['RScript ./R/packageCheck.r']);
elseif ispc
	handles.startdir = cd;
	handles.output = hObject;
	handles.edit5 = '0.80';
	handles.edit6 = '5';
    
    %check for R installation
    [status,result] = system('where Rscript');
    if ~exist(strcat(result))
        error('No R installation detected. Please install R and try again.')
    end
    
    %check for SoX installation
    [status0,result0] = system('where sox');
    if ~status0 == 0
        disp('SoX not found in system path, checking for installation...')
        [status,result] = system('cd \"Program Files" & dir /b/s sox.exe');
        if ~exist(strcat(result))
            error('No SoX installation detected in Program Files. Install SoX and try again.')
        elseif exist(strcat(result))
            disp('Found SoX install, adding to PATH...')
            [pathstr,name,ext] = fileparts(result);
            setenv('PATH',[getenv('PATH') strcat(';',pathstr)]);
            [status3,result3] = system('where sox');
            if ~status3 == 0
                disp('Unable to add SoX to PATH. Please remedy this yourself.')
            else
                disp('Added SoX to PATH. Launching VoICE_USV.')
            end
        end
    end
            
	handles.installdir = which('voice_usv.m');
	f = findstr('\',handles.installdir);
	handles.installdir = handles.installdir(1:max(f));
	set(handles.text22,'Visible','off');
	cd(handles.installdir);
    cd('..');
    handles.installdir = pwd;
    system(['RScript ./R/packageCheck.r']);
else
	error('Unable to determine OS.')
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voice_usv wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = voice_usv_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isunix
	folder = uigetdir('Select directory containing USVs to be clustered.');
	listofiles = dir(folder);
	handles.folder = folder;
	guidata(hObject,handles);
	set(handles.text2,'String', folder);
elseif ispc
	folder = uigetdir('Select directory containing USVs to be clustered.');
	listofiles = dir(folder);
	handles.folder = folder;
	guidata(hObject,handles);
	set(handles.text2,'String', folder);
else
	error('Unable to determine OS.')
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
edit1 = get(hObject,'String');
handles.edit1 = edit1;
set(handles.text5,'String','Ready!');
set(handles.text5,'Backgroundcolor','g');
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.foldern = strrep(handles.folder,' ','\ ');
if isunix
    system(['/usr/local/bin/R --slave --args ' handles.foldern ' < ./R/renameWavs.r']);
elseif ispc
    system(['R --slave --args ' handles.foldern ' < ./R/renameWavs.r']);
else
    error('Cannot determine OS.')
end
id = handles.edit1;
set(handles.text5,'String','Running!');
set(handles.text5,'Backgroundcolor','r');
pause(.0000001)
similaritybatch_mouse_pub(handles.folder,id);
set(handles.text5,'Backgroundcolor','y');
set(handles.text5,'String','Done! Awaiting next animal.');
cd(handles.installdir);

% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileAssign1, pathAssign1] = uigetfile('*.csv','Select similarity batch.');
handles.fileAssign1 = strcat(pathAssign1,fileAssign1);
guidata(hObject,handles);
set(handles.text15,'String', fileAssign1);


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileAssign2, pathAssign2] = uigetfile('*.csv','Select similarity batch.');
handles.fileAssign2 = strcat(pathAssign2,fileAssign2);
handles.fileAssign2u = handles.fileAssign2;
guidata(hObject,handles);
set(handles.text16,'String', fileAssign2);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% launch the assignment gui; pass the f1, f2, and cohesion threshold
% variables out to it

set(handles.text22,'Visible','on');
if isunix
	setenv('DYLD_LIBRARY_PATH', '/usr/local/bin/');
	voice_usv_assign({handles.fileAssign1},{handles.fileAssign2},{handles.edit5},{handles.edit6});
elseif ispc
	voice_usv_assign({handles.fileAssign1},{handles.fileAssign2},{handles.edit5},{handles.edit6});
set(handles.text22,'Visible','off');
else
    error('Unable to determine OS.')
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
edit5 = get(hObject,'String');
handles.edit5 = edit5;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
edit6 = get(hObject,'String');
handles.edit6 = edit6;
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
