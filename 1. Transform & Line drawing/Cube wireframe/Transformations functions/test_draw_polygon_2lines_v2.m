% test polygon raster V3
% this one is dedicated to test draw_polygon_2lines function
% this one is working :)
% You can take it as a ref to use draw_polygon_2lines function

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
[x,y,z] = sphere(6);
x1 = x(:);
y1 = y(:);
z1 = z(:);
% sphere vertices generation
vlx = [x1 y1 z1];

% Loading all vertices into one column vector
vertex_list = vlx;

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
vl = vertex_list;

% extracting sphere horizontal lines
   
    poly_list1 = [vl(1,:); vl(8,:); vl(15,:); vl(22,:); vl(29,:); vl(36,:); vl(43,:)];
    poly_list2 = [vl(2,:); vl(9,:); vl(16,:); vl(23,:); vl(30,:); vl(37,:); vl(44,:)];
    poly_list3 = [vl(3,:); vl(10,:); vl(17,:); vl(24,:); vl(31,:); vl(38,:); vl(45,:)];
    poly_list4 = [vl(4,:); vl(11,:); vl(18,:); vl(25,:); vl(32,:); vl(39,:); vl(46,:)];
    poly_list5 = [vl(5,:); vl(12,:); vl(19,:); vl(26,:); vl(33,:); vl(40,:); vl(47,:)];
    poly_list6 = [vl(6,:); vl(13,:); vl(20,:); vl(27,:); vl(34,:); vl(41,:); vl(48,:)];
    poly_list7 = [vl(7,:); vl(14,:); vl(21,:); vl(28,:); vl(35,:); vl(42,:); vl(49,:)];
    
% packing color values into one column vector
% color values
c1 = [0 0 1];
c2 = [0 1 0];
c3 = [0 1 1];
c4 = [1 0 0];
c5 = [1 0 1];
c6 = [1 1 0];
c7 = [1 1 1];
cx = [0 0 0];
color_list1 = [c1;c1;c1;c1;c1;c1;c1];
color_list2 = [c2;c2;c2;c2;c2;c2;c2];
color_list3 = [c3;c3;c3;c3;c3;c3;c3];
color_list4 = [c4;c4;c4;c4;c4;c4;c4];
color_list5 = [c5;c5;c5;c5;c5;c5;c5];
color_list6 = [c6;c6;c6;c6;c6;c6;c6];
% poles color list
color_pole = [cx;cx;cx;cx;cx;cx;cx];

[ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list1, color_pole, poly_list2, color_list1, frame_buffer, z_buffer);
[ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list2, color_list1, poly_list3, color_list2, frame_buffer, z_buffer);
[ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list3, color_list2, poly_list4, color_list3, frame_buffer, z_buffer);
[ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list4, color_list3, poly_list5, color_list4, frame_buffer, z_buffer);
[ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list5, color_list4, poly_list6, color_list5, frame_buffer, z_buffer);
[ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list6, color_list5, poly_list7, color_pole, frame_buffer, z_buffer);


% [ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list1, color_list1, poly_list2, color_list1, frame_buffer, z_buffer);
% [ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list2, color_list5, poly_list3, color_list5, frame_buffer, z_buffer);
% [ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list3, color_list2, poly_list4, color_list2, frame_buffer, z_buffer);
% [ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list4, color_list3, poly_list5, color_list3, frame_buffer, z_buffer);
% [ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list5, color_list4, poly_list6, color_list4, frame_buffer, z_buffer);
% [ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list6, color_list5, poly_list7, color_pole, frame_buffer, z_buffer);

% viewing results
figure(9791)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)
