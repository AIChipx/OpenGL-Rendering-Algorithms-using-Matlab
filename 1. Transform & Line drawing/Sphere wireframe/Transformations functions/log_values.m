% test
jj = 0;
% Drawing the sphere vertical lines
for y=1:n-1
    for u=1:n
    jj = jj + 1;
    coord1_1(jj, :) = poly_list(u,:,y);
    coord2_1(jj, :) = poly_list(u,:,y+1);
    col1(jj, :) = color_list1(u,:,y);
    end
    
end

% Drawing the sphere horizontal lines
jj = 0;
for y=1:n-1
    for u=1:n-1
    %[ frame_buffer ] = Bresenham_line( poly_list(u,:,y),poly_list(u+1,:,y), color_list2(u,:,y), frame_buffer);
    jj = jj + 1;
    coord1_2(jj, :) = poly_list(u,:,y);
    coord2_2(jj, :) = poly_list(u+1,:,y);
    col2(jj, :) = color_list2(u,:,y);
    end
end