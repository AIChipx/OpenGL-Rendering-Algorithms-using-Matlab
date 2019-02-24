function [ frame_out, zbuffer_out ] = polygon_raster_lit_text(vertex1, normal1, vertex2, normal2, vertex3, normal3, vertex4, normal4, framebuffer_in, Z_buffer,texture_image,v1_textcoord, v2_textcoord, v3_textcoord, v4_textcoord, material_prop ,light_prop ,L,h,p  )

% polygon rasterizer with lighting and texture mapping
% Render individual polygons that make up the sphere
% my input is 4 vertices with their associated normals and texture coordinates
% my output is the polygon rasterized with depth buffer updated
% the case of sphere pole triangles is handled here

% some initializations
x1 = vertex1(1); 
y1 = vertex1(2);
z1 = vertex1(3);

x2 = vertex2(1);
y2 = vertex2(2);
z2 = vertex2(3);

x3 = vertex3(1);
y3 = vertex3(2);
z3 = vertex3(3);

x4 = vertex4(1);
y4 = vertex4(2);
z4 = vertex4(3);

% test for pole triangle case
op1 = (x1 == x2)&&(y1 == y2)&&(z1 == z2);
op2 = (x3 == x4)&&(y3 == y4)&&(z3 == z4);

% case of drawing only one triangle
if(op1 || op2)
    if(op1 == 1)
        [frame_out, zbuffer_out] = tri_scan_conv_Z_lit_text(vertex1, vertex3, vertex4, normal1, normal3, normal4, framebuffer_in, Z_buffer,v1_textcoord,v3_textcoord,v4_text_coord,texture_image,material_prop ,light_prop ,L,h,p );
    end
    if(op2 == 1)
        [frame_out, zbuffer_out] = tri_scan_conv_Z_lit_text(vertex1, vertex2, vertex3, normal1, normal2, normal3, framebuffer_in, Z_buffer,v1_textcoord,v2_textcoord,v3_text_coord,texture_image,material_prop ,light_prop ,L,h,p);
    end
else
    % the full polygon drawing case
     [frame_out, zbuffer_out] = tri_scan_conv_Z_lit_text(vertex1, vertex2, vertex3, normal1, normal2, normal3, framebuffer_in, Z_buffer,v1_textcoord,v2_textcoord,v3_textcoord,texture_image,material_prop ,light_prop ,L,h,p);
     [frame_out, zbuffer_out] = tri_scan_conv_Z_lit_text(vertex2, vertex3, vertex4, normal2, normal3, normal4, frame_out, zbuffer_out, v2_textcoord,v3_textcoord,v4_textcoord,texture_image,material_prop ,light_prop ,L,h,p);
    
end
end

