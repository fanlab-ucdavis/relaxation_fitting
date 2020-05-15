function [rms, vox] = r2_rmse(T2, TE, magTE0, map)

% 9:18pm May, 14 2020 

% produce a 4D prediction using magTE0 and map produced by the ...
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
