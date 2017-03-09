%% Surface_profile_balistique:
%Description:
%   Fonction qui, à l'aide du profil du projectile (valeur en X et Rayon Y
%   à chacun de ces points), va calculer la surface sur lequel s'applique
%   la force de l'air.
%
%   Cette fonction est nécessaire à l'utilisation des profils balistiques
%   pour le calcul de la force de résistance de l'air.
%
%Paramètres:
%   - profil_x: les valeurs en X de 0 à L des points du profile dy
%   projectile.
%
%   - profil_y: les valeurs du Rayon à chacune des valeurs en X.
%
%   - azimut_dir_project: Azimut (relié aux points cardinaux) de la 
%   direction vers lequel se dirige le projectile. EN RADIAN.
%
%   - azimut_ecoulement_air: Azimut (relié aux points cardinaux) de la
%   direction de l'écoulement de l'air. EN RADIAN.
%
%   - est_pour_air_traverser: TRUE(oui) si c'est pour la surface qu'on
%   traverse en progressant dans le fluide. FALSE(non) si pas le cas.
%
%Note sur paramètres:
%   - profil_x (soit x) et profil_y (soit y) viennent de la fonction
%     "profil_balistique(r_n, L2, R2, p, Coeff_K, Coeff_n, Coeff_C, L, R,
%     precision_x, choix)"
%
%   - azimut_dir_project: L'orientation initiale (je pense) ou en temps
%   réel. Est nécesaire pour pouvoir définir l'orientation de la direction
%   vers lequel se dirige le projectile.
%
%   - azimut_ecoulement_air: L'orientation de l'ecoulement d'air par
%   rapport aux points cardinaux. Permet de se servir des points cardinaux
%   de l'orientation du vent sur la zone (ce qui est indépendant du
%   projectile). Est uniquement pour l'écoulement de l'air sur le plan X-Y,
%   ce qui exclue l'orientation pour vent ascendant ou descendant.
%
%Méthodologie de calcul actuelle (en date du 4 janvier 2017):
%   Le profile de la pointe balistique (sera racourci à balle) qu'on a
%   obtenue à l'aide de la fonction "profil_balistique" donne le rayon à
%   chacun des points de la longueur. 
%
%   La forme de la balle est approximé comme ayant une base circulaire où
%   l'on a un profil qui tourne autour de l'axe central de la longueur. Par
%   simplicité, on va approximer la surface de la base à un cercle 
%   parfaitement plat, comme le suggère aussi le calcul du profil 
%   balistique (puisqu'on utilise actuellement un profil et un rayon R au 
%   lieu d'un vecteur de rayon R ET car on ne peut pas toujours mesurer ou
%   vérifier que la surface de la base est parfaitement plate).
%   
%   3 cas de base peuvent visualisé (note: turbulence pas prit en compte):
%       #1) L'air uniquement de face (ex.: l'air traversé par la balle): 
%           L'air va s'appliquer sur 100% de la surface latéral.
%           La forme peut s'apperenté à demi-cercle (selon moi).
%
%       #2) L'air uniquement par l'arrière (ex: vent derrière le tireur):
%           L'air va s'appliquer sur 100% de la surface de la base (je
%           pense). La forme peut s'apparenté à un disque plat (selon moi).
%
%       #3) L'air uniquement par les côtés ou ascendant/descendant:
%           L'air va frapper environ 50% de l'air latéral et la forme sera
%           de la surface où s'applique l'air sera équivalent à plusieurs
%           cercle d'épaisseur infime (selon moi). Cela semble en accord
%           (selon mon interprétation) avec la source cité.
%
%   À partir de ces 3 cas, on peut déterminer la surface où s'applique
%   l'air en utilisant le système de coordonnée sphérique afin de pouvoir
%   couvrir tous les cas possibles d'écoulement d'air autour du projectile.
%   On réfléchie d'abord sur un plan X-Y et on extropole en ajoutant Z.
%   
%   Cependant, il est vrai que dans le cas de certaines informations, il
%   peut être complexe de les obtenir en temps réel et il est possible
%   qu'elles devront être approximé (ex: valeur constante ou 0 degré en
%   tout temps ou l'angle de tir et l'angle inverse au tir -> idée: droite
%   de la dérivé de la position ? ...).
%   
%Note importante sur approximation des calculs:
%   #1) Orientation du vent:
%       Pour l'instant, on a seulement vent en X-Y, comme un mur d'air qui
%       se déplace de manière linéaire, comme un mur, a travers le
%       projectile. La prise em considération vent selon les 3 axes
%       donneraient de meilleur résultats.
%
%   #2) La surface de la base:
%       On approxime la surface de la base comme étant un cercle à rayon
%       constant au lieu d'une ellipse (car rayon pas parfaitement constant)
%       ou d'un ellipsoide tronqué (car surface par parfaitement plate).
%       Ceci est dû à une simplicité de calcul et au fait que dans le cas
%       d'une balle, il n'est pas vraiment toujours possible de mesure à la
%       perfection la surface de la base de la balle (car on ne peut pas
%       l'enlever de la cartouche). De ce fait, on va l'approximer à un
%       cercle.
%
%   #3) Calcule de la surface:
%       On ne prend pas en compte l'écoulement de l'air autour de la
%       surface, comme celui dû au turbulence et à la trainée. On ne prend
%       en compte que la surface où la force va principalement s'appliquer.
%       De plus, j'ai posé que si 100% côté = 50% aire latéral (car exclue
%       base dite "100% lise et plate". Cependant, fait non fondée et
%       possiblement une grossière approximation dû à turbulence et
%       écoulement autour des cercle. La source cité semble en accord avec
%       cela (mais je peux avoir mal interprété les informations).
%
%   #4) Obtention des mesures des azimut SOL-Z:
%       L'orientation des Azimuts pour le plan X-Y est assez facile à
%       obtenir, car c'est le genre de mesure habituelle. Le problème porte
%       sur l'orientation entre le plan XY et l'axe Z. Dans le cas de la
%       balle, c'est l'orientation de l'axe de la longueur par rapport au
%       sol, ce qui varie dans le temps. Dans le cas du vent, c'est pour le
%       vent ascendant et descendant qui peut lui aussi varier dans le
%       temps. Ces deux mesures sont pour l'instant (en date du 4 janvier
%       2017) assez incertain sur la manière de les obtenirs.
%
%Paramètres:
%   - profil_x et profil_y: valeur X et Y retourné par la fonction
%   "profil_balistique" qui utilise (précisé dans les paramètres) des
%   mesures en MÈTRES.
%
%   - R: le rayon (considéré actuellement comme étant constant en tout
%   point) de la base. Le même "R" que celui utilisé dans
%   "profil_balistique".
%
%   - azimut_xy_dir_project: Azimut (angle des points cardinaux) de la
%   direction où se dirige le projectile. Équivalent de l'angle X-Y des
%   coordonnées sphérique et cylindrique. En RADIAN.
%
%   - angle_sol_z_project: Angle entre le sol et l'axe de la longueur du
%   projectile (coordonnées sphérique). En RADIAN.
%
%   - azimut_xy_ecoulement_air: Azimut (angle des points cardinaux) de la
%   direction où se dirige le vent ou l'air traversé par le projectile. 
%   Équivalent de l'angle X-Y des coordonnées sphérique et cylindrique. En 
%   RADIAN.
%
%   - angle_sol_z_ecoulement_air: Angle sol-z (coordonnées sphérique) de 
%   l'écoulement de l'air (pour la partie du vent qui est ascendante ou 
%   descendante). En RADIAN.
%
%   - est_pour_air_traverser: TRUE/1 (VRAI/OUI) si c'est pour la surface
%   traversé par la balle qui progresse dans le fluide (ce qui va
%   directement vers le calcul correspondant). FALSE/0 (FAUX/NON) si ce n'est
%   pas le cas et donc, que c'est pour le vent.
%
%   - reset: TRUE/1 si on veut changer la valeurs des variables qui ne
%   change pas en cours au cours du calcul d'un projectile spécifique. Ex:
%   Si on fait pas "clear" en cours de route et qu'on veut faire le calcul
%   pour plus d'un projectile au cours de l'exécution du programme
%   (idéalement, faire un projectile à la fois et non en alternance).
%
%Retour:
%   S = la surface où s'applique l'air, ce qui est utilisé pour le calcul
%   de la force de résistance de l'air (air traversé par la balle et le
%   vent qui pousse sur la balle).
%
%Note progression:
%   TESTÉ (donne un résultat et aire < cylindre lorsque devrait l'être)
%   JAMAIS VÉRIFIER PAR RAPPORT VRAI DONNÉE (en date du 4 janvier 2016).
%   
%
%Sources:
%   - Écoulement d'air: http://www.lavionnaire.fr/AerodynEcoulAir.php
%   (consulé le 4 janvier 2016)
%
function  [S] = Surface_profile_balistique(profil_x, profil_y, azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air, est_pour_air_traverser, reset)
    %Obtention de R et de L à partir de profil_x et profil_y (car L peut ne
    %pas avoir été atteint dû à l'espacement choisit pour faire profil_x
    %avec L qui à été utilisé initialement).
    
    %Variable static seulement misent à jour si vide ou si reset = 1 (évite
    %de le refaire à chaque fois qu'on les appelles, soit à chaque point de
    %la trajectoire alors qu'il ne change pas en chemin).
    persistent aire_lat %Aire latéral
    persistent aire_x_plus %Aire si 100% selon l'axe X où X+ = la pointe et X- = la base (coordonnée cartésienne)
    persistent aire_x_moins 
    persistent aire_y %Aire si 100% selon l'axe Y où axe Y et Z sont autour du projectile
    persistent aire_z %Aire si 100% selon l'axe Z
    
    if reset == 1 || isempty(aire_lat)
        [aire_lat, aire_x_plus, aire_x_moins, aire_y, aire_z] = initialisation(profil_x, profil_y);
    end
    
    %-------------------
    %Calcule pour le cas où aire qu'on traverse en progressant dans le
    %fluide.
    if est_pour_air_traverser == 1
       S = aire_lat;
       return
    end
    
    %-------------------
    %Calcule pour cas où pour le vent (donc pas juste aire qu'on traverse).
    %Puisque face et arrière différent, switch pour si prend avant ou arrière.
    %NOTE: MÉTHODOLOGIE DE CALCULE INCERTAINE.
    
    %Calcule de la différence d'angle des directions:
    %   - Si même angle XY (ex.: Nord et Nord OU Sud et Sud):
    %       -> On obtient 0 degré, car pouse par en arrière (la base).
    %   - Si angle oposé XY (ex.: Nord et Sud):
    %       -> On obtient 180 degré, car pouse par en avant (direction
    %       trajectoire où progresse).
    %   - Si angle perpendiculaire(ex.: Nord et Est OU Nord et Ouest):
    %       -> On obtient 90 ou 270 degré, car pouse sur les côté.
    %
    diff_angle_xy = azimut_xy_dir_project - azimut_xy_ecoulement_air;
    if(diff_angle_xy < 0)
       diff_angle_xy = 2*pi + diff_angle_xy; %360-abs(angle négatif)
    end
    
    diff_angle_sol_z = angle_sol_z_project - angle_sol_z_ecoulement_air;
    if(diff_angle_sol_z < 0)
       diff_angle_sol_z = 2*pi + diff_angle_sol_z; %360-abs(angle négatif) 
    end
    
    %Calcule de l'air en fonction des angles selon le principe des vecteurs
    %que F_total = F_x + F_y + F_z où p = sqrt(aire_x^2 + aire_y^2 + aire_z
    %^2). Note: Se voit mieux si le voit seuelement en 2D avec X et Y.
    %Note: Vraiment INCERTAIN ICI !
    
    %L'aire selon l'axe X (où X+ = base et X- = la pointe)
    %Cas #1: la pointe en axe X
    if(diff_angle_xy > pi/2 || diff_angle_xy < 3*pi/2)
        S_x = abs(aire_x_moins*cos(diff_angle_xy)*cos(diff_angle_sol_z));
        
    %Cas #2: la base en axe X
    else
        S_x = abs(aire_x_plus*cos(diff_angle_xy)*cos(diff_angle_sol_z)); 
    end
    
    %L'aire selon l'axe Y et Z (les côtés)
    S_y = abs(aire_y*sin(diff_angle_xy)*cos(diff_angle_sol_z));
    S_z = abs(aire_z*sin(diff_angle_sol_z));
    
    %Calcule aire total (en se basant sur méthode avec les vecteurs, mais
    %incertain entre méthode vecteur et juste sommation des aires).
    S = sqrt(S_x^2 + S_y^2 + S_z^2);
end

%% Initialisation
%Description:
%   Initialise les différentes variables statiques lorsque appelées.
%   Cela permet d'éviter de recalculer à chaque fois ces valeurs alors que
%   cela n'est pas nécessaire puisqu'elle ne change pas entre les
%   différents appelles.
%
%   Voir bloc commentaire fonction Surface_profile_balistique, dans la
%   fonction, qui porte sur les diff_angle pour plus d'explication.
%
function [aire_lat, aire_x_plus, aire_x_moins, aire_y, aire_z] = initialisation(profil_x, profil_y)
   %L = profil_x(numel(profil_x));
   R = profil_y(numel(profil_y)); 
   
   [base] = calcul_aire_base(R);
   [aire_lat] = calcul_aire_lateral(profil_x, profil_y);
   
   %X+ = la base; X- = la pointe. Y = les côtés.
   aire_x_plus = base; %la base
   aire_x_moins = aire_lat; %la pointe
   aire_y = 0.5*aire_lat; %le côté
   aire_z = 0.5*aire_lat; %le côté
end

%% Aire base
%Description:
%   Fonction qui calcule l'aire de la base en supposant que le rayon est
%   constant en tout point (en date du 4 janvier 2016).
%
function [base] = calcul_aire_base(R)
    base = pi*R^2;
end

%% Aire latéral
%Description:
%   Fonction qui calcule l'aire latéral total à l'aide d'une intérgrale.
%   En effet, on peut voir situation comme étant soit un ensemble de 
%   cylindre infinimement mince (calcule simple, mais + approxe) soit un
%   ensemble de cône tronqué ayant une hauteur infinimement mince (calcul
%   plus long, mais plus préci). Note: Au cégep, équation du cône démontré
%   à l'aide de cylindre infiniment mince/haut. 
%
%   La méthode de calcule de l'intégrale utilisé ici est celle du
%   trapèze, car très simple, très rapide (presqu'aucune différence de
%   calcul supplémentaire par rapport à rectangle).
%
%
function [aire_lat] = calcul_aire_lateral(profil_x, profil_y)
    %Obtention des valeurs des aires latérale des cylindres (en excluant le
    %"dh" de l'équation de l'intégrale).
    y = 2*pi*profil_y;
    
    %Calcule de l'intégrale des aires latérales de chaque cylindre à l'aide
    %de la méthode du trapèze implémenté en ELE735 (qui considére un
    %espacement entre points en X et en Y comme pouvant être différents
    %entre chaque point, ce qui est moins performant (serait à améliorer
    %plus tard).
    
    choix = 3; %1=Rectangle; 2=MidPt; 3=Trapeze; 4=Simpson 1/3; 5=Simpson 3/8 
    
    [aire_lat] = intergral_num(profil_x, y, 0, choix);
end

