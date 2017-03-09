%% Trajectoire_V2:
%Description:
%   Méthodologie de calcul final (pour l'instant) qui résout les EDO
%   d'ordre 2 de la vitesse et les EDO d'ordre 1 de la position afin
%   d'obtenir les valeurs de la vitesse et de la position pour chacune des
%   valeurs du temps. La méthodologie de calcul est expliqué plus loin.
%          
%Méthodologie de calcul pour résoudre le sytème d'EDO ordre 2 et ordre 1:
%   Dans notre calcul, on cherche à obtenir (au minimum) la position
%   (en x,y,z) à chaque moment du temps. En partant de la lois de Newton
%   F = m*a et du fait qu'on 3 axes, on a 3 équations de l'accélération.
%   
%   L'accélération est la dérivé de la vitesse en fonction du temps
%   (a = d(v)/dt) et la vitesse est la dérivé de la position en fonction du
%   temps (v = d(pos)/dt). De manière analythique, on doit d'abord résoudre
%   les EDO de l'accélération pour obtenir les vitesses 
%   (a = d(v)/dt = f_v où f_v = (1/m)*Sum(Forces)) suivie des EDO de la 
%   vitesse pour obtenir les positions (v = d(pos)/dt = f_pos où f_pos = v).
%
%   Dans notre calcul, on a 3 EDO ordre 2 (à partir accélération en x,y,z)
%   à 6 variables (v_x, v_y, v_z + x,y,z dû aux constantes qui utilise la
%   position) ET 3 EDO d'ordre 1 (x,y,z) qui dépendant aussi des mêmes
%   constantes qui varient selon la position.
%
%   De manière analythique, le calcul est très complexe et long à
%   effectuer. Par méthode numérique, une fois la méthodologie établie,
%   cela se fait très facilement dû au fait qu'on ne manipule que des
%   chiffres ainsi que {donnée(i), donnée(i+1)}. De ce fait, on a qu'on a
%   calculé les v(i+1) et les pos(i+1) à partir des v(i) et pos(i) qui 
%   sont aussi utilisé pour calculer les constantes rataché à ces données
%   actuelles. Ces constantes sont par exemple la masse volumique de l'air,
%   la température, la pression, etc.
%
%   Le premier système est le système d'EDO d'ordre 2 (exprimé sous forme 
%   d'ordre 1 via passe-passe des constantes), soit les vitesses.
%   m*a = sum(Forces) -> a = d(v)/dt = (1/m)*sum(Forces) où on a 
%   d(v_x)/dt, d(v_y)/dt et d(v_z)/dt. (1/m)*sum(Forces) = f(t,...) qui
%   sont les fonctions à utiliser dans la résolution d'une EDO d'ordre 1.
%   
%   Le deuxième système est le système d'EDO d'ordre 1 de la position.
%   v = d(pos)/dt où v = f_pos(t, ...).
%
%   Ainsi, cela se résout plutôt bien, car dans les deux cas, on
%   utilise uniquement la position et la vitesse actuelle pour le calcul de
%   la vitesse et de la position suivante. Cela va de même pour les
%   constantes. Ainsi, l'ordre entre [calcul vitesse] et [calcul position]
%   n'a pas d'importances, mais il faut les faire dans la même boucle du
%   calcul de la vitesse et de la position suivante. À des fins de
%   simplicité et de cohérence par rapport à la méthode analithyque, j'ai
%   choisit de prendre le même ordre qu'avec la méthode analithyque, soit
%   la vitesse suivie de la position.
%
%   À la fin, il suffit de calculer les constantes pour le point (vitesse
%   et position) suivant, comme on fait aussi en transférant la valeur du
%   suivant à la valeur actuelle.
%
%   Ainsi, notre calcul se fait en quelques étapes (où les étapes #2.1 et
%   #2.2 peuvent être inversé):
%       #1) L'initialisation:
%           - valeur des conditions initiales
%           - valeur des constantes qui ne change pas (ex: Aire latéral)
%           - calcul des autres aspects préliminaires
%
%       #2) Boucles pour l'ensemble des points (s'arrête lorsque condition
%       d'arrêt valide [ex: à atteint la cible]):
%           #2.1) Calcul syst. EDO ordre 1 de la vitesse suivante V[i+1]
%           #2.2) Calcul syst. EDO ordre 1 de la position suivante Pos[i+1]
%           #2.3) Pos[i] = Pos[i+1] ET V[i] = V[i+1]
%           #2.4) Calcul des constantes pour la nouvelle positions et
%           vitesses.
%
%   Cette démarche mathématiques à été longuement réfléchie et devrait bien
%   se faire. Il faudra copier-coller et arranger un peu, à l'aide de
%   découpage du code en plusieurs fonctions, le calcul qui avait été fait
%   pour résoudre un système d'EDO d'ordre 1 (ex.: code de 1 point syst.
%   EDO ordre 1 mit dans une fonction qu'on peut appeler ensuite pour
%   calcul de Pos et calcul de V au lieu de recopier 2 fois tout ce
%   calcul).
%
%   Le découpage en plusieurs fonctions permettra de rendre le code plus
%   lisible et plus facile à retravailler et à corriger plus tard en cas de
%   problème (ex.: modifier le calcul de V_z pour ajouter plus de
%   précision).
%
%Méthode de résolution d'EDO utilisé (actuellement):
%   La méthode de résolution de système d'EDO d'ordre 1 utilisé est la 
%   méthode de Runge-Kutta d'ordre 4 car,
%       #1) Ordre 4 contient ordre 3, 2 et 1
%       #2) Ordre 2 contient aussi Euler modifié et Midpt.
%   De ce fait, on englobe le plus de possibilité et c'est la plus
%   complexe. Je préfère partir du compliqué et ensuite aller vers le
%   simple plutôt que l'inverse.
%
%   Le code utilisé est (pour l'instant) un copie-coller du code de "Outils
%   ELE735" où on a seulement enlever l'utilisation de la fonction "eval_f"
%   dû au fait qu'on a directement des chiffres au lieu de fonction de
%   forme (ex.) "f = @(x,y,z) ...".
%
%Paramètres:
%   - Paramètres de base pour le calcul avec méthodologie utilisé:
%       - temps: vecteur de [0, temps_max] qui permet de spécifier la
%       groseur des matrices des résultats obtenues et de délimités un
%       taille maximale au cas où n'atteint jamais la cible.
%
%       - masse: la masse du projectile (pourrait changer dans le temps, si
%       le cas, sera masse initiale et ajout code dans 3ème partie boucle à
%       faire).
%
%       - pos_init: [pos_x, pos_y, pos_z] de la position initiale.
%
%       - vitesse_init: [v_x, v_y, v_z] de la vitesse initiale.
%
%       - Coeff_RK_a, Coeff_RK_b, Coeff_RK_c: Les coefficients a, b et c de
%       la méthode de Runge-Kutta pour résoudre EDO d'ordre 1.
%
%       - pos_cible: [pos_cible_x, pos_cible_y, pos_cible_z]: la position
%       de la cible afin qu'on arrête la boucle de calcul des points de
%       position et de vitesse lorsqu'on a soit atteint la cible, soit
%       atteint la durée maximale qui à été choisit.
%
%       - pourcentage_marge_erreur: le % d'erreur acceptable atour du point
%       de la cible. Ex.: avec 5%, on considère que si le projectile se
%       trouve dans la sphère autour du point de la cible
%       [x +/- 5%, y +/- 5%, z +/- 5%], on a atteint la cible (nécessaire
%       dû au fait que égalité avec nombre flottant impossible).
%
%   - Paramètres pour calculs de la vitesse, de la position et des
%   constantes qui varie selon vitesse ou/et position:
%       - azimut_init: L'orientation des Points Cardinaux au début
%       - latitude_init: La latitude initiale
%       - 
%
%Note de dévéloppement:
%   Étape #1: La méthodologie de calcul:
%       La méthodologie de calcul (exclue les calculs effectués par les
%       fonctions à l'extérieur de ce fichier en lien avec les forces). 
%       À été tester, corrigé et valider (à première vue). Sans aucune
%       autre fonction utilisé: fonctionne parfaitement bien et semble
%       valide. Testé avec accélération constante de 1 en x, y, z.
%
%   Étape #2: La gravité:
%       J'ai ajouté la force de Gravité dans le calcul de F_z et les
%       résultats obtenues (la forme de la trajectoire) semble valide.
%
%   Étape #3: La force de Coriolis:
%       J'ai ajouté la force de Coriolis dans les calculs de F_x,F_y,F_z.
%       On remarque une très légère accélération qui va causer une légère
%       déviation (sur de courte distance). J'ai revérifier les calculs et
%       ils semblent valides.
%
%   Étape #4: La force de résistance de l'air (celle traversé lors du
%   déplacement):
%       EN COURS...
%       J'ai ajouté la fonction "Surface_profil_forme_general" pour ajouté
%       des formes général (note: À AMÉLIORER). J'ai regarder un peu
%       "Force_resistance_air", mais elle est à améliorer, car
%       actuellement, vraiment incertain pour Cx et elle ne pourra faire
%       que la balistique (pour l'instant).
%
%       ON EST RENDU ICI: Améliorer "Force_resistance_air".
%       
%
%
%Retour:
%   1ère ligne (pour  les deux matrices): le temps.
%   2ème ligne: position ou vitesse en X (selon la matrice utilisé).
%   3ème ligne: position ou vitesse en Y (selon la matrice utilisé).
%   4ème ligne: position ou vitesse en Z (selon la matrice utilisé).
%
function [position, vitesse] = Trajectoire_V2(temps, masse, pos_init, latitude_init, azimut_init, vitesse_init, pos_cible, pourcentage_marge_erreur, Coeff_RK_a, Coeff_RK_b, Coeff_RK_c)    
    %% Initialisation: Assignation des variables avant début calcul via C.I.
    %Variables avec vérification atteintes de la cible
    size_pos_cible = size(pos_cible);
    
    %Si le vecteur pos_cible est un vecteur line -> le mettre en vecteur
    %colonne (car vecteur utilisé dans boucle est un vecteur colonne).
    if(size_pos_cible(1) == 1)
        pos_cible = transpose(pos_cible);
    end
    
    %Calcul des valeurs initiales des constantes en fonctions de la vitesse
    %et de la position initiale
    [g, Fc] = Calcul_constantes(masse, vitesse_init(2:numel(vitesse_init)), pos_init, latitude_init, azimut_init);
    
    
    
    %Résultat des différentes fonctions avec C.I. = n'aura pas à faire 
    %eval_f dans calcul des EDO, mais doit répéter ces 5 lignes à chaque 
    %fois (celle pos par contre un peut modifier).
    [f_vx] = Sum_forces_acceleratiom_x(masse, Fc);
    [f_vy] = Sum_forces_acceleratiom_y(masse, Fc);
    [f_vz] = Sum_forces_acceleratiom_z(masse, g, Fc);
    list_f_v = {f_vx, f_vy, f_vz}; %Liste des fonctions pour EDO de d(v)/dt
    list_f_pos = {vitesse_init(2), vitesse_init(3), vitesse_init(4)}; %Liste des fonction pour EDO de d(pos)/dt où 1er = t_init suivie des vitesses (colonne 2,3,4)
    
    %Nb ligne = la ligne de T + les lignes des nb fonction. Nb colonne = Nb point.
    vitesse = zeros(numel(list_f_v)+1, numel(temps));
    position = zeros(numel(list_f_pos)+1, numel(temps));
    
    %Calcul des constantes à partir des C.I.
    %[g] = Calcul_constantes(vitesse, position);
    
    %% Début des calculs:
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
        %Calcul de l'espacement entre les données (h)(méthode pour h !=
        %cte, mais nb point maximal connue).
        h = temps(i+1) - temps(i);
        
        %Calcul des données suivantes (le y[i+1])
        [mat_next_f_v] = syst_edo_order2_Runge_Kutta_order4(vector_value_f_v, list_f_v, a, b, c, h);
        [mat_next_f_pos] = syst_edo_order2_Runge_Kutta_order4(vector_value_f_pos, list_f_pos, a, b, c, h);
        
        %Données actuelle = Données suivante (y[i] = y[i+1])
        vector_value_f_v(:) = mat_next_f_v(:);
        vector_value_f_pos(:) = mat_next_f_pos(:);
        
        %Enregistrement de la données
        vitesse(:, i+1) = mat_next_f_v;
        position(:, i+1) = mat_next_f_pos;
        
        %Calcul des constantes en fonction des vitesses et position
        %suivante (ex.: gravité, masse (si varie dans le temps), masse
        %volumique de l'air, etc).
        [g, Fc] = Calcul_constantes(masse, vector_value_f_v(2:numel(vector_value_f_v)), vector_value_f_pos, latitude_init, azimut_init);
        
        %Calcul des valeurs des listes list_f (vitesse et position) à
        %partir des nouvelles valeurs des constantes (qui ont été établie
        %pour le point suivant).
        
        [f_vx] = Sum_forces_acceleratiom_x(masse, Fc);
        [f_vy] = Sum_forces_acceleratiom_y(masse, Fc);
        [f_vz] = Sum_forces_acceleratiom_z(masse, g, Fc);
        list_f_v = {f_vx, f_vy, f_vz}; %Liste des fonctions pour EDO de d(v)/dt
        list_f_pos = {mat_next_f_v(2), mat_next_f_v(3), mat_next_f_v(4)}; %Liste des fonction pour EDO de d(pos)/dt où 1er = temps et (2,3,4) = les vitesses.
        
        %Ajustement des variables pour la prochaine donnée et la condition
        %d'arrêt.
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
%   Fonction qui, à partir des informations fournients, calcule les
%   nouvelles valeurs des constantes. Cela permet de remplacer le code de
%   cela pour être mit ici au lieu de la fonction principale = fonction
%   principale plus petite et plus lisible, surtout si plusieurs paramètres
%   sont ratachés à plusieurs constantes.
%
%   Note: Si certaines forces sont présente en X,Y,Z et qu'un seul calcul
%   fournit les 3 (comme avec Force de Coriolis), alors on va faire le
%   calcul ici afin d'éviter de faire le calcul à plusieurs reprises
%   inutilement.
%
%Paramètres:
%   - vitesse: [v_x, v_y, v_z] actuelle (ou du pt suivant si sera utilisé
%   avec pt suivant). NOTE: Vitesse de Trajectoire_V2 = [temps, v_x, v_y,
%   v_z] -> doit skip la 1ère ligne avant de l'envoyer à cette fonction.

%   - position: [pos_x, pos_y, pos_z] actuelle (ou du pt suivant si sera utilisé
%   avec pt suivant).
%
%NOTE DE DÉVÉLOPPEMENT
%   À AMÉLIORER (calcul de certaines constantes).
%
%Retour:
%   Les valeurs des constantes mise à jour en fonction des données
%   fournient.
%
function [g, Fc] = Calcul_constantes(masse, vitesse, position, latitude_init, azimut_init)
    altitude = position(4); %Rappel: 1ère ligne = le temps, ligne (2,3,4) = les vitesses.
    latitude = latitude_init; %À AMÉLIORER...
    azimut = azimut_init; %À AMÉLIORER...
    
    [Fc, ac] = Force_Coriolis(masse, vitesse, azimut, latitude);
    
    [g]=gravity(altitude, latitude);
end



%-----------------------------------------------
%% Fonction de l'accélération en Z
%Description:
%   Fonction dans le calcul a_z = d(v_z)/dt = (1/m)*sum(F_z).
%   Utilisé pour le calcul de l'EDO d'ordre 2 (mit en forme ordre 1) du
%   calcul de la vitesse en z (v_z).
%
%Forces en présences pour l'accélération en Z:
%   - Effet de Coriolis
%   - Résistance de l'air (dû au déplacemenet en Z + dépend de si on monte
%   ou si on descend)
%   - Vent qui pousse en Z (clacul devrait être similaire à celui de
%   résistance de l'air).
%   - La portance (principe d'archimède, mais avec l'air)(note: varie un
%   peu en fonction de si on monte ou si on descend)
%   - Gravité (note: sens dépend de si on monte ou descend)
%   - Effet Magnus (si présent).
%
%Paramètres nécessaire pour chacune des forces:
%   Force de gravité:
%       - masse
%       - gravité (valeur de la constante)
%
%   Force de Coriolis (calculé par "Calcul_constantes"):
%       - Fc = (Fc_x, Fc_y, Fc_z) = masse*(ac_x, ac_y, ac_z)
%       - NOTE: ac aussi fournit par la fonction dans "Calcul_constantes"
%
%
%Retour:
%   Le résultat de (1/m)*sum(F_z) au temps fournie et selon les valeurs des
%   variables fournient.
%
function [f_vz] = Sum_forces_acceleratiom_z(masse, gravity, Fc)
    %EN COURS...
    %F_z = m*a_z = sum(Forces en z) -> a_z = (1/m)*sum(Forces en z)
    
    F_gravity = - masse*gravity;
    
    f_vz = (1/masse)*(F_gravity + Fc(3));
end

%-----------------------------------------------
%% Fonction de l'accélération en X 
%Description:
%   Fonction dans le calcul a_x = d(v_x)/dt = (1/m)*sum(F_x).
%   Utilisé pour le calcul de l'EDO d'ordre 2 (mit en forme ordre 1) du
%   calcul de la vitesse en x (v_x).
%
%Forces en présences pour l'accélération en X:
%   - Effet de Coriolis
%   - Résistance de l'air (dû au déplacemenet en X)
%   - Vent qui pousse en X (clacul devrait être similaire à celui de
%   résistance de l'air).
%   - Effet Magnus (si présent).
%
%Paramètres des forces présente dans la fonction:
%   Force de Coriolis (calculé par "Calcul_constantes"):
%       - Fc = (Fc_x, Fc_y, Fc_z) = masse*(ac_x, ac_y, ac_z)
%       - NOTE: ac aussi fournit par la fonction dans "Calcul_constantes"
%
%
%Retour:
%   Le résultat de (1/m)*sum(F_x) au temps fournie et selon les valeurs des
%   variables fournient.
%
function [f_vx] = Sum_forces_acceleratiom_x(masse, Fc)
    %EN COURS...
    f_vx = (1/masse)*Fc(1);
end

%-----------------------------------------------
%% Fonction de l'accélération en y
%Description:
%   Fonction dans le calcul a_y = d(v_y)/dt = (1/m)*sum(F_y).
%   Utilisé pour le calcul de l'EDO d'ordre 2 (mit en forme ordre 1) du
%   calcul de la vitesse en y (v_y).
%
%Forces en présences pour l'accélération en Y:
%   - Effet de Coriolis
%   - Résistance de l'air (dû au déplacemenet en Y)
%   - Vent qui pousse en Y (clacul devrait être similaire à celui de
%   résistance de l'air).
%   - Effet Magnus (si présent).
%
%Paramètres des forces présente dans la fonction:
%   Force de Coriolis (calculé par "Calcul_constantes"):
%       - Fc = (Fc_x, Fc_y, Fc_z) = masse*(ac_x, ac_y, ac_z)
%       - NOTE: ac aussi fournit par la fonction dans "Calcul_constantes"
%
%Retour:
%   Le résultat de (1/m)*sum(F_y) au temps fournie et selon les valeurs des
%   variables fournient.
%
function [f_vy] = Sum_forces_acceleratiom_y(masse, Fc)
    %EN COURS...
    f_vy = (1/masse)*Fc(2);
end

%-----------------------------------------------
%% Résolution 1 pt avec Runge-Kutta ordre 4 (copie-coller de outils ELE735)
%Description:
%   Résolution Runge-Kutta d'ordre 4, qui est le plus souvent utilisé dans
%   les exercices du manuel et qui sera la plus précise. Elle combine le
%   maximum de coéfficient et on peut avoir celle des autres inférieur en
%   mettant les coéfficient des autres supérieur à 0.
function [mat_next] = syst_edo_order2_Runge_Kutta_order4(vector_value, list_funct, a, b, c, h)
    mat_next = zeros(numel(list_funct)+1,1);
    mat_k = zeros(numel(list_funct),4);
    tempo1 = vector_value;
    tempo2 = vector_value;
    tempo3 = vector_value;
    
    mat_next(1,1) = vector_value(1)+h;
    
    %Calcule des coefficient K1 des différentes fonctions.
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
%% Vérification atteinte de la cible ou atteinte d'un obstacle
%Description:
%   La condition d'arrêt du calcul de la trajectoire peut se faire selon
%   plusieurs facteurs:
%       #1) La durée maximal permise (la longueur du vecteur temps)
%       #2) L'atteinte de la cible (avec une marge d'erreur autour du point
%       choisit pour dire que la cible se trouve là).
%       #3) L'atteinte d'un obstacle (ex.: le sol sous la cible ou le
%       plafond, mais cela dépend de la situation + pourrait utiliser image
%       de la situation et calcul de distance).
%
%Paramètres:
%   - pos_cible: [pos_cible_x, pos_cible_y, pos_cible_z] du point de la cible.
%   - pourcentage_marge_erreur: le % d'erreur possible (ex.: +/- 5% en X, Y, Z).
%   - pos_actuelle [pos_x, pos_y, pos_z] de la position actuelle.
%
%Retour:
%   Retourne 1(true) si condition arrêt valide, 0(false) si pas le cas
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
    
    %Si VRAI pour tous, on aura 3, car aura [1,1,1] en retour de l'équation
    %logique.
    cas_1 = sum(pos_actuelle >= [pos_x_moins; pos_y_moins; pos_z_moins]);
    cas_2 = sum(pos_actuelle <= [pos_x_plus; pos_y_plus; pos_z_plus]);
    
    arret = (cas_1 == 3) && (cas_2 == 3);
end

%-----------------------------------------------
%% Correction pour l'affichage
%Description:
%   Afin de pouvoir bien les afficher, on va enlever la parties du temps,
%   de la position et de la vitesse qui n'a pas été utilisé dans le but que
%   ces 3 matrices ayaient le même nombre de colonne (ce qui est
%   indispendsable pour l'affichage).
%
function [position, vitesse] = correction_pour_affichage(position, vitesse)
    %Identifier la longueur cible (le nombre de dimension cible).
    
    is_column_search = 1; %Dans notre cas, 1 colonne = 1 valeur de temps précise.
    column_or_line_start_search = 2; %On exclue la 1ère, car si v_init = 0 (chute libre), ne pas s'arrêter là.
    [vitesse, column_start_cut] = remove_zeros_at_end(vitesse, column_or_line_start_search, is_column_search);
    
    %Appliquer les dimensions cibles aux autres via même méthode que la
    %fonction utilisé par la fonction "remove_zeros_at_end".
    if(column_start_cut > 1)
        position = position(:,1:column_start_cut-1);
        
    %Sinon, matrice devenue vide, car l'aura enlever.
    else
        position = [];
    end
end