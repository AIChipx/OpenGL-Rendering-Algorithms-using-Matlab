% calculations are done on gray scale images
% prospective texture mapping
% Modelview and projection matrix is taken from openGL directly 
% dir > "D:\Foundations of Computer Graphics\Projects\Master transforms\prospective proj\prospective_proj"
% we implement viewport mapping manually
% Z-buffer is disabled

clear; clc;

% reading texture image
disp('.........');
disp(' Generating texture image');
ss1 = input('Texture width= ');
ss2 = input('Texture height= ');
option = input('Texture option= ');
image_1 = Texture_gen_gray([ss2, ss1], option);


% Mipmap generation
Mip_level_0 = image_1;
Mipmap_unit;
save MIPMAPS;
% save current texture to image file 
% ttte = size(image_1);
% Text_img = zeros(ttte(2), ttte(1), 3);
% Text_img(:,:,1) = image_1;
% Text_img(:,:,2) = image_1;
% Text_img(:,:,3) = image_1;
% imwrite(Text_img, 'Text_img.bmp', 'bmp');

% screen dimentions (x and y) used  
x_screen = 500;
y_screen = 500;
% Frame buffer
frame_buffer = zeros(x_screen,y_screen);
% Z-buffer
% z_buffer = 255*ones(x_screen, y_screen);
% decision bufffer
decision = zeros(x_screen, y_screen);

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
disp(' Select Magnification filtering mode');
disp(' "0" >> GL_NEAREST');
disp(' "1" >> GL_LINEAR');
GL_TEXTURE_MAG_FILTER = input(' GL_TEXTURE_MAG_FILTER= ');
disp('.........');
disp(' Select Minification filtering mode');
disp(' "0" >> GL_NEAREST');
disp(' "1" >> GL_LINEAR');
disp(' "2" >> GL_NEAREST_MIPMAP_NEAREST');
disp(' "3" >> GL_LINEAR_MIPMAP_NEAREST');
disp(' "4" >> GL_NEAREST_MIPMAP_LINEAR');
disp(' "5" >> GL_LINEAR_MIPMAP_LINEAR');
GL_TEXTURE_MIN_FILTER = input(' GL_TEXTURE_MIN_FILTER= ');

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
% first triangle (left) 
[frame_buffer, decision] = tri_scan_conv_Z_text_pros_LoD( a(1:3)', c(1:3)',b(1:3)' ,ah, ch, bh, frame_buffer ,cc,aa,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER, decision,k);
% second triangle (right)
[frame_buffer, decision] = tri_scan_conv_Z_text_pros_LoD( d(1:3)', c(1:3)',b(1:3)' ,dh, ch, bh,  frame_buffer ,bb,aa,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER, decision, k);


% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
decision = flipdim(decision ,1);

% viewing results
figure(979)
imshow(frame_buffer)
figure(545)
imshow(decision)

delete MIPMAPS.mat

