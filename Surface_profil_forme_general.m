%% Surface_profil_forme_general
%Description:
%   Dans le m�me ordre d'id�e que la fonction "Surface_profil_balistique",
%   cette fonction applique les m�mes m�thodologies de calcul pour des
%   formes de base en g�om�trie tel que:
%       - Cylindre
%       - Prisme rectangulaire (un cube si longueur X,Y,Z sont approxim�
%       comme �tant pareilles).
%       - Ellipsoide (une sph�re si on approxime les rayon en X,Y,Z comme
%       �tant pareille)
%       - Pyramide pour plusieurs base (inclue le c�ne)
%
%Utilit�:
%   L'id�al serait d'avoir un scanner pour mettre sous un mod�le 3D les
%   projectiles afin qu'on puisse par la suite calculer les aires des
%   surfaces. 
%   Le probl�me, c'est que je n'ai pas cela et le plus souvent, on peut
%   approximer la forme du projectile � l'aide d'une surface connue qui
%   englobe cette surface. De cette mani�re, on est capable d'obtenir des
%   aires de surface pour n'importe quel projectile, mais on va approximer
%   l'aire de la surface o� va s'appliquer cette force (comme la Force de
%   la r�sistance de l'air).
%   Le principe est notamment utilis� dans le jeux vid�o, l'id�e met venue
%   en �coutant des vid�os de la chaine "Pause Process" sur YouTube.
%
%NOTE IMPORTANTE SUR APPROXIMATION DES CALCULS - EFFET MAGNUS PAS PR�SENT:
%   � l'�tat actuelle (en date du 15 janvier 2017), on suppose que la forme
%   g�om�trique ne tourne pas autour de son axe de sym�trie (que se soit en
%   X, Y ou Z) et donc que les surfaces selon les axes X, Y et Z sont
%   toujours les m�mes.
%
%   En effet, en cas de rotation, le calcul devra changer et dependra
%   notamment (par exemple) d'un point de r�f�rence qui d�pendant de sa
%   position (d� � la vitesse de rotation) servira � d�terminer l'aire
%   qu'on a selon chacun des axes.
%
%   L'ajout de la prise en compte de l'effet Magnus aura pour cons�quence
%   le besoin de prendre en compte cela, ce qui ne sera pas le cas avec les
%   profiles balistiques (puisque rotation autour axe de la largeur n'est
%   g�n�ralement pas possible et rotation sur axe de la longueur n'a pas de
%   cons�quence sur le calcul des autres surfaces).
%
%Param�tres g�n�raux (pour toutes les formes utilis�):
%   - Choix: pour choisir la forme o�:
%       - 1 = Prisme rectangulaire � plat
%           - PAS effet Magnus (ne tourne pas sur lui-m�me)
%           - Envoye dans la direction de l'axe de la longueur
%           - La surface o� repose son poid est celle d�finit par :
%           longueur*largeur.
%       
%       - 2 = Sph�re (ou ellipsoide approximer comme �tant une sph�re):
%
%       - 3 = Ellipsoide (EN COURS)
%
%       - 4 = Cylindre � base circulaire:
%           - Pas de rotation autour de l'axe perpendiculaire � celui de la
%           longueur
%           - Cylindre project� selon le sens de la longueur.
%       
%       - 5 = Cylindre � base elliptique:
%           - Pas de rotation autour de l'axe perpendiculaire � celui de la
%           longueur
%           - Cylindre project� selon le sens de la longueur.
%       
%       - 6 = Pyramide r�gulier � base de polygone r�gulier convexe
%
%
%       
%       
function [S] = Surface_profil_forme_general(longueur, largeur, hauteur, apotheme_triangle, Rayon_grand, Rayon_petit, nb_cote, nbpt_integral, choix_integral, azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air, reset)
    persistent aires_surfaces;
    
    %Calculs des aires des surfaces si pas d�j� fait OU si reset === 1
    if(reset == 1 || isempty(aires_surfaces))
        switch(choix)
            case 1 %Prisme rectangulaire � plat SANS effet Magnus
                %aire_surfaces = [aire_x, aire_y, aire_z]
                aires_surfaces = surfaces_prisme_rectangulaire(longueur, largeur, hauteur);
                
            case 2 %Sph�re
                %aire_surfaces = [aire_x, aire_y, aire_z]
                aires_surfaces = surface_sphere(rayon);
                
            case 3 %Ellipsoide SANS effet Magnus
                disp('Surface_profil_forme_general: ELLIPSOIDE EN COURS');
                aires_surfaces = 0;
                
            case 4 %Cylindre � base circulaire SANS effet Magnus
                aires_surfaces = surface_cylindre_base_circulaire(longueur, rayon);
                
            case 5 %Cylindre � base Elliptique SANS effet Magnus
                aires_surfaces = surface_cylindre_base_elliptique(longueur, Rayon_grand, Rayon_petit, nbpt_integral, choix_integral);
                
            case 6 %Pyramide r�guli�re � base de polygone r�gulier convexe SANS effet MAGNUS
                %NOTE: CALCULS aire_y et aire_z INVALIDE LA PLUPART DU
                %TEMPS.
                %[aire_x_plus, aire_x_moins, aire_y, aire_z]
                aires_surfaces = surface_pyramide_regulier_base_polygone_regulier_convexe(nb_cote, longueur, hauteur, apotheme_triangle);
                
                
                
        end
    end
    
    %Calcul de la surface total o� s'applique cette force (o� aire_surfaces
    %ne change pas si pas besoin d'�tre recalculer).
    switch(choix)
        case 1 %Prisme rectangulaire � plat SANS effet Magnus
            [S] = calcul_aires_symetrie_axe_x_y_z(aires_surfaces(1), aires_surfaces(2), aires_surfaces(3), azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air);
            
        case 2  %Sph�re
            [S] = calcul_aires_symetrie_axe_x_y_z(aires_surfaces(1), aires_surfaces(2), aires_surfaces(3), azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air);
            
        case 3  %Ellipsoide SANS effet Magnus
            %EN COURS
            S = 0;
            
        case 4 %Cylindre � base circulaire SANS effet Magnus
            [S] = calcul_aires_symetrie_axe_x_y_z(aires_surfaces(1), aires_surfaces(2), aires_surfaces(3), azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air);
            
            
        case 5 %Cylindre � base elliptique SANS effet Magnus
            [S] = calcul_aires_symetrie_axe_x_y_z(aires_surfaces(1), aires_surfaces(2), aires_surfaces(3), azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air);
            
        case 6 %Pyramide r�guli�re � base de polygone r�gulier convexe SANS effet MAGNUS
            [S] = calcul_aires_symetrie_axe_y_z_pas_x(aires_surfaces(1), aires_surfaces(2), aires_surfaces(3), aires_surfaces(4), azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air);
            
            
            
    end
    
end

%% Calculs des surfaces - CAS o� sym�tries selon axes X, Y et Z 
%Description:
%   M�thologie copie-coller de celle utilis� dans
%   "Surface_profile_balistique", mais simplifi�e par rapport aux cas o� la
%   surface o� s'applique la force est la m�me pour les deux c�t�s (sens
%   positif et n�gatif) des 3 axes.
%
%   Si la m�thodologie de calcul de "Surface_profile_balistique" change, il
%   faudra r�viser le calcul qu'il y a ici. Celui ici vient de la
%   m�thologie qui �tait pr�sente en date du 15 janvier 2017 (o� derni�re
%   modification de "Surface_profile_balistique" (selon date �crite l�)
%   vient du 4 janvier 2017).
%
function [S] = calcul_aires_symetrie_axe_x_y_z(aire_x, aire_y, aire_z, azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air)
    
    %CODE COPIE-COLLER ET UN PEU MODIFIER DE "Surface_profile_balistique"
    
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
    %^2). Note: Se voit mieux si le voit seulement en 2D avec X et Y.
    %Note: Vraiment INCERTAIN ICI !
    
    %L'aire selon l'axe X, Y et Z sont toujours les m�mes, qu'on soit en
    %[X+ ou X-], [Y+ ou Y-], [Z+ ou Z-]
    S_x = abs(aire_x*cos(diff_angle_xy)*cos(diff_angle_sol_z));
    S_y = abs(aire_y*sin(diff_angle_xy)*cos(diff_angle_sol_z));
    S_z = abs(aire_z*sin(diff_angle_sol_z));
    
    %Calcule aire total (en se basant sur m�thode avec les vecteurs, mais
    %incertain entre m�thode vecteur et juste sommation des aires).
    S = sqrt(S_x^2 + S_y^2 + S_z^2);
end

%% Calculs des surfaces - SYM�TRIES EN Y et Z, mais pas en X
%Description:
%   M�thologie copie-coller de celle utilis� dans
%   "Surface_profile_balistique" o� l'aire de la surface en X+ est
%   diff�rentes de celle en X- (o� l'axe X et Y sont d�finit par la
%   diff�rences d'angles des azimuts ET non par choix arbitraire).
%
%   Si la m�thodologie de calcul de "Surface_profile_balistique" change, il
%   faudra r�viser le calcul qu'il y a ici. Celui ici vient de la
%   m�thologie qui �tait pr�sente en date du 15 janvier 2017 (o� derni�re
%   modification de "Surface_profile_balistique" (selon date �crite l�)
%   vient du 4 janvier 2017).
%
function [S] = calcul_aires_symetrie_axe_y_z_pas_x(aire_x_plus, aire_x_moins, aire_y, aire_z, azimut_xy_dir_project, angle_sol_z_project, azimut_xy_ecoulement_air, angle_sol_z_ecoulement_air)
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


%% Surface Prisme Rectangulaire
%Description:
%   Fonction qui renvoie l'aire de la surface o� s'applique la force sur un
%   prisme rectangulaire
%
%SITUATION ACTUELLE:
%   - PAS d'effet Magnus (ne tourne pas sur lui-m�me = toujours les m�mes
%   surface qu'on regarde lorsque l'observateur ne bouge pas)
%   - Le projectile est envoy� dans la direction de l'axe de la longueur
%   - Son poids repose uniquement selon la surface d�finit par:
%   longueur*largeur.
%
%Param�tres:
%   - longueur (en m)
%   - largeur (en m)
%   - hauteur (en m)
%
function [aire_x, aire_y, aire_z] = surfaces_prisme_rectangulaire(longueur, largeur, hauteur)
    aire_x = largeur*hauteur; %aire_x = avant et arri�re du prisme
    aire_y = longueur*hauteur; %aire_y = c�t� gauche et droite du prisme
    aire_z = longueur*largeur; %aire_z = haut et bas du prisme
end

%% Surface sph�re
%Description
%   Fonction qui fait le calcul des aires en x,y,z (tous pareilles) pour
%   une sph�re (car calcul plus simple qu'avec un ellipsoide)
%
%NOTE APPROXIMATION:
%   On suppose que la surface o� s'applique l'air est toujours 50% de
%   l'aire total.
%
%Param�tres:
%   - rayon: Le rayon qu'on approxime comme �tant constant en tout point
%   autour du centre.
%
%Sources:
%   - https://fr.wikipedia.org/wiki/Sph%C3%A8re (consult� le 15 janvier
%   2017)
%
function [aire_x, aire_y, aire_z] = surface_sphere(rayon)
    aire_total = 4*pi*rayon^2;
    aire_x = 0.5*aire_total; %50% de l'aire total = 50% aire lat�ral
    aire_y = aire_x;
    aire_z = aire_x;
end

%% Surface cylindre � base circulaire
%Description:
%   Fonction qui calcul la surface en X,Y,Z o� s'applique la force selon
%   chacun des axes pour un cylindre � base circulaire (cylindre
%   habituelle).
%
%   Cylindre project� selon l'axe de la longueur. Peut tourner autour de
%   l'axe de la longueur (cela ne changera pas le calcul des aires), mais
%   pas autour de celui perpendiculaire � cet axe (car changerais le calcul
%   des aires).
%
%Param�tre:
%   - Longueur: la longueur/hauteur du cylindre
%   - Rayon: le rayon du cercle de la base
%
%Source:
%   - https://www.assistancescolaire.com/eleve/5e/maths/reviser-une-notion/construire-l-aire-laterale-d-un-prisme-droit-ou-d-un-cylindre-5mso05
%   (consult� le 15 janvier 2017) 
%
function [aire_x, aire_y, aire_z] = surface_cylindre_base_circulaire(longueur, rayon)
    circonference = 2*pi*rayon;
    aire_x = pi*rayon^2; %Aire de la base
    aire_y = 0.5*(circonference*longueur); %aire_y et aire_z = 50% aire lat�ral.
    aire_z = aire_y;
    
end

%% Surface cylindre � base elliptique
%Description:
%   Fonction qui calcul la surface en X,Y,Z o� s'applique la force selon
%   chacun des axes pour un cylindre � base elliptique (au lieu de
%   circulaire)
%
%   Cylindre project� selon l'axe de la longueur. Peut tourner autour de
%   l'axe de la longueur (cela ne changera pas le calcul des aires), mais
%   pas autour de celui perpendiculaire � cet axe (car changerais le calcul
%   des aires).
%
%Param�tres:
%   - Longueur: la longueur/hauteur du cylindre
%   - Rayon_grand_axe: Le rayon selon le plus grand des axes de la base
%   - Rayon_petit_axe: Le rayon selon le plus petit des axes de la base
%
%Sources:
%   - https://fr.wikipedia.org/wiki/Ellipse_(math%C3%A9matiques) (consult�
%   le 15 janvier 2017)
%
%   - https://www.assistancescolaire.com/eleve/5e/maths/reviser-une-notion/construire-l-aire-laterale-d-un-prisme-droit-ou-d-un-cylindre-5mso05
%   (consult� le 15 janvier 2017)
%
function [aire_x, aire_y, aire_z] = surface_cylindre_base_elliptique(longueur, R_grand, R_petit, nb_points_integral, choix_integral)
    %V�rification et modification en cas d'erreur de positionnement des
    %valeurs en grand et petit rayon.
    if(R_petit > R_grand)
       tempo = R_grand;
       R_grand = R_petit;
       R_petit = tempo;
    end
    
    %Calcul de l'Excentricit� "e" (+ fonction pour �viter division par 0)
    excencitricite = sqrt(1-(division_nb(R_petit, R_grand))^2);
    
    %Calcul de la circonf�rence d'int�grale (m�thode avec s�rie, mais ayant
    %convergence par toujours bonne, aussi disponible).
    %L'autre version de l'int�grale disponible utilie un sinus^2.
    x = linspace(0,1,nb_points_integral);
    y = sqrt(1-excencitricite^2*x.^2);
    y = y./(sqrt(1-x.^2));
    funct = @(x) sqrt(1-excencitricite^2*x.^2)./sqrt(1-x.^2);
    
    [circonference] = intergral_num(x, y, funct, choix_integral);
    circonference = 4*R_grand*circonference;
    
    %Calcul des aires
    aire_x = pi*R_grand*R_petit; %aire_x = aire de la base
    
    aire_y = 0.5*(longueur*circonference); %aire_y et aire_z = 50% aire lat�ral.
    aire_z = aire_y;
end

%% C�ne r�gulier � base de polygone r�gulier convexe
%Description:
%   Fonction qui calcule les aires dans le cas d'une Pyramide r�guli�re. Le
%   calcule est fait pour �tre applicable pour n'importe quel polygone
%   r�gulier convexe (soit des formes ayant "n" cot� de longueur "a" dont
%   la somme des angles internes = 360 degr�). 
%   
%   Ex. de base valide: rectangle (n=3), carr� (n=4), heptagone (n=5),
%   hexagone (n=6), heptagone (n=7), octogone (n=8), ...
%
%NOTE SUR APPROXIMATION DES CALCULS:
%   D�pendant de l'orientation de la pyramide, l'aire expos� � la force en
%   pr�sence va grandement varier et faire uniquement
%   50%*aire_lateral_total et une approximation � certain cas pr�ci.
%
%   Ex.: Pyramide � base carr�. Je peux avoir seulement 1 des triangles
%   expos� (aire_lat�ral = aire triangle) OU exactement � 45 degr� = 2
%   triangles OU un entre deux o� aura partiellement les deux triangles.
%   Avec un base tringulaire, un peu avoir (ex) y = un triangle et z = 2
%   triangles.
%   
%   Avec plus de c�t�, le nombre de triangles varie et avec un rotation
%   autour de l'axe de la longuer, c'est encore pire.
%
%   Ainsi, le calcul utilis� pour d�terminer aire_y et aire_z n'est
%   vraiment pas pr�ci et valide, mais peut suffire pour l'instant (dans
%   l'objectif de progresser de revenir sur cela plus tard).
%
%Param�tres:
%   - nb_cote : le nombre de cot� qu'� le polygone r�gulier convexe
%   - longueur_cote: la longueur qu'on tous les "n" cot�.
%   
%   Ensuite, 2 possibilit� (d�pendant des donn�es disponible):
%       - hauteur: la hauteur total de la pyramide (par rapport � son 
%         centre)
%       - apotheme_triangle: la longueur entre [le milieu de l'un des c�t�]
%         et le sommet.
%       - Note: Mettre � '' celui inconnue. V�rification d�bute avec
%       apotheme.
%   Note: Si on a la hauteur, on va faire des calculs pour obtenir
%   l'apotheme (car c'est elle qu'on a besoin par la suite).
%
%Sources:
%   - https://fr.wikipedia.org/wiki/Pyramide (consult� le 15 janvier 2017)
%   - http://www.alloprof.qc.ca/BV/pages/m1485.aspx (consult� le 15 janvier
%   2017)
%   - https://fr.wikipedia.org/wiki/Apoth%C3%A8me (consult� le 15 janvier
%   2017)
%   - https://fr.wikipedia.org/wiki/Polygone_r%C3%A9gulier#Polygones_r.C3.A9guliers_convexes
%   (consult� le 15 janvier 2017)
%
function [aire_x_plus, aire_x_moins, aire_y, aire_z] = surface_pyramide_regulier_base_polygone_regulier_convexe(nb_cote, longueur_cote, hauteur, apotheme_triangle)
    
    apotheme_base = longueur_cote/(2*tan(pi/nb_cote));
    
    %V�rification si on a soit apotheme, soit la hauteur
    if(isempty(apotheme_triangle) && not(isempty(hauteur)))
        apotheme_triangle = sqrt(hauteur^2 + apotheme_base^2);
    else
       disp('surface_pyramide_regulier_base_polygone_regulier_convexe: bespon de hauteur OU apotheme');
       aire_x_plus = 0;
       aire_x_moins = 0;
       aire_y = 0;
       aire_z = 0;
       return
    end
    
    aire_triangle_base = longueur_cote*apotheme_base/2; % (base*hauteur)/2
    aire_base = nb_cote*aire_triangle_base;
    
    %aire_lateral = (perimetre_base * apothme_triangle_pointe)/2
    aire_lateral = (nb_cote*longueur_cote)*apotheme_triangle/2;
    
    %Calcul des aires selon les 3 axes (dans le m�me format qu'avec les
    %calculs de la fonction utilis� dans "Surface_profile_balistique", soit
    %la pointe vers X- et la base vers X+.
    aire_x_plus = aire_lateral;
    aire_x_moins = aire_base;
    
    %Calcul aire_y et aire_z INVALIDE la plupart du temps (� CORRIG� PLUS
    %TARD).
    aire_y = 0.5*aire_lateral;
    aire_z = 0.5*aire_lateral;
end

%% Surface Ellipsoide
%Description:
%   Fonction qui donne les aires des surfaces pour un Ellipsoide, soit
%   une forme qui s'apparente � un ovale en 3D. Si les rayons en X, Y et Z
%   sont pareilles, on alors une sph�re.
%
%SITUATION ACTUELLE:
%   - PAS d'effet Magnus (ne tourne pas sur lui-m�me = toujours les m�mes
%   surface qu'on regarde lorsque l'observateur ne bouge pas)
%   - Le projectile est envoy� dans la direction de l'axe de la longueur
%   - Son poids repose uniquement selon la surface d�finit par:
%   longueur*largeur.
%
%�quation param�trique habituelle:
%   x = a*cos(angle_1)*cos(angle_2) + pos_centre_x
%   y = b*cos(angle_1)*sin(angle_2) + pos_centre_y
%   z = c*sin(angle_1) + pos_centre_z
%   o� angle_1 = [-pi/2, pi/2] et angle_2 = [-pi, pi]
%   a = demi-longueur en x, b = demi-longueur en y, c = demi-longeur en z.
%
%Param�tres:
%   - longueur_x = longueur total selon le sens de la longueur = 2*a
%   - longueur_y = longueur total selon le sens de la largeur = 2*b
%   - longueur_z = longueur total selon le sens de la hauteur = 2*c
%   Note: longueur par rapport au fait que le centre est � l'origine.
%
%Sources:
%   - https://fr.wikipedia.org/wiki/Ellipso%C3%AFde (consult� le 15 janvier
%   2017)
%   NOTE: Source 1 parle aussi de calcul de centre de masse et d'Inertie
%   (possiblement utile pour calcul de effet Magnus ou plus pr�cision dans
%   mes calculs).
%
%   - https://fr.wikipedia.org/wiki/Aire_de_surfaces_usuelles (consult� le
%   15 janvier 2017)
%
%   - https://fr.wikipedia.org/wiki/Ellipse_(math%C3%A9matiques) (consult�
%   le 15 janvier 2017)
%
%   - http://mathworld.wolfram.com/PappussCentroidTheorem.html (consult� le
%   15 janvier 2017)
%
%   - https://fr.wikipedia.org/wiki/Th%C3%A9or%C3%A8mes_de_Guldin (consult�
%   le 15 janvier 2017)
%
%   - https://en.wikipedia.org/wiki/Pappus%27s_centroid_theorem (consult�
%   le 15 janvier 2017)
%
%   - https://fr.wikipedia.org/wiki/Surface_de_r%C3%A9volution (consult� le
%   15 janvier 2017)
%
function [aire_x, aire_y, aire_z] = surfaces_ellipsoide(longueur_x, longueur_y, longueur_z)
    %
    %EN COURS... (pas aussi simple que ce que je pensais au d�but)
end