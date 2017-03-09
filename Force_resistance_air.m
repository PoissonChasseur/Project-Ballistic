%% Force_resistance_air:
%Description:
%   Calcul, en Newton, la force de la résistance de l'air.
%   Actuellement pour de la balistique seulement (Cx varie selon les
%   objets, pour l'instant = pour la balistique seulement).
%
%   Note importante: Les autres compostantes de la trainé (comme Cy et Cz)
%   peuvent aussi s'appliquer (Cy = Cx ou Cz = Cx) dans le cas de
%   déplacement selon d'autre axe.
%   Aussi, LA PORTANCE à les mêmes équations mathématique, mais avec les
%   autres compostantes de la trainée.
%
%NOTE IMPORTANTES - en date du 15 janvier 2017:
%   #1) Le calculs des Surfaces laisse actuellement à désiré dans le cas
%   des formes complexe présente dans "Surface_profil_forme_general".
%
%   #2) Le calcul actuelle du "Cx" est pour le cas balistique ET non pour
%   le cas généralisé à autre chose.
%
%   #3) On doit appeler cette fonction au minimum 3 fois (axe x,y,z) + une
%   fois pour le vent si on le prend en compte.
%
%Paramètres:
%   - aire_surface: L'aire de la surface (en m^2) contre lequel la
%   résistance de l'air s'applique, soit l'air de la surface qui est
%   perpendiculaire à l'axe du déplacement.
%
%   - vitesse : [v_x, v_y, v_z] de l'écoulement de l'air contre le
%   projectile.
%
%   - hr: humidité relative de l'air autour du projectile
%     NOTE À FAIRE: relation quelconque entre Temperature ou Pression (ex)
%     avec la variation de l'humidité relative.
%
%   - temperature_sol: la température initial
%
%   - altitude: L'altitude actuelle du projectile
%
%   - altitude_sol: L'altitude initiale de projectile
%
%   - choix: pour sélectionner la fonction du calcul du Cx en lien avec la
%   forme (À COMPLÉTER ET À AMÉLIORER)
%       #1) Balistique:
%           -> densite_projectile
%           -> diametre
%
%       #2) Sphère (ex.: boulet de canon)
%   
%Retour:
%   - R = [R_x, R_y, R_z]: La résistance de l'air (en x,y,z) par rapport aux déplacement
%       selon chacun des axes (sera toujours dans le sens opposé au
%       mouvement)
%
%   - portance: force en Z qui amène le projectile vers haut.
%
%Source: 
%   - https://fr.wikipedia.org/wiki/Chute_avec_r%C3%A9sistance_de_l'air (19 novembre 2016)
%   - http://fred.elie.free.fr/balistique_exterieure.pdf (19 novembre 2016)
%   - https://fr.wikipedia.org/wiki/Balistique_ext%C3%A9rieure (19 novembre 2016)
%
function  [R, portance] = Force_resistance_air(aire_surface, vitesse, hr, temperature_sol, altitude, altitude_sol, choix, densite_projectile, diametre)
    %% Calculs coefficient applicable pour les 3 axes

    %Équation original : R = 1/2*Cx*p*aire_surface*v^n
    %   -> aire_surface*v^n = force_air_table_Cranz(aire_surface, vitesse)
    %   -> p = masse volumique de l'air = masse_volumique_air(hr, temperature, altitude)
    %    -> cx = coefficient de résistance "aérodynamique" -> dépend de la
    %    forme du projectile, version Balistique et Sphère présente plus
    %    bas (seulement, pour l'instant).
    %  
    mv_air = masse_volumique_air(hr, temperature_sol, altitude, altitude_sol);
    
    %À l'aide de la Table de Cranz on obtient un coeffient qui est ensuite multiplier
    %avec l'aire de la surface et la vitese
    
    %Force_air = aire_surface*vitesse^n
    force_air = force_air_table_Cranz(aire_surface, vitesse);
    
    R = zeros(1,3);
    
    %------------------------------------------
    %% Calcul des coefficients de trainée selon chacun des axes
    
    %Sélection de la fonction approprié pour le calcul du Cx
    %NOTE: À REVOIR ET À AMÉLIORER.
    
    Cy = 1; %À améliorer
    Cz = 1; %À améliorer
    
    switch(choix)
        case 1 %Balistique
            Cx = coefficient_trainee_balistique(vitesse, densite_projectile, diametre);
            
        case 2 %Sphère
            [Cx] = coefficient_trainee_sphere(vitesse, L, temperature);
            
        otherwise
            disp('Force_resistance_air: ERROR choix invalid');
            Cx = 0;
            Cy = 0;
            Cz = 0;
    end
    
    %------------------------------------------
    %% Calculs des forces en présences avec l'air selon chaque axe
    
    %Axe X:
    R(1) = 0.5*Cx*mv_air*force_air(1);
    
    %Axe Y:
    R(2) = 0.5*Cy*mv_air*force_air(2);
    
    %Axe Z: (NOTE: À REVOIR POUR SI EXISTE R(3) ou si R(3) = Portance)
    %Actuellement: R(3) = portance (même équation).
    R(3) = 0.5*Cz*mv_air*force_air(3);
    [portance] = calcul_portance(force_air(3), mv_air, Cz);
end

%% Portance
%Description:
%   La résitance de l'air et la portance ont exactement les MÊMES
%   ÉQUATIONS, à la seule différences qu'ils utilisent pas nécessairements
%   les mêmes coefficients de trainée.
%   Le coéfficient de la réssitance de l'air dépend de l'axe du
%   déplacement. Celui de la portance est toujour en Z. De ce fait, au lieu
%   de créer un nouveau fichier, je les ais mit ensemble.
%
%   La portance est la force d'Archimède dans l'air dans lequel l'air
%   circule autour du projectile de manière à l'amener vers le haut (par
%   exemple) afin de contribuer à son élévation au dessus du sol (comme
%   avec les avions) ou à rester plus longtemps dans les air avant de
%   revenir au sol.
%
%Sources:
%   - https://fr.wikipedia.org/wiki/Portance_(m%C3%A9canique_des_fluides)
%   (consulté le 15 janvier 2017)
%   - https://fr.wikipedia.org/wiki/%C3%89quations_de_Navier-Stokes
%   (consulté le 15 janvier 2017)
%
function [portance] = calcul_portance(force_air, mv_air, C_z)
    %Calcul de la portance: F_z = 0.5*mv_air*S*V^n*C_z
    %Force_air = S*V^n
    portance = 0.5*mv_air*force_air*C_z;
end


%----------------------------------------
%% force_air_table_Cranz
%Méthode 1 calcul force de l'air: A*V^n où A = aire section qui subit la
%force de l'air. vitesse = [0, 1000[ m/s
%Source: http://fred.elie.free.fr/balistique_exterieure.pdf (19 novembre 2016)
%p.11
%
%NOTE importante:
%   Selon la source qui suit, certaines "petite armes" (celle transportable
%   par un ou plusieurs individus) ont des velocité > 1524 m/s
%   (hypervelocité)
%
%Paramètres:
%   - aire_surface: [aire_x, aire_y, aire_z] de la surface contre lequel
%   s'applique cette force.
%
%   - vitesse: [v_x, v_y, v_z] de la vitesse de l'écoulement de l'air
%   autour du projectile selon chacun des axes.
%
%Sources:
%   - http://fred.elie.free.fr/balistique_exterieure.pdf (19 novembre 2016)
%
%   - Carl Cranz: https://fr.wikipedia.org/wiki/Carl_Cranz (consulté le 15
%   janvier 2017)
%
%   - Livres table de Cranz (à lire ou à ...):
%     https://archive.org/stream/handbookofballis01cranuoft#page/14/mode/2up/search/table
%   (consulté le 15 janvier 2017)
%
function [force] = force_air_table_Cranz(aire_surface, vitesse)
    force = zeros(1,3);
    
    v = abs(vitesse);
    
    %Pour chacune des vitesses (pour chacun des axes)
    for i=1:3
        %Note: vitesse est en m/s
        if(v(i) < 1000)
            if(v(i) < 240) % v < 864 km/h
                n = 2;
            elseif(v(i) < 295) % v < 1062 km/h
                n = 3;
            elseif(v(i) < 375) % v < 1350 km/h
                n = 5;
            elseif(v(i) < 419) % v < 1508.4 km/h
                n = 3;
            elseif(v(i) < 550) % v < 1980 km/h
                n = 2;
            elseif(v(i) < 800) % v < 2880 km/h
                n = 1.7;
            elseif(v(i) < 1000) % v < 3600 km/h
                n = 1.55;
            end
            force(i) = signe_chiffre(vitesse(i))*aire_surface(i).*v(i).^n;
        else
            Disp('Force_air_table_Cranz: speed > 1000 = force unknow');
            force(i) = 0;
        end
    end
end

%-----------------------------
%% coefficient_trainee_sphere
%Description:
%   Fait le calcul du coefficient de traine pour une sphère.
%
%Source:
%   - https://fr.wikipedia.org/wiki/Coefficient_de_tra%C3%AEn%C3%A9e (19 novembre 2016)
%
function [cx] = coefficient_trainee_sphere(vitesse, L, temperature)
    %Problème: Dépend des objets, mais version pour Balistique trouvés.
    %Code ici = pour le cas d'une sphère.
    Re = Nb_Reynolds(vitesse, L, temperature);
    if(Re < 1)
        cx = 24/Re;
    elseif(Re < 10^3)
        cx = 18.5/(Re^0.6);
    elseif(re < 5*10^5)
        cx = 0.44;
    else
        disp('coefficient_trainee_sphere: ERROR Re too much hight');
        cx = 0;
    end
end

%-----------------------------
%% coefficient_trainee_balistique:
%Description:
%   Calcul le coefficient de Trainée dans le cas balistique.
%
%Paramètres:
%   - vitesse = vitesse (velocité du projectile) en m/s à une certaine distance.
%   - densite_projectile = densité du projectile
%   - diametre = "measured cross section (diameter) of projectile" en
%   mètre.
%
%Note autre truc sur la page source: 
%   - Calcule du point de masse de la trajectoire.
%   - Calcule du coefficient de forme en fonctione calibre de l'ogive.
%
%Source: 
%   - https://en.wikipedia.org/wiki/Ballistic_coefficient (19 novembre 2016)
function  [cx] = coefficient_trainee_balistique(vitesse, densite_projectile, diametre)
    cx = 8/(densite_projectile*vitesse^2*pi*diametre);
end


%----------------------------------------
%% Nombre de Reynolds (Re)
%
%Paramètres:
%   - masse_volumique du fluide (en kg/m^3)
%   - viscosite_dynamique du fluide (en m^2/s)
%   - L = dimension caractéristique (en m)
%
%Note:
%   - Pour un fluide circulant dans un tuyau, L = R (rayon) = 2*R (diamètre)
%
%Viscocité dynamique: dépend température, pressionn et du fluide.
%
%
%Source: 
%   - https://fr.wikipedia.org/wiki/Nombre_de_Reynolds (19 novembre 2016)
%
function [Re] = Nb_Reynolds(vitesse, L, temperature)
    v = viscocite_cinematique_air(temperature);
    Re = (vitesse*L)/v;
end

%-------------------------------------------
%% viscocite_dynamique_air:
%Description:
%   Calcule la viscocité dynamique de l'air.
%   Formule: viscocité cinématique du fluide / masse_volumique du fluide.
%
%Paramètre:
%   - masse volumique de l'air en kg/m^3
%   - température de l'air en Kelvin.
%
%Retour:
%   - viscocité dynmaique du fluide en Pas*s ou kg/(m*s).
%
%Source:
%   - https://fr.wikipedia.org/wiki/Viscosit%C3%A9_dynamique (19 novembre 2016)
%
function  [v] = viscocite_dynamique_air(masse_volumique, temperature)
    v = viscocite_cinematique_air(temperature)/masse_volumique;
end

%-------------------------------------------
%% viscocite_cinematique_air
%Description:
%   Calcule la viscocité cinématique de l'air en 
%   en fonction de la température.
%
%   Basé sur une table de valeur provennant
%   du site "Chemical Professionals"
%   
%Paramètre:
%   - Température en Kelvin.
%
%Retour:
%   Viscocité cinématique de l'air en m^2/s.
%
%Source:
%   - https://fr.wikipedia.org/wiki/Air (19 novembre 2016)
%
function [v] = viscocite_cinematique_air(temperature)
    v = (-1.363528*10^-14)*temperature^3;
    v = v + (1.00881778*10^-10)*temperature^2;
    v = v + (6.2657*10^-8)*temperature;
    v = v + (2.3543*10^-6);
end


