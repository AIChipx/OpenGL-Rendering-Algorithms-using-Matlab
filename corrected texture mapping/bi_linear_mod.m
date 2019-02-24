function [ color ] = bi_linear_mod( u,v,image_1 )

% reading size of texture image
s = size(image_1);
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
c00 = image_1(tx00(1), tx00(2));
c10 = image_1(tx10(1), tx10(2));
c01 = image_1(tx01(1), tx01(2));
c11 = image_1(tx11(1), tx11(2));

% computing bilinearly interpolated color
u_dash = pu - fix(pu);
v_dash = pv - fix(pv);

% color = cal1*(1-b)*(1-a) + cal2*a*(1-b) + cal3*b*(1-a) + cal4*b*a;
color = (1 - u_dash)*(1 - v_dash)*c00 + u_dash*(1 - v_dash)*c10 + v_dash*(1 - u_dash)*c01 + u_dash*v_dash*c11;

end

