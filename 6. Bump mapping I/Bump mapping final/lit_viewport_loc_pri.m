function [ vertex_color ] = lit_viewport_loc_pri( mat_amb_diff, light_ambient, light_diffuse, lightsource_dir, vertex_normal)

% Seperate lighting equation >> primary color
% here only ambient and diffuse light components are calculated

% >>>>>> Every thing should be normalized before calling this function <<<<<<
% >>>>>> You have to normalize vertex_normal, lightsource_dir, half_vector
% before calling this function

% This function computes the final vetex lighting color
% material diffuse and ambient reflectance are normally the same color
% here we deal with directional light source only
% viewer is assumed to be at local position

% VERY IMPORTANT NOTE
% before performing lighting equations the following vectors
%>> light source vector
%>> vertex normal vector


vertex_color = light_ambient.*mat_amb_diff + (light_diffuse.*mat_amb_diff)*(max(0,dot(vertex_normal,lightsource_dir)));
end

