function [ final_col ] = Texture_Env_unit_RGB(frag_color,x1,y1,image,alpha,base_format,text_function)

% texel color value
texel_col = bi_linear(x1,y1,image);



switch base_format
    case 0
        % Alpha
        switch text_function
            case 0      %replace
                final_col = frag_color;
            case 1      %modulate
                final_col = frag_color;
            case 2      %decal
                final_col = frag_color;
            case 3      %add
                final_col = frag_color;
        end
    case 1
        % LUMINANCE
        switch text_function
            case 0      %replace
                final_col = texel_col;
            case 1      %modulate
                final_col = texel_col*frag_color;
            case 2      %decal
                final_col = frag_color;
            case 3      %add
               final_col = texel_col+frag_color; 
        end
    case 2
        % LUMINANCE_ALPHA
        switch text_function
            case 0      %replace
                final_col = texel_col;
            case 1      %modulate
                final_col = texel_col*frag_color;
            case 2      %decal
                final_col = frag_color;
            case 3      %add
                final_col = texel_col+frag_color; 
        end
    case 3 
        % RGB
        switch text_function
            case 0      %replace
                final_col = texel_col;
            case 1      %modulate
                final_col = texel_col*frag_color;
            case 2      %decal
                final_col = texel_col;
            case 3      %add
                final_col = texel_col+frag_color;
        end
    case 4
        % RGBA
        switch text_function
            case 0      %replace
                final_col = texel_col;
            case 1      %modulate
                final_col = texel_col*frag_color;
            case 2      %decal
                % alpha value
                alpha_val = bi_linear(x1,y1,alpha);
                final_col = frag_color*(1-alpha_val) + texel_col*alpha_val;
            case 3      %add
                final_col = texel_col+frag_color;
        end
end


end

