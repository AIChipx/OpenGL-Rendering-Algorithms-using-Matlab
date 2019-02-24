function [ texture_image ] = Texture_gen_gray( size, option )
% option 0 >> small chess
% option 1 >> big chess

% generating a texture of chess board
c1 = zeros(size);
c0 = ones(size);
% chess generation

% small chess
if(option == 0)
    % rea component 
    ccr = [
           c0  c1;  
           c1  c0 ];
else
    % big chess
    % rea component 
ccr =  [c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0];
end
% combining them together into one matrix
texture_image = ccr;
end

