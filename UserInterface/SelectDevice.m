function varargout = SelectDevice(varargin)
% SELECTDEVICE MATLAB code for SelectDevice.fig
%      SELECTDEVICE, by itself, creates a new SELECTDEVICE or raises the existing
%      singleton*.
%
%      H = SELECTDEVICE returns the handle to a new SELECTDEVICE or the handle to
%      the existing singleton*.
%
%      SELECTDEVICE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTDEVICE.M with the given input arguments.
%
%      SELECTDEVICE('Property','Value',...) creates a new SELECTDEVICE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SelectDevice_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SelectDevice_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SelectDevice

% Last Modified by GUIDE v2.5 18-Dec-2015 15:34:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SelectDevice_OpeningFcn, ...
                   'gui_OutputFcn',  @SelectDevice_OutputFcn, ...
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

end

% --- Executes just before SelectDevice is made visible.
function SelectDevice_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SelectDevice (see VARARGIN)

refreshDeviceList(handles);

% Choose default command line output for SelectDevice
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SelectDevice wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = SelectDevice_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end

% --- Executes on selection change in deviceList.
function deviceList_Callback(hObject, eventdata, handles)
% hObject    handle to deviceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns deviceList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from deviceList

end

% --- Executes during object creation, after setting all properties.
function deviceList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in selectDevice_refresh.
function selectDevice_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to selectDevice_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

refreshDeviceList(handles);

end

function refreshDeviceList(handles)

% Retrieve all the devices.
[cameraCounts, cameraSerials] = GetAvailableDevices();
% ...populate them into the device list.
set(handles.deviceList, 'String', cameraSerials);
if cameraCounts == 0
    set(handles.deviceList, 'enable', 'off');
else
    set(handles.deviceList, 'enable', 'on');
end

end

% --- Executes on button press in selectDevice_continue.
function selectDevice_continue_Callback(hObject, eventdata, handles)
% hObject    handle to selectDevice_continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
