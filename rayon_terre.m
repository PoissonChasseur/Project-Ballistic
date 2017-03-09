%% rayon_terre
%Description:
%   Donne le Rayon de la terre pour une latitude précise
%   en mètre. Équation prise de Wikipédia Anglais.
%
%Source:
%   - https://en.wikipedia.org/wiki/Earth_radius (19 novembre 2016)
%
function [rayon] = rayon_terre(latitude)
    equatorial_radius = 6378.1370*10^3;
    polar_radius = 6356.7523*10^3;
    rayon = (equatorial_radius^2*cos(latitude))^2+(polar_radius^2*sin(latitude))^2;
    rayon = rayon/( (equatorial_radius*cos(latitude))^2+(polar_radius*sin(latitude))^2);
    rayon = sqrt(rayon);
end