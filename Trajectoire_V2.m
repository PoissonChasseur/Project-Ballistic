%% Trajectoire_V2:
%Description:
%   M�thodologie de calcul final (pour l'instant) qui r�sout les EDO
%   d'ordre 2 de la vitesse et les EDO d'ordre 1 de la position afin
%   d'obtenir les valeurs de la vitesse et de la position pour chacune des
%   valeurs du temps. La m�thodologie de calcul est expliqu� plus loin.
%          
%M�thodologie de calcul pour r�soudre le syt�me d'EDO ordre 2 et ordre 1:
%   Dans notre calcul, on cherche � obtenir (au minimum) la position
%   (en x,y,z) � chaque moment du temps. En partant de la lois de Newton
%   F = m*a et du fait qu'on 3 axes, on a 3 �quations de l'acc�l�ration.
%   
%   L'acc�l�ration est la d�riv� de la vitesse en fonction du temps
%   (a = d(v)/dt) et la vitesse est la d�riv� de la position en fonction du
%   temps (v = d(pos)/dt). De mani�re analythique, on doit d'abord r�soudre
%   les EDO de l'acc�l�ration pour obtenir les vitesses 
%   (a = d(v)/dt = f_v o� f_v = (1/m)*Sum(Forces)) suivie des EDO de la 
%   vitesse pour obtenir les positions (v = d(pos)/dt = f_pos o� f_pos = v).
%
%   Dans notre calcul, on a 3 EDO ordre 2 (� partir acc�l�ration en x,y,z)
%   � 6 variables (v_x, v_y, v_z + x,y,z d� aux constantes qui utilise la
%   position) ET 3 EDO d'ordre 1 (x,y,z) qui d�pendant aussi des m�mes
%   constantes qui varient selon la position.
%
%   De mani�re analythique, le calcul est tr�s complexe et long �
%   effectuer. Par m�thode num�rique, une fois la m�thodologie �tablie,
%   cela se fait tr�s facilement d� au fait qu'on ne manipule que des
%   chiffres ainsi que {donn�e(i), donn�e(i+1)}. De ce fait, on a qu'on a
%   calcul� les v(i+1) et les pos(i+1) � partir des v(i) et pos(i) qui 
%   sont aussi utilis� pour calculer les constantes ratach� � ces donn�es
%   actuelles. Ces constantes sont par exemple la masse volumique de l'air,
%   la temp�rature, la pression, etc.
%
%   Le premier syst�me est le syst�me d'EDO d'ordre 2 (exprim� sous forme 
%   d'ordre 1 via passe-passe des constantes), soit les vitesses.
%   m*a = sum(Forces) -> a = d(v)/dt = (1/m)*sum(Forces) o� on a 
%   d(v_x)/dt, d(v_y)/dt et d(v_z)/dt. (1/m)*sum(Forces) = f(t,...) qui
%   sont les fonctions � utiliser dans la r�solution d'une EDO d'ordre 1.
%   
%   Le deuxi�me syst�me est le syst�me d'EDO d'ordre 1 de la position.
%   v = d(pos)/dt o� v = f_pos(t, ...).
%
%   Ainsi, cela se r�sout plut�t bien, car dans les deux cas, on
%   utilise uniquement la position et la vitesse actuelle pour le calcul de
%   la vitesse et de la position suivante. Cela va de m�me pour les
%   constantes. Ainsi, l'ordre entre [calcul vitesse] et [calcul position]
%   n'a pas d'importances, mais il faut les faire dans la m�me boucle du
%   calcul de la vitesse et de la position suivante. � des fins de
%   simplicit� et de coh�rence par rapport � la m�thode analithyque, j'ai
%   choisit de prendre le m�me ordre qu'avec la m�thode analithyque, soit
%   la vitesse suivie de la position.
%
%   � la fin, il suffit de calculer les constantes pour le point (vitesse
%   et position) suivant, comme on fait aussi en transf�rant la valeur du
%   suivant � la valeur actuelle.
%
%   Ainsi, notre calcul se fait en quelques �tapes (o� les �tapes #2.1 et
%   #2.2 peuvent �tre invers�):
%       #1) L'initialisation:
%           - valeur des conditions initiales
%           - valeur des constantes qui ne change pas (ex: Aire lat�ral)
%           - calcul des autres aspects pr�liminaires
%
%       #2) Boucles pour l'ensemble des points (s'arr�te lorsque condition
%       d'arr�t valide [ex: � atteint la cible]):
%           #2.1) Calcul syst. EDO ordre 1 de la vitesse suivante V[i+1]
%           #2.2) Calcul syst. EDO ordre 1 de la position suivante Pos[i+1]
%           #2.3) Pos[i] = Pos[i+1] ET V[i] = V[i+1]
%           #2.4) Calcul des constantes pour la nouvelle positions et
%           vitesses.
%
%   Cette d�marche math�matiques � �t� longuement r�fl�chie et devrait bien
%   se faire. Il faudra copier-coller et arranger un peu, � l'aide de
%   d�coupage du code en plusieurs fonctions, le calcul qui avait �t� fait
%   pour r�soudre un syst�me d'EDO d'ordre 1 (ex.: code de 1 point syst.
%   EDO ordre 1 mit dans une fonction qu'on peut appeler ensuite pour
%   calcul de Pos et calcul de V au lieu de recopier 2 fois tout ce
%   calcul).
%
%   Le d�coupage en plusieurs fonctions permettra de rendre le code plus
%   lisible et plus facile � retravailler et � corriger plus tard en cas de
%   probl�me (ex.: modifier le calcul de V_z pour ajouter plus de
%   pr�cision).
%
%M�thode de r�solution d'EDO utilis� (actuellement):
%   La m�thode de r�solution de syst�me d'EDO d'ordre 1 utilis� est la 
%   m�thode de Runge-Kutta d'ordre 4 car,
%       #1) Ordre 4 contient ordre 3, 2 et 1
%       #2) Ordre 2 contient aussi Euler modifi� et Midpt.
%   De ce fait, on englobe le plus de possibilit� et c'est la plus
%   complexe. Je pr�f�re partir du compliqu� et ensuite aller vers le
%   simple plut�t que l'inverse.
%
%   Le code utilis� est (pour l'instant) un copie-coller du code de "Outils
%   ELE735" o� on a seulement enlever l'utilisation de la fonction "eval_f"
%   d� au fait qu'on a directement des chiffres au lieu de fonction de
%   forme (ex.) "f = @(x,y,z) ...".
%
%Param�tres:
%   - Param�tres de base pour le calcul avec m�thodologie utilis�:
%       - temps: vecteur de [0, temps_max] qui permet de sp�cifier la
%       groseur des matrices des r�sultats obtenues et de d�limit�s un
%       taille maximale au cas o� n'atteint jamais la cible.
%
%       - masse: la masse du projectile (pourrait changer dans le temps, si
%       le cas, sera masse initiale et ajout code dans 3�me partie boucle �
%       faire).
%
%       - pos_init: [pos_x, pos_y, pos_z] de la position initiale.
%
%       - vitesse_init: [v_x, v_y, v_z] de la vitesse initiale.
%
%       - Coeff_RK_a, Coeff_RK_b, Coeff_RK_c: Les coefficients a, b et c de
%       la m�thode de Runge-Kutta pour r�soudre EDO d'ordre 1.
%
%       - pos_cible: [pos_cible_x, pos_cible_y, pos_cible_z]: la position
%       de la cible afin qu'on arr�te la boucle de calcul des points de
%       position et de vitesse lorsqu'on a soit atteint la cible, soit
%       atteint la dur�e maximale qui � �t� choisit.
%
%       - pourcentage_marge_erreur: le % d'erreur acceptable atour du point
%       de la cible. Ex.: avec 5%, on consid�re que si le projectile se
%       trouve dans la sph�re autour du point de la cible
%       [x +/- 5%, y +/- 5%, z +/- 5%], on a atteint la cible (n�cessaire
%       d� au fait que �galit� avec nombre flottant impossible).
%
%   - Param�tres pour calculs de la vitesse, de la position et des
%   constantes qui varie selon vitesse ou/et position:
%       - azimut_init: L'orientation des Points Cardinaux au d�but
%       - latitude_init: La latitude initiale
%       - 
%
%Note de d�v�loppement:
%   �tape #1: La m�thodologie de calcul:
%       La m�thodologie de calcul (exclue les calculs effectu�s par les
%       fonctions � l'ext�rieur de ce fichier en lien avec les forces). 
%       � �t� tester, corrig� et valider (� premi�re vue). Sans aucune
%       autre fonction utilis�: fonctionne parfaitement bien et semble
%       valide. Test� avec acc�l�ration constante de 1 en x, y, z.
%
%   �tape #2: La gravit�:
%       J'ai ajout� la force de Gravit� dans le calcul de F_z et les
%       r�sultats obtenues (la forme de la trajectoire) semble valide.
%
%   �tape #3: La force de Coriolis:
%       J'ai ajout� la force de Coriolis dans les calculs de F_x,F_y,F_z.
%       On remarque une tr�s l�g�re acc�l�ration qui va causer une l�g�re
%       d�viation (sur de courte distance). J'ai rev�rifier les calculs et
%       ils semblent valides.
%
%   �tape #4: La force de r�sistance de l'air (celle travers� lors du
%   d�placement):
%       EN COURS...
%       J'ai ajout� la fonction "Surface_profil_forme_general" pour ajout�
%       des formes g�n�ral (note: � AM�LIORER). J'ai regarder un peu
%       "Force_resistance_air", mais elle est � am�liorer, car
%       actuellement, vraiment incertain pour Cx et elle ne pourra faire
%       que la balistique (pour l'instant).
%
%       ON EST RENDU ICI: Am�liorer "Force_resistance_air".
%       
%
%
%Retour:
%   1�re ligne (pour  les deux matrices): le temps.
%   2�me ligne: position ou vitesse en X (selon la matrice utilis�).
%   3�me ligne: position ou vitesse en Y (selon la matrice utilis�).
%   4�me ligne: position ou vitesse en Z (selon la matrice utilis�).
%
function [position, vitesse] = Trajectoire_V2(temps, masse, pos_init, latitude_init, azimut_init, vitesse_init, pos_cible, pourcentage_marge_erreur, Coeff_RK_a, Coeff_RK_b, Coeff_RK_c)    
    %% Initialisation: Assignation des variables avant d�but calcul via C.I.
    %Variables avec v�rification atteintes de la cible
    size_pos_cible = size(pos_cible);
    
    %Si le vecteur pos_cible est un vecteur line -> le mettre en vecteur
    %colonne (car vecteur utilis� dans boucle est un vecteur colonne).
    if(size_pos_cible(1) == 1)
        pos_cible = transpose(pos_cible);
    end
    
    %Calcul des valeurs initiales des constantes en fonctions de la vitesse
    %et de la position initiale
    [g, Fc] = Calcul_constantes(masse, vitesse_init(2:numel(vitesse_init)), pos_init, latitude_init, azimut_init);
    
    
    
    %R�sultat des diff�rentes fonctions avec C.I. = n'aura pas � faire 
    %eval_f dans calcul des EDO, mais doit r�p�ter ces 5 lignes � chaque 
    %fois (celle pos par contre un peut modifier).
    [f_vx] = Sum_forces_acceleratiom_x(masse, Fc);
    [f_vy] = Sum_forces_acceleratiom_y(masse, Fc);
    [f_vz] = Sum_forces_acceleratiom_z(masse, g, Fc);
    list_f_v = {f_vx, f_vy, f_vz}; %Liste des fonctions pour EDO de d(v)/dt
    list_f_pos = {vitesse_init(2), vitesse_init(3), vitesse_init(4)}; %Liste des fonction pour EDO de d(pos)/dt o� 1er = t_init suivie des vitesses (colonne 2,3,4)
    
    %Nb ligne = la ligne de T + les lignes des nb fonction. Nb colonne = Nb point.
    vitesse = zeros(numel(list_f_v)+1, numel(temps));
    position = zeros(numel(list_f_pos)+1, numel(temps));
    
    %Calcul des constantes � partir des C.I.
    %[g] = Calcul_constantes(vitesse, position);
    
    %% D�but des calculs:
    vector_value_f_v = vitesse_init;
    vector_value_f_pos = pos_init;
    
    vitesse(:,1) = vitesse_init(:);
    position(:,1) = pos_init(:);
    
    a = Coeff_RK_a;
    b = Coeff_RK_b;
    c = Coeff_RK_c;
    
    i = 1;
    arret = 0;
    while(i <= (numel(temps)-1) && arret == 0) 
        %Calcul de l'espacement entre les donn�es (h)(m�thode pour h !=
        %cte, mais nb point maximal connue).
        h = temps(i+1) - temps(i);
        
        %Calcul des donn�es suivantes (le y[i+1])
        [mat_next_f_v] = syst_edo_order2_Runge_Kutta_order4(vector_value_f_v, list_f_v, a, b, c, h);
        [mat_next_f_pos] = syst_edo_order2_Runge_Kutta_order4(vector_value_f_pos, list_f_pos, a, b, c, h);
        
        %Donn�es actuelle = Donn�es suivante (y[i] = y[i+1])
        vector_value_f_v(:) = mat_next_f_v(:);
        vector_value_f_pos(:) = mat_next_f_pos(:);
        
        %Enregistrement de la donn�es
        vitesse(:, i+1) = mat_next_f_v;
        position(:, i+1) = mat_next_f_pos;
        
        %Calcul des constantes en fonction des vitesses et position
        %suivante (ex.: gravit�, masse (si varie dans le temps), masse
        %volumique de l'air, etc).
        [g, Fc] = Calcul_constantes(masse, vector_value_f_v(2:numel(vector_value_f_v)), vector_value_f_pos, latitude_init, azimut_init);
        
        %Calcul des valeurs des listes list_f (vitesse et position) �
        %partir des nouvelles valeurs des constantes (qui ont �t� �tablie
        %pour le point suivant).
        
        [f_vx] = Sum_forces_acceleratiom_x(masse, Fc);
        [f_vy] = Sum_forces_acceleratiom_y(masse, Fc);
        [f_vz] = Sum_forces_acceleratiom_z(masse, g, Fc);
        list_f_v = {f_vx, f_vy, f_vz}; %Liste des fonctions pour EDO de d(v)/dt
        list_f_pos = {mat_next_f_v(2), mat_next_f_v(3), mat_next_f_v(4)}; %Liste des fonction pour EDO de d(pos)/dt o� 1er = temps et (2,3,4) = les vitesses.
        
        %Ajustement des variables pour la prochaine donn�e et la condition
        %d'arr�t.
        i = i + 1;
        pos_actuelle = mat_next_f_pos(2:numel(mat_next_f_pos));
        [arret] = verification_arret(pos_cible, pourcentage_marge_erreur, pos_actuelle);
    end
    
    %% Finalisation
    [position, vitesse] = correction_pour_affichage(position, vitesse);
    
end


%-----------------------------------------------
%% Calcul Constantes
%Description:
%   Fonction qui, � partir des informations fournients, calcule les
%   nouvelles valeurs des constantes. Cela permet de remplacer le code de
%   cela pour �tre mit ici au lieu de la fonction principale = fonction
%   principale plus petite et plus lisible, surtout si plusieurs param�tres
%   sont ratach�s � plusieurs constantes.
%
%   Note: Si certaines forces sont pr�sente en X,Y,Z et qu'un seul calcul
%   fournit les 3 (comme avec Force de Coriolis), alors on va faire le
%   calcul ici afin d'�viter de faire le calcul � plusieurs reprises
%   inutilement.
%
%Param�tres:
%   - vitesse: [v_x, v_y, v_z] actuelle (ou du pt suivant si sera utilis�
%   avec pt suivant). NOTE: Vitesse de Trajectoire_V2 = [temps, v_x, v_y,
%   v_z] -> doit skip la 1�re ligne avant de l'envoyer � cette fonction.

%   - position: [pos_x, pos_y, pos_z] actuelle (ou du pt suivant si sera utilis�
%   avec pt suivant).
%
%NOTE DE D�V�LOPPEMENT
%   � AM�LIORER (calcul de certaines constantes).
%
%Retour:
%   Les valeurs des constantes mise � jour en fonction des donn�es
%   fournient.
%
function [g, Fc] = Calcul_constantes(masse, vitesse, position, latitude_init, azimut_init)
    altitude = position(4); %Rappel: 1�re ligne = le temps, ligne (2,3,4) = les vitesses.
    latitude = latitude_init; %� AM�LIORER...
    azimut = azimut_init; %� AM�LIORER...
    
    [Fc, ac] = Force_Coriolis(masse, vitesse, azimut, latitude);
    
    [g]=gravity(altitude, latitude);
end



%-----------------------------------------------
%% Fonction de l'acc�l�ration en Z
%Description:
%   Fonction dans le calcul a_z = d(v_z)/dt = (1/m)*sum(F_z).
%   Utilis� pour le calcul de l'EDO d'ordre 2 (mit en forme ordre 1) du
%   calcul de la vitesse en z (v_z).
%
%Forces en pr�sences pour l'acc�l�ration en Z:
%   - Effet de Coriolis
%   - R�sistance de l'air (d� au d�placemenet en Z + d�pend de si on monte
%   ou si on descend)
%   - Vent qui pousse en Z (clacul devrait �tre similaire � celui de
%   r�sistance de l'air).
%   - La portance (principe d'archim�de, mais avec l'air)(note: varie un
%   peu en fonction de si on monte ou si on descend)
%   - Gravit� (note: sens d�pend de si on monte ou descend)
%   - Effet Magnus (si pr�sent).
%
%Param�tres n�cessaire pour chacune des forces:
%   Force de gravit�:
%       - masse
%       - gravit� (valeur de la constante)
%
%   Force de Coriolis (calcul� par "Calcul_constantes"):
%       - Fc = (Fc_x, Fc_y, Fc_z) = masse*(ac_x, ac_y, ac_z)
%       - NOTE: ac aussi fournit par la fonction dans "Calcul_constantes"
%
%
%Retour:
%   Le r�sultat de (1/m)*sum(F_z) au temps fournie et selon les valeurs des
%   variables fournient.
%
function [f_vz] = Sum_forces_acceleratiom_z(masse, gravity, Fc)
    %EN COURS...
    %F_z = m*a_z = sum(Forces en z) -> a_z = (1/m)*sum(Forces en z)
    
    F_gravity = - masse*gravity;
    
    f_vz = (1/masse)*(F_gravity + Fc(3));
end

%-----------------------------------------------
%% Fonction de l'acc�l�ration en X 
%Description:
%   Fonction dans le calcul a_x = d(v_x)/dt = (1/m)*sum(F_x).
%   Utilis� pour le calcul de l'EDO d'ordre 2 (mit en forme ordre 1) du
%   calcul de la vitesse en x (v_x).
%
%Forces en pr�sences pour l'acc�l�ration en X:
%   - Effet de Coriolis
%   - R�sistance de l'air (d� au d�placemenet en X)
%   - Vent qui pousse en X (clacul devrait �tre similaire � celui de
%   r�sistance de l'air).
%   - Effet Magnus (si pr�sent).
%
%Param�tres des forces pr�sente dans la fonction:
%   Force de Coriolis (calcul� par "Calcul_constantes"):
%       - Fc = (Fc_x, Fc_y, Fc_z) = masse*(ac_x, ac_y, ac_z)
%       - NOTE: ac aussi fournit par la fonction dans "Calcul_constantes"
%
%
%Retour:
%   Le r�sultat de (1/m)*sum(F_x) au temps fournie et selon les valeurs des
%   variables fournient.
%
function [f_vx] = Sum_forces_acceleratiom_x(masse, Fc)
    %EN COURS...
    f_vx = (1/masse)*Fc(1);
end

%-----------------------------------------------
%% Fonction de l'acc�l�ration en y
%Description:
%   Fonction dans le calcul a_y = d(v_y)/dt = (1/m)*sum(F_y).
%   Utilis� pour le calcul de l'EDO d'ordre 2 (mit en forme ordre 1) du
%   calcul de la vitesse en y (v_y).
%
%Forces en pr�sences pour l'acc�l�ration en Y:
%   - Effet de Coriolis
%   - R�sistance de l'air (d� au d�placemenet en Y)
%   - Vent qui pousse en Y (clacul devrait �tre similaire � celui de
%   r�sistance de l'air).
%   - Effet Magnus (si pr�sent).
%
%Param�tres des forces pr�sente dans la fonction:
%   Force de Coriolis (calcul� par "Calcul_constantes"):
%       - Fc = (Fc_x, Fc_y, Fc_z) = masse*(ac_x, ac_y, ac_z)
%       - NOTE: ac aussi fournit par la fonction dans "Calcul_constantes"
%
%Retour:
%   Le r�sultat de (1/m)*sum(F_y) au temps fournie et selon les valeurs des
%   variables fournient.
%
function [f_vy] = Sum_forces_acceleratiom_y(masse, Fc)
    %EN COURS...
    f_vy = (1/masse)*Fc(2);
end

%-----------------------------------------------
%% R�solution 1 pt avec Runge-Kutta ordre 4 (copie-coller de outils ELE735)
%Description:
%   R�solution Runge-Kutta d'ordre 4, qui est le plus souvent utilis� dans
%   les exercices du manuel et qui sera la plus pr�cise. Elle combine le
%   maximum de co�fficient et on peut avoir celle des autres inf�rieur en
%   mettant les co�fficient des autres sup�rieur � 0.
function [mat_next] = syst_edo_order2_Runge_Kutta_order4(vector_value, list_funct, a, b, c, h)
    mat_next = zeros(numel(list_funct)+1,1);
    mat_k = zeros(numel(list_funct),4);
    tempo1 = vector_value;
    tempo2 = vector_value;
    tempo3 = vector_value;
    
    mat_next(1,1) = vector_value(1)+h;
    
    %Calcule des coefficient K1 des diff�rentes fonctions.
    tempo1(1) = tempo1(1) + a(1)*h;
    tempo2(1) = tempo2(1) + a(2)*h;
    tempo3(1) = tempo3(1) + a(3)*h;
    for i=1:numel(list_funct)
       %mat_k(i,1) = eval_f(list_funct{i}, vector_value);
       mat_k(i,1) = list_funct{i};
       tempo1(i+1) = vector_value(i+1)+b(1)*mat_k(i,1)*h;
    end
    
    for i=1:numel(list_funct)
        %mat_k(i,2) = eval_f(list_funct{i}, tempo1);
        mat_k(i,2) = list_funct{i};
        tempo2(i+1) = vector_value(i+1)+b(2)*mat_k(i,1)*h+b(3)*mat_k(i,2)*h;
    end
    
    for i=1:numel(list_funct)
        %mat_k(i,3) = eval_f(list_funct{i}, tempo2);
        mat_k(i,3) = list_funct{i};
        tempo3(i+1) = vector_value(i+1)+ + b(4)*mat_k(i,1)*h+b(5)*mat_k(i,2)*h+b(6)*mat_k(i,3)*h;
    end
    
    for i=1:numel(list_funct)
       %mat_k(i,4) = eval_f(list_funct{i}, tempo3);
       mat_k(i,4) = list_funct{i};
       mat_next(i+1) =  vector_value(i+1) + h*(c(1)*mat_k(i,1)+c(2)*mat_k(i,2)+c(3)*mat_k(i,3)+c(4)*mat_k(i,4));
    end
end

%-----------------------------------------------
%% V�rification atteinte de la cible ou atteinte d'un obstacle
%Description:
%   La condition d'arr�t du calcul de la trajectoire peut se faire selon
%   plusieurs facteurs:
%       #1) La dur�e maximal permise (la longueur du vecteur temps)
%       #2) L'atteinte de la cible (avec une marge d'erreur autour du point
%       choisit pour dire que la cible se trouve l�).
%       #3) L'atteinte d'un obstacle (ex.: le sol sous la cible ou le
%       plafond, mais cela d�pend de la situation + pourrait utiliser image
%       de la situation et calcul de distance).
%
%Param�tres:
%   - pos_cible: [pos_cible_x, pos_cible_y, pos_cible_z] du point de la cible.
%   - pourcentage_marge_erreur: le % d'erreur possible (ex.: +/- 5% en X, Y, Z).
%   - pos_actuelle [pos_x, pos_y, pos_z] de la position actuelle.
%
%Retour:
%   Retourne 1(true) si condition arr�t valide, 0(false) si pas le cas
%
function [arret] = verification_arret(pos_cible, pourcentage_marge_erreur, pos_actuelle)
    persistent pos_x_moins;
    persistent pos_x_plus;
    persistent pos_y_moins;
    persistent pos_y_plus;
    persistent pos_z_moins;
    persistent pos_z_plus;
    
    %Calcul des intervalles de valeurs valide si pas encore fait ou si
    %reset = 1 (via utilisation de variable static "persistent").
    if(isempty(pos_x_moins))
        calcul_marge_distance = pourcentage_marge_erreur*pos_cible;
        %[pos_x_moins, pos_y_moins, pos_z_moins] = vector_pos_cible - calcul_marge_distance;
        %[pos_x_plus, pos_y_plus, pos_z_plus] = vector_pos_cible + calcul_marge_distance;
        pos_x_moins = pos_cible(1) - calcul_marge_distance(1);
        pos_y_moins = pos_cible(2) - calcul_marge_distance(2);
        pos_z_moins = pos_cible(3) - calcul_marge_distance(3);
        pos_x_plus = pos_cible(1) + calcul_marge_distance(1);
        pos_y_plus = pos_cible(2) + calcul_marge_distance(2);
        pos_z_plus = pos_cible(3) + calcul_marge_distance(3);
    end
    
    %Si VRAI pour tous, on aura 3, car aura [1,1,1] en retour de l'�quation
    %logique.
    cas_1 = sum(pos_actuelle >= [pos_x_moins; pos_y_moins; pos_z_moins]);
    cas_2 = sum(pos_actuelle <= [pos_x_plus; pos_y_plus; pos_z_plus]);
    
    arret = (cas_1 == 3) && (cas_2 == 3);
end

%-----------------------------------------------
%% Correction pour l'affichage
%Description:
%   Afin de pouvoir bien les afficher, on va enlever la parties du temps,
%   de la position et de la vitesse qui n'a pas �t� utilis� dans le but que
%   ces 3 matrices ayaient le m�me nombre de colonne (ce qui est
%   indispendsable pour l'affichage).
%
function [position, vitesse] = correction_pour_affichage(position, vitesse)
    %Identifier la longueur cible (le nombre de dimension cible).
    
    is_column_search = 1; %Dans notre cas, 1 colonne = 1 valeur de temps pr�cise.
    column_or_line_start_search = 2; %On exclue la 1�re, car si v_init = 0 (chute libre), ne pas s'arr�ter l�.
    [vitesse, column_start_cut] = remove_zeros_at_end(vitesse, column_or_line_start_search, is_column_search);
    
    %Appliquer les dimensions cibles aux autres via m�me m�thode que la
    %fonction utilis� par la fonction "remove_zeros_at_end".
    if(column_start_cut > 1)
        position = position(:,1:column_start_cut-1);
        
    %Sinon, matrice devenue vide, car l'aura enlever.
    else
        position = [];
    end
end