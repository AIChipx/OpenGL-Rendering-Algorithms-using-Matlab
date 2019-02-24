function [ value ] = bi_linear( x1,y1,image )
% a bilinear function
s = size(image);
h = s(1) -1;
w = s(2) -1;

m11 = (x1*w);
n11 = (y1*h);

if (m11 == 0)
    m11 = 1;
end

if (n11 ==0)
    n11 = 1;
end

m1 = fix(m11);
n1 = fix(n11);

cal1 = image(n1,m1);
cal2 = image(n1,(m1+1));
cal3 = image((n1+1),m1);
cal4 = image((n1+1),(m1+1));

a = m11 - m1 ;
b = n11 - n1 ;
value = cal1*(1-b)*(1-a) + cal2*a*(1-b) + cal3*b*(1-a) + cal4*b*a;
end

