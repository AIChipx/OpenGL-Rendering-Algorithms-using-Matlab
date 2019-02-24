% Monitor ubeta and ugamma values
% Answer this question
% Does sign divider is required ??

s = size(vertex_list);


    x_z = vertex_list(1,:);
    y_z = vertex_list(2,:);
    z_z = vertex_list(3,:);
    x = fix(x_z);
    y = fix(y_z);
    z = fix(z_z);
    e1 = y - x;
    e2 = z - x;
    ubeta = (dot(e2,e2)*e1 - dot(e1,e2)*e2)/(dot(e1,e1)*dot(e2,e2) - dot(e1,e2)^2);
    ugamma = (dot(e1,e1)*e2 - dot(e1,e2)*e1)/(dot(e1,e1)*dot(e2,e2) - dot(e1,e2)^2);
