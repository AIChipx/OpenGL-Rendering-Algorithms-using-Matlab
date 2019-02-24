function [ color, decision ] = Texture_unit_LoD (texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, Grad_Buff, counter_state,GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER )
% LoD calculation is supported

% GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER
% "0" >> GL_NEAREST
% "1" >> GL_LINEAR

% Texture Wrap Modes
% "0" >> CLAMP_TO_EDGE
% "1" >> REPEAT

% the output "decision" will determine if the current filtering
% needed is minification or magnification 
% we will use it for debugging purposes only
% decision = 0 >> minification;
% decision = 1 >> magnification;

% reading size of texture image
s = size(texture_image);
width_tx = s(2);        % texture width in (x or u) - direction
height_tx = s(1);       % texture height in (y or v) - direction

% Extracting u, v coordinates
% counter_state = [i, j];
i = counter_state(1);
j = counter_state(2);
u_in = Grad_Buff(j, i, 1);
v_in = Grad_Buff(j, i, 2);

% determine wrap modes 
[ u, v ] = Wrap_modes (u_in, v_in, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);

% computing LoD value
[ LoD ] = LoD_calculation(width_tx, height_tx, u_in, v_in, i, j, Grad_Buff);

% detemine wheter to use minification or magnification filter 
% and using the suitable filter for the current pixel
if(LoD <= 0.0)
    % magnification case
    decision = 1;
    if(GL_TEXTURE_MAG_FILTER == 0)
        % perform nearest neighbor filtering
        [ color ] = GL_NEAREST (u, v, texture_image);
    else
        % perform bilinear interpolation
        [ color ] = GL_LINEAR (u, v, texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
    end
else
    % minification case
    decision = 0;
    if(GL_TEXTURE_MIN_FILTER == 0)
        % perform nearest neighbor filtering
        [ color ] = GL_NEAREST (u, v, texture_image);
    else
        % perform bilinear interpolation
        [ color ] = GL_LINEAR (u, v, texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
    end
end
end

