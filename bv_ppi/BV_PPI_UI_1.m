function varargout = BV_PPI_UI_1(varargin)
% BV_PPI_UI_1 MATLAB code for BV_PPI_UI_1.fig
%      BV_PPI_UI_1, by itself, creates a new BV_PPI_UI_1 or raises the existing
%      singleton*.
%
%      H = BV_PPI_UI_1 returns the handle to a new BV_PPI_UI_1 or the handle to
%      the existing singleton*.
%
%      BV_PPI_UI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BV_PPI_UI_1.M with the given input arguments.
%
%      BV_PPI_UI_1('Property','Value',...) creates a new BV_PPI_UI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BV_PPI_UI_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BV_PPI_UI_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BV_PPI_UI_1

% Last Modified by GUIDE v2.5 13-Jan-2014 16:01:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BV_PPI_UI_1_OpeningFcn, ...
                   'gui_OutputFcn',  @BV_PPI_UI_1_OutputFcn, ...
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


% --- Executes just before BV_PPI_UI_1 is made visible.
function BV_PPI_UI_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BV_PPI_UI_1 (see VARARGIN)

% Choose default command line output for BV_PPI_UI_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BV_PPI_UI_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BV_PPI_UI_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnStart.
function btnStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SDM_Folder = get(handles.txtSDMFolder,'String');
if ~exist(SDM_Folder, 'file')
    hMsg=errordlg('Selected SDM folder path does not exist');
    uiwait(hMsg);
    return;
end

VTC_Folder = get(handles.txtVTCFolder,'String');
if ~exist(VTC_Folder, 'file')
    hMsg=errordlg('Selected VTC folder path does not exist');
    uiwait(hMsg);
    return;
end

VOI_File = get(handles.txtVOIFile,'String');
if ~exist(VOI_File, 'file')
    hMsg=errordlg('Selected VOI file does not exist');
    uiwait(hMsg);
    return;
end


num_chars = str2double(get(handles.txtNumChars,'String'));
if isnan(num_chars)
    hMsg=errordlg(sprintf('Invalid No. of chars to match.\nSpecify a numeric value or leave empty for full name match'));
    uiwait(hMsg);
    return;
end

try
    matches = bv_ppi_match_files(VTC_Folder, SDM_Folder, num_chars);
catch exception
    hMsg=errordlg(exception.message);
    uiwait(hMsg);
    return;
end

BV_PPI_UI_2(matches, VOI_File);
close(handles.figure1);


function txtVTCFolder_Callback(hObject, eventdata, handles)
% hObject    handle to txtVTCFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtVTCFolder as text
%        str2double(get(hObject,'String')) returns contents of txtVTCFolder as a double


% --- Executes during object creation, after setting all properties.
function txtVTCFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtVTCFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSDMFolder_Callback(hObject, eventdata, handles)
% hObject    handle to txtSDMFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSDMFolder as text
%        str2double(get(hObject,'String')) returns contents of txtSDMFolder as a double


% --- Executes during object creation, after setting all properties.
function txtSDMFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSDMFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtOutputFolder_Callback(hObject, eventdata, handles)
% hObject    handle to txtOutputFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtOutputFolder as text
%        str2double(get(hObject,'String')) returns contents of txtOutputFolder as a double


% --- Executes during object creation, after setting all properties.
function txtOutputFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtOutputFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtNumChars_Callback(hObject, eventdata, handles)
% hObject    handle to txtNumChars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNumChars as text
%        str2double(get(hObject,'String')) returns contents of txtNumChars as a double


% --- Executes during object creation, after setting all properties.
function txtNumChars_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNumChars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtVOIFile_Callback(hObject, eventdata, handles)
% hObject    handle to txtVOIFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtVOIFile as text
%        str2double(get(hObject,'String')) returns contents of txtVOIFile as a double


% --- Executes during object creation, after setting all properties.
function txtVOIFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtVOIFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnChooseVTCFolder.
function btnChooseVTCFolder_Callback(hObject, eventdata, handles)
% hObject    handle to btnChooseVTCFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir(cd, 'Select VTC Folder');
if path ~=0
    set(handles.txtVTCFolder, 'String', path);
end

% --- Executes on button press in btnChooseSDMFolder.
function btnChooseSDMFolder_Callback(hObject, eventdata, handles)
% hObject    handle to btnChooseSDMFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir(cd, 'Select SDM Folder');
if path ~=0
    set(handles.txtSDMFolder, 'String', path);
end

% --- Executes on button press in btnChooseVOIFile.
function btnChooseVOIFile_Callback(hObject, eventdata, handles)
% hObject    handle to btnChooseVOIFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[voiFileName,voiPath] = uigetfile('*.voi', 'Select VOI File');
if voiFileName~=0
    set(handles.txtVOIFile, 'String', fullfile(voiPath,voiFileName));
end