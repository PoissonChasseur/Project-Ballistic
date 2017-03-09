%% convert_spherique_to_cartesien:
%Description:
%   Fait le calcul pour convertir des coordonn�es sph�rique
%   au coordonn�es cart�sienne.
%
%Param�tres si par rapport position sur Terre:
%   - norme: d�signe distance par rapport centre Terre (Rayon Terre +
%   altitude)
%   - angle_xy: d�signe la longitude, mesur� depuis l'axe x, en radian.
%   G�n�ralement entre -pi et pi.
%   - angle_sol_z = la latitude, angle par rapport plan �quatorial, en radian,
%   g�n�ralement tnre -pi/2 et pi/2.
%
%Source: 
%   - https://fr.wikipedia.org/wiki/Coordonn%C3%A9es_sph%C3%A9riques (19 novembre 2016)
%
function [x, y, z] = convert_spherique_to_cartesien(norme, angle_xy, angle_sol_z)
    x = norme*cos(angle_sol_z)*cos(angle_xy);
    y = norme*cos(angle_sol_z)*sin(angle_xy);
    z = norme*sin(angle_sol_z);
end