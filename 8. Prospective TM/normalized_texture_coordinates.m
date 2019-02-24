% normalized texture coordinates
% in this code all functions has been modified to deal with texture
% coordinates in the range [0, 1]

clc; clear;
% screen dimentions (x and y) used  
x_screen = 400;
y_screen = 400;
% Frame buffer
frame_buffer = zeros(x_screen,y_screen,3);
% Z-buffer
z_buffer = 255*ones(x_screen, y_screen);

% reading texture image
% image_1 = double(imread('road_text.png'))/255;
image_1 = double(imread('chess.png'))/255;

% polygon vertices
a = [1, 1, 3];
b = [1, 200, 3];
c = [200, 1, 3];
d = [200, 200, 3];

% texture coordinates (used only with Option 2 & 3)
aa = [0 0];
bb = [0 1];
cc = [1 0];
dd = [1 1];

% Drawing with normal texture mapping
% first triangle (right) 
[frame_buffer,z_buffer] = tri_scan_conv_Z_text_n( c(1:3)', a(1:3)', b(1:3)', frame_buffer, z_buffer ,aa,cc,dd,image_1);
% second triangle (left)
[frame_buffer,z_buffer] = tri_scan_conv_Z_text_n( c(1:3)', d(1:3)', b(1:3)', frame_buffer, z_buffer ,aa,bb,dd,image_1);

% viewing results
figure(979)
% vertical flip of framebuffer
% frame_buffer = flipdim(frame_buffer ,1);

imshow(frame_buffer)

