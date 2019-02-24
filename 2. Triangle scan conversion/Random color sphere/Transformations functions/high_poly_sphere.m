% test polygon raster V4
% this one is dedicated to create high poly sphere model
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

% color list generation
% generating random color vector
grad1 = rand(1,n);
grad2 = rand(1,n);
grad3 = rand(1,n);

color_list = zeros(n,3,n);
for f = 1:n
    for v = 1:n
            % You can make special effects by using the commented lines ;)
%             color_list(v,:,f) = [grad1(f), grad2(f), grad3(f)];
%           color_list(v,:,f) = [rand(1), grad2(f), rand(1)];
          color_list(v,:,f) = [grad1(f), rand(1), rand(1)];
    end
end

% Drawing the sphere
for y=1:n-1
    [ frame_buffer, z_buffer ] = draw_polygon_2lines( poly_list(:,:,y), color_list(:,:,y), poly_list(:,:,y+1), color_list(:,:,y+1), frame_buffer, z_buffer);
end


% viewing results
figure(9795)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)
