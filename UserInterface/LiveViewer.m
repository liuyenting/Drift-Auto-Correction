function varargout = LiveViewer(varargin)
% LIVEVIEWER MATLAB code for LiveViewer.fig
%      LIVEVIEWER, by itself, creates a new LIVEVIEWER or raises the existing
%      singleton*.
%
%      H = LIVEVIEWER returns the handle to a new LIVEVIEWER or the handle to
%      the existing singleton*.
%
%      LIVEVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIVEVIEWER.M with the given input arguments.
%
%      LIVEVIEWER('Property','Value',...) creates a new LIVEVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LiveViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LiveViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LiveViewer

% Last Modified by GUIDE v2.5 18-Dec-2015 20:39:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LiveViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @LiveViewer_OutputFcn, ...
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

% --- Executes just before LiveViewer is made visible.
function LiveViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LiveViewer (see VARARGIN)

handles.cameraHandle = int32(varargin{1});
[handles.xPixels, handles.yPixels, handles.useSoftwareTrigger] = CameraDefaultInit();

% Set state variables.
handles.isStreaming = true;
handles.isCompensating = false;

% Choose default command line output for LiveViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Move the window to the center of the screen.
movegui(hObject, 'center');

% UIWAIT makes LiveViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Set the default image.
axis(handles.frameView, 'image');
defaultImage = imread('private/default_image.tiff');
imshow(defaultImage);

end

% --- Outputs from this function are returned to the command line.
function varargout = LiveViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end

% --- Executes on button press in selectTargets.
function selectTargets_Callback(hObject, eventdata, handles)
% hObject    handle to selectTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end

% --- Executes on button press in exitProgram.
function exitProgram_Callback(hObject, eventdata, handles)
% hObject    handle to exitProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end

% --- Executes on button press in toggleCompensation.
function toggleCompensation_Callback(hObject, eventdata, handles)
% hObject    handle to toggleCompensation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleCompensation

if handles.isCompensating
    handles.isCompensating = false;
    StopCamera();
else
    handles.isCompensating = true;
    % TODO: Start the camera.
end

end

function StartCamera(handles)

cameraFilePath = fullfile(matlabroot, 'toolbox', 'Andor', 'Camera Files');
SetCurrentCamera(handles.cameraHandle);
ret = AndorInitialize(cameraFilePath);
CheckError(ret);

end

function StopCamera()

ret = AbortAcquisition();
CheckWarning(ret);

% Close the shutter.
ret = SetShutter(1, 2, 1, 1);
CheckWarning(ret);

ret = AndorShutDown();
CheckWarning(ret);

end


% --- Executes on button press in toggleStream.
function toggleStream_Callback(hObject, eventdata, handles)
% hObject    handle to toggleStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleStream

[ret] = StartAcquisition();                   
CheckWarning(ret);

axesInfo = get(handles.frameView, 'Position');
width = axesInfo(3);
height = axesInfo(4);

while get(hObject, 'Value')
    if handles.useSoftwareTrigger == true
        ret = SendSoftwareTrigger();
        CheckWarning(ret);
        
        ret = WaitForAcquisition();
        CheckWarning(ret);
    end
    
    [ret, imageData] = GetMostRecentImage(handles.xPixels * handles.yPixels);
    CheckWarning(ret);
    
    if ret == atmcd.DRV_SUCCESS
        %display the acquired image
        newImage = flip(transpose(reshape(imageData, handles.xPixels, handles.yPixels)), 1);
        %newImage = imresize(newImage, [width, height]);
        imagesc(newImage);
        drawnow;
    end
end

end
