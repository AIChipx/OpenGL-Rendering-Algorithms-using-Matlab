function [ frame_out,z_out, decision_out ] = tri_scan_conv_Z_text_pros_LoD( x1, y1, z1, h0, h1, h2, Frame_buffer, Z_buffer,aa,bb,cc,image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER, decision )

% the output "decision" will determine if the current filtering
% needed is minification or magnification 
% we will use it for debugging purposes only
% decision = 0 >> minification;
% decision = 1 >> magnification;

% the algorithm used here for prospective correct interpolation is
% descriped in page 255 "Fundamentals of computer graphics 3rd edition"

% Z- buffer is supported
% colored scan conversion based on barycentric coordinates
% here we interpolate depth value as well as texture coordinates 
% depth value will be read and interpolated
% perspective texture mapping

% We will create a gradient buffer here to hold interpolated texture coordinates
% this buffer will be used for gradient calculation 

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

% creating gradient buffer
Grad_Buff = zeros(yy_max, xx_max, 2);

% Precomputed constants
e1 = y - x;
e2 = z - x;
ubeta = (dot(e2,e2)*e1 - dot(e1,e2)*e2)/(dot(e1,e1)*dot(e2,e2) - dot(e1,e2)^2);
ugamma = (dot(e1,e1)*e2 - dot(e1,e2)*e1)/(dot(e1,e1)*dot(e2,e2) - dot(e1,e2)^2);

% performing the loop for the first time to fill the "Grad_Buff"
for j=yy_min:yy_max
    for i=xx_min:xx_max
        % variable parameters
        f = [i j] - x';
        Beta = dot(ubeta,f);
        Gamma = dot(ugamma,f);
        Alpha = 1 - Beta - Gamma;
        
        if(Alpha>=0 && Beta>=0 && Gamma >=0)
                
                % perspective correct interpolation
                d = h1*h2 + h2*Beta*(h0 - h1) + h1*Gamma*(h0 - h2);
                Bw = (h0*h2*Beta)/d;
                Gw = (h0*h1*Gamma)/d;
                Aw = 1 - Bw - Gw;

                text_cord = Aw*aa +Bw*bb + Gw*cc;
                % Updating the gradient buffer
                Grad_Buff(j, i, 1) = text_cord(1);      % u-coordinate
                Grad_Buff(j, i, 2) = text_cord(2);      % v-coordinate
        end
    end
end

% performing the loop for the second time to perform texture filtering
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
                
                counter_state = [i, j];
               % fetching texture color from Texture_unit0
                [red_val  , dec] = Texture_unit_LoD(image(:,:,1), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, Grad_Buff, counter_state, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER);
                [green_val,] = Texture_unit_LoD(image(:,:,2), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, Grad_Buff, counter_state, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER);
                [blue_val ,] = Texture_unit_LoD(image(:,:,3), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, Grad_Buff, counter_state, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER);
                
                % updating the frame buffer
                Frame_buffer(j,i,1) = red_val;
                Frame_buffer(j,i,2) = green_val;
                Frame_buffer(j,i,3) = blue_val;
                % updating the Z-buffer
                Z_buffer(j,i) = depth;
                
                % updating decision buffer
                decision(j,i) = dec;
                
            end
        end
    end
end
frame_out = Frame_buffer;
z_out = Z_buffer;

% >>> You can delete if you don't need it
decision_out = decision;

end
