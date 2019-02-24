clear; clc;
[x,y,z] = sphere(6);
x1 = x(:);
y1 = y(:);
z1 = z(:);

% [x,y,z] = sphere;
surf(x,y,z)  % sphere centered at origin

% no = 10;
% A = sphere(10);
% % figure(12)
% % scatter3(A(:,), y1, z1)
A = [x1 y1 z1]
size(A)