function [ out_vertex ] = viewport_map( vertex_list, x_screen, y_screen )
% viewport mapping transformation
% vertex list is a list of all vertices to be transformed
% x_screen is the screen width
% y_screen is the screen height

% Evaluating viewport mapping matrix
M_viewport = [x_screen/2, 0, 0, (x_screen-1)/2;
              0, y_screen/2, 0, (y_screen-1)/2;
              0, 0, 1, 0;
              0, 0, 0, 1];
          
% applying transformation 
cnt = size(vertex_list);
out_vertex = ones(cnt(1),cnt(2));
for i=1:cnt(1)
    temp = M_viewport * [vertex_list(i,:) 1]';
    out_vertex(i, :) = temp(1:3)';
end
end

