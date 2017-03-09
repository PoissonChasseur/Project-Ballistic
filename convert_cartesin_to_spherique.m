%% convert_cartesin_to_spherique
%Description:
%   Permet de passer de coordonnées cartésienne en coordonnées sphérique.
%
%Source:
%   - https://fr.wikipedia.org/wiki/Coordonn%C3%A9es_sph%C3%A9riques (19 novembre 2016)
function [norme, angle_xy, angle_sol_z] = convert_cartesin_to_spherique(x, y, z)
    norme = sqrt(x.^2 + y.^2 + z.^2);
    angle_sol_z = acos(z./norme);
    angle_xy = atan(y/x);
end