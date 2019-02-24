% affine texture mapping
% Modelview and projection matrix is taken from openGL directly 
% dir > "D:\Foundations of Computer Graphics\Projects\Master transforms\prospective proj\prospective_proj"
% we implement viewport mapping manually

clear; clc;
% screen dimentions (x and y) used  
x_screen = 500;
y_screen = 500;
% Frame buffer
frame_buffer = zeros(x_screen,y_screen,3);
% Z-buffer
z_buffer = 255*ones(x_screen, y_screen);


% color values for the two triangles
% triangle one
cx = [1 0 0];
cy = [0 1 0];
cz = [0 0 1];
% triangle two
cw = [1 1 0];

% polygon vertices
a0 = [-3, -1, 0.5];
b0 = [3, -1, 0.5];
c0 = [-3, -1, -5];
d0 = [3, -1, -5];

% Loading Modelview Matrix
M1 = zeros(4,4);
m_tmp = load('modelview_matrix.txt');
i = 1;
for j=1:4
    for k=1:4
        M1(k, j) = m_tmp(i);
        i = i + 1;
    end;
end;

% applying modelview transform
a1m = M1 * [a0, 1]';
b1m = M1 * [b0, 1]';
c1m = M1 * [c0, 1]';
d1m = M1 * [d0, 1]';
 
% Loading Projection Matrix
M2 = zeros(4,4);
m_tmp = load('projection_matrix.txt');
i = 1;
for j=1:4
    for k=1:4
        M2(k, j) = m_tmp(i);
        i = i + 1;
    end;
end;

% applying projction transform
a1p = M2 * a1m;
b1p = M2 * b1m;
c1p = M2 * c1m;
d1p = M2 * d1m;

% applying prospective division
a1 = a1p/a1p(4);
b1 = b1p/b1p(4);
c1 = c1p/c1p(4);
d1 = d1p/d1p(4);

% Loading all vertices into one column vector
vertex_list = [a1'; b1'; c1'; d1'];

% applying viewport mapping transformation
[vertex_list] = viewport_map(vertex_list, x_screen, y_screen);

% transformed vertices
a = vertex_list(1, :);
b = vertex_list(2, :);
c = vertex_list(3, :);
d = vertex_list(4, :);

% Drawing with normal texture mapping
% first triangle (right) 
[frame_buffer,z_buffer] = tri_scan_conv_Z( c(1:3)', a(1:3)', b(1:3)', frame_buffer, z_buffer ,cz,cx,cy);
% second triangle (left)
[frame_buffer,z_buffer] = tri_scan_conv_Z( c(1:3)', d(1:3)', b(1:3)', frame_buffer, z_buffer ,cz,cw,cy);


% viewing results
figure(9779)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);

imshow(frame_buffer)
