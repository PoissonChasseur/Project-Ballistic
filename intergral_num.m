%% intergral_num
%Description:
%   Plusieurs m�thode d'int�gration num�rique � partir des points en x et
%   en y qui ont �t� obtenue. Si la fonction est d�j� connue, les points en
%   x et en y peuvent facilement �tre export� en deux vecteur s�par�.
%
%   Note: Fichier copie-coller de celui du dossier "Outils ELE735".
%
%Param�tres:
%   - x et y = les valeurs de la fonction en chaque points.
%   - choix = le num�ro de la m�thode utilis�:
%       - choix = 1: Methode Rectangle composite
%       - choix = 2: Methode Point Milieu (MidPt) composite (n�cessite
%       "funct")
%       - choix = 3: Methode Trap�ze.
%       - choix = 4: Simpson's 1/3 (n�cessite h = cte et (nbpt-1)%2=0).
%       - choix = 5: Simpson's 3/8 (n�cessite h= cte et (nbpt-1)%3 = 0).
%
%Retour:
%   - L'int�grale de la fonction (l'aire sous la courbe) selon les points
%   fournies.
%
%Note:
%   - x sert uniquement � calcule du h (au cas o� pas constant) et � Midpt
%   pour y milieu.
%   - Meth Trap�ze et Midpt test� avec un exemple.
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
%   Calcule l'int�grale � l'aide de la m�thode du rectangle composite.
%   M�thode tr�s simple et rapide � calculer, parfait si point tr�s
%   rapproch�, mais est-celle qui aura la plus grande erreur de calcul pour
%   une m�me s�rie de point.
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
%   Calcule l'int�grale � l'aide de la m�thode du point Milieu, soit la
%   m�thode du rectangle, mais avec lequel on prend le point au milieu de
%   l'intervalle. Plus pr�cise que celle du rectangle (et parfaite si
%   lin�aire entre les points fournis), mais n�cessite d'avoir la fonction.
%   Sans cela, revient � faire la m�thode du trap�ze (selon le prof).
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
%   Calcule l'int�grale � l'aide de la m�thode du trap�ze composite, une
%   m�thode parfaite si le polynombre est d'ordre 1 entre les points (suit
%   parfaitement la courbe), sans pour autant n�cessiter d'avoir la
%   fonction (contrairement � la m�thode du point milieu). Donne de
%   meilleur approximation que la m�thode du rectangle dans les autres cas.
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
%   Calcule l'int�grale � l'aide de la m�thode de Simpson's 1/3, une
%   m�thode qui approxime l'aire sous la courbe � l'aide d'un polynombre
%   d'ordre 2 (une parabole), ce qui donne un calcul parfait lorsque le
%   polynombre sur l'intervalle est un polynombre d'ordre 2 ou moins.
%
%Param�tres n�cessaire:
%   - Le nombre d'intervalle, (nbpt-1), doit �tre pair.
%   - L'espacement entre les points , h = x(i+1)-x(i), doit �tre constant
%     sur l'intervalle du calcul de l'int�grale.
function [integral] = integral_simpson_1(x,y)
    nbpt = numel(x);
    %Le nombre d'intervalle doit �tre pair pour cette m�thode.
    if(not(mod(nbpt-1,2)==0))
       disp('intergral_num: Simpson 1/3: Need (nbpt-1)%2 = 0');
       integral = NaN;
       return
    end
    integral = y(1)+y(nbpt);
    
    %L'espacement entre les points doit �tre constant pour cette m�thode.
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
%   Calcule l'int�grale � l'aide de la m�thode de Simpson's 3/8, une
%   m�thode qui approxime l'aire sous la courbe � l'aide d'un polynombre
%   d'ordre 3, ce qui donne un calcul parfait lorsque le polynombre sur
%   l'intervalle est un polynombre d'ordre 3 ou moins.
%
%Param�tres n�cessaire:
%   - Le nombre d'intervalle, (nbpt-1), doit �tre multiple de 3.
%   - L'espacement entre les points , h = x(i+1)-x(i), doit �tre constant
%     sur l'intervalle du calcul de l'int�grale.
function [integral] = integral_simpson_2(x,y)
    nbpt = numel(x);
    %Le nombre d'intervalle doit �tre divisible par 3 pour cette m�thode.
    if(not(mod(nbpt-1,3)==0))
       disp('intergral_num: Simpson 3/8: Need (nbpt-1)%3 = 0');
       integral = NaN;
       return
    end
    integral = y(1)+y(nbpt);
    
    %L'espacement entre les points doit �tre constant pour cette m�thode.
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