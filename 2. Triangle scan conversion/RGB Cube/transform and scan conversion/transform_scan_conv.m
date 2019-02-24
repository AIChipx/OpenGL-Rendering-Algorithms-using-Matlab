% test transform engine using scan conversion 
% testing transformation functions

clear; clc;
% screen dimentions (x and y) used  
x_screen = 240;
y_screen = 320;

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
% n = 0.6;
% far
f = 10; 

% Cube vertices
% scaled
s = 1.3;
a1 = s*[-1, -1, -1];
a2 = s*[1, -1, -1];
a3 = s*[-1, -1, 1];
a4 = s*[1, -1, 1];
a5 = s*[-1, 1, -1];
a6 = s*[1, 1, -1];
a7 = s*[-1, 1, 1];
a8 = s*[1, 1, 1];

% Scan conversion
% color at each triangle vertex
ca1 = [1 0 0];
ca2 = [1 0 1];
ca3 = [0 0 0];
ca4 = [0 0 1];
ca5 = [1 1 0];
ca6 = [1 1 1];
ca7 = [0 1 0];
ca8 = [0 1 1];

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
[vertex_list] = viewport_map(vertex_list, y_screen, x_screen);
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


% Drawing using scan conversion
% 1st face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a1(1:3)', a2(1:3)', a3(1:3)', ca1, ca2, ca3, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a4(1:3)', a2(1:3)', a3(1:3)', ca4, ca2, ca3, frame_buffer, z_buffer );

% 2nd face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a5(1:3)', a6(1:3)', a7(1:3)', ca5, ca6, ca7, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a8(1:3)', a6(1:3)', a7(1:3)', ca8, ca6, ca7, frame_buffer, z_buffer );
% 
% % 3rd face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a7(1:3)', a3(1:3)', a4(1:3)', ca7, ca3, ca4, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a7(1:3)', a8(1:3)', a4(1:3)', ca7, ca8, ca4, frame_buffer, z_buffer );
% 
% % 4th face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a5(1:3)', a1(1:3)', a2(1:3)', ca5, ca1, ca2, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a5(1:3)', a6(1:3)', a2(1:3)', ca5, ca6, ca2, frame_buffer, z_buffer );
%   
% % 5th face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a8(1:3)', a4(1:3)', a2(1:3)', ca8, ca4, ca2, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a8(1:3)', a6(1:3)', a2(1:3)', ca8, ca6, ca2, frame_buffer, z_buffer );
% 
% % 6th face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a7(1:3)', a5(1:3)', a1(1:3)', ca7, ca5, ca1, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a7(1:3)', a3(1:3)', a1(1:3)', ca7, ca3, ca1, frame_buffer, z_buffer );


% viewing results
figure(979)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)



