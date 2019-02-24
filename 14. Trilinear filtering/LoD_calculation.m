function [ LoD ] = LoD_calculation(width_tx, height_tx, u, v, i, j, Grad_Buff)

% Calculate LoD using gradients
% x-direction is (u or i or width)
% y-direction is (v or j or height)

% width_tx, height_tx is the (width, height) of texture image

% reading size of Grad_Buff
s1 = size(Grad_Buff);
width_gb = s1(2);        % Grad_Buff width in (x or u) - direction
height_gb = s1(1);       % Grad_Buff height in (y or v) - direction

iplus = i + 1;
jplus = j + 1;
% check if x-direction of Grad_Buff is exceeded
if(iplus > width_gb)
    iplus = i - 1;
end
% check if y-direction of Grad_Buff is exceeded
if(jplus > height_gb)
    jplus = j - 1;
end

% computing partial derivatives
du_dx = abs((Grad_Buff( j, iplus, 1) - u) * width_tx);
du_dy = abs((Grad_Buff( jplus, i, 1) - u) * width_tx);

dv_dx = abs((Grad_Buff( j, iplus, 2) - v) * height_tx);
dv_dy = abs((Grad_Buff( jplus, i, 2) - v) * height_tx);

% computing scale factor "rho"
mu = max(du_dx, du_dy);
mv = max(dv_dx, dv_dy);
rho = max(mu, mv);

% computing level of detail parameter
LoD = log2(rho);

end

