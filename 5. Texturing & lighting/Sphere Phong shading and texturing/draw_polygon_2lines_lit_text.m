function [ frame_buffer, z_buffer ] = draw_polygon_2lines_lit_text(poly_list1, normal_list1, poly_list2, normal_list2, frame_in, z_in,textcoord_list1,textcoord_list2,texture_image,material_prop ,light_prop ,L,h,p)
% This function takes as input two vertex list with their associated normals
% gives as output the rasterized polygons
% n is the number of polygons to be rendered 
% n is computed from the size of incoming poly_list

% drawing the polygons
% Fully automated 
cnt = size(poly_list1);
n = cnt(1);
    [ frame_buffer, z_buffer ] = polygon_raster_lit_text(poly_list1(1,:), normal_list1(1,:), poly_list2(1,:), normal_list2(1,:), poly_list1(2,:), normal_list1(2,:), poly_list2(2,:), normal_list2(2,:), frame_in, z_in,texture_image,textcoord_list1(1,:),textcoord_list2(1,:),textcoord_list1(2,:),textcoord_list2(2,:),material_prop ,light_prop ,L,h,p );
for i=2:n-1
    [ frame_buffer, z_buffer ] = polygon_raster_lit_text(poly_list1(i,:), normal_list1(i,:), poly_list2(i,:), normal_list2(i,:), poly_list1(i+1,:), normal_list1(i+1,:), poly_list2(i+1,:), normal_list2(i+1,:), frame_buffer, z_buffer,texture_image,textcoord_list1(i,:),textcoord_list2(i,:),textcoord_list1(i+1,:),textcoord_list2(i+1,:),material_prop ,light_prop ,L,h,p);
end
end

