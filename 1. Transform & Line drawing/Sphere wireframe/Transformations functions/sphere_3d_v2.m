% second trial to render 3D sphere
% using enhanced transformation functions
clear; clc;
% screen dimentions (x and y) used  
x_screen = 500;
y_screen = 500;
% Frame buffer
frame_buffer = zeros(x_screen,y_screen,3);

% Z-buffer
z_buffer = 255*ones(x_screen, y_screen);

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

% sphere vertices generation
[x,y,z] = sphere(5);
x1 = x(:);
y1 = y(:);
z1 = z(:);
% sphere vertices generation
vlx = [x1 y1 z1];

% Loading all vertices into one column vector
vertex_list = vlx;

% Bresenham's line color
white = [1 1 1];
blue = [0 0 1];

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
% drawing sphere vertical lines
vl = vertex_list;
for i=1:5
    frame_buffer = Bresenham_line(vl(i,:), vl(i+1,:),white,frame_buffer);
end

for i=7:11
    frame_buffer = Bresenham_line(vl(i,:), vl(i+1,:),white,frame_buffer);
end

for i=13:17
    frame_buffer = Bresenham_line(vl(i,:), vl(i+1,:),white,frame_buffer);
end

for i=19:23
    frame_buffer = Bresenham_line(vl(i,:), vl(i+1,:),white,frame_buffer);
end

for i=25:29
    frame_buffer = Bresenham_line(vl(i,:), vl(i+1,:),white,frame_buffer);
end

for i=31:35
    frame_buffer = Bresenham_line(vl(i,:), vl(i+1,:),white,frame_buffer);
end

% drawing sphere horizontal lines
for j=2:6:30
    frame_buffer = Bresenham_line(vl(j,:), vl(j+6,:),blue,frame_buffer);
end

for j=3:6:29
    frame_buffer = Bresenham_line(vl(j,:), vl(j+6,:),blue,frame_buffer);
end

for j=4:6:28
    frame_buffer = Bresenham_line(vl(j,:), vl(j+6,:),blue,frame_buffer);
end

for j=5:6:27
    frame_buffer = Bresenham_line(vl(j,:), vl(j+6,:),blue,frame_buffer);
end

% viewing results
figure(9791)
imshow(frame_buffer)
