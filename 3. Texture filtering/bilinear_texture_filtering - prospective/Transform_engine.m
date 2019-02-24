function [ transformed_vertex ] = Transform_engine( input_vertex, screen_dimensions)
% Transform engine
% This engine can only transform one vertex at a time
% My inputs will be the vertex to be transformed
% Also Modelview & Projection matrix will be read
% viewport transformation is also performed here
% screen_dimensions is for screen width and height
% prospective division is also performed
% input vetex is converted to homogeneous coordinates format


% Loading Modelview Matrix
M_modelview = zeros(4,4);
m_tmp = load('modelview_matrix.txt');
i = 1;
for j=1:4
    for k=1:4
        M_modelview(k, j) = m_tmp(i);
        i = i + 1;
    end;
end;

% Loading Projection Matrix
M_projection = zeros(4,4);
m_tmp = load('projection_matrix.txt');
i = 1;
for j=1:4
    for k=1:4
        M_projection(k, j) = m_tmp(i);
        i = i + 1;
    end;
end;

x_screen = screen_dimensions(1);
y_screen = screen_dimensions(2);
% Evaluating viewport mapping matrix
M_viewport = [x_screen/2, 0, 0, (x_screen-1)/2;
              0, y_screen/2, 0, (y_screen-1)/2;
              0, 0, 1, 0;
              0, 0, 0, 1];

% Multiplying them together
M_transform = M_viewport * M_projection * M_modelview;

% transforming vertex
trans_vertex = M_transform * [input_vertex' ; 1];
transformed_vertex = trans_vertex/trans_vertex(4);

end

