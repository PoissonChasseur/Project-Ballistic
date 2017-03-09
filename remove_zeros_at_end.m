%% Remove_column_zero_at_end
%Description:
%   Fonction qui r�duit la dimension de la matrice envoy� en enlevant les
%   colonnes ou les lignes (d�pendant du choix) o� toutes les lignes ou 
%   toutes les colonnes sont  misent � 0.
%
%   Cette fonction est notamment utilis� dans la fonction "Trajectoire_V2"
%   d� au fait qu'on part avec des matrices tr�s grandes qui ne seront pas
%   n�cessairement remplie, ce qui fait que pour l'affichage, on va r�duire
%   les dimensions en enlevant la parties pas utilis�.
%
%Fonctionnement (ex avec is_column_search = 1):
%   On identifie la 1�re colonne (� partir de celle envoy� [ce qui l'inclue
%   pour l'actuellement]) � toutes les lignes sont � 0 et on r�duit donc la
%   taille de la matrice en enlevant cette colonne et tout ce qui ce trouve
%   apr�s celle-ci.
%
%Param�tres:
%   - mat: la matrice � r�duire de taille
%   
%   - column_or_line_start_search: le no de ligne o� on commence �
%   recherche la ligne ou colonne ayant uniquement des valeurs � 0.
%   
%   -  is_column_search: 1(true) si recherche de colonne � 0. 0 (false) si
%   recherche de ligne � 0.
%
%Note de d�v�l�loppement:
%   � �t� test� et corrig� par rapport � vecteur ligne et vecteur colonne
%   (avec et sans 0 � couper). Maintenant compl�te et fonctionnelle.
%
%Retour:
%   La matrice envoy� auquel on a enlever les colonnes (ou les lignes) qui
%   �tait apr�s celle � 0.
%
%   column_or_line_start_cut = le num�ro de ligne ou de la colonne
%   identifier comme ayant uniquement des 0.
%   On peut ensuite s'en servir pour appliquer la m�me chose sur d'autres
%   matrices qui doivent avoir les m�mes dimensions SANS passer par cette
%   fonction via (ex):
%   1) [a, i] = remove_zeros_at_end(a, column_or_line_start_search,
%   is_column_search)
%   2) b = 
%
function [mat, column_or_line_start_cut] = remove_zeros_at_end(mat, column_or_line_start_search, is_column_search)
    switch(is_column_search)
        %Line search
        case 0
            [mat, column_or_line_start_cut] = remove_line_zero_at_end(mat, column_or_line_start_search);
            
        %Column search
        case 1
            [mat, column_or_line_start_cut] = remove_column_zero_at_end(mat, column_or_line_start_search);
    end
end

%% Remove column zero at end
%Description:
%   Fonction pour enlever toutes les colonnes ayant des lignes � 0 (en se
%   basant sur la 1�re identifier comme ayant uniquement des lignes � 0).
%
function [mat, i] = remove_column_zero_at_end(mat, column_start_search)
    %Initialisation
    [nb_line, nb_column] = size(mat);
    
    i = column_start_search;
    
    %Trouv� la 1�re colonne (� partir celle de d�part envoy�) o� uniquement
    %des 0.
    while(not(sum(mat(:,i)==0)==nb_line) && (i+1)<= nb_column)
       i = i + 1; 
    end
    
    %Si on l'a pas trouv�, alors on aumgente i de 1 afin que la
    %m�thodologie du calcul de coupure soit toujours la m�me.
    if(not(sum(mat(:,i)==0)==nb_line))
       i = i + 1;
    end
    
    %Enl�ve les colonnes de trop (si la matrice � plus d'une colonne)
    if(i > 1)
        mat = mat(:,1:i-1);
        
    %Sinon, matrice devenue vide, car l'aura enlever.
    else
        mat = [];
    end
end

%% Remove line zero at end
%Description:
%   Fonction pour enlever toutes les lignes ayant des colonnes � 0 (en se
%   basant sur la 1�re identifier comme ayant uniquement des colonnes � 0).
%
function [mat, i] = remove_line_zero_at_end(mat, line_start_search)
    %Initialisation
    [nb_line, nb_column] = size(mat);
    i = line_start_search;
    
    %Trouv� la 1�re ligne (� partir celle de d�part envoy�) o� uniquement
    %des 0.
    while(not(sum(mat(i,:)==0)==nb_column) && (i+1)<= nb_line)
       i = i + 1; 
    end
    
    %Si on a pas trouv�, alors on augmente i de 1 afin que la m�thodologie
    %du calcul de coupure soit applicable en tout temps.
    if(not(sum(mat(i,:)==0)==nb_column))
       i = i + 1;
    end
    
    
    %Enl�ve les lignes de trop (si la matrice � plus d'une ligne)
    if(i > 1)
        mat = mat(1:i-1,:);
    
    %Sinon, matrice devenue vide, car l'aura enlever
    else
        mat = [];
    end
end

