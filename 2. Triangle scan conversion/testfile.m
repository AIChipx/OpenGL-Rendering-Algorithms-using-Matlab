% test file 

% screen dimentions (x and y) used  
x_screen = 480;
y_screen = 640;

% Frame buffer
Frame_buffer = zeros(x_screen,y_screen,3);

x_z = [1, 1];
y_z = [400, 1];
z_z = [600, 400];

cx = [1 0 0];
cy = [1 1 0];
cz = [1 1 1];

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
        f = [i j] - x(1:2);
        Beta = dot(ubeta,f);
        Gamma = dot(ugamma,f);
        Alpha = 1 - Beta - Gamma;
        
        if(Alpha>=0 && Beta>=0 && Gamma >=0)
            
            
                tempc = (Alpha * cx) + (Beta * cy) + (Gamma * cz);
                Frame_buffer(j,i,1) = tempc(1);
                Frame_buffer(j,i,2) = tempc(2);
                Frame_buffer(j,i,3) = tempc(3);
               
        end
    end
end

% viewing results
figure(979)
% vertical flip of framebuffer
imshow(Frame_buffer)
