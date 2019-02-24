function [ color ] = GL_LINEAR ( u, v, texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T )
% Bilinear filtering unit
% enhanced to do smooth filtering on the edges based on wrap mode used
% Texture Wrap Modes
% "0" >> CLAMP_TO_EDGE
% "1" >> REPEAT
% Note 
% w, pu, t1, GL_TEXTURE_WRAP_S are parameters in x-direction .. [MATLAB Columns] 
% h, pv, t2, GL_TEXTURE_WRAP_T are parameters in y-direction .. [MATLAB Rows] 

% reading size of texture image
s = size(texture_image);
width = s(2);        % texture width in (x or u) - direction
height = s(1);        % texture height in (y or v) - direction

% MATLAB can't read image at (0, 0) or (0 with any combination)
% so we will use this simple mapping (trick ;)
% ////////////////////////////////////////////////////////////////////////
% transform (u, v) to texture image space
w = width - 1;
h = height - 1;

pu = (u*w);
pv = (v*h);

t1 = fix(pu) + 1;
t2 = fix(pv) + 1;
% ////////////////////////////////////////////////////////////////////////

% generating the 4 texture coordinates ...  That's the correct order
tx00 = [t2, t1];
tx10 = [t2, t1 + 1];
tx01 = [t2 + 1, t1];
tx11 = [t2 + 1, t1 + 1];

% packing texture coordinates into one array
tx = zeros(4, 2);

tx(1, :) = tx00;
tx(2, :) = tx10;
tx(3, :) = tx01;
tx(4, :) = tx11;

% if you reached the edge of the texture and still need neighbour texels to work on check wrap mode used 
% if using "CLAMP_TO_EDGE"
% >> x = x_max;
% >> y = y_max;

% if using "REPEAT"
% >> x = x - x_max;
% >> y = y - y_max;
for k=1:4
     % check if x-direction of texture resolution is exceeded
     if(tx(k, 2) > width)
        if(GL_TEXTURE_WRAP_S == 0)
            % CLAMP_TO_EDGE
            tx(k, 2) = width;
        else
            % REPEAT
            tx(k, 2) = tx(k, 2) - width;
        end
     end
     % check 2
     if(tx(k, 2) == 1)
        if(GL_TEXTURE_WRAP_S == 0)
            % CLAMP_TO_EDGE
            tx(k, 2) = width;
        else
            % REPEAT
            tx(k, 2) = width;
        end
     end
    
     % check if y-direction of texture resolution is exceeded
    if(tx(k, 1) > height)
        if(GL_TEXTURE_WRAP_T == 0)
            % CLAMP_TO_EDGE
            tx(k, 1) = height;
        else
            % REPEAT
            tx(k, 1) = tx(k, 1) - height;
        end
    end
    % check 2
    if(tx(k, 1) == 1)
        if(GL_TEXTURE_WRAP_T == 0)
            % CLAMP_TO_EDGE
            tx(k, 1) = height;
        else
            % REPEAT
            tx(k, 1) = height;
        end
    end
end

% unpacking texture coordinates from the array
tx00 = tx(1, :);
tx10 = tx(2, :);
tx01 = tx(3, :);
tx11 = tx(4, :);

% access texture image and get texel color values
c00 = texture_image(tx00(1), tx00(2));
c10 = texture_image(tx10(1), tx10(2));
c01 = texture_image(tx01(1), tx01(2));
c11 = texture_image(tx11(1), tx11(2));

% computing bilinearly interpolated color
u_dash = pu - fix(pu);
v_dash = pv - fix(pv);

color = (1 - u_dash)*(1 - v_dash)*c00 + u_dash*(1 - v_dash)*c10 + v_dash*(1 - u_dash)*c01 + u_dash*v_dash*c11;

end

