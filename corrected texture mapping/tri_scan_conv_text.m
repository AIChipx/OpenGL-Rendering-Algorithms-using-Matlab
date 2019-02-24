function [ frame_out ] = tri_scan_conv_text( x1, y1, z1,frame_in ,aa,bb,cc,image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T )
% Z- buffer is supported
% colored scan conversion based on barycentric coordinates
% here we interpolate depth value as well as texture coordinates 
% depth value will be read and interpolated

Frame_buffer = frame_in;

x_z = x1;
y_z = y1;
z_z = z1;

x = fix(x_z(1:2));
y = fix(y_z(1:2));
z = fix(z_z(1:2));

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
        text_cord = Alpha*aa + Beta *bb + Gamma*cc ;
        
        if(Alpha>=0 && Beta>=0 && Gamma >=0)
%             depth = Alpha*x_z(3) + Beta*y_z(3) + Gamma*z_z(3);
%             if(depth < Z_buffer(j,i))
                
                red_val   = bi_linear_wrap(text_cord(1),text_cord(2),image(:,:,1), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
                green_val = bi_linear_wrap(text_cord(1),text_cord(2),image(:,:,2), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
                blue_val  = bi_linear_wrap(text_cord(1),text_cord(2),image(:,:,3), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
               
                Frame_buffer(j,i,1) = red_val;
                Frame_buffer(j,i,2) = green_val;
                Frame_buffer(j,i,3) = blue_val;
%                 Z_buffer(j,i) = depth;
%             end
        end
    end
end
frame_out = Frame_buffer;
% z_out = Z_buffer;
end






