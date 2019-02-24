function [ out_raster ] = Bresenham_line( start_point,end_point, color, raster )
% This function can draw Bresenham line on a RGB colored buffer
% you can control color value by changing "color" 
% input vertices must be in row vector format
% only x,y values of input vertices are used 
% line color can be customized

% Extracting (x, y) coordinates
x0 = round(start_point(1));
y0 = round(start_point(2));

x1 = round(end_point(1));
y1 = round(end_point(2));

% The algorithm
% boolean
steep = abs(y1-y0) > abs(x1-x0);
if(steep)
    [x0, y0] = swap(x0, y0);
    [x1, y1] = swap(x1, y1);
end
if(x0 > x1) 
    [x0, x1] = swap(x0, x1);
    [y0, y1] = swap(y0, y1);
end

deltax = x1 - x0;
deltay = abs(y1 - y0);
error = deltax / 2;
y = y0;

if(y0<y1)
    ystep = 1;
else
    ystep = -1;
end

for x=x0:x1
    if(steep)
        raster(x, y, 1) = color(1);
        raster(x, y, 2) = color(2);
        raster(x, y, 3) = color(3);
    else
        raster(y, x, 1) = color(1);
        raster(y, x, 2) = color(2);
        raster(y, x, 3) = color(3);
    end
    
    error = error - deltay;
    if(error < 0)
        y = y + ystep;
        error = error + deltax;
    end
end

out_raster = raster;
end

