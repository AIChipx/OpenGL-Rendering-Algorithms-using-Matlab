% Sphere Phong shading
% here we will use lit_viewport_inf
% all normalizations are performed here


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

disp('Enter rotation angles')
theta_x = input('theta_x= ');
theta_y = input('theta_y= ');
theta_z = input('theta_z= ');

% sphere vertices generation
[x,y,z] = sphere(vtx_cnt - 1);
x1 = x(:);
y1 = y(:);
z1 = z(:);
% sphere vertices generation
vlx = [x1 y1 z1];
cnt = size(vlx);
% Loading all vertices into one column vector
vertex_list = 2.5*vlx;

% Computing normals (and normalizing them)
normal_list = zeros(cnt(1),3);
for ss=1:cnt(1)
    normal_list(ss,:) = normalize(vertex_list(ss,:));
end

%/////////////////////////////////////////////////////////////////////////
% applying transformations 
% rotation trans (vertex transformations)
[vertex_list] = rotate_Xaxis(vertex_list, theta_x, 1);
[vertex_list] = rotate_Yaxis(vertex_list, theta_y, 1);
[vertex_list] = rotate_Zaxis(vertex_list, theta_z, 1);

% rotation trans (normal transformations)
[normal_list] = rotate_Xaxis(normal_list, theta_x, 0);
[normal_list] = rotate_Yaxis(normal_list, theta_y, 0);
[normal_list] = rotate_Zaxis(normal_list, theta_z, 0);

% applying projection 
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


% Lighting calculations
% normalizing normals
nn = zeros(cnt(1),3);
for ss=1:cnt(1)
    nn(ss,:) = normalize(normal_list(ss,:));
end

% Material properties
    % material diffuse/ambient reflectance
    mat_amb_diff = [1 0.1 0.2];
    % material specular color
    mat_specular = [1 1 1];
    % shiness exponent
    p = 75;
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
    lightsource_dir2 = normalize(lightsource_dir1);
    % applying modelview transformation to light source direction
    [lightsource_dir2] = rotate_Xaxis(lightsource_dir2, theta_x, 0);
    [lightsource_dir2] = rotate_Yaxis(lightsource_dir2, theta_y, 0);
    [lightsource_dir2] = rotate_Zaxis(lightsource_dir2, theta_z, 0);
    L = normalize(lightsource_dir2);
    % half vector
    h0 = e0 + L;
    h = normalize(h0);

% color list generation
%     color_list = zeros(n,3,n);
%     cl = zeros(cnt(1),3);
%     for cc=1:cnt(1)
%         [ cl(cc,:) ] = lit_viewport_inf( mat_amb_diff, mat_shininess, mat_specular, light_ambient, light_diffuse, light_specular, h, lightsource_dir, nn(cc,:));
%     end
    i = 1;
    for l=1:n
        for k=1:n
            normal_list(l,:,k) = nn(i,:);
            i = i + 1;
        end
    end

% Drawing the sphere
for y=1:n-1
    [ frame_buffer, z_buffer ] = draw_polygon_2lines_lit( poly_list(:,:,y), normal_list(:,:,y), poly_list(:,:,y+1), normal_list(:,:,y+1), frame_buffer, z_buffer,material_prop ,light_prop ,L,h,p);
end


% viewing results
figure(9795)
% vertical flip of framebuffer
frame_buffer = flipdim(frame_buffer ,1);
imshow(frame_buffer)

f = getframe(gcf);
imwrite(f.cdata,'framebuff_x1.png');
