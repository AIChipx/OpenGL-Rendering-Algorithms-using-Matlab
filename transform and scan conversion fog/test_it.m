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
% n = 1; 
n = 0.5;
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

% Loading all vertices into one column vector
vertex_list = [a1; a2; a3; a4; a5; a6; a7; a8];

% perspective  projection
% vertex list is a list of all vertices to be transformed
% perspective division is also performed here
% VERY IMPORTANT NOTE

% l >> left
% r >> right
% b >> bottom
% t >> top
% n >> near
% f >> far

Mfrstm = [(2*abs(n))/(r-l), 0                           ,(r+l)/(r-l)                       , 0;
          0               ,(2*abs(n))/(t-b)             ,(t+b)/(t-b)                       , 0;
          0               , 0                           ,(abs(n)+abs(f))/(abs(n)-abs(f))   , (2*abs(f)*abs(n))/(abs(n)-abs(f));
          0               , 0                           , -1                               , 0];

% applying Orthographic projection 
cnt = size(vertex_list);
out_vertex = ones(cnt(1),cnt(2));
for i=1:cnt(1)
    vertex_list_out(i,:) = Mfrstm * [vertex_list(i,:) 1]'
    
    % perspective division
    %temp = temp/temp(4);
    
end
