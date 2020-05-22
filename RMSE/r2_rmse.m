function [rms, vox] = r2_rmse(T2, TE, magTE0, map)

% 5:45pm May, 21 2020 

% T2 is the original image as a 4D voxel
% TE is the echo times for T2
% magTE0 are the estimated starting values for the mono-exponential curve
% map is the R2 values taken from the nonlin_fit.m

% rms is the root mean square difference for T2 and vox
% vox is nonlin_fitted image

% produces a 4D prediction using magTE0 and map produced by the ...
% r2_nonlin_fit.m function
    [x, y] = size(TE);
    dim = size(magTE0);
    vox = zeros(dim(1),dim(2),dim(3),y);
    for z = 1:y
        ypred = magTE0.*exp(-map.*TE(z));
        vox(:,:,:,z) = ypred;
    end

% uses original T2 image to compare against predicted 'ypred' to find rms
	rms = sqrt(mean((T2-vox).^2./vox.^2,4));
    rms(isnan(rms)) = 0;    % troubleshoots isnan values and sets them to 0
    
end
