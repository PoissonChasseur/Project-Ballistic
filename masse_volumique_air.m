%% masse_volumique_air:
%Description:
%   Calcul la masse volumique de l'air autour du projectile.
%
%facteur prit en compte dans le calcul:
%   - pression atmosphérique selon l'altitude du projectile.
%   - variation de la température de l'air autour projectile selon l'altitude.
%   - humidité relative (qui est supposé comme étant la même que celle où à
%   prit la mesure, soit au point de départ de la trajectoire).
%
%Testage:
%   - à testé à 25 C et 0 C pour air sec + niveau de la mer, et semble 
%   avoir approximativement les mêmes résultats (fait avant l'ajout
%   température selon altitude).
%
%Note:
%   La fonction de la température en fonction de l'altitude suppose que le
%   projectile est envoyé depuis une position à une altitude inférieur à
%   11km.
%
%Paramètre:
%   - hr: humidite_relative : en pourcentage (0.76 correspond à 76%).
%   - temperature: température en degré Celcius.
%   - p_atm: pression_atmospherique : en Pascal.
%
%Note: 
%   utilisé dans le calcul de la résistance de l'air.
%   Calcul plus précis possible en calculant soi-même les coefficients.
%
%Sources:
%   - https://fr.wikipedia.org/wiki/Masse_volumique_de_l%27air (19 novembre 2016)
%   - https://fr.wikipedia.org/wiki/Formule_du_nivellement_barom%C3%A9trique (19 novembre 2016)
%   - https://fr.wikipedia.org/wiki/Variation_de_la_pression_atmosph%C3%A9rique_avec_l%27altitude (19 novembre 2016)
function [mv_air] = masse_volumique_air(hr, temperature_au_sol, altitude, altitude_sol)
    p_atm = pression_air(altitude);
    temperature = temperature_air(temperature_au_sol, altitude_sol, altitude);
    mv_air = p_atm-230.617*hr*exp((17.5043*temperature)/(241.2+temperature));
    mv_air = mv_air/(287.06*(temperature+273.15));
end

%--------------------------------
%% pression_air:
%Description:
%   Calcule la pression de l'air selon l'altitude.
%   Forme international du nivellement barométrique.
%
%   Puisque la formule est en hecto Pascal (ou mmbar)
%   on convertie le résultat en Pa à la fin.
%
%Paramètre:
%   - l'altitude en mètre.
%
%Retour:
%   - pression atmosphérique selon l'altitude.
%
%Source:
%   - https://fr.wikipedia.org/wiki/Variation_de_la_pression_atmosph%C3%A9rique_avec_l%27altitude (19 novembre 2016)
%   - https://fr.wikipedia.org/wiki/Atmosph%C3%A8re_normalis%C3%A9e
%   (consulté le 20 novembre 2016)
function [p_atm] = pression_air(altitude)
    %p_atm = 1013.25*((1-(0.0065*altitude)/288.15)^5.255);
    p_atm = (0.0065*altitude)/288.15;
    p_atm = 1-p_atm;
    p_atm = p_atm.^5.255;
    p_atm = p_atm*1013.25; %Obtient p_atm en hPa (*10^2)
    
    p_atm = p_atm*10^2; %Le met en Pascal.
end

%--------------------------------
%% temperature_air:
%Description:
%   Fonction qui, à l'aide de gradient thermique linéaire, détermine la
%   température du milieu dans lequel se trouve le projectile sachant la
%   température ambiante du point de départ.
%
%   Cette fonction permet de dire que le thermomètre utilisé dans les
%   calculs utilisant la température se trouve avec le système de lancement
%   et non sur le projectile (ou les données pourrait être fausé si (ex.)
%   propulsion dégage beaucoup de chaleur, comme dans le cas d'une fusée).
%
%Note:
%   La fonction suppose que le projectile est envoyé à partir d'une
%   position se situant à moins de 11km du niveau de la mer, ce qui devrait
%   être le cas la grande majorité du temps, sauf dans cas très particulier
%   d'un projectile envoyé depuis un véhicule volant à très haute altitude.
%
%Paramètres:
%   - temperature_au_sol en Celcius = température à la position où envoye
%   le projectile.
%   - altitude_sol = altitude de la position où à envoyer le projectile
%   - altitude = altitude actuelle du projectile.
%
%Retour:
%   - Une approximation de la température en Celcius de l'air autour du
%   projectile situé à cette altitude.
%
%Note:
%   La fonction ne fait qu'utiliser un tableau international standart
%   d'atmophère de 1976 présent dans la source et qui fonctionne pour des
%   hauteur allant jusqu'à 86 000 km (Mésopayse, au-dessus de la
%   Mésosphère).
%
%Source: 
%   - https://fr.wikipedia.org/wiki/Atmosph%C3%A8re_normalis%C3%A9e
%   (consulté le 20 novembre 2016).
%
function [t] = temperature_air(temperature_au_sol, altitude_sol, altitude)
    h_diff = (altitude - altitude_sol);
    %0)Tropohsphère
    if h_diff < 11000
        t = temperature_au_sol-(6.5*10^-3)*h_diff;
    %1)Tropopause
    elseif h_diff < 20000
        t = -56.5;
    %2)Startosphère
    elseif h_diff < 32000
        t = -56.5+(1*10^-3)*(h_diff-20000);
    %3)Stratosphère
    elseif h_diff < 47000
        t = -44.5+(2.8*10^-3)*(h_diff-32000);
    %4)Stratopause
    elseif h_diff < 51000
        t = -2.5;
    %5)Mésosphère
    elseif h_diff < 71000
        t = -2.5 - (2.8*10^-3)*(h_diff-51000);
    %6)Mésosphère
    elseif h_diff<84852
        t = -58.5 - (2*10^-3)*(h_diff-71000);
    else
        disp('Masse_volumique_air -> temperature_air -> altitude too hight = possible not good result.');
        t = -86.2;
    end
end


