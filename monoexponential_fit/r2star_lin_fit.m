function [map, magTE0] = r2star_lin_fit(V, TE)
% 
% Calculate R2star maps from multi-echo GRE data
%
% S.J. Holdsworth
% 
% Input: V is a 4D Magnitude (or Complex) data [Y X Z echoes] and
% TE is a 1D vector listing the Echo Times
% Uses Least-Squares minimization of entire 3D volume at once
% 
% Output: R2star map and
% the estimated initial signal intensity of the curve (magTE0)
%
% Modified by Wei Bian 12-15-2016

dim = size(V);
A = [ones(numel(TE),1),TE'];
Y = reshape(permute(-log(V),[4 1 2 3]),[dim(4), dim(1)*dim(2)*dim(3)]);

coef = A\squeeze(Y);
map = reshape(coef(2,:),dim(1:3));
magTE0 = reshape(exp(abs(coef(1,:))),dim(1:3));
map(map < 0) = 0;





