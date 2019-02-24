% resize images with transperancy

[im, map, alpha] =  imread('Ibn_al_Haytham.png');
temp1 = imresize(im, [128 128]);
temp2 = double(imresize(alpha, [128 128]))/255;
f = imshow(temp1);
set(f, 'AlphaData', temp2);
imwrite(f, 'a.png', 'png','transparency', temp2);
