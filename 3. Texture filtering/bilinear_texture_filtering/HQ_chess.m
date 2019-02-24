% HQ chess generation

cc1 = 255*ones(8);
cc2 = zeros(8);

% chess generation
ccx = [cc1  cc2  cc1  cc2  cc1  cc2  cc1  cc2;
       cc2  cc1  cc2  cc1  cc2  cc1  cc2  cc1;
       cc1  cc2  cc1  cc2  cc1  cc2  cc1  cc2;
       cc2  cc1  cc2  cc1  cc2  cc1  cc2  cc1;
       cc1  cc2  cc1  cc2  cc1  cc2  cc1  cc2;
       cc2  cc1  cc2  cc1  cc2  cc1  cc2  cc1;
       cc1  cc2  cc1  cc2  cc1  cc2  cc1  cc2;
       cc2  cc1  cc2  cc1  cc2  cc1  cc2  cc1];
   
figure(188787)
imshow(ccx)

f = getframe(gcf);
imwrite(f.cdata,'framebuff_xc.png');   