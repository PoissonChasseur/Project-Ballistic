%% Force_Coriolis
%Description:
%   La force de Coriolis est une force agisant perpendiculairement � la
%   direction du mouvement dans corps en d�placement dans un milieu
%   (r�f�rentiel) lui-m�me rotation uniforme. Ex: Le fait que la Terre
%   tourne sur elle-m�me � pour effet que la position  o� va atterir le
%   projectile sera d�vi� d� � la rotation de la Terre.
%
%   Dans le cas de courte port�, l'effet de Coriolis � un impact
%   n�gligeable, mais � longue port� (ex.: snipper, missile
%   intercontinental et fus�e), cette force � un impact non n�gligeable.
%
%Note:
%   - Le calcul de la force de Coriolis utilis� ici prend en compte
%   l'acc�l�ration de l'effet Eotvos.
%   - La formule ici = formule compl�te et prise de la section des sources
%   qui parle pour l'effet de Coriolis sur la Terre.
%
%Note importante:
%   Les calculs de la Force de Coriolis avec l'utilisation des coordonn�es
%   sph�riques pour repr�senter la Terre am�ne le besoin que le reste du
%   programme devra suivre ce r�f�rentielle (� moins que celle-ci ne
%   s'adapte aux autres). Voici les r�f�rentielles n�cessaire pour les
%   calculs qui ont �t� implement� actuellement:
%
%   La Terre tourne d'Ouest en Est (vers l'Est). En posant un r�f�rentielle 
%   o� X est vers l'Est, alors aller vers l'Ouest = X n�gatif.
%
%   L'utilisation du r�f�rentielle que Y va vers le Nord am�ne donc que si
%   on va vers le sud, on va en Y n�gatif.
%
%   L'utilisation du r�f�rentielle Z comme allant vers l'ext�rieur du
%   centre de la Terre (ce qui �tait d�j� fait avec l'Altitude) ne change
%   rien par contre au reste du programme.
%
%Param�tres:
%   - azimut: angle, en Radian, par rapport au Nord. Permet de savoir dans
%   les signes des diff�rents param�tres de calcul qui sont reli� � la
%   direction du projectile. Note sur Points Cardinaux, le Nord = + et
%   l'Est = +, dans le sens que N.N.E = Pi/8 = + X et + Y.
%
%   - vitesse = [v_x, v_y, v_z] selon syst�me de coordonn�es cart�sien
%   (en m/s).
%
%Note sur les param�tres:
%   - Id�alement: angle_sol = azimut (en radian).
%
%Sources:
%   - https://fr.wikipedia.org/wiki/Force_de_Coriolis (consult� le 20
%   novembre 2016)
%   - https://en.wikipedia.org/wiki/Coriolis_force (consult� le 20 novembre
%   2016)
%   - https://fr.wikipedia.org/wiki/Point_cardinal (consult� le 20 novembre
%   2016)
%   - https://fr.wikipedia.org/wiki/Rotation_de_la_Terre (consult� le 20
%   novembre 2016).
%   - https://en.wikipedia.org/wiki/Cardinal_direction (consult� le 20
%   novembre 2016)
%   
function  [Fc, ac] = Force_Coriolis(masse, vitesse, azimut, latitude)
    %Vitesse angulaire (rad/s) rotation Terre. Pas constant en r�alit�.
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
%   En se basant sur le fait que le Nord = 0 degr� et Est = 90 degr�, on
%   fait la simulitude avec les coordonn�es cart�siennes et polaires.
%   Ainsi, V_Nord = V_x = V*cos(angle) et V_Est = V_y = V*cos(angle) et si
%   V_nord n�gatif = V_sud positif (logic) et m�me chose entre V_Est et
%   V_ouest.
%
%Note:
%   Dans le m�me sens que les calculs de la Force de Coriolis, dans le
%   syst�me de points cardinaux, le Nord = l'axe X +, l'Est = l'axe Y+.
%
%Param�tre:
%   - la vitesse selon le plan du sol (r en coordonn�e cylindrique,
%     (soit r = sqrt(v_x^2 + v_y^2))
%   - L'azimut, l'angle par rapport au Nord, en radian.
%
%Source:
%   - https://en.wikipedia.org/wiki/Coriolis_force (consult� le 20 novembre
%   2016)
%   - https://fr.wikipedia.org/wiki/Point_cardinal (consult� le 20
%   novembere 2016)
%
function [v_nord, v_est] = calcul_vitesse_selon_azimut(vitesse, azimut)
    v_nord = vitesse*cos(azimut);
    v_est = vitesse*sin(azimut);
end
