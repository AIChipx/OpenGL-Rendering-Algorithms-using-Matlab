% Bump mapping Gamma
% this code will be the basis for Bump mapping
% here lighting calculations is performed per pixel (Phong shading)
% texture image is combined with lighting in the correct order
clear; clc;

% screen dimentions (must be identical)
disp('>> Range is from 100 to 500')
dim = input(' Enter framebuffer dimentions= ');
x_screen = dim;
y_screen = dim;

% Frame buffer
Frame_buffer = zeros(x_screen,y_screen,3);

% reading texture image
% four texture images are available you can choose between them
% text1.png, text2.png, text3.png, text4.png
texture_image = double(imread('text4.png'))/255;

% polygon vertices computed from screen dimentions
dim1 = round(x_screen/10);
dim2 = round(y_screen - dim1);
a1 = [dim1, dim2, 1];
a2 = [dim2, dim2, 1];
a3 = [dim1, dim1, 1];
a4 = [dim2, dim1, 1];

% assigning texture coordinates
% texture coordinates are computed from screen dimentions
textcoord_a1 = [dim2, dim1];
textcoord_a2 = [dim2, dim2];
textcoord_a3 = [dim1, dim1];
textcoord_a4 = [dim1, dim2];

% polygon normal (one normal for the whole polygon)
normal =[0 0 1];

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
[Frame_buffer] = tri_scan_conv_Z_lit_text( a3(1:3)', a1(1:3)', a2(1:3)', normal, viewport_pos, Frame_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a1, textcoord_a2, texture_image);
[Frame_buffer] = tri_scan_conv_Z_lit_text( a3(1:3)', a4(1:3)', a2(1:3)', normal, viewport_pos, Frame_buffer, material_prop ,light_prop ,L,p, textcoord_a3, textcoord_a4, textcoord_a2, texture_image);

% viewing results
figure(4519)
imshow(Frame_buffer) 

% f = getframe(gcf);              %# Capture the current window
% imwrite(f.cdata,'Frame_buffer4.png');   %# Save the frame data
