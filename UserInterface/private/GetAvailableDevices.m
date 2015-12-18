function [totalCameras, list] = GetAvailableDevices()
%GETAVAILABLEDEVICES Get available cameras that are connected to this
%computer. 
%   Detailed explanation goes here

cameraFilePath = fullfile(matlabroot,'toolbox','Andor','Camera Files','atmcd64d.dll');

[~, totalCameras] = GetAvailableCameras();
if totalCameras == 1
    % When totalCameras is 1, it actually means no device is connected.
    totalCameras = 0;
    list = 'No available camera';
else
    list = cell(totalCameras, 1);
    % Initialize all the cameras.
    for index = 1:totalCameras
        [~, handle] = GetCameraHandle(index);
        if handle == 0
            continue
        end
        SetCurrentCamera(handle);
        
        % Initialize the camera in order to get the serial number.
        ret = AndorInitialize('');
        CheckError(ret);
        
        [~, serial] = GetCameraSerialNumber();
        if serial ~= 0
            list{index} = num2str(serial);
        end
        
        AndorShutdown();
    end
end

if isempty(list)
    totalCameras = 0;
    list = 'No available camera';
end

end
