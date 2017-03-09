%% Remove_column_zero_at_end
%Description:
%   Fonction qui réduit la dimension de la matrice envoyé en enlevant les
%   colonnes ou les lignes (dépendant du choix) où toutes les lignes ou 
%   toutes les colonnes sont  misent à 0.
%
%   Cette fonction est notamment utilisé dans la fonction "Trajectoire_V2"
%   dû au fait qu'on part avec des matrices très grandes qui ne seront pas
%   nécessairement remplie, ce qui fait que pour l'affichage, on va réduire
%   les dimensions en enlevant la parties pas utilisé.
%
%Fonctionnement (ex avec is_column_search = 1):
%   On identifie la 1ère colonne (à partir de celle envoyé [ce qui l'inclue
%   pour l'actuellement]) à toutes les lignes sont à 0 et on réduit donc la
%   taille de la matrice en enlevant cette colonne et tout ce qui ce trouve
%   après celle-ci.
%
%Paramètres:
%   - mat: la matrice à réduire de taille
%   
%   - column_or_line_start_search: le no de ligne où on commence à
%   recherche la ligne ou colonne ayant uniquement des valeurs à 0.
%   
%   -  is_column_search: 1(true) si recherche de colonne à 0. 0 (false) si
%   recherche de ligne à 0.
%
%Note de dévéléloppement:
%   À été testé et corrigé par rapport à vecteur ligne et vecteur colonne
%   (avec et sans 0 à couper). Maintenant complète et fonctionnelle.
%
%Retour:
%   La matrice envoyé auquel on a enlever les colonnes (ou les lignes) qui
%   était après celle à 0.
%
%   column_or_line_start_cut = le numéro de ligne ou de la colonne
%   identifier comme ayant uniquement des 0.
%   On peut ensuite s'en servir pour appliquer la même chose sur d'autres
%   matrices qui doivent avoir les mêmes dimensions SANS passer par cette
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
%   Fonction pour enlever toutes les colonnes ayant des lignes à 0 (en se
%   basant sur la 1ère identifier comme ayant uniquement des lignes à 0).
%
function [mat, i] = remove_column_zero_at_end(mat, column_start_search)
    %Initialisation
    [nb_line, nb_column] = size(mat);
    
    i = column_start_search;
    
    %Trouvé la 1ère colonne (à partir celle de départ envoyé) où uniquement
    %des 0.
    while(not(sum(mat(:,i)==0)==nb_line) && (i+1)<= nb_column)
       i = i + 1; 
    end
    
    %Si on l'a pas trouvé, alors on aumgente i de 1 afin que la
    %méthodologie du calcul de coupure soit toujours la même.
    if(not(sum(mat(:,i)==0)==nb_line))
       i = i + 1;
    end
    
    %Enlève les colonnes de trop (si la matrice à plus d'une colonne)
    if(i > 1)
        mat = mat(:,1:i-1);
        
    %Sinon, matrice devenue vide, car l'aura enlever.
    else
        mat = [];
    end
end

%% Remove line zero at end
%Description:
%   Fonction pour enlever toutes les lignes ayant des colonnes à 0 (en se
%   basant sur la 1ère identifier comme ayant uniquement des colonnes à 0).
%
function [mat, i] = remove_line_zero_at_end(mat, line_start_search)
    %Initialisation
    [nb_line, nb_column] = size(mat);
    i = line_start_search;
    
    %Trouvé la 1ère ligne (à partir celle de départ envoyé) où uniquement
    %des 0.
    while(not(sum(mat(i,:)==0)==nb_column) && (i+1)<= nb_line)
       i = i + 1; 
    end
    
    %Si on a pas trouvé, alors on augmente i de 1 afin que la méthodologie
    %du calcul de coupure soit applicable en tout temps.
    if(not(sum(mat(i,:)==0)==nb_column))
       i = i + 1;
    end
    
    
    %Enlève les lignes de trop (si la matrice à plus d'une ligne)
    if(i > 1)
        mat = mat(1:i-1,:);
    
    %Sinon, matrice devenue vide, car l'aura enlever
    else
        mat = [];
    end
end

