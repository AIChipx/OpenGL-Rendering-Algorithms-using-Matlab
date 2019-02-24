% full Mipmap generation unit
% here we read source imge >> convert it to double
% perform box filtering and generating Mipmap levels until 1x1 image
% here we use "mipmap_gen_beta" function

% reading source image
% Mip_level_0 = double(imread('test_img.png'));

% determine number of levels to generate
s123 = length(Mip_level_0);
no_level = log2(s123);
fprintf(' Number of generated Mipmap levels: %s\n', num2str(no_level))

% initialization
tmpo = Mip_level_0;
str = 'Mip_level_';

% generating Mipmap levels
for iii=1:no_level
   [tmpo] = mipmap_gen_beta(tmpo);
   
   % generating variable name
   Name = strcat(str, num2str(iii));
   Name = genvarname(Name, who);
   eval([Name ' = tmpo;']);
end
