%% La force de l'effet Magnus
%Description:
%   La force engendr� par l'effet Magnus est une force d� � la rotation du
%   projectile sur lui-m�me dans un fluide.
%   
%   La rotation du projectile autour de lui-m�me � pour effet de causer une
%   pression inf�rieur sur le c�t� o� l'air va dans le m�me sens que la
%   rotation du projectile et une pression plus haute de l'autre c�t� o� la
%   rotation du projectile cr�er une r�sistance (d� � la vitesse dans le
%   sens inverse � l'air).
%
%   Ceci � pour effet de faire diriger le projectile vers le c�t� o� la
%   pression est le plus faible, soit le c�t� o� sa vitesse de rotation et
%   la vitesse de l'air sont dans le m�me sens. Un effet de portance se
%   cr�er, ce qui � des impacts non-n�gligeable notamment dans certains
%   sports (comme le soccer) et certains mode de propulsion.
%   
%   L'effet Magnus est principalement pr�sent� par rapport � des vues de
%   coupe circulaire, mais th�oriquement, on peut le faire avec n'importe
%   quel forme de coupe.
%
%Forces en pr�sences dans calcul effet Magnus:
%   Deux forces importantes sont � prendre en compte:
%       1) La force de Magnus: La portance du cot� o� la vitesse de l'air
%       et celle de rotation sont dans la m�me direction.
%   
%       2) La force de frotemment de l'air: La r�sistance � l'�coulement de
%       l'air d� � la rotation dans le sens inverse � l'air qui une plus
%       grande pression de l'autre c�t�.
%   
%   Selon la source 1 "math�matique", les �quations des forces sont
%   pareilles � celle de portance et r�sistance de l'air, mais la surface
%   et le coefficient "C" (comme C_x ou C_y) change.
%
%Param�tres:
%   - mv_air:   masse volumique de l'air
%   
%   - S: [S_x, _Sy, S_z] L'aire des surfaces selon chaque axes
%   
%   - v: [v_x, v_y, v_z] La vitesse de d�placement du projectile selon
%   chaque axe.
%   
%   - axe_spin: [axe_spin_x, axe_spin_y, axe_spin_z]: Vecteur unitaire de
%   l'axe de rotation du projectile (dirig� dans le sens vers lequel la
%   balle tourne [je pense]) Note: Peut �tre seulement 1 ou 2 axes (donc
%   les autres mient � 0).
%   
%   - 
%
%
%Sources amenant � d'autres sources:
%   - https://fr.wikipedia.org/wiki/Effet_Magnus (consutl� le 18 janvier
%   2017)
%   - https://fr.wikipedia.org/wiki/Th%C3%A9or%C3%A8me_de_Kutta-Jukowski
%   (consult� le 18 janvier 2017)
%   -
%   https://fr.wikipedia.org/wiki/Effet_Magnus_et_turbulence_dans_le_football
%   (consult� le 18 janvier 2017)
%
%Sources tr�s int�ressantes, mais pas �quations:
%   - http://www.dtic.mil/ndia/2006smallarms/weinacht.pdf (consult� le 18
%   janvier 2017)
%
%   - 
%
%Sources utilis� pour �quation math�matiques:
%   Note: Actuellement, les 2 sources n'ont pas les m�mes r�sultats.
%   1) = trouv� sur Google via "Effet Magnus equations" + 0 source
%   2) = trouv� via source de Wikip�dia + source en fin de doc.
%
%   -1) +/- parfait, car donn�e manquante (d�terminer les coefficients) 
%   et aucune sources = 0 preuves de ces affirmations:
%   http://gilbert.gastebois.pagesperso-orange.fr/java/magnus/mvt_magnus.pdf
%   (consult� le 18 janvier 2017)
%   
%   -2) Source de Wikip�dia et peut obtenir des r�sultats pour les
%   coefficients sans m�thode exp�rimentale (ou pas 100% exp�rimentale)
%   http://people.stfx.ca/smackenz/Courses/HK474/Labs/Jump%20Float%20Lab/Bray%202002%20Modelling%20the%20flight%20of%20a%20soccer%20ball%20in%20a%20direct%20free%20kick.pdf 
%   (consult� le 18 janvier 2017)
%
%   3) � les m�mes �quations que source 2, ce qui semble concorder avec des
%   �quations valide et g�n�ralis� (semble bien expliqu� et � des sources)
%   http://spiff.rit.edu/richmond/baseball/traj_may2011/traj.html (consult�
%   le 18 janvier 2017)
%
%   4) Combine des informations sur l'effet Gyroscopique et l'effet Magnus
%   (�quations par contre diff�rents, mais moins li� � l'a�rodynamisme et
%   davantage � n'importe quel forme ... � ANALYSER EN PROFONDEUR + � des
%   sources + Traite sur l'Inertie..):
%   http://www.real-world-physics-problems.com/gyroscope-physics.html
%   (consult� le 18 janvier 2017)
%
%   5) 
%   
%   
function [M] = Force_de_Magnus(Surface, mv_air,)



end