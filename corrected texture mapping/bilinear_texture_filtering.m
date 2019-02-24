% Z-buffer is disabled

clear; clc
% screen dimentions 
scr = [400 400];

% Frame buffer
frame_buffer =zeros(scr(1),scr(2),3);

% reading texture image
texture_image = imread('t4.bmp');

disp(' Wrapping modes');
disp(' "0" >> CLAMP_TO_EDGE');
disp(' "1" >> REPEAT');
GL_TEXTURE_WRAP_S = input('GL_TEXTURE_WRAP_S= ');
GL_TEXTURE_WRAP_T = input('GL_TEXTURE_WRAP_T= ');

% texture coordinates
k = input(' Texture coordinates range [0 to k], k= ');
tx1 = [0,0];
tx2 = [k,0];
tx3 = [0,k];
tx4 = [k,k];

% vertices coordinates 
v1 = [50,50,50];
v2 = [350,50,50];
v3 = [50,350,50];
v4 = [350,350,50];

% Rasterization & scan conversion 
[frame_buffer] = tri_scan_conv_text( v1(1:3)', v2(1:3)', v4(1:3)', frame_buffer ,tx1,tx2,tx4,texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
[frame_buffer] = tri_scan_conv_text( v1(1:3)', v3(1:3)', v4(1:3)', frame_buffer ,tx1,tx3,tx4,texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);

figure(188787)
imshow(uint8(frame_buffer))
% imwrite(uint8(frame_buffer), 'shot5.bmp');