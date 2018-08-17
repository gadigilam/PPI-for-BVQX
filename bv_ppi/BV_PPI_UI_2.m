function varargout = BV_PPI_UI_2(varargin)
% BV_PPI_UI_2 MATLAB code for BV_PPI_UI_2.fig
%      BV_PPI_UI_2, by itself, creates a new BV_PPI_UI_2 or raises the existing
%      singleton*.
%
%      H = BV_PPI_UI_2 returns the handle to a new BV_PPI_UI_2 or the handle to
%      the existing singleton*.
%
%      BV_PPI_UI_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BV_PPI_UI_2.M with the given input arguments.
%
%      BV_PPI_UI_2('Property','Value',...) creates a new BV_PPI_UI_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BV_PPI_UI_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BV_PPI_UI_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BV_PPI_UI_2

% Last Modified by GUIDE v2.5 14-Jan-2014 10:16:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BV_PPI_UI_2_OpeningFcn, ...
                   'gui_OutputFcn',  @BV_PPI_UI_2_OutputFcn, ...
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


% --- Executes just before BV_PPI_UI_2 is made visible.
function BV_PPI_UI_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BV_PPI_UI_2 (see VARARGIN)

% Choose default command line output for BV_PPI_UI_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BV_PPI_UI_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.matches = varargin{1};
handles.VOIFile  = varargin{2};
guidata(hObject, handles);

pred = bv_ppi_get_predictors(handles.matches.sdmFiles{1});
set(handles.listPredictors, 'String', pred);
set(handles.listPredictors, 'Value', 1:length(pred));

vois = bv_ppi_get_vois(handles.VOIFile);
set(handles.listVOIs, 'String', vois);
set(handles.listVOIs, 'Value', 1:length(vois));

% --- Outputs from this function are returned to the command line.
function varargout = BV_PPI_UI_2_OutputFcn(hObject, eventdata, handles) 
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
out_folder =  get(handles.txtOutputFolder,'String');
if ~exist(out_folder, 'file')
    hMsg=errordlg('Output folder path does not exist');
    uiwait(hMsg);
    return;
end

selected_preds = get(handles.listPredictors,'Value');
if isempty(selected_preds)
    hMsg=errordlg('No predictors selected');
    uiwait(hMsg);
    return;
end


selected_vois = get(handles.listVOIs,'Value');
if isempty(selected_vois)
    hMsg=errordlg('No VOIs selected');
    uiwait(hMsg);
    return;
end

conf_zscore = get(handles.cbxConfsZscore,'Value');

try
    bv_ppi(handles.matches, handles.VOIFile, out_folder, selected_preds, selected_vois,conf_zscore);
catch exception
    hMsg=errordlg(exception.message);
    uiwait(hMsg);
    return;
end

close(handles.figure1);
hMsg=msgbox(sprintf('All .sdm files created.\nPress OK to view output folder.'));
uiwait(hMsg);
system(sprintf('%s %s' , 'explorer.exe ', out_folder));



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



% --- Executes on selection change in listPredictors.
function listPredictors_Callback(hObject, eventdata, handles)
% hObject    handle to listPredictors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listPredictors contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listPredictors


% --- Executes during object creation, after setting all properties.
function listPredictors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listPredictors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listVOIs.
function listVOIs_Callback(hObject, eventdata, handles)
% hObject    handle to listVOIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listVOIs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listVOIs


% --- Executes during object creation, after setting all properties.
function listVOIs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listVOIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnChooseOutFolder.
function btnChooseOutFolder_Callback(hObject, eventdata, handles)
% hObject    handle to btnChooseOutFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir(cd, 'Select Output Folder');
if path ~=0
    set(handles.txtOutputFolder, 'String', path);
end


% --- Executes on button press in cbxConfsZscore.
function cbxConfsZscore_Callback(hObject, eventdata, handles)
% hObject    handle to cbxConfsZscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbxConfsZscore
