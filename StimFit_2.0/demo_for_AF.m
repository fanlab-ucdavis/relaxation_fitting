%%   Load MRI data and predefined options structure
% Marc Lebel (GE Healthcare): I loaded the 8 echo times into a ...
% matrix of size 256(xres) x 256(yres) x 30(slices) x 16(echo times)

close all; clear all;

wDir = sprintf('%s',pwd);
load([wDir '/SampleData/Audreys_data/' 'R2_sample_data.mat']);
p = genpath(wDir); addpath(p);
%addpath([wDir '/Engine/']);

%%   Configure specific options

optR2.mode = 's';   % Model selective RF. To use this mode properly, we need the waveforms, durations, gradient amps, prescribed angles.
% optR2.mode = 'n';   % Assumes perfect rectangular waveform shape. Good for 3D or if we really don't know RF waveforms/timings.

optR2.esp = 0.0086; % Echo spacing, from dicom header (0043,10BA) / 1000 

optR2.RFr.angle = [158.18 130.68 125*ones(1,14)]; % I'm making assumptions about the refocusing scheme here. Header says 125 deg. If tailored RF this should be correct.
optR2.RFr.weight = [0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0]; %   I've added this weighting term to the fit to indicate where you do/don't have data
optR2.RFr.tau = 2.752e-3; % s
optR2.RFr.G = 0.599565; % Gauss/cm

optR2.RFe.tau = 3.2e-3; % s
optR2.RFe.G = 0.871192; % Gauss/cm

optR2.lsq.Icomp.X0 = [0.06, 0.1, 0.9995];  %   Set the fit boundaries. Without the first two echoes we cannot fit relative B1+. Assume perfect (=1.0).
optR2.lsq.Icomp.XU = [3, 1e6, 1];
optR2.lsq.Icomp.XL = [0.015, 0, 0.999];


%% Fit single voxel

optR2.debug = 1;
S = squeeze(img(107, 158, 15, :));
[T2, B1, amp] = StimFit(S, optR2);


%% Fit entire image

optR2.debug = 0;
optR2.th_te = 3; %  Use third echo for image threshold
gcp;

for slice = 1:16,
    disp(sprintf('Currently on slice: %d', slice));
    [T2, R2, B1, amp] = StimFitImg(img(:, :, slice, :), optR2); % One slice
end
%[T2, R2, B1, amp] = StimFitImg(img, optR2); % Option to do all slices

figure(2);
imagesc(T2, [0 0.15]);colorbar; colormap gray; axis image;