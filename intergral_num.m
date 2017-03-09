%% intergral_num
%Description:
%   Plusieurs méthode d'intégration numérique à partir des points en x et
%   en y qui ont été obtenue. Si la fonction est déjà connue, les points en
%   x et en y peuvent facilement être exporté en deux vecteur séparé.
%
%   Note: Fichier copie-coller de celui du dossier "Outils ELE735".
%
%Paramètres:
%   - x et y = les valeurs de la fonction en chaque points.
%   - choix = le numéro de la méthode utilisé:
%       - choix = 1: Methode Rectangle composite
%       - choix = 2: Methode Point Milieu (MidPt) composite (nécessite
%       "funct")
%       - choix = 3: Methode Trapèze.
%       - choix = 4: Simpson's 1/3 (nécessite h = cte et (nbpt-1)%2=0).
%       - choix = 5: Simpson's 3/8 (nécessite h= cte et (nbpt-1)%3 = 0).
%
%Retour:
%   - L'intégrale de la fonction (l'aire sous la courbe) selon les points
%   fournies.
%
%Note:
%   - x sert uniquement à calcule du h (au cas où pas constant) et à Midpt
%   pour y milieu.
%   - Meth Trapèze et Midpt testé avec un exemple.
function [integral] = intergral_num(x, y, funct, choix)
    integral = NaN;
        
    if( sum(isnan(x)) || sum(isnan(y)) || not(numel(x)==numel(y)) || choix<1 || choix>5) 
       disp('intergral_num: parameters invalid')
       return
    end
    switch(choix)
        %Methode Rectangle composite:
        case 1
           [integral] = integral_rect(x, y);
           
        %Methode du MidPt composite:
        case 2
           [integral] = integral_midpt(x, funct); 
           
        %Methode du Trapeze composite:
        case 3
           [integral] = intergral_trapeze(x,y);
        
        %Methode Simpson's 1/3: 
        case 4
            [integral] = integral_simpson_1(x,y);
            
        %Methode Simpson's 3/8: 
        case 5
            [integral] = integral_simpson_2(x,y);
    end
end

%----------------------------------------------------
%% integral_rect:
%Description;
%   Calcule l'intégrale à l'aide de la méthode du rectangle composite.
%   Méthode très simple et rapide à calculer, parfait si point très
%   rapproché, mais est-celle qui aura la plus grande erreur de calcul pour
%   une même série de point.
function [integral] = integral_rect(x, y)
    nbpt = numel(x);
    integral = 0;
    for i = 1:nbpt-1
        integral = integral + y(i)*(x(i+1)-x(i));
    end
end

%----------------------------------------------------
%% integral_midpt:
%Description:
%   Calcule l'intégrale à l'aide de la méthode du point Milieu, soit la
%   méthode du rectangle, mais avec lequel on prend le point au milieu de
%   l'intervalle. Plus précise que celle du rectangle (et parfaite si
%   linéaire entre les points fournis), mais nécessite d'avoir la fonction.
%   Sans cela, revient à faire la méthode du trapèze (selon le prof).
function [integral] = integral_midpt(x, funct)
    nbpt = numel(x);
    integral = 0;
    for i=1:nbpt-1
       integral = integral + (x(i+1)-x(i))*funct((x(i)+x(i+1))/2); 
    end
end

%----------------------------------------------------
%% integral_trapeze
%Description:
%   Calcule l'intégrale à l'aide de la méthode du trapèze composite, une
%   méthode parfaite si le polynombre est d'ordre 1 entre les points (suit
%   parfaitement la courbe), sans pour autant nécessiter d'avoir la
%   fonction (contrairement à la méthode du point milieu). Donne de
%   meilleur approximation que la méthode du rectangle dans les autres cas.
function [integral] = intergral_trapeze(x,y)
    nbpt = numel(x);
    integral = 0;
    for i=1:nbpt-1
       integral = integral + (y(i+1)+y(i))*(x(i+1)-x(i));
    end
    integral = 0.5*integral;
end

%----------------------------------------------------
%% integral_simpson_1
%Description:
%   Calcule l'intégrale à l'aide de la méthode de Simpson's 1/3, une
%   méthode qui approxime l'aire sous la courbe à l'aide d'un polynombre
%   d'ordre 2 (une parabole), ce qui donne un calcul parfait lorsque le
%   polynombre sur l'intervalle est un polynombre d'ordre 2 ou moins.
%
%Paramètres nécessaire:
%   - Le nombre d'intervalle, (nbpt-1), doit être pair.
%   - L'espacement entre les points , h = x(i+1)-x(i), doit être constant
%     sur l'intervalle du calcul de l'intégrale.
function [integral] = integral_simpson_1(x,y)
    nbpt = numel(x);
    %Le nombre d'intervalle doit être pair pour cette méthode.
    if(not(mod(nbpt-1,2)==0))
       disp('intergral_num: Simpson 1/3: Need (nbpt-1)%2 = 0');
       integral = NaN;
       return
    end
    integral = y(1)+y(nbpt);
    
    %L'espacement entre les points doit être constant pour cette méthode.
    h = x(2) - x(1);
    for i=2:nbpt-1
        %Si "i" est pair:
        if(mod(i,2)==0)
            integral = integral + 4*y(i);
        %Si "i" est impair:
        elseif(i<=nbpt-2)
          integral = integral + 2*y(i);  
        end
    end
    integral = (h/3)*integral;
end

%----------------------------------------------------
%% integral_simpson_2
%Description:
%   Calcule l'intégrale à l'aide de la méthode de Simpson's 3/8, une
%   méthode qui approxime l'aire sous la courbe à l'aide d'un polynombre
%   d'ordre 3, ce qui donne un calcul parfait lorsque le polynombre sur
%   l'intervalle est un polynombre d'ordre 3 ou moins.
%
%Paramètres nécessaire:
%   - Le nombre d'intervalle, (nbpt-1), doit être multiple de 3.
%   - L'espacement entre les points , h = x(i+1)-x(i), doit être constant
%     sur l'intervalle du calcul de l'intégrale.
function [integral] = integral_simpson_2(x,y)
    nbpt = numel(x);
    %Le nombre d'intervalle doit être divisible par 3 pour cette méthode.
    if(not(mod(nbpt-1,3)==0))
       disp('intergral_num: Simpson 3/8: Need (nbpt-1)%3 = 0');
       integral = NaN;
       return
    end
    integral = y(1)+y(nbpt);
    
    %L'espacement entre les points doit être constant pour cette méthode.
    h = x(2) - x(1);
    for i=2:nbpt-2
        %Si mod(i,3)==2:
        if(mod(i,3)==2)
            integral = integral + 3*(y(i)+y(i+1));
        %Si mod(i,3)==1:
        elseif(mod(i,3)==1 && i<=(nbpt-3))
          integral = integral + 2*y(i);
        end
    end
    integral = (3*h/8)*integral;
end