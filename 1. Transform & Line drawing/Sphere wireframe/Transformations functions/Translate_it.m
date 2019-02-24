function [ out_vertex ] = Translate_it( vertex_list, tx, ty, tz )
% translation transformation
% vertex list is a list of all vertices to be transformed 

% translation matrix
trans_mat = [1 0 0 tx;
             0 1 0 ty;
             0 0 1 tz;
             0 0 0 1];
         
% applying transformation 
cnt = size(vertex_list);
out_vertex = ones(cnt(1),cnt(2));
for i=1:cnt(1)
    temp = trans_mat * [vertex_list(i,:) 1]';
    out_vertex(i, :) = temp(1:3)';
end
end

