% Add required library path.
addpath('./UserInterface');
addpath('./CameraControl');
addpath('./Analysis');

% Initiate the program.
cameraHandle = SelectDevice();
disp(num2str(cameraHandle));
LiveViewer(cameraHandle);