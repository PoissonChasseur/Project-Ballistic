%% La force de l'effet Magnus
%Description:
%   La force engendré par l'effet Magnus est une force dû à la rotation du
%   projectile sur lui-même dans un fluide.
%   
%   La rotation du projectile autour de lui-même à pour effet de causer une
%   pression inférieur sur le côté où l'air va dans le même sens que la
%   rotation du projectile et une pression plus haute de l'autre côté où la
%   rotation du projectile créer une résistance (dû à la vitesse dans le
%   sens inverse à l'air).
%
%   Ceci à pour effet de faire diriger le projectile vers le côté où la
%   pression est le plus faible, soit le côté où sa vitesse de rotation et
%   la vitesse de l'air sont dans le même sens. Un effet de portance se
%   créer, ce qui à des impacts non-négligeable notamment dans certains
%   sports (comme le soccer) et certains mode de propulsion.
%   
%   L'effet Magnus est principalement présenté par rapport à des vues de
%   coupe circulaire, mais théoriquement, on peut le faire avec n'importe
%   quel forme de coupe.
%
%Forces en présences dans calcul effet Magnus:
%   Deux forces importantes sont à prendre en compte:
%       1) La force de Magnus: La portance du coté où la vitesse de l'air
%       et celle de rotation sont dans la même direction.
%   
%       2) La force de frotemment de l'air: La résistance à l'écoulement de
%       l'air dû à la rotation dans le sens inverse à l'air qui une plus
%       grande pression de l'autre côté.
%   
%   Selon la source 1 "mathématique", les équations des forces sont
%   pareilles à celle de portance et résistance de l'air, mais la surface
%   et le coefficient "C" (comme C_x ou C_y) change.
%
%Paramètres:
%   - mv_air:   masse volumique de l'air
%   
%   - S: [S_x, _Sy, S_z] L'aire des surfaces selon chaque axes
%   
%   - v: [v_x, v_y, v_z] La vitesse de déplacement du projectile selon
%   chaque axe.
%   
%   - axe_spin: [axe_spin_x, axe_spin_y, axe_spin_z]: Vecteur unitaire de
%   l'axe de rotation du projectile (dirigé dans le sens vers lequel la
%   balle tourne [je pense]) Note: Peut être seulement 1 ou 2 axes (donc
%   les autres mient à 0).
%   
%   - 
%
%
%Sources amenant à d'autres sources:
%   - https://fr.wikipedia.org/wiki/Effet_Magnus (consutlé le 18 janvier
%   2017)
%   - https://fr.wikipedia.org/wiki/Th%C3%A9or%C3%A8me_de_Kutta-Jukowski
%   (consulté le 18 janvier 2017)
%   -
%   https://fr.wikipedia.org/wiki/Effet_Magnus_et_turbulence_dans_le_football
%   (consulté le 18 janvier 2017)
%
%Sources très intéressantes, mais pas équations:
%   - http://www.dtic.mil/ndia/2006smallarms/weinacht.pdf (consulté le 18
%   janvier 2017)
%
%   - 
%
%Sources utilisé pour équation mathématiques:
%   Note: Actuellement, les 2 sources n'ont pas les mêmes résultats.
%   1) = trouvé sur Google via "Effet Magnus equations" + 0 source
%   2) = trouvé via source de Wikipédia + source en fin de doc.
%
%   -1) +/- parfait, car donnée manquante (déterminer les coefficients) 
%   et aucune sources = 0 preuves de ces affirmations:
%   http://gilbert.gastebois.pagesperso-orange.fr/java/magnus/mvt_magnus.pdf
%   (consulté le 18 janvier 2017)
%   
%   -2) Source de Wikipédia et peut obtenir des résultats pour les
%   coefficients sans méthode expérimentale (ou pas 100% expérimentale)
%   http://people.stfx.ca/smackenz/Courses/HK474/Labs/Jump%20Float%20Lab/Bray%202002%20Modelling%20the%20flight%20of%20a%20soccer%20ball%20in%20a%20direct%20free%20kick.pdf 
%   (consulté le 18 janvier 2017)
%
%   3) À les mêmes équations que source 2, ce qui semble concorder avec des
%   équations valide et généralisé (semble bien expliqué et à des sources)
%   http://spiff.rit.edu/richmond/baseball/traj_may2011/traj.html (consulté
%   le 18 janvier 2017)
%
%   4) Combine des informations sur l'effet Gyroscopique et l'effet Magnus
%   (équations par contre différents, mais moins lié à l'aérodynamisme et
%   davantage à n'importe quel forme ... À ANALYSER EN PROFONDEUR + à des
%   sources + Traite sur l'Inertie..):
%   http://www.real-world-physics-problems.com/gyroscope-physics.html
%   (consulté le 18 janvier 2017)
%
%   5) 
%   
%   
function [M] = Force_de_Magnus(Surface, mv_air,)



end