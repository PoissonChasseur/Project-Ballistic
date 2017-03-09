%% parabole_surete
%Description:
%  En physique et en balistique, la parabole de s�ret� d�sgine la courbe
%  enveloppe de toutes les trajectoires paraboliques possible d'un corps
%  lanc� depuis un points donn�es avec une vitesse donn�es dans un plan
%  vertical d'azimut fix�.
%  Nul point en dehors de cette courbe ne peut �tre atteint par un
%  projectile ayant cette vitesse initial: la zone est "s�re", d'o� le nom
%  de la courbe.
%
%   Note concept de ellipse de s�ret� aussi utilis�e (notamment pour
%   hauteur_max)
%
%Utilit�:
%   1) Savoir s'il est physiquement possible d'atteindre la cible (1�re
%   approximation rapide � calculer et simple)
%   2) Pouvoir dire qu'il est impossible d'atteindre tel zone et donc,
%   aucun danger si on se trouve au-del� de la parabole de suret�.
%
%Source: 
%   - https://fr.wikipedia.org/wiki/Parabole_de_s%C3%BBret%C3%A9 (19 novembre 2016)
%   - https://fr.wikipedia.org/wiki/Ellipse_de_s%C3%BBret%C3%A9 (19 novembre 2016)
%
%Source pouvant �tre utile (peut-�tre):
%   - http://fred.elie.free.fr/balistique_exterieure.pdf (19 novembre 2016)
function  [z]= parabole_surete(axe_sol, vitesse_initial, hauteur_vs_sol, altitude, latitude)
    r = rayon_terre(latitude);
    hauteur_max = (vitesse_initial^2)/(2*gravity(altitude, latitude)) + hauteur_vs_sol;
    
    %Ellispe suret�: H max z' telle que 1/z' = 1/z - 1/R o� 
    %z = Vo^2/(2*g) = hauteur maximale de la parabole de suret�.
    hauteur_max = (hauteur_max*r)/(r+hauteur_max);
    z = hauteur_max - (axe_sol.^2)./(4*hauteur_max);
end