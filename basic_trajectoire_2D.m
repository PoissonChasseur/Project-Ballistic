%% basic_trajectoire_2D:
%Description:
%   Sert à obtenir un vecteur de position qui dit la position du projectile
%   pour les différentes valeur de temps.
%   Modèle de la chute libre sans prise en compte de facteur complexe.
%   Ne prend pas non plus en compte facteur aérodynamique.   
%
%   Modélisation en 2D seulement (supose aucune déviation sur le 3ème axe
%   dû à effet de Coriolis et autre facteur).
%   
%Facteur prit en compte actuellement:
%   - variation de la force de gravité en fonction altitude et latitude
%
%Source:
%   - https://en.wikipedia.org/wiki/Trajectory_of_a_projectile?oldid=724379519
%   (19 novembre 2016)
%
function [position] = basic_trajectoire_2D(pos_initial, vitesse_initial, temps, altitude, latitude)
    position = zeros(1,length(temps));
    position(1) = pos_initial;
    
   % position = position + 25*temps-0.5*9.81*temps.^2;
    for i=1:length(position)-1
        position(i+1) = position(1) + vitesse_initial.*temps(i)-0.5.*gravity(altitude+position(i),latitude).*temps(i).^2;
    end
end