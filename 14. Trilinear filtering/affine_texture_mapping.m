% prospective texture mapping
% Modelview and projection matrix is taken from openGL directly 
% dir > "D:\Foundations of Computer Graphics\Projects\Master transforms\prospective proj\prospective_proj"
% we implement viewport mapping manually

clear; clc;
% screen dimentions (x and y) used  
x_screen = 500;
y_screen = 500;
% Frame buffer
frame_buffer = ones(x_screen,y_screen,3);
% Z-buffer
z_buffer = 255*ones(x_screen, y_screen);
% decision bufffer
decision = zeros(x_screen, y_screen);

% reading texture image
disp('.........');
disp(' Generating texture image');
ss1 = input('Texture width= ');
ss2 = input('Texture height= ');
option = input('Texture option= ');
image_1 = Texture_gen([ss2, ss1], option);

% wrapping modes
disp('.........');
disp(' Wrapping modes');
disp(' "0" >> CLAMP_TO_EDGE');
disp(' "1" >> REPEAT');
GL_TEXTURE_WRAP_S = input('GL_TEXTURE_WRAP_S= ');
GL_TEXTURE_WRAP_T = input('GL_TEXTURE_WRAP_T= ');

% texture coordinates
disp('.........');
k = input(' Texture coordinates range [0 to k], k= ');
aa = [0,0];
bb = [k,0];
cc = [0,k];
dd = [k,k];

% filtering mode
disp('.........');
disp(' Magnification and minification filtering modes');
disp(' "0" >> GL_NEAREST');
disp(' "1" >> GL_LINEAR');
GL_TEXTURE_MAG_FILTER = input(' GL_TEXTURE_MAG_FILTER= ');
GL_TEXTURE_MIN_FILTER = input(' GL_TEXTURE_MIN_FILTER= ');

% polygon vertices
a = [100, 100, 3];
b = [400, 100, 3];
c = [100, 400, 3];
d = [400, 400, 3];

ah = 1;
bh = 1;
ch = 1;
dh = 1;


% Drawing with normal texture mapping
% first triangle (right) 
[frame_buffer,z_buffer, decision] = tri_scan_conv_Z_text_pros_LoD( a(1:3)', c(1:3)',b(1:3)' ,ah, ch, bh, frame_buffer, z_buffer ,cc,aa,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER, decision);
% second triangle (left)
[frame_buffer,z_buffer, decision] = tri_scan_conv_Z_text_pros_LoD( d(1:3)', c(1:3)',b(1:3)' ,dh, ch, bh,  frame_buffer, z_buffer ,bb,aa,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER, decision);


% viewing results
figure(979)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)
figure(545)
decision = flipdim(decision ,1);
imshow(decision)
