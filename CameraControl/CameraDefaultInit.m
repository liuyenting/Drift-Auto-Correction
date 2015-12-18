function [xPixels, yPixels, useSoftwareTrigger] = CameraDefaultInit()

ret = CoolerON();
CheckWarning(ret);

ret = SetAcquisitionMode(5);
CheckWarning(ret);

ret = SetExposureTime(0.1);
CheckWarning(ret);

ret = SetReadMode(4);
CheckWarning(ret);

ret = SetTrigerMode(10);
CheckWarning(ret);
useSoftwareTrigger = true;

% Check whether software trigger is applicable.
if ret == atmcd.DRV_INVALID_TRIGGER_MODE
       disp('Software trigger not availabe, using internal trigger.');
       SetTriggerMode(0);
       useSoftwareTrigger = false;
end
CheckWarning(ret);

ret = SetShutter(1, 1, 0, 0);
CheckWarning(ret);

[ret, xPixels, yPixels] = GetDetector();
CheckWarning(ret);

% Set the image size, without any binning.
ret = SetImage(1, 1, 1, xPixels, 1, yPixels);
CheckWarning(ret);

end