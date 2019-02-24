function [ color ] = GL_NEAREST ( u, v, texture_image )
% Performing nearest neighbour texture filtering

% reading size of texture image
s = size(texture_image);
width = s(2);        % texture width in (x or u) - direction
height = s(1);        % texture height in (y or v) - direction

% MATLAB can't read image at (0, 0) or (0 with any combination)
% so we will use this simple mapping (trick ;)
% ////////////////////////////////////////////////////////////////////////
% transform (u, v) to texture image space
w = width;
h = height;

pu = (u*w);
pv = (v*h);

t1 = fix(pu) + 1;
t2 = fix(pv) + 1;
% ////////////////////////////////////////////////////////////////////////
if(t1>w)
    t1 = w;
end
if(t2>h)
    t2=h;
end
% access texture image and get texel color values
color = texture_image(t2, t1);

end

