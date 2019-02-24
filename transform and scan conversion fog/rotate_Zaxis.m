function [ out_vertex ] = rotate_Zaxis( vertex_list, theta_z )
% Rotation about z-axis
% vertex list is a list of all vertices to be transformed

x = (theta_z / 180.0)*pi;

% translation matrix
trans_mat = [ cos(x), -sin(x), 0.0, 0.0;
              sin(x), cos(x) , 0.0, 0.0;
              0.0   , 0.0    , 1.0, 0.0;
              0.0   , 0.0    , 0.0, 1.0];

% applying transformation 
cnt = size(vertex_list);
out_vertex = ones(cnt(1),cnt(2));
for i=1:cnt(1)
    temp = trans_mat * [vertex_list(i,:) 1]';
    out_vertex(i, :) = temp(1:3)';
end
end