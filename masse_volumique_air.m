%% masse_volumique_air:
%Description:
%   Calcul la masse volumique de l'air autour du projectile.
%
%facteur prit en compte dans le calcul:
%   - pression atmosph�rique selon l'altitude du projectile.
%   - variation de la temp�rature de l'air autour projectile selon l'altitude.
%   - humidit� relative (qui est suppos� comme �tant la m�me que celle o� �
%   prit la mesure, soit au point de d�part de la trajectoire).
%
%Testage:
%   - � test� � 25 C et 0 C pour air sec + niveau de la mer, et semble 
%   avoir approximativement les m�mes r�sultats (fait avant l'ajout
%   temp�rature selon altitude).
%
%Note:
%   La fonction de la temp�rature en fonction de l'altitude suppose que le
%   projectile est envoy� depuis une position � une altitude inf�rieur �
%   11km.
%
%Param�tre:
%   - hr: humidite_relative : en pourcentage (0.76 correspond � 76%).
%   - temperature: temp�rature en degr� Celcius.
%   - p_atm: pression_atmospherique : en Pascal.
%
%Note: 
%   utilis� dans le calcul de la r�sistance de l'air.
%   Calcul plus pr�cis possible en calculant soi-m�me les coefficients.
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
%   Forme international du nivellement barom�trique.
%
%   Puisque la formule est en hecto Pascal (ou mmbar)
%   on convertie le r�sultat en Pa � la fin.
%
%Param�tre:
%   - l'altitude en m�tre.
%
%Retour:
%   - pression atmosph�rique selon l'altitude.
%
%Source:
%   - https://fr.wikipedia.org/wiki/Variation_de_la_pression_atmosph%C3%A9rique_avec_l%27altitude (19 novembre 2016)
%   - https://fr.wikipedia.org/wiki/Atmosph%C3%A8re_normalis%C3%A9e
%   (consult� le 20 novembre 2016)
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
%   Fonction qui, � l'aide de gradient thermique lin�aire, d�termine la
%   temp�rature du milieu dans lequel se trouve le projectile sachant la
%   temp�rature ambiante du point de d�part.
%
%   Cette fonction permet de dire que le thermom�tre utilis� dans les
%   calculs utilisant la temp�rature se trouve avec le syst�me de lancement
%   et non sur le projectile (ou les donn�es pourrait �tre faus� si (ex.)
%   propulsion d�gage beaucoup de chaleur, comme dans le cas d'une fus�e).
%
%Note:
%   La fonction suppose que le projectile est envoy� � partir d'une
%   position se situant � moins de 11km du niveau de la mer, ce qui devrait
%   �tre le cas la grande majorit� du temps, sauf dans cas tr�s particulier
%   d'un projectile envoy� depuis un v�hicule volant � tr�s haute altitude.
%
%Param�tres:
%   - temperature_au_sol en Celcius = temp�rature � la position o� envoye
%   le projectile.
%   - altitude_sol = altitude de la position o� � envoyer le projectile
%   - altitude = altitude actuelle du projectile.
%
%Retour:
%   - Une approximation de la temp�rature en Celcius de l'air autour du
%   projectile situ� � cette altitude.
%
%Note:
%   La fonction ne fait qu'utiliser un tableau international standart
%   d'atmoph�re de 1976 pr�sent dans la source et qui fonctionne pour des
%   hauteur allant jusqu'� 86 000 km (M�sopayse, au-dessus de la
%   M�sosph�re).
%
%Source: 
%   - https://fr.wikipedia.org/wiki/Atmosph%C3%A8re_normalis%C3%A9e
%   (consult� le 20 novembre 2016).
%
function [t] = temperature_air(temperature_au_sol, altitude_sol, altitude)
    h_diff = (altitude - altitude_sol);
    %0)Tropohsph�re
    if h_diff < 11000
        t = temperature_au_sol-(6.5*10^-3)*h_diff;
    %1)Tropopause
    elseif h_diff < 20000
        t = -56.5;
    %2)Startosph�re
    elseif h_diff < 32000
        t = -56.5+(1*10^-3)*(h_diff-20000);
    %3)Stratosph�re
    elseif h_diff < 47000
        t = -44.5+(2.8*10^-3)*(h_diff-32000);
    %4)Stratopause
    elseif h_diff < 51000
        t = -2.5;
    %5)M�sosph�re
    elseif h_diff < 71000
        t = -2.5 - (2.8*10^-3)*(h_diff-51000);
    %6)M�sosph�re
    elseif h_diff<84852
        t = -58.5 - (2*10^-3)*(h_diff-71000);
    else
        disp('Masse_volumique_air -> temperature_air -> altitude too hight = possible not good result.');
        t = -86.2;
    end
end


