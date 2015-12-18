function [totalCameras, list] = GetAvailableDevices()
%GETAVAILABLEDEVICES Get available cameras that are connected to this
%computer. 
%   Detailed explanation goes here

cameraFilePath = fullfile(matlabroot,'toolbox','Andor','Camera Files','atmcd64d.dll');

[~, totalCameras] = GetAvailableCameras();
if totalCameras == 0
    list = 'No available camera';
else
    list = cell(totalCameras, 1);
    % Initialize all the cameras.
    for index = 1:totalCameras
        [~, handle] = GetCameraHandle(index);
        SetCurrentCamera(handle);
        
        % Initialize the camera in order to get the serial number.
        ret = AndorInitialize('');
        CheckError(ret);
        
        [ret, serial] = GetCameraSerialNumber();
        CheckError(ret);
        
        list{index} = num2str(serial);
    end
end

end

