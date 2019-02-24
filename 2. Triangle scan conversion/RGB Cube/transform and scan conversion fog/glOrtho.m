function [ out_vertex ] = glOrtho( vertex_list, l, r, b, t, n, f )
% Othographic projection
% vertex list is a list of all vertices to be transformed

% VERY IMPORTANT NOTE
% near and far values should be given positive, internal negation will
% happen then >> (n+f)/(n-f) instead of -(n+f)/(n-f)

% l >> left
% r >> right
% b >> bottom
% t >> top
% n >> near
% f >> far

Morth = [2/(r-l) 0 0 -(r+l)/(r-l); 0 2/(t-b)  0 -(t+b)/(t-b); 0 0 2/(n-f) (n+f)/(n-f); 0 0 0 1];

% applying Orthographic projection 
cnt = size(vertex_list);
out_vertex = ones(cnt(1),cnt(2));
for i=1:cnt(1)
    temp = Morth * [vertex_list(i,:) 1]';
    out_vertex(i, :) = temp(1:3)';
end
end