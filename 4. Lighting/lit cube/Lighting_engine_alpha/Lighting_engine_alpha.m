% test transform engine using scan conversion 
% testing transformation functions

clear; clc;
% screen dimentions (x and y) used  
x_screen = 500;
y_screen = 500;

% Frame buffer
frame_buffer = zeros(x_screen,y_screen,3);

%%% 
model_view =eye(4);

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

% Cube vertices
% scaled
s = 1.5;
a1 = s*[-1, -1, -1];
n1 = normal(a1);
a2 = s*[1, -1, -1];
n2 = normal(a2);
a3 = s*[-1, -1, 1];
n3 = normal(a3);
a4 = s*[1, -1, 1];
n4 = normal(a4);
a5 = s*[-1, 1, -1];
n5 = normal(a5);
a6 = s*[1, 1, -1];
n6 = normal(a6);
a7 = s*[-1, 1, 1];
n7 = normal(a7);
a8 = s*[1, 1, 1];
n8 = normal(a8);



% Loading all vertices into one column vector
vertex_list = [a1; a2; a3; a4; a5; a6; a7; a8];
normal_list = [n1; n1; n3; n4; n5; n6; n7; n8];

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
[vertex_list,model_view_matrix] = Scale_it(vertex_list, sx, sy, sz);
model_view = model_view_matrix * model_view ;

% rotation trans
[vertex_list,model_view_matrix] = rotate_Xaxis(vertex_list, theta_x);
model_view = model_view_matrix * model_view ;

[vertex_list , model_view_matrix] = rotate_Yaxis(vertex_list, theta_y);
model_view = model_view_matrix * model_view ;

[vertex_list , model_view_matrix] = rotate_Zaxis(vertex_list, theta_z);
model_view = model_view_matrix * model_view ;

% translation trans
[vertex_list] = Translate_it(vertex_list, tx, ty, tz);

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

% transformed normals
n1 = model_view*[n1, 0]';
n2 = model_view*[n2, 0]';
n3 = model_view*[n3, 0]';
n4 = model_view*[n4, 0]';
n5 = model_view*[n5, 0]';
n6 = model_view*[n6, 0]';
n7 = model_view*[n7, 0]';
n8 = model_view*[n8, 0]';

% performing lighting calculations
% material diffuse reflectance
cr = [1 1 1];
% light source ambient color
ca = [0.2 0.2 0];
%light source color intens
ci = [1 0 1];
% shiness exponent
p = 50;
% viewport direction 
e0 = [0 0 1];
% light source direction
i1 = [-1 -1 1];
i = normal(i1);

% computing lighting color for each vertex
% 1st vertex color
e1 = e0 - a1;
e = normal(e1);
h0 = (e + i);
h = normal(h0);
ca1 = cr.*(ca + ci*max(0,dot(n1(1:3)',i))) + ci * (dot(h,n1(1:3)')) ^ p;

%2nd vertex 
e1 = e0 - a2;
e = normal(e1);
h0 = (e + i);
h = normal(h0);
ca2 = cr.*(ca + ci*max(0,dot(n2(1:3)',i))) + ci * (dot(h,n2(1:3)')) ^ p;

% third vertex
e1 = e0 - a3;
e = normal(e1);
h0 = (e + i);
h = normal(h0);
ca3 = cr.*(ca + ci*max(0,dot(n3(1:3)',i))) + ci * (dot(h,n3(1:3))) ^ p;

% fourth vertex
e1 = e0 - a4;
e = normal(e1);
h0 = (e + i);
h = normal(h0);
ca4 = cr.*(ca + ci*max(0,dot(n4(1:3),i))) + ci * (dot(h,n4(1:3))) ^ p;

% 5th vertex
e1 = e0 - a5;
e = normal(e1);
h0 = (e + i);
h = normal(h0);
ca5 = cr.*(ca + ci*max(0,dot(n5(1:3),i))) + ci * (dot(h,n5(1:3))) ^ p;

% 6th vertex
e1 = e0 - a6;
e = normal(e1);
h0 = (e + i);
h = normal(h0);
ca6 = cr.*(ca + ci*max(0,dot(n6(1:3),i))) + ci * (dot(h,n6(1:3))) ^ p;

% 7th vertex
e1 = e0 - a7;
e = normal(e1);
h0 = (e + i);
h = normal(h0);
ca7 = cr.*(ca + ci*max(0,dot(n7(1:3),i))) + ci * (dot(h,n7(1:3))) ^ p;

% 8th vertex
e1 = e0 - a8;
e = normal(e1);
h0 = (e + i);
h = normal(h0);
ca8 = cr.*(ca + ci*max(0,dot(n8(1:3),i))) + ci * (dot(h,n8(1:3))) ^ p;


% Drawing using scan conversion
% 1st face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a1(1:3)', a2(1:3)', a3(1:3)', ca1, ca2, ca3, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a4(1:3)', a2(1:3)', a3(1:3)', ca4, ca2, ca3, frame_buffer, z_buffer );

% 2nd face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a5(1:3)', a6(1:3)', a7(1:3)', ca5, ca6, ca7, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a8(1:3)', a6(1:3)', a7(1:3)', ca8, ca6, ca7, frame_buffer, z_buffer );

% 3rd face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a7(1:3)', a3(1:3)', a4(1:3)', ca7, ca3, ca4, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a7(1:3)', a8(1:3)', a4(1:3)', ca7, ca8, ca4, frame_buffer, z_buffer );

% 4th face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a5(1:3)', a1(1:3)', a2(1:3)', ca5, ca1, ca2, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a5(1:3)', a6(1:3)', a2(1:3)', ca5, ca6, ca2, frame_buffer, z_buffer );
  
% 5th face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a8(1:3)', a4(1:3)', a2(1:3)', ca8, ca4, ca2, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a8(1:3)', a6(1:3)', a2(1:3)', ca8, ca6, ca2, frame_buffer, z_buffer );

% 6th face
[frame_buffer, z_buffer] = tri_scan_conv_Z( a7(1:3)', a5(1:3)', a1(1:3)', ca7, ca5, ca1, frame_buffer, z_buffer );
[frame_buffer, z_buffer] = tri_scan_conv_Z( a7(1:3)', a3(1:3)', a1(1:3)', ca7, ca3, ca1, frame_buffer, z_buffer );


% viewing results
figure(97912)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)



