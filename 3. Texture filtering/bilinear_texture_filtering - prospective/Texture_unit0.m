function [ color ] = Texture_unit0 ( u_in, v_in, texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, filter_mode )

% Filtering Modes
% "0" >> GL_NEAREST
% "1" >> GL_LINEAR

% Texture Wrap Modes
% "0" >> CLAMP_TO_EDGE
% "1" >> REPEAT

% wrap modes 
[ u, v ] = Wrap_modes (u_in, v_in, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);

% performing the desired filtering
if(filter_mode == 0)
    [ color ] = GL_NEAREST (u, v, texture_image);
else
    [ color ] = GL_LINEAR (u, v, texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
end

end

