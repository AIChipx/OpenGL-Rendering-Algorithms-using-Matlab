function [ color ] = bi_linear_wrap( u,v, texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T )

% Texture Wrap Modes
% "0" >> CLAMP_TO_EDGE
% "1" >> REPEAT

if(GL_TEXTURE_WRAP_S == 0)
    % CLAMP_TO_EDGE 
    if( u > 1) 
        u = 1; end
else
    % REPEAT
    u = u - fix(u);
end

if(GL_TEXTURE_WRAP_T == 0)
    % CLAMP_TO_EDGE case
    if( v > 1) 
        v = 1; end
else
    % REPEAT
    v = v - fix(v);
end

% reading size of texture image
s = size(texture_image);
h = s(1) -2;
w = s(2) -2;

% transform (u, v) to texture image space
pu = (u*w);
pv = (v*h);

% generating the 4 texture coordinates
t1 = fix(pu) + 1;
t2 = fix(pv) + 1;

tx00 = [t2, t1];
tx10 = [t2, t1 + 1];
tx01 = [t2 + 1, t1];
tx11 = [t2 + 1, t1 + 1];

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

