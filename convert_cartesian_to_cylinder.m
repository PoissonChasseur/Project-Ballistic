%% convert_cartesian_to_cylinder
%Description:
%   Permet de transférer du format de coorodnnées cartésienne au
%   coordonnées cylindrique.
%Source: 
%   - https://fr.wikipedia.org/wiki/Coordonn%C3%A9es_cylindriques (consulté
%   le 20 novembre 2016)
function [r, angle_sol, z_cyl] = convert_cartesian_to_cylinder(x, y, z)
    r = sqrt(x^2+y^2);
    angle_sol = atan(y/x);
    z_cyl = z;
end