function [ frame_out, zbuffer_out ] = polygon_raster(vertex1, color1, vertex2, color2, vertex3, color3, vertex4, color4, framebuffer_in, Z_buffer)

% polygon rasterizer 
% Render individual polygons that make up the sphere
% my input is 4 vertices with its associated colors
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
        [frame_out, zbuffer_out] = tri_scan_conv_Z(vertex1, vertex3, vertex4, color1, color3, color4, framebuffer_in, Z_buffer);
    end
    if(op2 == 1)
        [frame_out, zbuffer_out] = tri_scan_conv_Z(vertex1, vertex2, vertex3, color1, color2, color3, framebuffer_in, Z_buffer);
    end
else
    % the full polygon drawing case
     [frame_out, zbuffer_out] = tri_scan_conv_Z(vertex1, vertex2, vertex3, color1, color2, color3, framebuffer_in, Z_buffer);
     [frame_out, zbuffer_out] = tri_scan_conv_Z(vertex2, vertex3, vertex4, color2, color3, color4, frame_out, zbuffer_out);
    
end
end

