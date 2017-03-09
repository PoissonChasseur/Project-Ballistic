%% Profil_balistique.m (pas encore utilisé, juste fait en fichier TEXTE)
%Description:
%	Dans le cas de la balistique, le plus souvent, la balle est un profil 2D	
%	auquel on applique une révolution afin de forme un solide de révolution en 3D.
%
%	La pointe de la balistique le bout de la balle, la surface du projectile qui va traverser
%	l'air afin de se rendre vers son objectif. C'est le facteur qui rentre le plus en compte
%	dans le calcul de la force de résistance de l'air
%
%	Par le fait que c'est une surface 2D auquel on applique une révolution circulaire pour avoir 
%	la forme 3D, on obtient aussi à l'aide de ces équations la surface sur lequel l'air sera appliqué
%	avec le vent qui peut pousser sur d'autre partie que la pointe de la balle.
%
%
%Note importante sur équations de profil:
%	- L = longueur totale de la pointe
%	- R = le rayon de la base de la pointe
%	- y = le RAYON en tout point X (de la pointe à la base)
%	- X = 0 à la pointe et L à la base.
%
%Note importante:
%	- Les équations qui suivent sont pour la forme théorique parfaite
%	  en pratique, elle est souvent émoussée ou tronquié pour des raisons
%	  de fabrication ou d'aérodynamisme.
%
%
%Paramètres généraux (pour toutes les fonctions où s'applique):
%	- L = longueur totale de la pointe (en mètre pour la suite).
%	- R = le rayon de la base de la pointe (en mètre pour la suite).
%
%	- precision_x = l'espacement entre les points en X (plus petit = plus
%	précis, mais plus long à calculé) (en mètre pour la suite).
%
%   - choix sert à choisir le profil à utilisé:
%       - 1: Profil de pointe Conique (L, R, x)
%       - 2: Profil de pointe Conique tronqué par une sphère (L, R, r_n, x)
%       - 3: Profile de pointe Biconique (L, L2, R, R2, x)
%       - 4: Profile de pointe à Ogive Tangente (R, L, x)
%       - 5: Profile de pointe à Ogive Tangente à une Sphere (R, L, r_n, x)
%       - 6: Profile de pointe à ogive sécante (R, L, p, x) où p = rhô.
%       - 7: Profile de pointe Elliptique (R, L, x)
%       - 8: Profile de pointe Parabolique (R, L, Coeff_K, x)
%       - 9: Profile de pointe Generé par une Fonction de Puissance (R, L, Coeff_n, x)
%       - 10: Profile de pointe Generé par une Fonction de Haack (R, L, Coeff_C, x)
%
%Note pour paramètre spécialisé non utilisé: 
%   - Mettre des 0 pour les paramètres spécialisé aux autres profiles qui
%   ne sont pas nécessaires au calcul du profil choisit.
%
%   - Sur les 11 paramètres, seul les 4 derniers sont ceux qui doivent
%   toujours être là.
%
%Retour:
%   - y = la valeur du rayon aux différentes valeurs des points en X. 
%   - Sera un vecteur de 0 (+ message affiché signalant le problème) si une
%   condition nécessaire à la validation de l'équation utilisé pour le
%   calcul n'a pas été valide.
%
%NOTE SUR LA PROGRESSION:
%   RIEN N'A ENCORE ÉTÉ TESTÉ.
%
%Source:
%	- https://fr.wikipedia.org/wiki/A%C3%A9rodynamique_de_la_pointe_avant (consultÉ le 1er décembre 2016)
%	- https://en.wikipedia.org/wiki/Nose_cone_design (consulté le 1er décembre 2016)
%
function [x, y] = profil_balistique(r_n, L2, R2, p, Coeff_K, Coeff_n, Coeff_C, L, R, precision_x, choix)
	if not(choix==3)
        x = 0:precision_x:L;
    end
    
    switch(choix)
        %Profile Conique:
        case 1
            y = profil_conique(L, R, x);
            
        %Profil Conique tronqué par une sphère:
        case 2
            y = profile_conique_tronque_par_sphere(L, R, r_n, x);
            
        %Profil de Pointe biconique
        case 3
             x = 0:precision_x:(L+L2);
            [y] = profile_biconique(L, L2, R, R2, x);
            
        %Profil à ogive tangente
        case 4
            [y] = profile_ogive_tangente(R, L, x);
            
        %Pointe à ogive tangente tronqué par une sphère
        case 5
            [y] = profile_ogive_tangente_sphere(R, L, r_n, x);
            
        %Point à ogive sécante
        case 6
            [y] = profile_pointe_ogive_secante(R, L, p, x);
            
        %Pointe elliptique
        case 7
            [y] = profile_pointe_elliptique(R, L, x);
            
        %Pointe parabolique
        case 8
            [y] = profile_pointe_parabolique(R, L, Coeff_K, x);
            
        %Pointe générée par une fonction de puissance
        case 9
            [y] = profile_pointe_genere_via_fonction_puissance(R, L, Coeff_n, x);
            
        %Pointe générée par une fonction de Haack
        case 10
            [y] = profile_pointe_genere_via_fonction_Haack(R, L, Coeff_C, x);     
    end
end

%-----------------------------------------------------

%% Profil Conique:
%Description:
%	Une forme de pointe en cône, avant très commune.
%	Forme souvent choisit pour sa simplicité de fabrication, et
%	ausssi souvent choisie (et parfois mal choisit) pour ces 
%	caractéristique de trainée.
%
%Retour:
%   - y = La valeur du RAYON au différent point en X.
%
function [y] = profil_conique(L, R, x)
	%Équation du diamètre au différent point en X.
    %y = (2*R/L).*x;
    
    %Équation du rayon au différent point en X.
    y = (R/L).*x;
end

%-----------------------------------------------------
%% Profil Conique tronqué par une sphère:
%Description:
%	En pratique, une pointe conique est souvent tronqué par un morceau de sphère.
%
%Calculs:
%   - On a un cône tronqué par une sphère et on a l'équation
%     du diamètre pour un cône (voir profil conique).
%   - Sachant la position du cercle et son rayon,
%     on en déduit la position où débute le cône.
%
%Paramètre particulier:
%	- r_n = le rayon de la sphèrique
%
%Note:
%   Modification effectué après car avait inversé X.
%   Je me suis rappelé ensuite que x = 0 = la pointe et non l'inverse.
%
%Retour:
%   - y = le RAYON (par défaut, selon texte Wikipidia) au différent point
%   en X.
%
%Source supplémentaire:
%   - Calcule calotte sphérique: http://calculis.net/q/calotte-spherique-15
%   (consulté le 20 décembre 2016)
%   - Les équations utilisé pour le calcul de la colotte sphérique:
%   http://calculis.net/q/calotte-spherique-15 (consulté le 20 décembre
%   2016)
function [y] = profile_conique_tronque_par_sphere(L, R, r_n, x)
    %initialise le vecteur pour mémoire déjà mit. Note: 0 important pour
    %skip la fin où sait qu'on a déjà mit des 0 = pas besoin d'en mettre en
    %plus.
    y = zeros(1,numel(x));
    
    %Position où début le cône -> Point tangent au cercle.
    x_t = (L^2/R)*sqrt((r_n^2)/(R^2+L^2));
    y_t = (x_t*R)/L;
    
    %Calule du x du centre de la sphère
    x_o = x_t + sqrt(r_n^2 - y_t^2);
    
    %Calcule de la positon en x où finie la sphère (y = 0 après cela)
    x_a = x_o - r_n;
    
    %-----------------------------
    %Mettre le curseur "i" au début zone où a un rayon != 0. Note: Là
    %vérifier et semble parfait. But (a verifier car pas Matlab) = avoir dernier case ou x < x_a
    copie_x = x; %enregistré une copie de x.
    copie_x(copie_x>=x_a) = 0; %tout ceux > x_a (avant début sphère) mit à 0.
    pos = find(copie_x); %find retourne toute les position où pas 0 (ou x < x_a)
    i = pos(numel(pos)); %on va cherche la dernière valeur = celle avant début sphère.
    i = i + 1;
    
    %On obtient la position où débute la sphère.
    debut_sphere = x(i);
    
    %Calcule de y pour la partie sphérique (calotte sphérique en fait).
    %S'arrête au point de x_t ou au point après le x_t.
    %J'ai refait le calcul partie sphère et conique et maintenant ils sont
    %cohérent entre eux et avec xt et yt.
    while(i <= numel(x) && x(i) < x_t)
        h = x(i) - debut_sphere;
        y(i) = sqrt(2*r_n*h-h^2);
        i = i + 1;
    end
    
    %-----------
    %Calcule de "y" pour la partie conique
    while(i <= numel(x))
        y(i) = (R/L)*x(i);
        i = i + 1;
    end
end

%-----------------------------------------------------
%% Pointe biconique
%Description:
%   "Une pointe biconique est simplement un cône de longueur L1 tronqué 
%   par un autre cône de longueur L2", d'où 2 Longueurs et 2 Rayons.
%   
%   L_total = L = L1 + L2
%
%Retour:
%   - y = (par défaut, selon texte wikipéidia) le RAYON au différent point
%   en X.
%
function [y] = profile_biconique(L1, L2, R1, R2, x)
    %Assigner mémoire au tableau y.
    y = zeros(1,numel(x));
    
    %La zone du 1er cône: x = [0, L1] (pointe à fin cône 1)
    i = 1;
    while(i <= numel(x) && x(i) < L1)
       y(i) = (R1/L1)*x(i); 
       i = i + 1;
    end
    
    %La zone du 2ème cône: x = [L1 L]
    while(i <= numel(x))
       y(i) = R1 + (1/L2)*(x(i)-L1)*(R2 - R1);
       i = i + 1;
    end
end

%-----------------------------------------------------
%% Pointe à ogive tangente
%Description:
%   "Avec la forme conique, la forme en ogive est la plus familière dans
%   les micro fuses. Ce profil de révolution est obtenue à partir d'un arc
%   de cercle tangent à la base au corps de l'engin (fusée, balle). La
%   populariét de cette forme est largement due à la facilité de la
%   construction de de son profil."
%
%Retour:
%   - y = La valeur du RAYON au différent point en X.
%
function [y] = profile_ogive_tangente(R, L, x)
    %"Le rayon de l'arc de cercle qui forme l'ogie est appelé rayon de 
    %l'ogive p (rhô) et est liée à la longuer et la largeur de la pointe 
    %avant par la formule: "
    p = (R^2+L^2)/(2*R);
    y = sqrt(p^2-(L-x).^2) + R - p;
end

%-----------------------------------------------------
%% Pointe à ogive tangente tronqué par une sphère.
%Description:
%   "Une forme à ogive est souvent tronqué par un morceau de sphère."
%
%Retour (supposé par fonction précédente):
%   - y = valeur du RAYON au différent point en X.
function [y] = profile_ogive_tangente_sphere(R, L, r_n, x)
    %Assigner mémoire au tableau y.
    y = zeros(1,numel(x));
    
    %Note: à déduit que même p (rho) que ogive tangente
    p = (R^2+L^2)/(2*R);
    
    %Vérification pour s'assurer pas de nombre imaginaire = mauvaise
    %donnée.
    if (p>(R+r_n)/2 && (R-r_n)<0)==1
       disp('Error: Imag number. Increase L and need R<r_n OR increase R');
       disp('(R+r_n)/2 = ');
       disp((R+r_n)/2);
       %Rappel: 0 = pas chiffre Imag, 1 = aura chiffre Imag.
       disp('(p>(R+r_n)/2 && (R-r_n)<0): ')
       disp((p>(R+r_n)/2 && (R-r_n)<0))
       
    elseif (p<(R+r_n)/2 && (R-r_n)>0)==0
       disp('Error: Imag number. Increase L and need R<r_n OR increase R');
       disp('(R+r_n)/2 = ');
       disp((R+r_n)/2);
       %Rappel: 0 = pas chiffre Imag, 1 = aura chiffre Imag.
       disp('(p<(R+r_n)/2 && (R-r_n)>0): ')
       disp((p<(R+r_n)/2 && (R-r_n)>0))
    end

    %Point centre de la sphère
    disp((p-r_n)^2 - (p - R)^2)
    x_o = L - sqrt( (p-r_n)^2 - (p - R)^2);
    
    %Calcul point tangence entre sphère et ogive
    y_t = (1/(p-r_n))*r_n*(p-R);
    x_t = x_o - sqrt(r_n^2 - y_t^2);
    
    %Calcul point départ de la sphère (début pointe à partir de x = 0).
    x_a = x_o - r_n;
    
    %--------------
    %Calcule du rayon pour la partie sphérique (code copie-coller de conique tronqué)
    
    %Mettre le curseur "i" au début zone où a un rayon != 0. Note: Là
    %vérifier et semble parfait.
    copie_x = x; %enregistré une copie de x.
    copie_x(copie_x>=x_a) = 0; %tout ceux > x_a (avant début sphère) mit à 0.
    pos = find(copie_x); %find retourne toute les position où pas 0.
    i = pos(numel(pos)); %on va cherche la dernière valeur = celle avant début sphère.
    i = i + 1;
    
    %On obtient la position où débute la sphère.
    debut_sphere = x(i);
    
    %Calcule de y pour la partie sphérique (calotte sphérique en fait).
    %S'arrête au point de x_t ou au point après le x_t.
    %J'ai refait le calcul partie sphère et conique et maintenant ils sont
    %cohérent entre eux et avec xt et yt.
    while(i <= numel(x) && x(i) < x_t)
        h = x(i) - debut_sphere;
        y(i) = sqrt(2*r_n*h-h^2);
        i = i + 1;
    end
    
    %--------------
    %Calcule pour la partie ogive (via équation de fonction précédente)
    while(i <= numel(x))
       y(i) = sqrt(p^2-(L-x(i))^2) + R - p;
       i = i + 1;
    end
end

%-----------------------------------------------------
%% Pointe à ogive sécante
%Description:
%"Le profil de cette forme est également formé d'un arc de cercle définit
%par le rayon de l'ogive. Le orgps de l'engin n'est pas tangent à la base
%de l'ogive. Le rayon de l'ogive p(rhô) n'est pas déterminer par R et L
%(comme pour l'ogive tangente), mais l'un des facteur doit être choisit
%pour définir la forme de la pointe."
%Deux cas possible pour un R et L pareille: 
%#1) R_ogive_secante > R_ogive_tangente:
%   "Si l'on choisit le rayon de l'ogive sécante plus grande que le rayon
%   de l'ogive tangente avec le même R et L, l'ogive sécante résultante
%   apparaitra comme une ogive tangente avec une base tronqué".
%
%#2) R_ogive_secante < R_ogive_tangente:
%   "Si l'on choisit p (rhô) plus petit que le rayon de l'ogive tangente p
%   (rhô), alors on obtient une ogive sécante qui aura un renflement plus
%   important que le diamètre de la base. L'exemple classique de cette
%   forme est la pointe avant du missile MGR-1 Honest John. De plus le
%   rayon choisit doit être plus grand que la moitié de la longueur de la
%   pointe avant".
%
%Note:
%   On a seuelement équation dans section du cas #1, donc j'ai supposé que
%   équation était les mêmes pour le cas #2 (via Wikipédia FR et EN seulement)
%
%   De ce fait, puisque cas #1 et #2 ont les mêmes équations (supposition),
%   on va juste combiner les conditions des 2 cas ensemble pour la
%   validation que équation utilisable.
%
%   Condition cas #1: p > (R^2+L^2)/2*R
%   Condition cas #2: p < (R^2+L^2)/2*R && p > L/2
%
%Paramètres:
%   - R : Le rayon de la partie haute de l'ogive sécante (voir image
%   Wikipédia FR ou EN)
%   - L : La longueur (voir image de Wikipédia FR ou EN)
%   - p : rhô, le rayon de l'ogive sécante (voir image de Wikipédia FR ou
%   EN).
%   - X : la valeur des point de l'axe X variant de 0 à L où 0 = la pointe.
%
%Retour:
%   - y = la valeur du RAYON au différent point en X.
%
function [y] = profile_pointe_ogive_secante(R, L, p, x)
    %Par défaut, au cas où condition invalide, on met des 0 dans y.
    y = zeros(1,numel(x));
    
    %Vérification validité condition combinée
    if(p <= L/2)
        disp('profile_pointe_ogive_secante: Error of p <= L/2, equation not valid');
        return
    end
    
    %Calcule de l'angle alpha pour la suite
    alpha = atan(R/L) - acos(sqrt(L^2+R^2)/(2*p));
    
    %Calcule du rayon y pour tous les points en X
    tempo = p*cos(alpha)-x;
    tempo = tempo.^2;
    y = sqrt(p^2-tempo) + p*sin(alpha);
end

%-----------------------------------------------------
%% Pointe elliptique
%Description:
%"Le profil de cette forme est une moitié d'une ellipse, avec le grand axe
%et le petit axe étant la base de la pointe avant. Une rotation d'une
%ellipse complète autour de son axe majeur est un ellipsoïde, ainsi la
%forme de nez elliptique est un hémiellipsoïde. Cette forme est très
%utilisé pour le vol subsonique (tels que les fusées miniatures) en raison
%de l'arrondi de la pointe et de la tangente à la base. Ce n'est pas une
%forme que l'on retrouve sur les vraies fusées. Si R = L, il s'agit d'un
%hémisphère".
%
%Paramètres:
%   - R = le Rayon de la base
%   - L = la longueur total
%   - X = les différentes valeurs de la longueur où X varie de 0 (pointe) à
%   L (la base).
%   
%Retour:
%   - y = (par défaut, selon texte Wikipédia) le RAYON au différent point
%   en X.
%
function [y] = profile_pointe_elliptique(R, L, x)
    tempo_x = (x.^2)/(L.^2);
    y = R*sqrt(1-tempo_x);
    
    %Note: Puisque l'affichage montre que semble être dans le sens inversee
    %(car pointe semble être à la fin), inversion ordre des y.
    y = fliplr(y);
end

%-----------------------------------------------------
%% Pointe parabolique
%Description:
%"La forme parabolique série est produite par la rotation d'une partie
%parabole autour d'une ligne parallèle de son latus rectum. Cette
%construction est semblable à celle de l'ogive tangente, sauf que la
%génératrice est un arc de parabole plutôt qu'un arc de cercle. Tout comme
%sur une ogive, cette construction donne une forme de pointe avant avec une
%pointe aiguë. Pour la forme émousée généralement associée à un nez
%parabolique, voir la série des forme définit par des fonctions de
%puissance (la forme parabolique est également souvent confondue avec la
%forme elliptique)".
%
%Paramètres:
%   - Coeff_K : varie entre 0 et 1 où les plus utilisé sont:
%       - Coeff_K = 0 pour un cône.
%       - Coeff_K = 0.5 pour une demi parabole
%       - Coeff_K = 0.75 pour 3/4 de parabole.
%       - Coeff_K = 1 pout une parabole complète.
%
%Note supplémentaire:
%   Pour le cas de la parabole complète (Coeff_K = 1), la pointe avant est
%   tangente au coprs de l'engin à sa base et la base est sur un axe de
%   parabole. Les valeurs des Coeff_K < 1 donne une forme plus affinée qui
%   apparaisset à l'ogive sécante. La forme résultante n'Est alors plus
%   tangente à la base de l'engin, mais la base demeurse parallèle, bien
%   que décaée, à l'axe de de la parabole.
%
%Retour:
%   - y = (par défaut selon texte Wikipédia) le RAYON aux différentes
%   valeurs en X.
%
function [y] = profile_pointe_parabolique(R, L, Coeff_K, x)
    %Au cas où condition invalide.
    y = zeros(1,numel(x));

    %Vérification que Coeff_K respecte condition validation de l'équation
    %d'après.
    if (Coeff_K < 0 || Coeff_K > 1)
        disp('profile_pointe_parabolique: Error: 0 <= Coeff_K <= 1');
        return
    end
    tempo = x./L;
    y = 2.*tempo - Coeff_K.*(tempo.^2);
    y = y/(2-Coeff_K);
    y = y*R;
end

%-----------------------------------------------------
%% Pointe généré par une fonction de puissance
%Description:
%"La fonction de puissane inclut la forme communément appelée pointe aveant
%<<parabolique>>, mais la véritable pointe avant fait partie des pointes
%avant générées à partie de fonction parabolique, qui sont complètement
%différentes  des pointes avant générées par des fonctions de puissance. La
%forme générée par une fonction de puissance se caractérisent généralement
%par sa pointe émoussée, et par le fait que sa base n'est pas tangente avec
%le corps de l'engin qui peut être pénalisante pour l'aérodynamique. La
%forme peut être modifiée à la base pour lisser cette discontinuité. Les
%formes cylindrique et conique font parties de cette famille."
%
%Paramètres:
%   - Coeff_n: valeur qui doit être (pour l'équation utilisé) entre 0 et 1
%   où:
%       - Coeff_n = 1 pour un cône.
%       - Coeff_n = 0.5 pour une parabole
%       - Coeff_n = 0 pour un cylindre
%   - R = le rayon à la base (habituellement)
%   - L = la longueur totale (habituellement)
%   - X = les valeurs des points entre 0 (la pointe) et L (la base).
%   
%Retour:
%   - y = (par défaut, selon texte Wikipédia) du RAYON aux différents point
%   en X.
%
function [y] = profile_pointe_genere_via_fonction_puissance(R, L, Coeff_n, x)
    %Au cas où condition invalide.
    y = zeros(1,numel(x));
    
    %Vérification de la condition validation de l'équation qui suit.
    if(Coeff_n < 0 || Coeff_n > 1)
       disp('profile_pointe_genere_via_fonction_puissance: Error: 0 <= Coeff_n <= 1');
       return
    end
    
    %Calcule de y sachant condition valide: y = R*(x/L)^n;
    y = x./L;
    y = y.^Coeff_n;
    y = R*y;
end

%% Pointe générée par une fonction de Haack
%Description:
%"Contrairement aux formes de pointe avant précédentes, celle obtenue par
%une fonction de Haack n'est pas constuite à partir de forme géométriques.
%Ces formes proviennent des mathématiques afin de minimiser la traînée
%aérodynamique. Bien que la fonction de Haack existe pour toutes valeur de
%C [(on parle souvent de coeff C/L)], deux valeur de C ont une importance
%particulière. Lorsque C = 0, on obtient la traînée minimale pour une
%longueur est un diamètre données (LD-Haack), et lorsque C = 1/3, on
%obtient la trainée minimale pour une longueur et une volume donnés
%(LV-Haack). Les pointes avant construites sur les fonctions de Haack ne
%sont pas parfaitement tangentes, à leur base, au corps de l'engin. La
%discontinuité de tangente est cependant généralement très faible pour
%être imperceptible. L'extrémité des pointes avant construites sur les
%fonctions de Haack ne présentent pas une pointe aigüe mais sont légèrement
%arrondies".
%
%Paramètres:
%   - Coeff_C: Coefficient C qu'on parle dans le texte (?? c'est quoi ??)
%   où:
%       - Coeff_C = 1/3 pour LV-Haack (traine minimum pour longueur et
%       volume donnée)
%       - Coeff_C = 0 pour LD-Haack (trainée minimum pour longueur et
%       diamètre donnée).
%   - R = le rayon à la base
%   - L = la longueur total
%   - X = la valeur des points de 0 (la pointe) à L (la base).
%
%Retour:
%   - y = (par défaut, selon texte Wikipédia) du RAYON aux différents point
%   en X.
%
function [y] = profile_pointe_genere_via_fonction_Haack(R, L, Coeff_C, x)
    %Calcule de l'angle thêta
    theta = acos(1-(2/L).*x);
    
    %Calcule de y
    y = theta - 0.5*sin(2*theta) + Coeff_C*((sin(theta)).^3);
    y = (R/sqrt(pi))*sqrt(y);
end