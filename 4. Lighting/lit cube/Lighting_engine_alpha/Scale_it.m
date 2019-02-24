function [ out_vertex,trans_mat ] = Scale_it( vertex_list, sx, sy, sz )
% Scaling transformation
% vertex list is a list of all vertices to be transformed 

% translation matrix
trans_mat = [sx 0  0  0;
             0  sy 0  0;
             0  0  sz 0;
             0  0  0  1];
         
% applying transformation 
cnt = size(vertex_list);
out_vertex = ones(cnt(1),cnt(2));
for i=1:cnt(1)
    temp = trans_mat * [vertex_list(i,:) 1]';
    out_vertex(i, :) = temp(1:3)';
end
end

