% prospective texture mapping
% Modelview and projection matrix is taken from openGL directly 
% dir > "D:\Foundations of Computer Graphics\Projects\Master transforms\prospective proj\prospective_proj"
% we implement viewport mapping manually

clear; clc;
% screen dimentions (x and y) used  
x_screen = 400;
y_screen = 400;
% Frame buffer
frame_buffer = zeros(y_screen,x_screen,3);
% >> GL_LUMINANCE texture
% [image_1, map, alpha] = imread('star2_128.png');

% >> GL_LUMINANCE_ALPHA
% [image_1, map, alpha] = imread('star_128_alpha.png');

% >> GL_RGB texture
[image_1, map, alpha] = imread('flower2_128.png');

% >> GL_RGBA texture
% [image_1, map, alpha] = imread('moss_128.png');

image_1 = double(image_1)/255;
alpha = double(alpha)/255;

% Z-buffer
z_buffer = 255*ones(y_screen, x_screen);
%alpha_ch = zeros(x_screen, y_screen);

disp(' Please enter base texture format');
disp(' 0 >> GL_Alpha')
disp(' 1 >> GL_LUMINANCE')
disp(' 2 >> GL_LUMINANCE_ALPHA')
disp(' 3 >> GL_RGB')
disp(' 4 >> GL_RGBA')
base_format = input(' >> Enter your selection: ');
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
disp(' Please enter texture function');
disp(' 0 >> GL_REPLACE')
disp(' 1 >> GL_MODULATE')
disp(' 2 >> GL_DECAL')
disp(' 3 >> GL_ADD')
text_function = input (' >> Enter your selection: ');

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


% texture coordinates
aa = [1 1];
bb = [127 1];
cc = [1 127];
dd = [127 127];

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

% applying projection transform
a1 = M2 * a1;
b1 = M2 * b1;
c1 = M2 * c1;
d1 = M2 * d1;

ah = a1(4);
bh = b1(4);
ch = c1(4);
dh = d1(4);

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

% Drawing with normal texture mapping
% first triangle (right) 
[frame_buffer,z_buffer] = tri_scan_conv_Z_col_text_pros(base_format, text_function, a(1:3)', c(1:3)',b(1:3)' ,ah, ch, bh, frame_buffer, z_buffer ,cx,cz,cy, cc,aa,dd,image_1, alpha);
% second triangle (left)
[frame_buffer,z_buffer] = tri_scan_conv_Z_col_text_pros(base_format, text_function, d(1:3)', c(1:3)',b(1:3)' ,dh, ch, bh,  frame_buffer, z_buffer ,cw,cz,cy, bb,aa,dd,image_1, alpha);


% viewing results
figure(979)
% vertical flip of framebuffer
% frame_buffer = flipdim(frame_buffer ,1);

frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)
