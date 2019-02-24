function [ value ] = bi_linear( x1,y1,image )
% a bilinear function
m1 = fix(x1);
n1 = fix(y1);
if (m1 == 0)
    m1 = 1;
end

if (n1 ==0)
    n1 = 1;
end 

cal1 = image(n1,m1);
cal2 = image(n1,m1+1);
cal3 = image(n1+1,m1);
cal4 = image(n1+1,m1+1);

a = x1 - m1 ;
b = y1 - n1 ;
value = cal1*(1-b)*(1-a) + cal2*a*(1-b) + cal3*b*(1-a) + cal4*b*a;

end

