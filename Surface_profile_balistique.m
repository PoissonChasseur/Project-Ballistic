%% Surface_profile_balistique:
%Description:
%   Fonction qui, � l'aide du profil du projectile (valeur en X et Rayon Y
%   � chacun de ces points), va calculer la surface sur lequel s'applique
%   la force de l'air.
%
%   Cette fonction est n�cessaire � l'utilisation des profils balistiques
%   pour le calcul de la force de r�sistance de l'air.
%
%Param�tres:
%   - profil_x: les valeurs en X de 0 � L des points du profile dy
%   projectile.
%
%   - profil_y: les valeurs du Rayon � chacune des valeurs en X.
%
%   - azimut_dir_project: Azimut (reli� aux points cardinaux) de la 
%   direction vers lequel se dirige le projectile. EN RADIAN.
%
%   - azimut_ecoulement_air: Azimut (reli� aux points cardinaux) de la
%   direction de l'�coulement de l'air. EN RADIAN.
%
%   - est_pour_air_traverser: TRUE(oui) si c'est pour la surface qu'on
%   traverse en progressant dans le fluide. FALSE(non) si pas le cas.
%
%Note sur param�tres:
%   - profil_x (soit x) et profil_y (soit y) viennent de la fonction
%     "profil_balistique(r_n, L2, R2, p, Coeff_K, Coeff_n, Coeff_C, L, R,
%     precision_x, choix)"
%
%   - azimut_dir_project: L'orientation initiale (je pense) ou en temps
%   r�el. Est n�cesaire pour pouvoir d�finir l'orientation de la direction
%   vers lequel se dirige le projectile.
%
%   - azimut_ecoulement_air: L'orientation de l'ecoulement d'air par
%   rapport aux points cardinaux. Permet de se servir des points cardinaux
%   de l'orientation du vent sur la zone (ce qui est ind�pendant du
%   projectile). Est uniquement pour l'�coulement de l'air sur le plan X-Y,
%   ce qui exclue l'orientation pour vent ascendant ou descendant.
%
%M�thodologie de calcul actuelle (en date du 4 janvier 2017):
%   Le profile de la pointe balistique (sera racourci � balle) qu'on a
%   obtenue � l'aide de la fonction "profil_balistique" donne le rayon �
%   chacun des points de la longueur. 
%
%   La forme de la balle est approxim� comme ayant une base circulaire o�
%   l'on a un profil qui tourne autour de l'axe central de la longueur. Par
%   simplicit�, on va approximer la surface de la base � un cercle 
%   parfaitement plat, comme le sugg�re aussi le calcul du profil 
%   balistique (puisqu'on utilise actuellement un profil et un rayon R au 
%   lieu d'un vecteur de rayon R ET car on ne peut pas toujours mesurer ou
%   v�rifier que la surface de la base est parfaitement plate).
%   
%   3 cas de base peuvent visualis� (note: turbulence pas prit en compte):
%       #1) L'air uniquement de face (ex.: l'air travers� par la balle): 
%           L'air va s'appliquer sur 100% de la surface lat�ral.
%           La forme peut s'apperent� � demi-cercle (selon moi).
%
%       #2) L'air uniquement par l'arri�re (ex: vent derri�re le tireur):
%           L'air va s'appliquer sur 100% de la surface de la base (je
%           pense). La forme peut s'apparent� � un disque plat (selon moi).
%
%       #3) L'air uniquement par les c�t�s ou ascendant/descendant:
%           L'air va frapper environ 50% de l'air lat�ral et la forme sera
%           de la surface o� s'applique l'air sera �quivalent � plusieurs
%           cercle d'�paisseur infime (selon moi). Cela semble en accord
%           (selon mon interpr�tation) avec la source cit�.
%
%   � partir de ces 3 cas, on peut d�terminer la surface o� s'applique
%   l'air en utilisant le syst�me de coordonn�e sph�rique afin de pouvoir
%   couvrir tous les cas possibles d'�coulement d'air autour du projectile.
%   On r�fl�chie d'abord sur un plan X-Y et on extropole en ajoutant Z.
%   
%   Cependant, il est vrai que dans le cas de certaines informations, il
%   peut �tre complexe de les obtenir en temps r�el et il est possible
%   qu'elles devront �tre approxim� (ex: valeur constante ou 0 degr� en
%   tout temps ou l'angle de tir et l'angle inverse au tir -> id�e: droite
%   de la d�riv� de la position ? ...).
%   
%Note importante sur approximation des calculs:
%   #1) Orientation du vent:
%       Pour l'instant, on a seulement vent en X-Y, comme un mur d'air qui
%       se d�place de mani�re lin�aire, comme un mur, a travers le
%       projectile. La prise em consid�ration vent selon les 3 axes
%       donneraient de meilleur r�sultats.
%
%   #2) La surface de la base:
%       On approxime la surface de la base comme �tant un cercle � rayon
%       constant au lieu d'une ellipse (car rayon pas parfaitement constant)
%       ou d'un ellipsoide tronqu� (car surface par parfaitement plate).
%       Ceci est d� � une simplicit� de calcul et au fait que dans le cas
%       d'une balle, il n'est pas vraiment toujours possible de mesure � la
%       perfection la surface de la base de la balle (car on ne peut pas
%       l'enlever de la cartouche). De ce fait, on va l'approximer � un
%       cercle.
%
%   #3) Calcule de la surface:
%       On ne prend pas en compte l'�coulement de l'air autour de la
%       surface, comme celui d� au turbulence et � la train�e. On ne prend
%       en compte que la surface o� la force va principalement s'appliquer.
%       De plus, j'ai pos� que si 100% c�t� = 50% aire lat�ral (car exclue
%       base dite "100% lise et plate". Cependant, fait non fond�e et
%       possiblement une grossi�re approximation d� � turbulence et
%       �coulement autour des cercle. La source cit� semble en accord avec
%       cela (mais je peux avoir mal interpr�t� les informations).
%
%   #4) Obtention des mesures des azimut SOL-Z:
%       L'orientation des Azimuts pour le plan X-Y est assez facile �
%       obtenir, car c'est le genre de mesure habituelle. Le probl�me porte
%       sur l'orientation entre le plan XY et l'axe Z. Dans le cas de la
%       balle, c'est l'orientation de l'axe de la longueur par rapport au
%       sol, ce qui varie dans le temps. Dans le cas du vent, c'est pour le
%       vent ascendant et descendant qui peut lui aussi varier dans le
%       temps. Ces deux mesures sont pour l'instant (en date du 4 janvier
%       2017) assez incertain sur la mani�re de les obtenirs.
%
%Param�tres:
%   - profil_x et profil_y: valeur X et Y retourn� par la fonction
%   "profil_balistique" qui utilise (pr�cis� dans les param�tres) des
%   mesures en M�TRES.
%
%   - R: le rayon (consid�r� actuellement comme �tant constant en tout
%   point) de la base. Le m�me "R" que celui utilis� dans
%   "profil_balistique".
%
%   - azimut_xy_dir_project: Azimut (angle des points cardinaux) de la
%   direction o� se dirige le projectile. �quivalent de l'angle X-Y des
%   coordonn�es sph�rique et cylindrique. En RADIAN.
%
%   - angle_sol_z_project: Angle entre le sol et l'axe de la longueur du
%   projectile (coordonn�es sph�rique). En RADIAN.
%
%   - azimut_xy_ecoulement_air: Azimut (angle des points cardinaux) de la
%   direction o� se dirige le vent ou l'air travers� par le projectile. 
%   �quivalent de l'angle X-Y des coordonn�es sph�rique et cylindrique. En 
%   RADIAN.
%
%   - angle_sol_z_ecoulement_air: Angle sol-z (coordonn�es sph�rique) de 
%   l'�coulement de l'air (pour la partie du vent qui est ascendante ou 
%   descendante). En RADIAN.
%
%   - est_pour_air_traverser: TRUE/1 (VRAI/OUI) si c'est pour la surface
%   travers� par la balle qui progresse dans le fluide (ce qui va
%   directement vers le calcul correspondant). FALSE/0 (FAUX/NON) si ce n'est
%   pas le cas et donc, que c'est pour le vent.
%
%   - reset: TRUE/1 si on veut changer la valeurs des variables qui ne
%   change pas en cours au cours du calcul d'un projectile sp�cifique. Ex:
%   Si on fait pas "clear" en cours de route et qu'on veut faire le calcul
%   pour plus d'un projectile au cours de l'ex�cution du programme
%   (id�alement, faire un projectile � la fois et non en alternance).
%
%Retour:
%   S = la surface o� s'applique l'air, ce qui est utilis� pour le calcul
%   de la force de r�sistance de l'air (air travers� par la balle et le
%   vent qui pousse sur la balle).
%
%Note progression:
%   TEST� (donne un r�sultat et aire < cylindre lorsque devrait l'�tre)
%   JAMAIS V�RIFIER PAR RAPPORT VRAI DONN�E (en date du 4 janvier 2016).
%   
%
%Sources:
%   - �coulement d'air: http://www.lavionnaire.fr/AerodynEcoulAir.php
%   (consul� le 4 janvier 2016)
%
function  [S] = Surface_profile_balistique(profil_x, profil_y, azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air, est_pour_air_traverser, reset)
    %Obtention de R et de L � partir de profil_x et profil_y (car L peut ne
    %pas avoir �t� atteint d� � l'espacement choisit pour faire profil_x
    %avec L qui � �t� utilis� initialement).
    
    %Variable static seulement misent � jour si vide ou si reset = 1 (�vite
    %de le refaire � chaque fois qu'on les appelles, soit � chaque point de
    %la trajectoire alors qu'il ne change pas en chemin).
    persistent aire_lat %Aire lat�ral
    persistent aire_x_plus %Aire si 100% selon l'axe X o� X+ = la pointe et X- = la base (coordonn�e cart�sienne)
    persistent aire_x_moins 
    persistent aire_y %Aire si 100% selon l'axe Y o� axe Y et Z sont autour du projectile
    persistent aire_z %Aire si 100% selon l'axe Z
    
    if reset == 1 || isempty(aire_lat)
        [aire_lat, aire_x_plus, aire_x_moins, aire_y, aire_z] = initialisation(profil_x, profil_y);
    end
    
    %-------------------
    %Calcule pour le cas o� aire qu'on traverse en progressant dans le
    %fluide.
    if est_pour_air_traverser == 1
       S = aire_lat;
       return
    end
    
    %-------------------
    %Calcule pour cas o� pour le vent (donc pas juste aire qu'on traverse).
    %Puisque face et arri�re diff�rent, switch pour si prend avant ou arri�re.
    %NOTE: M�THODOLOGIE DE CALCULE INCERTAINE.
    
    %Calcule de la diff�rence d'angle des directions:
    %   - Si m�me angle XY (ex.: Nord et Nord OU Sud et Sud):
    %       -> On obtient 0 degr�, car pouse par en arri�re (la base).
    %   - Si angle opos� XY (ex.: Nord et Sud):
    %       -> On obtient 180 degr�, car pouse par en avant (direction
    %       trajectoire o� progresse).
    %   - Si angle perpendiculaire(ex.: Nord et Est OU Nord et Ouest):
    %       -> On obtient 90 ou 270 degr�, car pouse sur les c�t�.
    %
    diff_angle_xy = azimut_xy_dir_project - azimut_xy_ecoulement_air;
    if(diff_angle_xy < 0)
       diff_angle_xy = 2*pi + diff_angle_xy; %360-abs(angle n�gatif)
    end
    
    diff_angle_sol_z = angle_sol_z_project - angle_sol_z_ecoulement_air;
    if(diff_angle_sol_z < 0)
       diff_angle_sol_z = 2*pi + diff_angle_sol_z; %360-abs(angle n�gatif) 
    end
    
    %Calcule de l'air en fonction des angles selon le principe des vecteurs
    %que F_total = F_x + F_y + F_z o� p = sqrt(aire_x^2 + aire_y^2 + aire_z
    %^2). Note: Se voit mieux si le voit seuelement en 2D avec X et Y.
    %Note: Vraiment INCERTAIN ICI !
    
    %L'aire selon l'axe X (o� X+ = base et X- = la pointe)
    %Cas #1: la pointe en axe X
    if(diff_angle_xy > pi/2 || diff_angle_xy < 3*pi/2)
        S_x = abs(aire_x_moins*cos(diff_angle_xy)*cos(diff_angle_sol_z));
        
    %Cas #2: la base en axe X
    else
        S_x = abs(aire_x_plus*cos(diff_angle_xy)*cos(diff_angle_sol_z)); 
    end
    
    %L'aire selon l'axe Y et Z (les c�t�s)
    S_y = abs(aire_y*sin(diff_angle_xy)*cos(diff_angle_sol_z));
    S_z = abs(aire_z*sin(diff_angle_sol_z));
    
    %Calcule aire total (en se basant sur m�thode avec les vecteurs, mais
    %incertain entre m�thode vecteur et juste sommation des aires).
    S = sqrt(S_x^2 + S_y^2 + S_z^2);
end

%% Initialisation
%Description:
%   Initialise les diff�rentes variables statiques lorsque appel�es.
%   Cela permet d'�viter de recalculer � chaque fois ces valeurs alors que
%   cela n'est pas n�cessaire puisqu'elle ne change pas entre les
%   diff�rents appelles.
%
%   Voir bloc commentaire fonction Surface_profile_balistique, dans la
%   fonction, qui porte sur les diff_angle pour plus d'explication.
%
function [aire_lat, aire_x_plus, aire_x_moins, aire_y, aire_z] = initialisation(profil_x, profil_y)
   %L = profil_x(numel(profil_x));
   R = profil_y(numel(profil_y)); 
   
   [base] = calcul_aire_base(R);
   [aire_lat] = calcul_aire_lateral(profil_x, profil_y);
   
   %X+ = la base; X- = la pointe. Y = les c�t�s.
   aire_x_plus = base; %la base
   aire_x_moins = aire_lat; %la pointe
   aire_y = 0.5*aire_lat; %le c�t�
   aire_z = 0.5*aire_lat; %le c�t�
end

%% Aire base
%Description:
%   Fonction qui calcule l'aire de la base en supposant que le rayon est
%   constant en tout point (en date du 4 janvier 2016).
%
function [base] = calcul_aire_base(R)
    base = pi*R^2;
end

%% Aire lat�ral
%Description:
%   Fonction qui calcule l'aire lat�ral total � l'aide d'une int�rgrale.
%   En effet, on peut voir situation comme �tant soit un ensemble de 
%   cylindre infinimement mince (calcule simple, mais + approxe) soit un
%   ensemble de c�ne tronqu� ayant une hauteur infinimement mince (calcul
%   plus long, mais plus pr�ci). Note: Au c�gep, �quation du c�ne d�montr�
%   � l'aide de cylindre infiniment mince/haut. 
%
%   La m�thode de calcule de l'int�grale utilis� ici est celle du
%   trap�ze, car tr�s simple, tr�s rapide (presqu'aucune diff�rence de
%   calcul suppl�mentaire par rapport � rectangle).
%
%
function [aire_lat] = calcul_aire_lateral(profil_x, profil_y)
    %Obtention des valeurs des aires lat�rale des cylindres (en excluant le
    %"dh" de l'�quation de l'int�grale).
    y = 2*pi*profil_y;
    
    %Calcule de l'int�grale des aires lat�rales de chaque cylindre � l'aide
    %de la m�thode du trap�ze impl�ment� en ELE735 (qui consid�re un
    %espacement entre points en X et en Y comme pouvant �tre diff�rents
    %entre chaque point, ce qui est moins performant (serait � am�liorer
    %plus tard).
    
    choix = 3; %1=Rectangle; 2=MidPt; 3=Trapeze; 4=Simpson 1/3; 5=Simpson 3/8 
    
    [aire_lat] = intergral_num(profil_x, y, 0, choix);
end

