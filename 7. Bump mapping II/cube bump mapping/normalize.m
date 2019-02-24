function [ normal ] = normalize( p1 )

% Normalize the input vector
x = p1(1);
y = p1(2);
z = p1(3);

magnitude = ( (x^2) + (y^2) + (z^2) ) ^0.5;
x1 = x / magnitude ;
y1 = y / magnitude ;
z1 = z / magnitude ;

normal = [x1 , y1 ,z1 ];

end

