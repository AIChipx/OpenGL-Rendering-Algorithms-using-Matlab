function [ y ] = rescale_it( x )

% piecewise linear stretching function
% this function will do the mapping as following
% this function is created to deal with normal map
% 0 maps to >>> -1
% 255 maps to >>> +1

x0 = 0;
x1 = 255;
y0 = -1;
y1 = 1;

% slope
m = (y1 - y0)/(x1 - x0);

y = m*(x - x0) + y0;
end

