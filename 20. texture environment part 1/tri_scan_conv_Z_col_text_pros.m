function [ frame_out,z_out ] = tri_scan_conv_Z_col_text_pros(base_format, text_function, x1, y1, z1, h0, h1, h2, frame_in, Z_buffer,cx, cy, cz, aa,bb,cc,image,alpha )

% the algorithm used here for prospective correct interpolation is
% descriped in page 255 "Fundamentals of computer graphics 3rd edition"

% Z- buffer is supported
% colored scan conversion based on barycentric coordinates
% here we interpolate depth value as well as texture coordinates 
% depth value will be read and interpolated
% prospective texture mapping

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
        
        if(Alpha>=0 && Beta>=0 && Gamma >=0)
            depth = Alpha*x_z(3) + Beta*y_z(3) + Gamma*z_z(3);
            if(depth < Z_buffer(j,i))
                
                % interpolation of reciprocal of depth values
                d = h1*h2 + h2*Beta*(h0 - h1) + h1*Gamma*(h0 - h2);
                Bw = (h0*h2*Beta)/d;
                Gw = (h0*h1*Gamma)/d;
                Aw = 1 - Bw - Gw;
                
                text_cord = Aw*aa +Bw*bb + Gw*cc;
                frag_color = Aw*cx + Bw*cy + Gw*cz;
                
                red_val   = Texture_Env_unit_RGB(frag_color(1), text_cord(1),text_cord(2),image(:,:,1), alpha,base_format, text_function);
                green_val = Texture_Env_unit_RGB(frag_color(2), text_cord(1),text_cord(2),image(:,:,2), alpha,base_format, text_function);
                blue_val  = Texture_Env_unit_RGB(frag_color(3), text_cord(1),text_cord(2),image(:,:,3), alpha,base_format, text_function);
%                 alpha_val  = Texture_Env_unit_alpha(frag_color, text_cord(1),text_cord(2),alpha, base_format, text_function);
                
                Frame_buffer(j,i,1) = red_val;
                Frame_buffer(j,i,2) = green_val;
                Frame_buffer(j,i,3) = blue_val;
%                 alpha_ch(j, i) = alpha_val;
                Z_buffer(j,i) = depth;
            end
        end
    end
end
frame_out = Frame_buffer;
z_out = Z_buffer;
% alpha_ch_out = alpha_ch;
end
