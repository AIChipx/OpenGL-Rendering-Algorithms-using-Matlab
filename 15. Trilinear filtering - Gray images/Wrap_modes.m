function [ u_out, v_out ] = Wrap_modes ( u,v,GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T )
% Texture Wrap Modes
% "0" >> CLAMP_TO_EDGE
% "1" >> REPEAT

if(GL_TEXTURE_WRAP_S == 0)
    % CLAMP_TO_EDGE 
    if( u > 1) 
        u_out = 1;
    else
        u_out = u;
    end
else
    % REPEAT
    u_out = u - fix(u);
    if(u_out ==0 && u>0)
        u_out=1;
    end
end

if(GL_TEXTURE_WRAP_T == 0)
    % CLAMP_TO_EDGE case
    if( v > 1) 
        v_out = 1;
    else
        v_out = v;
    end
else
    % REPEAT
    v_out = v - fix(v);
    if(v_out ==0 && v>0)
        v_out=1;
    end
end

if(u < 0) 
    u_out = 0; end
if(v < 0) 
    v_out = 0; end
end

