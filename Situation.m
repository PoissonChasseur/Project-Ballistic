%% Situation:
%Description:
%   Définit la situation et est la fonction principale du programme.
%
%Sources altitude et latitude (à prit celle de Montréal):
%   - http://www.distancesfrom.com/ca/MONTREAL-latitude-longitude-MONTREAL-latitude-MONTREAL-longitude/LatLongHistory/17505.aspx 
%   (19 novembre 2016)
%   - https://fr.wikipedia.org/wiki/Montr%C3%A9al (19 novembre 2016)
%
%Source utile - calcul balistique:
%   - http://fred.elie.free.fr/balistique_exterieure.pdf (19 novembre 2016)
%
function Situation()
    format longEng; %Note: N'affecte que les valeurs affiché, pas comment Matlab calcule.

    %Données de départ nécessaire pour les calculs (données venant ex. de capteurs ou info connues):
    pos_initial = [0,0,0]; %la position où on est actuellement [x, y, z]
    angle_xy = 0; %Coordonnée sphérique, angle entre l'axe X et Y.
    azimut = angle_xy; %Dorénavant, l'azimut (point cardinaux) = angle_xy. Où 0 = Nord, 90 = Est, 180 = S, 270 = Ouest.
    angle_sol_z = conversion_degree_to_radian(45); %Coordonnée séphérique, angle entre le plan X-Y et l'axe Z.
    
    altitude_pos = 150; %Montréal: min (point-aux-trembles) = 8m et max (mont royal) = 234m.
    latitude = conversion_degree_to_radian(45.5087); %En Radian
    longitude = conversion_degree_to_radian(-73.554); %En Radian
    
    vitesse_depart = 100; %vitesse en m/s à la sortie.
    masse_projectile = 0.02; %Masse du projectile en Kg.
    
    vent = [0, 0, 0]; %La vitesse du vent, en m/s, en X, Y et Z.
    temperature_ambiante_au_sol = 25; %Celcius
    humidite_relative_ambiante = 0; %En Pourcentage (je pense).
    masse = 1; %Masse du projectile en Kg.
    
    %---------------------------------
    %Mettre certaines données sous des formats nécesaire pour les calculs:
    
    [vitesse_x, vitesse_y, vitesse_z] = convert_spherique_to_cartesien(vitesse_depart, angle_xy, angle_sol_z);
    vitesse_init = [vitesse_x, vitesse_y, vitesse_z];
    
    %----------------------------------
    %Donnée sur la position de la cible
    %vector_pos_cible = []; %EN COURS.
    
    %---------------------------
    %Les axes X, Y, Z et le temps
    nombre_points_axe = 25;
    increment_axe = 1;
    axe_x = pos_initial(1):increment_axe:nombre_points_axe;
    axe_y = pos_initial(2):increment_axe:nombre_points_axe;
    axe_z = pos_initial(3):increment_axe:nombre_points_axe;
    temps = 0:increment_axe:nombre_points_axe;
    
    %______________________________________________________________________
    %______________________________________________________________________
    
    %% Trajectoire 1 = y(t) = yi + viy*t - 0.5*h*t^2
    %trajectoire_1 = basic_trajectoire_2D(pos_initial(2), vitesse_z,temps,altitude_pos,latitude);
    %affichage_graph_2D(axe_x, trajectoire_1)
    
    %----------------------------
    %% Trajectoire Sécurité = Ellipse de sécurité -> Distance maximale possible
    %(sans prendre en compte le vent) que peut atteindre un projectile.
    %trajectoire_2 = parabole_surete(axe_x, vitesse_depart, pos_initial(2), altitude_pos, latitude);
    %affichage_graph_2D(axe_x, trajectoire_2);
    
    %----------------------------
    %% Affichage des profils balistiques et Calcul Surface.
    %Cas testé, vérifier, corrigé si besoin et maintenant semble parfait:
    %   - choix = 1 (rien modifié), 2, 3, 4 (rien modifié), 6 (rien
    %   modifié), 7 (a juste inversé y), 8 (rien modifié), 9, 10 (rien
    %   modifié).
    %Cas testé et semble problématique ou est problématique:
    %   - choix = 5 (impossible pas avoir nb imaginaire qui cause erreur ou
    %   pt bizzare).
    
%     R = 2;
%     L = 100;
%     precision_x = 0.1;
%     choix = 10; %no entre 1 et 10.
%     
%     r_n = 12; %Pour choix = 2 et 5
%     
%     L2 = L+1; %Pour  choix = 3 où L1 = L et L_total = L(L1)+L2 
%     R2 = R+2; %Pour choix = 3 où R1 = R et R_base = R2 >= R(R1)
%     
%     p = 10; %Pour choix = 6
%     Coeff_K = 0; %Pour choix = 8, nb entre 0 et 1
%     Coeff_n = 0.5; %Pour choix = 9, nb entre 0 et 1
%     Coeff_C = 1/3; %Pour choix = 10, nb entre 0 et 1 (0 et 1/3 habituellement)
%     
%     [x, y] = profil_balistique(r_n, L2, R2, p, Coeff_K, Coeff_n, Coeff_C, L, R, precision_x, choix);
%     affichage_profil_balistique(x, y);
%     
%     %--------
%     %Calcule de l'aire de la surface où s'applique la force de l'air
%     azimut_xy_dir_project = 0; %En RADIAN
%     angle_sol_z_project = 0; %En RADIAN
%     
%     azimut_xy_ecoulement_air = 0; %En RADIAN
%     angle_sol_z_ecoulement_air = 0; %En RADIAN
%     
%     est_pour_air_traverser = 0; %0 (false) ou 1 (true)
%     reset = 1; %0 (false) ou 1 (true) besoin de recalculer car profil_x et profil_y ont changé.
%     
%     
%     [S] = Surface_profile_balistique(x, y, azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air, est_pour_air_traverser, reset);
%     disp('Surface :');
%     disp(S);
    
    %----------------------------
    %% Trajectoire de la méthodologie de calcul complète (EN COURS).
    
    %Coefficient pour la méthode de résolution syst. EDO de Runge-Kutta
    degree_runge_kutta = 4; %C'est ce qui à été implémenter actuellement.
    [Coeff_RK_a,Coeff_RK_b,Coeff_RK_c] = get_coefficient_runge_kutta('Classical', degree_runge_kutta);
    
    %Paramètres à changer plus tard...(+précision ou autre)
    pos_cible = [1000, 1000, 1000]; %pos_cible = [pos_cible_x, pos_cible_y, pos_cible_z]
    vitesse_init = [0, vitesse_init]; %vitess_init = [t_init, vx_init, vy_init, vz_init];
    pos_initial = [0, pos_initial]; %pos_initial = [t_init, x_init, y_init, z_init];
    pourcentage_marge_erreur = 5/100; %Pourcentage marge erreur acceptable autour pt de la cible.

    
    %1ère ligne (des deux matrices) = le temps. Ensuite = x, y, z.
    [position, vitesse] = Trajectoire_V2(temps, masse, pos_initial, latitude, azimut, vitesse_init, pos_cible, pourcentage_marge_erreur, Coeff_RK_a, Coeff_RK_b, Coeff_RK_c);
    
    %Affichage des résultats obtenues
    titre_axe_x = ''; titre_axe_y = ''; titre_axe_z = '';
    titre_pos = 'Graph de Position(t,x,y,z)'; titre_vitesse = 'Graph de Vitesse(t,x,y,z';
    legende_pos = 'Position(t,x,y,z)'; legende_vitesse = 'Vitesse(t,x,y,z';
    
    %Rappel: 1ère ligne = le temps et ligne (2,3,4) = (x,y,z).
    affichage_graph_3D(position(2,:), position(3,:), position(4,:), titre_pos, legende_pos, titre_axe_x, titre_axe_y, titre_axe_z);
    affichage_graph_3D(vitesse(2,:), vitesse(3,:), vitesse(4,:), titre_vitesse, legende_vitesse, titre_axe_x, titre_axe_y, titre_axe_z);
end

%-------------------------------------------------------------------
%% affichage_graph_2D:
%Description:
%   Sert à afficher graphiquement l'équation 2D de la trajectoire
%   du projectile qui à été modélisé selon certains aspects.
%
function affichage_graph_2D(axe_x, axe_y)
    if not(numel(axe_x)==numel(axe_y))
        return
    end
    
    opengl('software')
    figure
    plot(axe_x, axe_y, 'o')
    xlabel('distance par rapport position initial');
    ylabel('hauteur par rapport au sol');
    title('Trajectoire 2D');
end

%-------------------------------------------------------------------
%% affichage_graph_3D:
%Description:
%   Sert à afficher graphiquement une fonctione en 3D.
function affichage_graph_3D(axe_x, axe_y, axe_z, titre_principal, legende, titre_x, titre_y, titre_z)
    if not(numel(axe_x)==numel(axe_y)) || not(numel(axe_x) == numel(axe_z))
        return 
    end
    if(isempty(titre_principal))
        titre_principal = 'Graphique 3D';
    end
    if(isempty(titre_x))
        titre_x = 'X';
    end
    if(isempty(titre_y))
        titre_y = 'Y';
    end
    if(isempty(titre_z))
       titre_z =  'Z';
    end
    if(isempty(legende))
        legende = 'f(x,y,z)';
    end
        
    opengl('software')
    figure
    plot3(axe_x, axe_y, axe_z, 'o');
    xlabel(titre_x);
    ylabel(titre_y);
    zlabel(titre_z);
    legend(legende);
    title(titre_principal);
end

%-------------------------------------------------------------------
%% affichage_profil_balistique:
%Description:
%   Sert à afficher le profil complet à partir du rayon en chaque point.
function affichage_profil_balistique(axe_x, axe_y)
    if not(numel(axe_x)==numel(axe_y))
        return
    end

    nb_x = numel(axe_x);
    x = zeros(1,2*nb_x);
    x(1:nb_x)= axe_x;
    x(nb_x+1:2*nb_x) = axe_x;
    axe_x = x; %axe_x = 2 fois les valeurs de lui (2 copie juxtaposé).
    
    nb_y = numel(axe_y);
    y = zeros(1,2*nb_y); %car numel(x) == numel(y) si rendu ici.
    y(1:nb_y) = axe_y;
    y(nb_y+1:2*nb_y) = -axe_y;
    axe_y = y;
    
    affichage_graph_2D(axe_x, axe_y);
end