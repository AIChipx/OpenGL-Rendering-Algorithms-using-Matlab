clc
clear all

u = -3
u_out = u - fix(u)
if(u_out ==0 && u>0)
    u_out=1
end