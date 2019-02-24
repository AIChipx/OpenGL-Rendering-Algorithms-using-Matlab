function [ o ] = mipmap_gen_beta(image)
% this function generate mipmap levels using box filter
% we assume that image width and height are the same
% here we deal with color images

% initialization 
y = image;
s = length(y);
%o = zeros(round(s/2),round(s/2),3);


% Applying Box filter for red channel 
temp = 0;
x1 = 1; 
v1 = 1;
for z=1:s/2
    v2 = v1 + 1;

    for c=1:s/2
        x2 = x1 + 1;
        for i=x1:x2
            for j=v1:v2
                temp = y(i,j,1) + temp;
            end
        end
        o(c,z,1) = temp/4;
        temp = 0;
        x1 = x1 + 2;
    end
    x1 = 1;
    v1 = v1 +2;
end

% Applying Box filter for green channel 
temp = 0;
x1 = 1; 
v1 = 1;
for z=1:s/2
    v2 = v1 + 1;

    for c=1:s/2
        x2 = x1 + 1;
        for i=x1:x2
            for j=v1:v2
                temp = y(i,j,2) + temp;
            end
        end
        o(c,z,2) = temp/4;
        temp = 0;
        x1 = x1 + 2;
    end
    x1 = 1;
    v1 = v1 +2;
end

% Applying Box filter for blue channel 
temp = 0;
x1 = 1; 
v1 = 1;
for z=1:s/2
    v2 = v1 + 1;

    for c=1:s/2
        x2 = x1 + 1;
        for i=x1:x2
            for j=v1:v2
                temp = y(i,j,3) + temp;
            end
        end
        o(c,z,3) = temp/4;
        temp = 0;
        x1 = x1 + 2;
    end
    x1 = 1;
    v1 = v1 +2;
end

end

