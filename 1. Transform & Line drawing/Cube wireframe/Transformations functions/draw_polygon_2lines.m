function [ frame_buffer, z_buffer ] = draw_polygon_2lines(poly_list1, color_list1, poly_list2, color_list2, frame_in, z_in  )
% This function takes as input two vertex list with their associated colors
% gives as output the rasterized polygons
% n is the number of polygons to be rendered 
% n is computed from the size of incoming poly_list

% drawing the polygons
% Fully automated 
cnt = size(poly_list1);
n = cnt(1);
    [ frame_buffer, z_buffer ] = polygon_raster(poly_list1(1,:), color_list1(1,:), poly_list2(1,:), color_list2(1,:), poly_list1(2,:), color_list1(2,:), poly_list2(2,:), color_list2(2,:), frame_in, z_in);
for i=2:n-1
    [ frame_buffer, z_buffer ] = polygon_raster(poly_list1(i,:), color_list1(i,:), poly_list2(i,:), color_list2(i,:), poly_list1(i+1,:), color_list1(i+1,:), poly_list2(i+1,:), color_list2(i+1,:), frame_buffer, z_buffer);
end
end

