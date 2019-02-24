% this script convert any 320x240 image into memory initialization file
% in normal text format (binary format)
% we use 24-bit resolution (8r, 8g, 8b)
% so output is given in 3 files (red, green, blue)

% Tested OK

clear; 
% read source image
aa = double(imread('320x240.png'));

% reading image size
s = size(aa);
rr = s(1); %rows
cc = s(2); %columns
ts = rr*cc; %total size

% some initializations
red_vec = zeros(ts, 1);
green_vec = zeros(ts, 1);
blue_vec = zeros(ts, 1);

% generating red channel
cnt=1;
for i=1:rr
    for j=1:cc
        red_vec(cnt) = aa(i,j,1);
        cnt = cnt + 1;
    end
end

% generating green channel
cnt=1;
for i=1:rr
    for j=1:cc
        green_vec(cnt) = aa(i,j,2);
        cnt = cnt + 1;
    end
end

% generating blue channel
cnt=1;
for i=1:rr
    for j=1:cc
        blue_vec(cnt) = aa(i,j,3);
        cnt = cnt + 1;
    end
end

% logging into a text file
% searche help for "fprintf" for more details

% logging red channel
fileID = fopen('red_chanx.txt','w');
for k=1:ts-1
    fprintf(fileID,'%8s\r\n',dec2bin(red_vec(k), 8));
end
fprintf(fileID,'%8s',dec2bin(red_vec(ts), 8));
fclose(fileID);

% logging green channel
fileID = fopen('green_chanx.txt','w');
for k=1:ts-1
    fprintf(fileID,'%8s\r\n',dec2bin(green_vec(k), 8));
end
fprintf(fileID,'%8s',dec2bin(green_vec(ts), 8));
fclose(fileID);

% logging blue channel
fileID = fopen('blue_chanx.txt','w');
for k=1:ts-1
    fprintf(fileID,'%8s\r\n',dec2bin(blue_vec(k), 8));
end
fprintf(fileID,'%8s',dec2bin(blue_vec(ts), 8));
fclose(fileID);