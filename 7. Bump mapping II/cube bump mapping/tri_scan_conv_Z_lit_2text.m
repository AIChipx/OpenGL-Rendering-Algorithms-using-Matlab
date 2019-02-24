function [ frame_out,z_out ] = tri_scan_conv_Z_lit_2text( x1, y1, z1,viewport_pos, frame_in ,Z_buffer, material_prop ,light_prop ,L,p, textcoord_x, textcoord_y, textcoord_z ,normal_map)

% here we use seperate lighting equations
% one equation to calculate ambient and diffuse components 
% another one to calculate specular component

% Z- buffer is not enabled here
% colored scan conversion based on barycentric coordinates
% here we interpolate depth value as well as color values
% depth value will be read and interpolated

% viewport unit vector is computed per pixel
% here we don't need to interpolate normals because they are constant

% bilinear interpolation is also disabled to enhance performance
% nearest neighbor will generate good results (as No 
% magnification or minification is applied to the texture)


Frame_buffer = frame_in;

% extract material prop 
amb_diff_mat = material_prop(1,:);
specular_mat = material_prop(2,:);

%extract light prop
ambient_lit = light_prop(1,:);
diffuse_lit = light_prop(2,:);
specular_lit = light_prop(3,:);


x_z = x1;
y_z = y1;
z_z = z1;

x = round(x_z(1:2));
y = round(y_z(1:2));
z = round(z_z(1:2));

% defining bounding rectangle 
xx = [x(1) y(1) z(1)];
yy = [x(2) y(2) z(2)];
xx_min = min(xx);
xx_max = max(xx);
yy_min = min(yy);
yy_max = max(yy);

% Precomputed constants
e1 = y - x;
e2 = z - x;
ubeta = (dot(e2,e2)*e1 - dot(e1,e2)*e2)/(dot(e1,e1)*dot(e2,e2) - dot(e1,e2)^2);
ugamma = (dot(e1,e1)*e2 - dot(e1,e2)*e1)/(dot(e1,e1)*dot(e2,e2) - dot(e1,e2)^2);

for j=yy_min:yy_max
    for i=xx_min:xx_max
        % variable parameters
        f = [i j] - x';
        Beta = dot(ubeta,f);
        Gamma = dot(ugamma,f);
        Alpha = 1 - Beta - Gamma;
        
        if(Alpha>=0 && Beta>=0 && Gamma >=0)
            depth = Alpha*x_z(3) + Beta*y_z(3) + Gamma*z_z(3);
            if(depth < Z_buffer(j,i))
                % interpolating texture coordinates and getting normal value
                text_cord =fix( Alpha*textcoord_x + Beta *textcoord_y + Gamma*textcoord_z );
                normal_red= normal_map(text_cord(1),text_cord(2),1);
                normal_green= normal_map(text_cord(1),text_cord(2),2);
                normal_blue= normal_map(text_cord(1),text_cord(2),3);
                normal_value = [normal_red, normal_green, normal_blue];
                
                pixel_normal = normalize(normal_value);
%                 
%                 % reading texture image
%                 texel_red= bi_linear(text_cord(1),text_cord(2),texture_image(:,:,1));
%                 texel_green= bi_linear(text_cord(1),text_cord(2),texture_image(:,:,2));
%                 texel_blue= bi_linear(text_cord(1),text_cord(2),texture_image(:,:,3));
%                 texel_color = [texel_red, texel_green, texel_blue];
                
                % computing viewport unit vector
                e0 = viewport_pos - [i, j, depth];
                viewport_unitvector = normalize(e0); 
                
                % ambient and diffuse components 
                [ amb_diff_color ] = lit_viewport_loc_pri( amb_diff_mat, ambient_lit, diffuse_lit, L, pixel_normal);
                 
                % combining lighting ambient and diffuse components with
                % texel color using "Modulation"
%                 texel_amb_diff = amb_diff_color.*texel_color;
                
                % specular components
                [ specular_color ] = lit_viewport_loc_sec( p, specular_mat, specular_lit ,pixel_normal, viewport_unitvector, L);
                
                % combining lighting with texture in the correct order
                tempx = amb_diff_color + specular_color;
                
                Frame_buffer(j,i,1) = tempx(1);
                Frame_buffer(j,i,2) = tempx(2);
                Frame_buffer(j,i,3) = tempx(3);
                Z_buffer(j,i) = depth;
            end
                
            
        end
    end
end
frame_out = Frame_buffer;
z_out = Z_buffer;

end

