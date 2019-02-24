function [ value ] = bi_linear_alpha( x1,y1, alpha )
% you will need to update this with every image you use
%


% a bilinear function
m1 = fix(x1);
n1 = fix(y1);
if (m1 == 0)
    m1 = 1;
end

if (n1 ==0)
    n1 = 1;
end 

cal1 = alpha(n1,m1);
cal2 = alpha(n1,m1+1);
cal3 = alpha(n1+1,m1);
cal4 = alpha(n1+1,m1+1);

a = x1 - m1 ;
b = y1 - n1 ;
value = cal1*(1-b)*(1-a) + cal2*a*(1-b) + cal3*b*(1-a) + cal4*b*a;

end

