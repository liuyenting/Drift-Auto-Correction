function [totalCameras, list] = GetAvailableDevices()
%GETAVAILABLEDEVICES Get available cameras that are connected to this
%computer. 
%   Detailed explanation goes here

[~, totalCameras] = GetAvailableCameras();
if totalCameras == 0
    list = 'No available camera';
else
    list = cell(totalCameras, 1);
    % Initialize all the cameras.
    for index = 1:totalCameras
        [~, handle] = GetCameraHandle(index);
        SetCurrentCamera(handle);
        [~, serial] = GetCameraSerialNumber();
        list{index} = num2str(serial);
    end
end

end

