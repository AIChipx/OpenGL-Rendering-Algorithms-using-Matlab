% test tri_scan_conv_Z_lit function
% test OK :) true :) folla :)

clear; clc;
% screen dimentions (x and y) used  
x_screen = 500;
y_screen = 500;

% Frame buffer
frame_buffer = zeros(x_screen,y_screen,3);

% Z-buffer
z_buffer = 255*ones(x_screen, y_screen);

s = 1;
x1 = s*[50, 50, 1];
nx = [0 1 0];
y1 = s*[450, 50, 1];
ny = [1 0 0];
z1 = s*[50, 450, 1];
nz = [0 0 1];
h1 = s*[450, 450, 1];
nh = [0 1 0];

% Material properties
    % material diffuse/ambient reflectance
    mat_amb_diff = [0 0 1];
    % material specular color
    mat_specular = [1 1 1];
    % shiness exponent
    p = 100;
material_prop = [mat_amb_diff;mat_specular];
    
% Light source properties
    % light source ambient color
    light_ambient = [0.3 0.3 0.3];
    %light source diffuse color
    light_diffuse = [1 1 1];
    % material specular color
    light_specular = [1 1 1];
 light_prop = [light_ambient;light_diffuse;light_specular];
 
 % viewport direction (at infinity) 
    e1 = [0 0 1];
    e0 = normalize(e1);
    % light source direction (at infinity)
    lightsource_dir1 = [0 0 1];
    L = normalize(lightsource_dir1);
    % half vector
    h0 = e0 + L;
    h = normalize(h0);


[ frame_buffer,z_buffer ] = polygon_raster_lit(x1, nx, y1, ny, z1, nz, h1, nh, frame_buffer, z_buffer,material_prop ,light_prop ,L,h,p  );

% viewing results
figure(9795)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)