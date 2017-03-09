%% Force_Coriolis
%Description:
%   La force de Coriolis est une force agisant perpendiculairement à la
%   direction du mouvement dans corps en déplacement dans un milieu
%   (référentiel) lui-même rotation uniforme. Ex: Le fait que la Terre
%   tourne sur elle-même à pour effet que la position  où va atterir le
%   projectile sera dévié dû à la rotation de la Terre.
%
%   Dans le cas de courte porté, l'effet de Coriolis à un impact
%   négligeable, mais à longue porté (ex.: snipper, missile
%   intercontinental et fusée), cette force à un impact non négligeable.
%
%Note:
%   - Le calcul de la force de Coriolis utilisé ici prend en compte
%   l'accélération de l'effet Eotvos.
%   - La formule ici = formule complète et prise de la section des sources
%   qui parle pour l'effet de Coriolis sur la Terre.
%
%Note importante:
%   Les calculs de la Force de Coriolis avec l'utilisation des coordonnées
%   sphériques pour représenter la Terre amène le besoin que le reste du
%   programme devra suivre ce référentielle (à moins que celle-ci ne
%   s'adapte aux autres). Voici les référentielles nécessaire pour les
%   calculs qui ont été implementé actuellement:
%
%   La Terre tourne d'Ouest en Est (vers l'Est). En posant un référentielle 
%   où X est vers l'Est, alors aller vers l'Ouest = X négatif.
%
%   L'utilisation du référentielle que Y va vers le Nord amène donc que si
%   on va vers le sud, on va en Y négatif.
%
%   L'utilisation du référentielle Z comme allant vers l'extérieur du
%   centre de la Terre (ce qui était déjà fait avec l'Altitude) ne change
%   rien par contre au reste du programme.
%
%Paramètres:
%   - azimut: angle, en Radian, par rapport au Nord. Permet de savoir dans
%   les signes des différents paramètres de calcul qui sont relié à la
%   direction du projectile. Note sur Points Cardinaux, le Nord = + et
%   l'Est = +, dans le sens que N.N.E = Pi/8 = + X et + Y.
%
%   - vitesse = [v_x, v_y, v_z] selon système de coordonnées cartésien
%   (en m/s).
%
%Note sur les paramètres:
%   - Idéalement: angle_sol = azimut (en radian).
%
%Sources:
%   - https://fr.wikipedia.org/wiki/Force_de_Coriolis (consulté le 20
%   novembre 2016)
%   - https://en.wikipedia.org/wiki/Coriolis_force (consulté le 20 novembre
%   2016)
%   - https://fr.wikipedia.org/wiki/Point_cardinal (consulté le 20 novembre
%   2016)
%   - https://fr.wikipedia.org/wiki/Rotation_de_la_Terre (consulté le 20
%   novembre 2016).
%   - https://en.wikipedia.org/wiki/Cardinal_direction (consulté le 20
%   novembre 2016)
%   
function  [Fc, ac] = Force_Coriolis(masse, vitesse, azimut, latitude)
    %Vitesse angulaire (rad/s) rotation Terre. Pas constant en réalité.
    %Pour l'instant, l'approximation de la vitesse sera suffisante.
    persistent vitesse_rotation_terre %Variable static, car ne change pas.
    if(isempty(vitesse_rotation_terre))
       vitesse_rotation_terre = 7.292115*10^-5; 
    end
    
    [v_sol] = convert_cartesian_to_cylinder(vitesse(1), vitesse(2), vitesse(3));
    [v_nord, v_est] = calcul_vitesse_selon_azimut(v_sol, azimut);
    v_haut = vitesse(3);
    
    ac = [v_nord*sin(latitude)-v_haut*cos(latitude), -v_est*sin(latitude), v_est*cos(latitude)];
    ac = 2*vitesse_rotation_terre*ac;
    
    Fc = masse*ac;
end

%---------------------------------------
%% calcul_vitesse_selon_azimut
%Description:
%   Fonction qui retourne la vitesse vers le Nord et la vitesse vers l'Est
%   en fonction de l'orientation des points cardinaux de la direction du
%   projectile, soit l'azimut de sa direction.
%
%   En se basant sur le fait que le Nord = 0 degré et Est = 90 degré, on
%   fait la simulitude avec les coordonnées cartésiennes et polaires.
%   Ainsi, V_Nord = V_x = V*cos(angle) et V_Est = V_y = V*cos(angle) et si
%   V_nord négatif = V_sud positif (logic) et même chose entre V_Est et
%   V_ouest.
%
%Note:
%   Dans le même sens que les calculs de la Force de Coriolis, dans le
%   système de points cardinaux, le Nord = l'axe X +, l'Est = l'axe Y+.
%
%Paramètre:
%   - la vitesse selon le plan du sol (r en coordonnée cylindrique,
%     (soit r = sqrt(v_x^2 + v_y^2))
%   - L'azimut, l'angle par rapport au Nord, en radian.
%
%Source:
%   - https://en.wikipedia.org/wiki/Coriolis_force (consulté le 20 novembre
%   2016)
%   - https://fr.wikipedia.org/wiki/Point_cardinal (consulté le 20
%   novembere 2016)
%
function [v_nord, v_est] = calcul_vitesse_selon_azimut(vitesse, azimut)
    v_nord = vitesse*cos(azimut);
    v_est = vitesse*sin(azimut);
end
