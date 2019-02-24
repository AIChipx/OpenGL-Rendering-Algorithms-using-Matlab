function [ texture_image ] = Texture_gen( size, option )
% option 0 >> small chess
% option 1 >> big chess

% generating a texture of chess board
c0 = zeros(size);
c1 = ones(size);
% chess generation

% small chess
if(option == 0)
    % rea component 
    ccr = [
           c0  c0;  
           c0  c0 ];
    % green component
    ccg = [
           c0  c1;  
           c1  c0 ];
    % blue component   
    ccb = [
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
% green component
ccg = [c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0];
% blue component   
ccb = [c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0;
       c0  c1  c0  c1  c0  c1  c0  c1;
       c1  c0  c1  c0  c1  c0  c1  c0];
end

% combining them together into one matrix
texture_image = cat(3, ccr, ccg, ccb);
end

