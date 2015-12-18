function [totalCameras, list] = GetAvailableDevices()
%GETAVAILABLEDEVICES Get available cameras that are connected to this
%computer. 
%   Detailed explanation goes here

cameraFilePath = fullfile(matlabroot,'toolbox','Andor','Camera Files','atmcd64d.dll');

[~, totalCameras] = GetAvailableCameras();
% When totalCameras is 1, it actually means no device is connected.
totalCameras = totalCameras-1;

if totalCameras <= 0
    list = 'No available camera';
else
    list = cell(totalCameras, 1);
    % Initialize all the cameras.
    for index = 1:totalCameras
        % Note: Andor camera index starts from 0 instead of 1.
        [~, handle] = GetCameraHandle(index-1);
        if handle == 0
            continue
        end
        SetCurrentCamera(handle);
        
        % Initialize the camera in order to get the serial number.
        ret = AndorInitialize(cameraFilePath);
        if ret ~= 20002
            continue
        end

        [~, serial] = GetCameraSerialNumber();
        if serial ~= 0
            list{index} = num2str(serial);
        end
        
        AndorShutDown();
    end
end

if isempty(list)
    totalCameras = 0;
    list = 'No available camera';
end

end
