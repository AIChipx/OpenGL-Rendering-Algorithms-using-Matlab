% testing transform engine
clear; clc; 

% All faces has the same texture (Wood) OK :)
%image = double(imread('128.png'))/255;
%image = double(imread('Text_img_128.bmp'))/255; 
%image_1 = double(imread('Text_img_16.bmp'))/255; 
image_1 = double(imread('koko.png'))/255;
% Mipmap generation
Mip_level_0 = image_1;
Mipmap_unit;
save MIPMAPS;

% screen dimentions 
scr = [500 500];

% Frame buffer
frame_buffer =zeros(scr(1),scr(2),3);

% Z-buffer
z_buffer = 255*ones(scr(1), scr(2));

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

% Cube vertices
s = 1.0;
a1 = s*[-1, -1, -1];
a2 = s*[1, -1, -1];
a3 = s*[-1, -1, 1];
a4 = s*[1, -1, 1];
a5 = s*[-1, 1, -1]; 
a6 = s*[1, 1, -1];
a7 = s*[-1, 1, 1];
a8 = s*[1, 1, 1];

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
a1 = M1 * [a1, 1]';
a2 = M1 * [a2, 1]';
a3 = M1 * [a3, 1]';
a4 = M1 * [a4, 1]';
a5 = M1 * [a5, 1]';
a6 = M1 * [a6, 1]';
a7 = M1 * [a7, 1]';
a8 = M1 * [a8, 1]';

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
a2 = M2 * a2;
a3 = M2 * a3;
a4 = M2 * a4;
a5 = M2 * a5;
a6 = M2 * a6;
a7 = M2 * a7;
a8 = M2 * a8;

ah1 = a1(4);
ah2 = a2(4);
ah3 = a3(4);
ah4 = a4(4);
ah5 = a5(4);
ah6 = a6(4);
ah7 = a7(4);
ah8 = a8(4);

% applying prospective division
a1 = a1/a1(4);
a2 = a2/a2(4);
a3 = a3/a3(4);
a4 = a4/a4(4);
a5 = a5/a5(4);
a6 = a6/a6(4);
a7 = a7/a7(4);
a8 = a8/a8(4);

% Loading all vertices into one column vector
vertex_list = [a1'; a2'; a3'; a4'; a5'; a6'; a7'; a8'];

% applying viewport mapping transformation
[vertex_list] = viewport_map(vertex_list, scr(1), scr(2));

% transformed vertices
a1 = vertex_list(1, :);
a2 = vertex_list(2, :);
a3 = vertex_list(3, :);
a4 = vertex_list(4, :);
a5 = vertex_list(5, :);
a6 = vertex_list(6, :);
a7 = vertex_list(7, :);
a8 = vertex_list(8, :);

% first face 
[frame_buffer,z_buffer] = tri_scan_conv_Z_text_pros_LoD( a1(1:3)', a2(1:3)', a3(1:3)', ah1, ah2, ah3 , frame_buffer, z_buffer ,aa,bb,cc,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER);
[frame_buffer,z_buffer] = tri_scan_conv_Z_text_pros_LoD( a4(1:3)', a2(1:3)', a3(1:3)', ah4, ah2, ah3 , frame_buffer, z_buffer ,dd,bb,cc,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER);

% second face 
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a5(1:3)', a6(1:3)', a7(1:3)', ah5, ah6, ah7, frame_buffer, z_buffer,aa,bb,cc,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a8(1:3)', a6(1:3)', a7(1:3)', ah8, ah6, ah7, frame_buffer, z_buffer,dd,bb,cc,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );

% 3rd face
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a7(1:3)', a3(1:3)', a4(1:3)', ah7, ah3, ah4, frame_buffer, z_buffer,aa,cc,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a7(1:3)', a8(1:3)', a4(1:3)', ah7, ah8, ah4, frame_buffer, z_buffer,aa,bb,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );

% 4th face
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a5(1:3)', a1(1:3)', a2(1:3)', ah5, ah1, ah2, frame_buffer, z_buffer,aa,cc,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a5(1:3)', a6(1:3)', a2(1:3)', ah5, ah6, ah2, frame_buffer, z_buffer,aa,bb,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );
  
% 5th face
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a8(1:3)', a4(1:3)', a2(1:3)', ah8, ah4, ah2, frame_buffer, z_buffer,aa,cc,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a8(1:3)', a6(1:3)', a2(1:3)', ah8, ah6, ah2, frame_buffer, z_buffer,aa,bb,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );

% 6th face
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a7(1:3)', a5(1:3)', a1(1:3)', ah7, ah5, ah1, frame_buffer, z_buffer,aa,bb,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );
[frame_buffer, z_buffer] = tri_scan_conv_Z_text_pros_LoD( a7(1:3)', a3(1:3)', a1(1:3)', ah7, ah3, ah1, frame_buffer, z_buffer,aa,cc,dd,image_1, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER );


figure(188787)
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)

% Delete generated MIPMAPS
delete MIPMAPS.mat

%f = getframe(gcf);
%imwrite(f.cdata,'framebuff_x3.png');
