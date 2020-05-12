function [map, magTE0] = r2star_nonlin_fit(V, x0, TE, mask)
% 
% Calculate R2star maps from multi-echo GRE data
% with non-linear fitting routine
% 
% Input: V is a 4D Magnitude (or Complex) data [Y X Z echoes] and
% TE is a 1D vector listing the Echo Times
% x0 is an initial guess from linear fitting
% Mask is an optional matrix with the size [Y X Z]
%
% Output: R2star map and
% the estimated initial signal intensity of the curve (magTE0)
%

[nrow, ncol, nSlice, ~] = size(V);
map = zeros(nrow, ncol, nSlice);
magTE0 = zeros(nrow, ncol, nSlice);

% Choose Levenburg-marquardt algorithm
options = optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt', 'display', 'off');

% Fitting voxel by voxel
for slice = 1:nSlice
    display(['Nonlinear fitting for image slice ' num2str(slice)]);
    for row = 1:nrow
        for col = 1:ncol
            if ~mask(row,col,slice)
                continue
            else
                y = squeeze(V(row,col,slice,:));
                y = y';
                % the function to fit
                fun = @(x)x(1)*exp(-TE*x(2))-y;
                
                % initial values from linear fitting
                x1_0 = x0(row,col,slice,1);
                x2_0 = x0(row,col,slice,2);
                X0 = [x1_0, x2_0];
                x = lsqnonlin(fun,X0,[],[],options);
                
                % magnitude image at TE=0
                magTE0(row,col,slice) = x(1);
                
                % R2* map
                map(row,col,slice) = x(2);
                map(map<0) = 0;
                
            end
        end
    end
end
