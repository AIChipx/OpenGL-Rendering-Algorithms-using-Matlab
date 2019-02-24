clear
% Generating texture image
% size ... [actual size will be (2*ss)x(2*ss)]
ss = 16;
c0 = zeros(ss);
c1 = ones(ss);
% chess generation
% rea component 
ccr = [
       c0  c1;  
       c1  c0 ];
% green component
ccg = [
       c0  c1;  
       c1  c0 ];
% blue component   
ccb = [
       c0  c0;  
       c0  c0 ];

% combining them together into one matrix
ccx = cat(3, ccr, ccg, ccb);
 
% viewing results
figure(101)
imshow(ccx)
