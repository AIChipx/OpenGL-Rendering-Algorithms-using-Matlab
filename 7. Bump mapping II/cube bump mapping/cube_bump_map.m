% use scaling parameters of "2"
% Bump mapping Gamma
% this code will be the basis for Bump mapping
% here lighting calculations is performed per pixel (Phong shading)
% texture image is combined with lighting in the correct order
clear; clc;

% % screen dimentions (must be identical)
% disp('>> Range is from 100 to 500')
% dim = input(' Enter framebuffer dimentions= ');
dim=500;
x_screen = dim;
y_screen = dim;

% Frame buffer
Frame_buffer = zeros(x_screen,y_screen,3);

% Z-buffer
z_buffer = 255*ones(x_screen, y_screen);



% reading texture image
% four texture images are available you can choose between them
% text1.png, text2.png, text3.png, text4.png
% normal_map = double(imread('normal_map_1.png'))/255;
normal_map = rescale_it(double(imread('normal_map_3.png')));
% texture_image = double(imread('text2.png'))/255;

% polygon vertices computed from screen dimentions
% dim1 = round(x_screen/10);
% dim2 = round(y_screen - dim1);
% a1 = [dim1, dim2, 1];
% a2 = [dim2, dim2, 1];
% a3 = [dim1, dim1, 1];
% a4 = [dim2, dim1, 1];

% assigning texture coordinates
% texture coordinates are computed from screen dimentions
textcoord_a1 = [100, 100];
textcoord_a2 = [450, 100];
textcoord_a3 = [100, 450];
textcoord_a4 = [450, 450];


% projection planes
% left
l = -4;
% right
r = 4;
% bottom
b = -4;
% top
t = 4;
% near
n = 1; 
% far
f = 10; 

% Cube vertices
% scaled
s = 1;
a1 = s*[-1, -1, -1];
a2 = s*[1, -1, -1];
a3 = s*[-1, -1, 1];
a4 = s*[1, -1, 1];
a5 = s*[-1, 1, -1];
a6 = s*[1, 1, -1];
a7 = s*[-1, 1, 1];
a8 = s*[1, 1, 1];



% Loading all vertices into one column vector
vertex_list = [a1; a2; a3; a4; a5; a6; a7; a8];

disp('Enter Scaling parameters')
sx = input('sx= ');
sy = input('sy= ');
sz = input('sz= ');

disp('Enter rotation angles')
theta_x = input('theta_x= ');
theta_y = input('theta_y= ');
theta_z = input('theta_z= ');

% disp('Enter translation parameters')
% tx = input('tx= ');
% ty = input('ty= ');
% tz = input('tz= ');

%/////////////////////////////////////////////////////////////////////////
% applying transformations
% scaling trans
[vertex_list] = Scale_it(vertex_list, sx, sy, sz);

% rotation trans
[vertex_list] = rotate_Xaxis(vertex_list, theta_x);

[vertex_list ] = rotate_Yaxis(vertex_list, theta_y);

[vertex_list ] = rotate_Zaxis(vertex_list, theta_z);

% translation trans
% [vertex_list] = Translate_it(vertex_list, tx, ty, tz);

% applying projection 
% Orthographic proj
[vertex_list] = glOrtho(vertex_list, l, r, b, t, n, f);

% Viewport mapping transformation
[vertex_list] = viewport_map(vertex_list, x_screen, y_screen);
%/////////////////////////////////////////////////////////////////////////

% transformed vertices 
a1 = vertex_list(1, :);
a2 = vertex_list(2, :);
a3 = vertex_list(3, :);
a4 = vertex_list(4, :);
a5 = vertex_list(5, :);
a6 = vertex_list(6, :);
a7 = vertex_list(7, :);
a8 = vertex_list(8, :);





% Lighting calculations
% Material properties
    % material diffuse/ambient reflectance
    mat_amb_diff = [1 1 1];
    % material specular color
    mat_specular = [1 1 1];
    % shiness exponent
    p = 100;
    material_prop = [mat_amb_diff;mat_specular];
   
% Light source properties
% light source ambient color
    light_ambient = [0.0 0.0 0.0];
    %light source diffuse color
    light_diffuse = [1 1 1];
    % material specular color
    light_specular = [1 1 1];
    light_prop = [light_ambient;light_diffuse;light_specular]; 
    
% viewport direction (at local position) 
% normalization is not needed here, viewport unit vector will be 
% normalized in tri_scan_conv_Z_***
    viewport_pos = round([dim/2 dim/2 100]);

% light source direction (at infinity)
    disp('>> Input must be in this format [x y z]')
    lightsource_dir1 = input(' Enter light source direction vextor= ');
    L = normalize(lightsource_dir1);
    
% Drawing the polygon 
% this function works on normal map only
% [Frame_buffer] = tri_scan_conv_Z_lit_text( a3(1:3)', a1(1:3)', a2(1:3)', normal, viewport_pos, Frame_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a1, textcoord_a2, normal_map);
% [Frame_buffer] = tri_scan_conv_Z_lit_text( a3(1:3)', a4(1:3)', a2(1:3)', normal, viewport_pos, Frame_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a4, textcoord_a2, normal_map);


% % first face 
% [frame_buffer,z_buffer] = tri_scan_conv_Z_text( a1(1:3)', a2(1:3)', a3(1:3)', frame_buffer, z_buffer ,aa,bb,cc,image_1);
% [frame_buffer,z_buffer] = tri_scan_conv_Z_text( a4(1:3)', a2(1:3)', a3(1:3)', frame_buffer, z_buffer ,dd,bb,cc,image_1);
% 
% %second face 
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a5(1:3)', a6(1:3)', a7(1:3)', frame_buffer, z_buffer,aa,bb,cc,image_1);
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a8(1:3)', a6(1:3)', a7(1:3)', frame_buffer, z_buffer,dd,bb,cc,image_1);
% 
% %3rd face
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a7(1:3)', a3(1:3)', a4(1:3)', frame_buffer, z_buffer,aa,cc,dd,image_2);
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a7(1:3)', a8(1:3)', a4(1:3)', frame_buffer, z_buffer,aa,bb,dd,image_2);
% 
% % 4th face
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a5(1:3)', a1(1:3)', a2(1:3)', frame_buffer, z_buffer,aa,cc,dd,image_2);
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a5(1:3)', a6(1:3)', a2(1:3)', frame_buffer, z_buffer,aa,bb,dd,image_2);
%   
% % 5th face
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a8(1:3)', a4(1:3)', a2(1:3)', frame_buffer, z_buffer,aa,cc,dd,image_3);
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a8(1:3)', a6(1:3)', a2(1:3)', frame_buffer, z_buffer,aa,bb,dd,image_3);
% 
% % 6th face
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a7(1:3)', a5(1:3)', a1(1:3)', frame_buffer, z_buffer,aa,bb,dd,image_3);
% [frame_buffer, z_buffer] = tri_scan_conv_Z_text( a7(1:3)', a3(1:3)', a1(1:3)', frame_buffer, z_buffer,aa,cc,dd,image_3);
% 

% this function works on normal map and textures 
% 
% %1st face 
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a1(1:3)', a2(1:3)', a3(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a1, textcoord_a2, textcoord_a3, normal_map);
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a4(1:3)', a2(1:3)', a3(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a4, textcoord_a2, textcoord_a3, normal_map);
% %2nd face 
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a5(1:3)', a6(1:3)', a7(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a1, textcoord_a2, textcoord_a3, normal_map);
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a8(1:3)', a6(1:3)', a7(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a4, textcoord_a2, textcoord_a3, normal_map);
% %3rd face 
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a7(1:3)', a3(1:3)', a4(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a1, textcoord_a3, textcoord_a4, normal_map);
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a7(1:3)', a8(1:3)', a4(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a1, textcoord_a2, textcoord_a4, normal_map);
% %4th face
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a5(1:3)', a1(1:3)', a2(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a1, textcoord_a2, normal_map);
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a5(1:3)', a6(1:3)', a2(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a4, textcoord_a2, normal_map);
% %5th face
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a8(1:3)', a4(1:3)', a2(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a4, textcoord_a2, normal_map);
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a8(1:3)', a6(1:3)', a2(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a1, textcoord_a2, normal_map);
% %6th 
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a7(1:3)', a5(1:3)', a1(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a4, textcoord_a2, textcoord_a1, normal_map);
% [Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a7(1:3)', a3(1:3)', a1(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a4, textcoord_a3, textcoord_a1, normal_map);



%1st face 
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a1(1:3)', a2(1:3)', a3(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a1, textcoord_a2, textcoord_a3, normal_map);
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a4(1:3)', a2(1:3)', a3(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a4, textcoord_a2, textcoord_a3, normal_map);
%2nd face 
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a5(1:3)', a6(1:3)', a7(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a1, textcoord_a2, textcoord_a3, normal_map);
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a8(1:3)', a6(1:3)', a7(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a4, textcoord_a2, textcoord_a3, normal_map);
%3rd face 
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a7(1:3)', a3(1:3)', a4(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a1, textcoord_a3, textcoord_a4, normal_map);
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a7(1:3)', a8(1:3)', a4(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a1, textcoord_a2, textcoord_a4, normal_map);
%4th face
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a5(1:3)', a1(1:3)', a2(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a1, textcoord_a2, normal_map);
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a5(1:3)', a6(1:3)', a2(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a4, textcoord_a2, normal_map);
%5th face
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a8(1:3)', a4(1:3)', a2(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a4, textcoord_a2, normal_map);
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a8(1:3)', a6(1:3)', a2(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a1, textcoord_a2, normal_map);
%6th 
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a7(1:3)', a5(1:3)', a1(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a4, textcoord_a2, textcoord_a1, normal_map);
[Frame_buffer,z_buffer] = tri_scan_conv_Z_lit_2text( a7(1:3)', a3(1:3)', a1(1:3)' , viewport_pos, Frame_buffer,z_buffer, material_prop ,light_prop ,L,p, textcoord_a4, textcoord_a3, textcoord_a1, normal_map);


% viewing results
figure(4519)
imshow(Frame_buffer) 

% f = getframe(gcf);              %# Capture the current window
% imwrite(f.cdata,'Frame_bufferx55.png');   %# Save the frame data
