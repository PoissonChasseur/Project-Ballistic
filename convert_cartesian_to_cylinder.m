%% convert_cartesian_to_cylinder
%Description:
%   Permet de transf�rer du format de coorodnn�es cart�sienne au
%   coordonn�es cylindrique.
%Source: 
%   - https://fr.wikipedia.org/wiki/Coordonn%C3%A9es_cylindriques (consult�
%   le 20 novembre 2016)
function [r, angle_sol, z_cyl] = convert_cartesian_to_cylinder(x, y, z)
    r = sqrt(x^2+y^2);
    angle_sol = atan(y/x);
    z_cyl = z;
end