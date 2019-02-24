function [ color, decision ] = Texture_unit_LoD_MIP_Tri (texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, Grad_Buff, counter_state,GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER , k )
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

% detemine whether to use minification or magnification filter 
% and using the suitable filter for the current pixel
if(LoD <= 0.5)
    % magnification case
    decision = 1;
    if(GL_TEXTURE_MAG_FILTER == 0)
        % perform nearest neighbor filtering
        [ color ] = GL_NEAREST (u, v, texture_image);
    else
        % perform bilinear interpolation
        [ color ] = GL_LINEAR (u, v, texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T , u_in, v_in , k);
    end
else
    % minification case
    decision = 0;
    
    switch GL_TEXTURE_MIN_FILTER
        case 0
           % GL_NEAREST
           [ color ] = GL_NEAREST (u, v, texture_image);
           
        case 1
           % GL_LINEAR
           [ color ] = GL_LINEAR (u, v, texture_image, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T , u_in, v_in , k);
           
        case 2
            % GL_NEAREST_MIPMAP_NEAREST
            % in OpenGL ES 1.1 specs q = no_level
            load MIPMAPS;
            if((LoD > 0.5) && (LoD <=(no_level + 0.5)))
                d = round(LoD + 0.5) - 1;
                [ color ] = GL_NEAREST (u, v, eval(MIPMAPS_Name_conv(d)));
            end
            if(LoD > (no_level + 0.5))
                d = no_level;
                [ color ] = GL_NEAREST (u, v, eval(MIPMAPS_Name_conv(d)));
            end
            
        case 3
            % GL_LINEAR_MIPMAP_NEAREST
            % in OpenGL ES 1.1 specs q = no_level
            load MIPMAPS;
            if((LoD > 0.5) && (LoD <=(no_level + 0.5)))
                d = round(LoD + 0.5) - 1;
                [ color ] = GL_LINEAR (u, v, eval(MIPMAPS_Name_conv(d)), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
            end
            if(LoD > (no_level + 0.5))
                d = no_level;
                [ color ] = GL_LINEAR (u, v, eval(MIPMAPS_Name_conv(d)), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
            end
            
        case 4
            % GL_NEAREST_MIPMAP_LINEAR
            % in OpenGL ES 1.1 specs q = no_level
            load MIPMAPS;
            % Access the first MIPMAP
            if(LoD >= no_level)
                d1 = no_level;
            else
                d1 = fix(LoD);
            end
            % Fetch texel color from the first MIPMAP
            [ color1 ] = GL_NEAREST (u, v, eval(MIPMAPS_Name_conv(d1)));
            
            % Access the second MIPMAP
            if(LoD >= no_level)
                d2 = no_level;
            else
                d2 = d1 + 1;
            end
            % Fetch texel color from the second MIPMAP
            [ color2 ] = GL_NEAREST (u, v, eval(MIPMAPS_Name_conv(d2)));
            
            % performing linear interpolation between the two colors
            % fractional part of LoD
            frac_LoD = LoD - fix(LoD);
            color = (1 - frac_LoD)*color1 + frac_LoD*color2;
            
        case 5
            % GL_LINEAR_MIPMAP_LINEAR
            % in OpenGL ES 1.1 specs q = no_level
            load MIPMAPS;
            % Access the first MIPMAP
            if(LoD >= no_level)
                d1 = no_level;
            else
                d1 = fix(LoD);
            end
            % Fetch texel color from the first MIPMAP
            [ color1 ] = GL_LINEAR (u, v, eval(MIPMAPS_Name_conv(d1)), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
            
            % Access the second MIPMAP
            if(LoD >= no_level)
                d2 = no_level;
            else
                d2 = d1 + 1;
            end
            % Fetch texel color from the second MIPMAP
            [ color2 ] = GL_LINEAR (u, v, eval(MIPMAPS_Name_conv(d2)), GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T);
            
            % performing linear interpolation between the two colors
            % fractional part of LoD
            frac_LoD = LoD - fix(LoD);
            color = (1 - frac_LoD)*color1 + frac_LoD*color2;
            
        otherwise
            error('Incorrect selection for MIN_FILTER');     
    end
      
end
end

