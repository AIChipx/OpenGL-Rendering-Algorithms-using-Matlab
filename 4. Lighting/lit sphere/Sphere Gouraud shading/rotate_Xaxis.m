function [ out_vertex ] = rotate_Xaxis( vertex_list, theta_x, state )
% Rotation about x-axis
% vertex list is a list of all vertices to be transformed
% can transform vertices as well as normals based on state value
% if state = 1 >> vertex transform
% if state = 0 >> normal transform

if (state == 1)
    kk = 1;
else
    kk = 0;
end

x = (theta_x / 180.0)*pi;

% translation matrix
trans_mat = [ 1.0,  0.0   , 0.0     , 0.0;
              0.0,  cos(x), -sin(x) , 0.0;
              0.0,  sin(x), cos(x)  , 0.0;
              0.0,  0.0   , 0.0     , 1.0];

% applying transformation 
cnt = size(vertex_list);
out_vertex = ones(cnt(1),cnt(2));

for i=1:cnt(1)
    temp = trans_mat * [vertex_list(i,:) kk]';
    out_vertex(i, :) = temp(1:3)';
end
end

