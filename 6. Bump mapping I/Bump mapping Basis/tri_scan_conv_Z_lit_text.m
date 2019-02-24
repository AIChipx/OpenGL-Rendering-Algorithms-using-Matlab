function [ frame_out ] = tri_scan_conv_Z_lit_text( x1, y1, z1, normal,viewport_pos, frame_in , material_prop ,light_prop ,L,p, textcoord_x, textcoord_y, textcoord_z, texture_image)

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

pixel_normal = normal;
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
            
                % interpolating texture coordinates and getting texel color
                text_cord =fix( Alpha*textcoord_x + Beta *textcoord_y + Gamma*textcoord_z );
                texel_red= texture_image(text_cord(1),text_cord(2),1);
                texel_green= texture_image(text_cord(1),text_cord(2),2);
                texel_blue= texture_image(text_cord(1),text_cord(2),3);
                texel_color = [texel_red, texel_green, texel_blue];
                
                % computing viewport unit vector
                e0 = viewport_pos - [i, j, 1];
                viewport_unitvector = normalize(e0); 
                
                % ambient and diffuse components 
                [ amb_diff_color ] = lit_viewport_loc_pri( amb_diff_mat, ambient_lit, diffuse_lit, L, pixel_normal);
                 
                % combining lighting ambient and diffuse components with
                % texel color using "Modulation"
                texel_amb_diff = amb_diff_color.*texel_color;
                
                % specular components
                [ specular_color ] = lit_viewport_loc_sec( p, specular_mat, specular_lit ,pixel_normal, viewport_unitvector, L);
                
                % combining lighting with texture in the correct order
                tempx = texel_amb_diff + specular_color;
                
                Frame_buffer(j,i,1) = tempx(1);
                Frame_buffer(j,i,2) = tempx(2);
                Frame_buffer(j,i,3) = tempx(3);
                
            
        end
    end
end
frame_out = Frame_buffer;
end

