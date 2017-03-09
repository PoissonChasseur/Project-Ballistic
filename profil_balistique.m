%% Profil_balistique.m (pas encore utilis�, juste fait en fichier TEXTE)
%Description:
%	Dans le cas de la balistique, le plus souvent, la balle est un profil 2D	
%	auquel on applique une r�volution afin de forme un solide de r�volution en 3D.
%
%	La pointe de la balistique le bout de la balle, la surface du projectile qui va traverser
%	l'air afin de se rendre vers son objectif. C'est le facteur qui rentre le plus en compte
%	dans le calcul de la force de r�sistance de l'air
%
%	Par le fait que c'est une surface 2D auquel on applique une r�volution circulaire pour avoir 
%	la forme 3D, on obtient aussi � l'aide de ces �quations la surface sur lequel l'air sera appliqu�
%	avec le vent qui peut pousser sur d'autre partie que la pointe de la balle.
%
%
%Note importante sur �quations de profil:
%	- L = longueur totale de la pointe
%	- R = le rayon de la base de la pointe
%	- y = le RAYON en tout point X (de la pointe � la base)
%	- X = 0 � la pointe et L � la base.
%
%Note importante:
%	- Les �quations qui suivent sont pour la forme th�orique parfaite
%	  en pratique, elle est souvent �mouss�e ou tronqui� pour des raisons
%	  de fabrication ou d'a�rodynamisme.
%
%
%Param�tres g�n�raux (pour toutes les fonctions o� s'applique):
%	- L = longueur totale de la pointe (en m�tre pour la suite).
%	- R = le rayon de la base de la pointe (en m�tre pour la suite).
%
%	- precision_x = l'espacement entre les points en X (plus petit = plus
%	pr�cis, mais plus long � calcul�) (en m�tre pour la suite).
%
%   - choix sert � choisir le profil � utilis�:
%       - 1: Profil de pointe Conique (L, R, x)
%       - 2: Profil de pointe Conique tronqu� par une sph�re (L, R, r_n, x)
%       - 3: Profile de pointe Biconique (L, L2, R, R2, x)
%       - 4: Profile de pointe � Ogive Tangente (R, L, x)
%       - 5: Profile de pointe � Ogive Tangente � une Sphere (R, L, r_n, x)
%       - 6: Profile de pointe � ogive s�cante (R, L, p, x) o� p = rh�.
%       - 7: Profile de pointe Elliptique (R, L, x)
%       - 8: Profile de pointe Parabolique (R, L, Coeff_K, x)
%       - 9: Profile de pointe Gener� par une Fonction de Puissance (R, L, Coeff_n, x)
%       - 10: Profile de pointe Gener� par une Fonction de Haack (R, L, Coeff_C, x)
%
%Note pour param�tre sp�cialis� non utilis�: 
%   - Mettre des 0 pour les param�tres sp�cialis� aux autres profiles qui
%   ne sont pas n�cessaires au calcul du profil choisit.
%
%   - Sur les 11 param�tres, seul les 4 derniers sont ceux qui doivent
%   toujours �tre l�.
%
%Retour:
%   - y = la valeur du rayon aux diff�rentes valeurs des points en X. 
%   - Sera un vecteur de 0 (+ message affich� signalant le probl�me) si une
%   condition n�cessaire � la validation de l'�quation utilis� pour le
%   calcul n'a pas �t� valide.
%
%NOTE SUR LA PROGRESSION:
%   RIEN N'A ENCORE �T� TEST�.
%
%Source:
%	- https://fr.wikipedia.org/wiki/A%C3%A9rodynamique_de_la_pointe_avant (consult� le 1er d�cembre 2016)
%	- https://en.wikipedia.org/wiki/Nose_cone_design (consult� le 1er d�cembre 2016)
%
function [x, y] = profil_balistique(r_n, L2, R2, p, Coeff_K, Coeff_n, Coeff_C, L, R, precision_x, choix)
	if not(choix==3)
        x = 0:precision_x:L;
    end
    
    switch(choix)
        %Profile Conique:
        case 1
            y = profil_conique(L, R, x);
            
        %Profil Conique tronqu� par une sph�re:
        case 2
            y = profile_conique_tronque_par_sphere(L, R, r_n, x);
            
        %Profil de Pointe biconique
        case 3
             x = 0:precision_x:(L+L2);
            [y] = profile_biconique(L, L2, R, R2, x);
            
        %Profil � ogive tangente
        case 4
            [y] = profile_ogive_tangente(R, L, x);
            
        %Pointe � ogive tangente tronqu� par une sph�re
        case 5
            [y] = profile_ogive_tangente_sphere(R, L, r_n, x);
            
        %Point � ogive s�cante
        case 6
            [y] = profile_pointe_ogive_secante(R, L, p, x);
            
        %Pointe elliptique
        case 7
            [y] = profile_pointe_elliptique(R, L, x);
            
        %Pointe parabolique
        case 8
            [y] = profile_pointe_parabolique(R, L, Coeff_K, x);
            
        %Pointe g�n�r�e par une fonction de puissance
        case 9
            [y] = profile_pointe_genere_via_fonction_puissance(R, L, Coeff_n, x);
            
        %Pointe g�n�r�e par une fonction de Haack
        case 10
            [y] = profile_pointe_genere_via_fonction_Haack(R, L, Coeff_C, x);     
    end
end

%-----------------------------------------------------

%% Profil Conique:
%Description:
%	Une forme de pointe en c�ne, avant tr�s commune.
%	Forme souvent choisit pour sa simplicit� de fabrication, et
%	ausssi souvent choisie (et parfois mal choisit) pour ces 
%	caract�ristique de train�e.
%
%Retour:
%   - y = La valeur du RAYON au diff�rent point en X.
%
function [y] = profil_conique(L, R, x)
	%�quation du diam�tre au diff�rent point en X.
    %y = (2*R/L).*x;
    
    %�quation du rayon au diff�rent point en X.
    y = (R/L).*x;
end

%-----------------------------------------------------
%% Profil Conique tronqu� par une sph�re:
%Description:
%	En pratique, une pointe conique est souvent tronqu� par un morceau de sph�re.
%
%Calculs:
%   - On a un c�ne tronqu� par une sph�re et on a l'�quation
%     du diam�tre pour un c�ne (voir profil conique).
%   - Sachant la position du cercle et son rayon,
%     on en d�duit la position o� d�bute le c�ne.
%
%Param�tre particulier:
%	- r_n = le rayon de la sph�rique
%
%Note:
%   Modification effectu� apr�s car avait invers� X.
%   Je me suis rappel� ensuite que x = 0 = la pointe et non l'inverse.
%
%Retour:
%   - y = le RAYON (par d�faut, selon texte Wikipidia) au diff�rent point
%   en X.
%
%Source suppl�mentaire:
%   - Calcule calotte sph�rique: http://calculis.net/q/calotte-spherique-15
%   (consult� le 20 d�cembre 2016)
%   - Les �quations utilis� pour le calcul de la colotte sph�rique:
%   http://calculis.net/q/calotte-spherique-15 (consult� le 20 d�cembre
%   2016)
function [y] = profile_conique_tronque_par_sphere(L, R, r_n, x)
    %initialise le vecteur pour m�moire d�j� mit. Note: 0 important pour
    %skip la fin o� sait qu'on a d�j� mit des 0 = pas besoin d'en mettre en
    %plus.
    y = zeros(1,numel(x));
    
    %Position o� d�but le c�ne -> Point tangent au cercle.
    x_t = (L^2/R)*sqrt((r_n^2)/(R^2+L^2));
    y_t = (x_t*R)/L;
    
    %Calule du x du centre de la sph�re
    x_o = x_t + sqrt(r_n^2 - y_t^2);
    
    %Calcule de la positon en x o� finie la sph�re (y = 0 apr�s cela)
    x_a = x_o - r_n;
    
    %-----------------------------
    %Mettre le curseur "i" au d�but zone o� a un rayon != 0. Note: L�
    %v�rifier et semble parfait. But (a verifier car pas Matlab) = avoir dernier case ou x < x_a
    copie_x = x; %enregistr� une copie de x.
    copie_x(copie_x>=x_a) = 0; %tout ceux > x_a (avant d�but sph�re) mit � 0.
    pos = find(copie_x); %find retourne toute les position o� pas 0 (ou x < x_a)
    i = pos(numel(pos)); %on va cherche la derni�re valeur = celle avant d�but sph�re.
    i = i + 1;
    
    %On obtient la position o� d�bute la sph�re.
    debut_sphere = x(i);
    
    %Calcule de y pour la partie sph�rique (calotte sph�rique en fait).
    %S'arr�te au point de x_t ou au point apr�s le x_t.
    %J'ai refait le calcul partie sph�re et conique et maintenant ils sont
    %coh�rent entre eux et avec xt et yt.
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
%   "Une pointe biconique est simplement un c�ne de longueur L1 tronqu� 
%   par un autre c�ne de longueur L2", d'o� 2 Longueurs et 2 Rayons.
%   
%   L_total = L = L1 + L2
%
%Retour:
%   - y = (par d�faut, selon texte wikip�idia) le RAYON au diff�rent point
%   en X.
%
function [y] = profile_biconique(L1, L2, R1, R2, x)
    %Assigner m�moire au tableau y.
    y = zeros(1,numel(x));
    
    %La zone du 1er c�ne: x = [0, L1] (pointe � fin c�ne 1)
    i = 1;
    while(i <= numel(x) && x(i) < L1)
       y(i) = (R1/L1)*x(i); 
       i = i + 1;
    end
    
    %La zone du 2�me c�ne: x = [L1 L]
    while(i <= numel(x))
       y(i) = R1 + (1/L2)*(x(i)-L1)*(R2 - R1);
       i = i + 1;
    end
end

%-----------------------------------------------------
%% Pointe � ogive tangente
%Description:
%   "Avec la forme conique, la forme en ogive est la plus famili�re dans
%   les micro fuses. Ce profil de r�volution est obtenue � partir d'un arc
%   de cercle tangent � la base au corps de l'engin (fus�e, balle). La
%   populari�t de cette forme est largement due � la facilit� de la
%   construction de de son profil."
%
%Retour:
%   - y = La valeur du RAYON au diff�rent point en X.
%
function [y] = profile_ogive_tangente(R, L, x)
    %"Le rayon de l'arc de cercle qui forme l'ogie est appel� rayon de 
    %l'ogive p (rh�) et est li�e � la longuer et la largeur de la pointe 
    %avant par la formule: "
    p = (R^2+L^2)/(2*R);
    y = sqrt(p^2-(L-x).^2) + R - p;
end

%-----------------------------------------------------
%% Pointe � ogive tangente tronqu� par une sph�re.
%Description:
%   "Une forme � ogive est souvent tronqu� par un morceau de sph�re."
%
%Retour (suppos� par fonction pr�c�dente):
%   - y = valeur du RAYON au diff�rent point en X.
function [y] = profile_ogive_tangente_sphere(R, L, r_n, x)
    %Assigner m�moire au tableau y.
    y = zeros(1,numel(x));
    
    %Note: � d�duit que m�me p (rho) que ogive tangente
    p = (R^2+L^2)/(2*R);
    
    %V�rification pour s'assurer pas de nombre imaginaire = mauvaise
    %donn�e.
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

    %Point centre de la sph�re
    disp((p-r_n)^2 - (p - R)^2)
    x_o = L - sqrt( (p-r_n)^2 - (p - R)^2);
    
    %Calcul point tangence entre sph�re et ogive
    y_t = (1/(p-r_n))*r_n*(p-R);
    x_t = x_o - sqrt(r_n^2 - y_t^2);
    
    %Calcul point d�part de la sph�re (d�but pointe � partir de x = 0).
    x_a = x_o - r_n;
    
    %--------------
    %Calcule du rayon pour la partie sph�rique (code copie-coller de conique tronqu�)
    
    %Mettre le curseur "i" au d�but zone o� a un rayon != 0. Note: L�
    %v�rifier et semble parfait.
    copie_x = x; %enregistr� une copie de x.
    copie_x(copie_x>=x_a) = 0; %tout ceux > x_a (avant d�but sph�re) mit � 0.
    pos = find(copie_x); %find retourne toute les position o� pas 0.
    i = pos(numel(pos)); %on va cherche la derni�re valeur = celle avant d�but sph�re.
    i = i + 1;
    
    %On obtient la position o� d�bute la sph�re.
    debut_sphere = x(i);
    
    %Calcule de y pour la partie sph�rique (calotte sph�rique en fait).
    %S'arr�te au point de x_t ou au point apr�s le x_t.
    %J'ai refait le calcul partie sph�re et conique et maintenant ils sont
    %coh�rent entre eux et avec xt et yt.
    while(i <= numel(x) && x(i) < x_t)
        h = x(i) - debut_sphere;
        y(i) = sqrt(2*r_n*h-h^2);
        i = i + 1;
    end
    
    %--------------
    %Calcule pour la partie ogive (via �quation de fonction pr�c�dente)
    while(i <= numel(x))
       y(i) = sqrt(p^2-(L-x(i))^2) + R - p;
       i = i + 1;
    end
end

%-----------------------------------------------------
%% Pointe � ogive s�cante
%Description:
%"Le profil de cette forme est �galement form� d'un arc de cercle d�finit
%par le rayon de l'ogive. Le orgps de l'engin n'est pas tangent � la base
%de l'ogive. Le rayon de l'ogive p(rh�) n'est pas d�terminer par R et L
%(comme pour l'ogive tangente), mais l'un des facteur doit �tre choisit
%pour d�finir la forme de la pointe."
%Deux cas possible pour un R et L pareille: 
%#1) R_ogive_secante > R_ogive_tangente:
%   "Si l'on choisit le rayon de l'ogive s�cante plus grande que le rayon
%   de l'ogive tangente avec le m�me R et L, l'ogive s�cante r�sultante
%   apparaitra comme une ogive tangente avec une base tronqu�".
%
%#2) R_ogive_secante < R_ogive_tangente:
%   "Si l'on choisit p (rh�) plus petit que le rayon de l'ogive tangente p
%   (rh�), alors on obtient une ogive s�cante qui aura un renflement plus
%   important que le diam�tre de la base. L'exemple classique de cette
%   forme est la pointe avant du missile MGR-1 Honest John. De plus le
%   rayon choisit doit �tre plus grand que la moiti� de la longueur de la
%   pointe avant".
%
%Note:
%   On a seuelement �quation dans section du cas #1, donc j'ai suppos� que
%   �quation �tait les m�mes pour le cas #2 (via Wikip�dia FR et EN seulement)
%
%   De ce fait, puisque cas #1 et #2 ont les m�mes �quations (supposition),
%   on va juste combiner les conditions des 2 cas ensemble pour la
%   validation que �quation utilisable.
%
%   Condition cas #1: p > (R^2+L^2)/2*R
%   Condition cas #2: p < (R^2+L^2)/2*R && p > L/2
%
%Param�tres:
%   - R : Le rayon de la partie haute de l'ogive s�cante (voir image
%   Wikip�dia FR ou EN)
%   - L : La longueur (voir image de Wikip�dia FR ou EN)
%   - p : rh�, le rayon de l'ogive s�cante (voir image de Wikip�dia FR ou
%   EN).
%   - X : la valeur des point de l'axe X variant de 0 � L o� 0 = la pointe.
%
%Retour:
%   - y = la valeur du RAYON au diff�rent point en X.
%
function [y] = profile_pointe_ogive_secante(R, L, p, x)
    %Par d�faut, au cas o� condition invalide, on met des 0 dans y.
    y = zeros(1,numel(x));
    
    %V�rification validit� condition combin�e
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
%"Le profil de cette forme est une moiti� d'une ellipse, avec le grand axe
%et le petit axe �tant la base de la pointe avant. Une rotation d'une
%ellipse compl�te autour de son axe majeur est un ellipso�de, ainsi la
%forme de nez elliptique est un h�miellipso�de. Cette forme est tr�s
%utilis� pour le vol subsonique (tels que les fus�es miniatures) en raison
%de l'arrondi de la pointe et de la tangente � la base. Ce n'est pas une
%forme que l'on retrouve sur les vraies fus�es. Si R = L, il s'agit d'un
%h�misph�re".
%
%Param�tres:
%   - R = le Rayon de la base
%   - L = la longueur total
%   - X = les diff�rentes valeurs de la longueur o� X varie de 0 (pointe) �
%   L (la base).
%   
%Retour:
%   - y = (par d�faut, selon texte Wikip�dia) le RAYON au diff�rent point
%   en X.
%
function [y] = profile_pointe_elliptique(R, L, x)
    tempo_x = (x.^2)/(L.^2);
    y = R*sqrt(1-tempo_x);
    
    %Note: Puisque l'affichage montre que semble �tre dans le sens inversee
    %(car pointe semble �tre � la fin), inversion ordre des y.
    y = fliplr(y);
end

%-----------------------------------------------------
%% Pointe parabolique
%Description:
%"La forme parabolique s�rie est produite par la rotation d'une partie
%parabole autour d'une ligne parall�le de son latus rectum. Cette
%construction est semblable � celle de l'ogive tangente, sauf que la
%g�n�ratrice est un arc de parabole plut�t qu'un arc de cercle. Tout comme
%sur une ogive, cette construction donne une forme de pointe avant avec une
%pointe aigu�. Pour la forme �mous�e g�n�ralement associ�e � un nez
%parabolique, voir la s�rie des forme d�finit par des fonctions de
%puissance (la forme parabolique est �galement souvent confondue avec la
%forme elliptique)".
%
%Param�tres:
%   - Coeff_K : varie entre 0 et 1 o� les plus utilis� sont:
%       - Coeff_K = 0 pour un c�ne.
%       - Coeff_K = 0.5 pour une demi parabole
%       - Coeff_K = 0.75 pour 3/4 de parabole.
%       - Coeff_K = 1 pout une parabole compl�te.
%
%Note suppl�mentaire:
%   Pour le cas de la parabole compl�te (Coeff_K = 1), la pointe avant est
%   tangente au coprs de l'engin � sa base et la base est sur un axe de
%   parabole. Les valeurs des Coeff_K < 1 donne une forme plus affin�e qui
%   apparaisset � l'ogive s�cante. La forme r�sultante n'Est alors plus
%   tangente � la base de l'engin, mais la base demeurse parall�le, bien
%   que d�ca�e, � l'axe de de la parabole.
%
%Retour:
%   - y = (par d�faut selon texte Wikip�dia) le RAYON aux diff�rentes
%   valeurs en X.
%
function [y] = profile_pointe_parabolique(R, L, Coeff_K, x)
    %Au cas o� condition invalide.
    y = zeros(1,numel(x));

    %V�rification que Coeff_K respecte condition validation de l'�quation
    %d'apr�s.
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
%% Pointe g�n�r� par une fonction de puissance
%Description:
%"La fonction de puissane inclut la forme commun�ment appel�e pointe aveant
%<<parabolique>>, mais la v�ritable pointe avant fait partie des pointes
%avant g�n�r�es � partie de fonction parabolique, qui sont compl�tement
%diff�rentes  des pointes avant g�n�r�es par des fonctions de puissance. La
%forme g�n�r�e par une fonction de puissance se caract�risent g�n�ralement
%par sa pointe �mouss�e, et par le fait que sa base n'est pas tangente avec
%le corps de l'engin qui peut �tre p�nalisante pour l'a�rodynamique. La
%forme peut �tre modifi�e � la base pour lisser cette discontinuit�. Les
%formes cylindrique et conique font parties de cette famille."
%
%Param�tres:
%   - Coeff_n: valeur qui doit �tre (pour l'�quation utilis�) entre 0 et 1
%   o�:
%       - Coeff_n = 1 pour un c�ne.
%       - Coeff_n = 0.5 pour une parabole
%       - Coeff_n = 0 pour un cylindre
%   - R = le rayon � la base (habituellement)
%   - L = la longueur totale (habituellement)
%   - X = les valeurs des points entre 0 (la pointe) et L (la base).
%   
%Retour:
%   - y = (par d�faut, selon texte Wikip�dia) du RAYON aux diff�rents point
%   en X.
%
function [y] = profile_pointe_genere_via_fonction_puissance(R, L, Coeff_n, x)
    %Au cas o� condition invalide.
    y = zeros(1,numel(x));
    
    %V�rification de la condition validation de l'�quation qui suit.
    if(Coeff_n < 0 || Coeff_n > 1)
       disp('profile_pointe_genere_via_fonction_puissance: Error: 0 <= Coeff_n <= 1');
       return
    end
    
    %Calcule de y sachant condition valide: y = R*(x/L)^n;
    y = x./L;
    y = y.^Coeff_n;
    y = R*y;
end

%% Pointe g�n�r�e par une fonction de Haack
%Description:
%"Contrairement aux formes de pointe avant pr�c�dentes, celle obtenue par
%une fonction de Haack n'est pas constuite � partir de forme g�om�triques.
%Ces formes proviennent des math�matiques afin de minimiser la tra�n�e
%a�rodynamique. Bien que la fonction de Haack existe pour toutes valeur de
%C [(on parle souvent de coeff C/L)], deux valeur de C ont une importance
%particuli�re. Lorsque C = 0, on obtient la tra�n�e minimale pour une
%longueur est un diam�tre donn�es (LD-Haack), et lorsque C = 1/3, on
%obtient la train�e minimale pour une longueur et une volume donn�s
%(LV-Haack). Les pointes avant construites sur les fonctions de Haack ne
%sont pas parfaitement tangentes, � leur base, au corps de l'engin. La
%discontinuit� de tangente est cependant g�n�ralement tr�s faible pour
%�tre imperceptible. L'extr�mit� des pointes avant construites sur les
%fonctions de Haack ne pr�sentent pas une pointe aig�e mais sont l�g�rement
%arrondies".
%
%Param�tres:
%   - Coeff_C: Coefficient C qu'on parle dans le texte (?? c'est quoi ??)
%   o�:
%       - Coeff_C = 1/3 pour LV-Haack (traine minimum pour longueur et
%       volume donn�e)
%       - Coeff_C = 0 pour LD-Haack (train�e minimum pour longueur et
%       diam�tre donn�e).
%   - R = le rayon � la base
%   - L = la longueur total
%   - X = la valeur des points de 0 (la pointe) � L (la base).
%
%Retour:
%   - y = (par d�faut, selon texte Wikip�dia) du RAYON aux diff�rents point
%   en X.
%
function [y] = profile_pointe_genere_via_fonction_Haack(R, L, Coeff_C, x)
    %Calcule de l'angle th�ta
    theta = acos(1-(2/L).*x);
    
    %Calcule de y
    y = theta - 0.5*sin(2*theta) + Coeff_C*((sin(theta)).^3);
    y = (R/sqrt(pi))*sqrt(y);
end