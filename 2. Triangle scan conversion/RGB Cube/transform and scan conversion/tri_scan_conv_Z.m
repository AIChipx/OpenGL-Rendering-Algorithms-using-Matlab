function [ frame_out,z_out ] = tri_scan_conv_Z( x1, y1, z1, cx, cy, cz, frame_in, Z_buffer )
% Z- buffer is supported
% colored scan conversion based on barycentric coordinates
% here we interpolate depth value as well as color values
% depth value will be read and interpolated

Frame_buffer = frame_in;

% this variable will hold temporary color value
tempc = [0 0 0];

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
        f = [i j] - x(1:2)';
        Beta = dot(ubeta,f);
        Gamma = dot(ugamma,f);
        Alpha = 1 - Beta - Gamma;
        
        if(Alpha>=0 && Beta>=0 && Gamma >=0)
            depth = Alpha*x_z(3) + Beta*y_z(3) + Gamma*z_z(3);
            if(depth < Z_buffer(j,i))
                tempc = (Alpha * cx) + (Beta * cy) + (Gamma * cz);
                Frame_buffer(j,i,1) = tempc(1);
                Frame_buffer(j,i,2) = tempc(2);
                Frame_buffer(j,i,3) = tempc(3);
                Z_buffer(j,i) = depth;
            end
        end
    end
end
frame_out = Frame_buffer;
z_out = Z_buffer;
end

