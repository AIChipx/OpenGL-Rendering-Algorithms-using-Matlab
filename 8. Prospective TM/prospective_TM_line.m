% prospective texture mapping
% Modelview and projection matrix is taken from openGL directly 
% dir > "D:\Foundations of Computer Graphics\Projects\Master transforms\prospective proj\prospective_proj"
% we implement viewport mapping manually

clear; clc;
% screen dimentions (x and y) used  
x_screen = 300;
y_screen = 300;
% Frame buffer
frame_buffer = zeros(x_screen,y_screen,3);

% polygon vertices
a0 = [-3, -1, 0.5];
b0 = [3, -1, 0.5];
c0 = [-3, -1, -5];
d0 = [3, -1, -5];

% Bresenham's line color
white = [1 1 1];
red = [1 0 0];
blue = [0 0 1];
green = [0 1 0];

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
a1 = M1 * [a0, 1]';
b1 = M1 * [b0, 1]';
c1 = M1 * [c0, 1]';
d1 = M1 * [d0, 1]';
 
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
a1 = M2 * a1;
b1 = M2 * b1;
c1 = M2 * c1;
d1 = M2 * d1;

% applying prospective division
a1 = a1/a1(4);
b1 = b1/b1(4);
c1 = c1/c1(4);
d1 = d1/d1(4);

% Loading all vertices into one column vector
vertex_list = [a1'; b1'; c1'; d1'];

% applying viewport mapping transformation
[vertex_list] = viewport_map(vertex_list, x_screen, y_screen);

% transformed vertices
a = vertex_list(1, :);
b = vertex_list(2, :);
c = vertex_list(3, :);
d = vertex_list(4, :);

% Drawing using Bresenham Algorithm
% near edge
frame_buffer = Bresenham_line(a(1:2)', b(1:2)', red,frame_buffer);
% far edge
frame_buffer = Bresenham_line(c(1:2), d(1:2), blue,frame_buffer);
% right edge
frame_buffer = Bresenham_line(d(1:2), b(1:2), green,frame_buffer);
% left edge
frame_buffer = Bresenham_line(c(1:2), a(1:2), green,frame_buffer);

% viewing results
figure(979)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);

imshow(frame_buffer)
