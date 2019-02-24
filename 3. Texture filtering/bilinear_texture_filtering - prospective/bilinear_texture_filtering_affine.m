% testing transform engine
clear 
% screen dimentions 
scr = [500 500];

% All faces has the same texture (Wood) OK :)
%image = double(imread('128.png'))/255;
image = double(imread('Text_img_128.bmp'))/255; 

% Frame buffer
frame_buffer =zeros(scr(1),scr(2),3);

% Z-buffer
z_buffer = 255*ones(scr(1), scr(2));

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

% texture coordinates (used only with Option 2 & 3)
aa = [1 1];
bb = [127 1];
cc = [1 127];
dd = [127 127];


% transformed vertices 
a1 = Transform_engine(a1, scr);
a2 = Transform_engine(a2, scr);
a3 = Transform_engine(a3, scr);
a4 = Transform_engine(a4, scr);
a5 = Transform_engine(a5, scr);
a6 = Transform_engine(a6, scr);
a7 = Transform_engine(a7, scr);
a8 = Transform_engine(a8, scr);


% first face 
[frame_buffer,z_buffer] = tri_scan_conv_Z_text( a1(1:3)', a2(1:3)', a3(1:3)', frame_buffer, z_buffer ,aa,bb,cc,image);
[frame_buffer,z_buffer] = tri_scan_conv_Z_text( a4(1:3)', a2(1:3)', a3(1:3)', frame_buffer, z_buffer ,dd,bb,cc,image);

% second face 
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a5(1:3)', a6(1:3)', a7(1:3)', frame_buffer, z_buffer,aa,bb,cc,image);
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a8(1:3)', a6(1:3)', a7(1:3)', frame_buffer, z_buffer,dd,bb,cc,image);

% 3rd face
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a7(1:3)', a3(1:3)', a4(1:3)', frame_buffer, z_buffer,aa,cc,dd,image);
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a7(1:3)', a8(1:3)', a4(1:3)', frame_buffer, z_buffer,aa,bb,dd,image);

% 4th face
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a5(1:3)', a1(1:3)', a2(1:3)', frame_buffer, z_buffer,aa,cc,dd,image);
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a5(1:3)', a6(1:3)', a2(1:3)', frame_buffer, z_buffer,aa,bb,dd,image);
  
% 5th face
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a8(1:3)', a4(1:3)', a2(1:3)', frame_buffer, z_buffer,aa,cc,dd,image);
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a8(1:3)', a6(1:3)', a2(1:3)', frame_buffer, z_buffer,aa,bb,dd,image);

% 6th face
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a7(1:3)', a5(1:3)', a1(1:3)', frame_buffer, z_buffer,aa,bb,dd,image);
[frame_buffer, z_buffer] = tri_scan_conv_Z_text( a7(1:3)', a3(1:3)', a1(1:3)', frame_buffer, z_buffer,aa,cc,dd,image);


% figure(188787)
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)

%f = getframe(gcf);
%imwrite(f.cdata,'framebuff_x3.png');
