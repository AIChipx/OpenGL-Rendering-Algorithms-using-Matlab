% testing transformation functions
% Revised OK :)
% Now Bresenham Line drawing algorithm is working correctly with glOrtho

clear; clc;
% screen dimentions (x and y) used  
x_screen = 320;
y_screen = 240;
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

% Cube vertices
% scaled
s = 0.5;
a1 = s*[-1, -1, -1];
a2 = s*[1, -1, -1];
a3 = s*[-1, -1, 1];
a4 = s*[1, -1, 1];
a5 = s*[-1, 1, -1];
a6 = s*[1, 1, -1];
a7 = s*[-1, 1, 1];
a8 = s*[1, 1, 1];

% Axis vertices
oo = [0, 0, 0];
x_axis = [2, 0, 0];
y_axis = [0, 2, 0];
z_axis = [0, 0, 2];

% Bresenham's line color
white = [1 1 1];
red = [1 0 0];
blue = [0 0 1];
green = [0 1 0];

% Loading all vertices into one column vector
vertex_list = [a1; a2; a3; a4; a5; a6; a7; a8; oo; x_axis; y_axis; z_axis];

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
% perspective proj (not working)
% [vertex_list] = glFrustum(vertex_list, l, r, b, t, n, f );

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

% transformed axis vertices
oo = vertex_list(9, :);
x_axis = vertex_list(10, :);
y_axis = vertex_list(11, :);
z_axis = vertex_list(12, :);

% Drawing using Bresenham Algorithm

% Axis lines
frame_buffer = Bresenham_line(oo, x_axis, red,frame_buffer);
frame_buffer = Bresenham_line(oo, y_axis, green,frame_buffer);
frame_buffer = Bresenham_line(oo, z_axis, blue,frame_buffer);

% cube lines
frame_buffer = Bresenham_line(a1, a2, white,frame_buffer);
frame_buffer = Bresenham_line(a1, a5, white,frame_buffer);

frame_buffer = Bresenham_line(a5, a6, white,frame_buffer);
frame_buffer = Bresenham_line(a2, a6, white,frame_buffer);

frame_buffer = Bresenham_line(a3, a4, white,frame_buffer);
frame_buffer = Bresenham_line(a3, a7, white,frame_buffer);

frame_buffer = Bresenham_line(a7, a8, white,frame_buffer);
frame_buffer = Bresenham_line(a4, a8, white,frame_buffer);

frame_buffer = Bresenham_line(a5, a7, white,frame_buffer);
frame_buffer = Bresenham_line(a6, a8, white,frame_buffer);

frame_buffer = Bresenham_line(a2, a4, white,frame_buffer);
frame_buffer = Bresenham_line(a1, a3, white,frame_buffer);



% viewing results
figure(979)

% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);

imshow(frame_buffer)

f = getframe(gcf);              %# Capture the current window
%imwrite(f.cdata,'Frame_bufferx3.png');   %# Save the frame data

% % viewport mapping (fake !!)
% t1 = [-2,2,0];
% t2 = [-2,2,0];
% 
% figure(1011)
% plot(t1(1:2), t2(1:2),'color', 'black')
% hold all
% % foreground color black
% set(gcf, 'color', [0 0 0])
% % axis color black
% set(gca, 'color', [0 0 0])
% % window size
% hFig = figure(1011);
% set(hFig, 'Position', [500 100 500 500])
% % Drawing Cube vertices
% line([a1(1) a2(1)], [a1(2) a2(2)],  'color', 'white')
% line([a1(1) a5(1)], [a1(2) a5(2)],  'color', 'white')
% line([a5(1) a6(1)], [a5(2) a6(2)],  'color', 'white')
% line([a2(1) a6(1)], [a2(2) a6(2)],  'color', 'white')
% line([a3(1) a4(1)], [a3(2) a4(2)],  'color', 'white')
% line([a3(1) a7(1)], [a3(2) a7(2)],  'color', 'white')
% line([a7(1) a8(1)], [a7(2) a8(2)],  'color', 'white')
% line([a4(1) a8(1)], [a4(2) a8(2)],  'color', 'white')
% line([a5(1) a7(1)], [a5(2) a7(2)],  'color', 'white')
% line([a6(1) a8(1)], [a6(2) a8(2)],  'color', 'white')
% line([a2(1) a4(1)], [a2(2) a4(2)],  'color', 'white')
% line([a1(1) a3(1)], [a1(2) a3(2)],  'color', 'white')
% 
% % Drawing Axis vertices 
% line([oo(1) x_axis(1)], [oo(2) x_axis(2)],  'color', 'red')
% line([oo(1) y_axis(1)], [oo(2) y_axis(2)],  'color', 'green')
% line([oo(1) z_axis(1)], [oo(2) z_axis(2)],  'color', 'blue')
