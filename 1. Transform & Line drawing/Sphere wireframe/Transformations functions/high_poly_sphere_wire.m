% test polygon raster V4_wire
% this one is dedicated to create high poly sphere model in wireframe 
% here we will use the traditional Bresenham Line drawing

clear; clc;
% screen dimentions (x and y) used  
x_screen = 500;
y_screen = 500;
% Frame buffer
frame_buffer = zeros(x_screen,y_screen,3);

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

disp('Enter vertex factor')
vtx_cnt = input('vtx_cnt= ');
disp('Enter Scaling parameters')
sx = input('sx= ');
sy = input('sy= ');
sz = input('sz= ');

disp('Enter rotation angles')
theta_x = input('theta_x= ');
theta_y = input('theta_y= ');
theta_z = input('theta_z= ');

disp('Enter translation parameters')
tx = input('tx= ');
ty = input('ty= ');
tz = input('tz= ');

% sphere vertices generation
[x,y,z] = sphere(vtx_cnt - 1);
x1 = x(:);
y1 = y(:);
z1 = z(:);
% sphere vertices generation
vlx = [x1 y1 z1];

% Loading all vertices into one column vector
vertex_list = 2.5*vlx;

%/////////////////////////////////////////////////////////////////////////
% applying transformations
% scaling trans
[vertex_list] = Scale_it(vertex_list, sx, sy, sz);
% rotation trans
[vertex_list] = rotate_Xaxis(vertex_list, theta_x);
[vertex_list] = rotate_Yaxis(vertex_list, theta_y);
[vertex_list] = rotate_Zaxis(vertex_list, theta_z);
% translation trans
[vertex_list] = Translate_it(vertex_list, tx, ty, tz);

% applying projection 
% We need to comment one of them
% Orthographic proj
[vertex_list] = glOrtho(vertex_list, l, r, b, t, n, f);

% Viewport mapping transformation
[vertex_list] = viewport_map(vertex_list, x_screen, y_screen);
%/////////////////////////////////////////////////////////////////////////

% drawing the sphere
% Don't scale this variable "vl" Z-buffer will not work
vl = vertex_list;

% extracting sphere horizontal lines
% storing horizontal lines in multi-dimentional matrix poly_list
cnt = size(vl);
n = sqrt(cnt(1));
disp(' Number of vertices is: '); disp(cnt(1));
poly_list = zeros(n,3,n);
i = 1;
for l=1:n
    for k=1:n
        poly_list(l,:,k) = vl(i,:);
        i = i + 1;
    end
end

% sphere Lines color
% vertical lines
color1 = [1 0 1];
% horizontal lines
color2 = [0 1 1];

color_list1 = zeros(n,3,n);
color_list2 = zeros(n,3,n);
for f = 1:n
    for v = 1:n
            color_list1(v,:,f) = color1;
            color_list2(v,:,f) = color2;
    end
end

% Drawing the sphere vertical lines
for y=1:n-1
    for u=1:n
    [ frame_buffer ] = Bresenham_line( poly_list(u,:,y),poly_list(u,:,y+1), color_list1(u,:,y), frame_buffer);
    end
end

% Drawing the sphere horizontal lines
for y=1:n-1
    for u=1:n-1
    [ frame_buffer ] = Bresenham_line( poly_list(u,:,y),poly_list(u+1,:,y), color_list2(u,:,y), frame_buffer);
    end
end

% viewing results
figure(9791)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)


% f = getframe(gcf);              %# Capture the current window
% imwrite(f.cdata,'Frame_buffery2.png');   %# Save the frame data
