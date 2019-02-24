function [ out_vertex ] = glFrustum( vertex_list, l, r, b, t, n, f )
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
    temp = Mfrstm * [vertex_list(i,:) 1]';
    
    % perspective division
    temp = temp/temp(4);
    out_vertex(i, :) = temp(1:3)';
end
end