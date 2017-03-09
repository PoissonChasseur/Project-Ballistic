%% eval_f:
%Description
%   Pour évaluer une fonction en fonction d'un vecteur des paramètres.
%
%Important:
%   Le nombre de paramètre de "funct" et la longuer de "vector_value"
%   doivent être pareille, sinon = erreur.
%Solution: 
%   - http://stackoverflow.com/questions/15075444/want-to-use-a-vector-as-parameter-to-a-function-without-having-to-separate-its
%   - (+) nargin -> number of input argument of the function (because if
%   not long or too short = trouble)
function [value] = eval_f(funct, vector_value)
    valeur = num2cell(vector_value); %Prend la matrice et la met en liste.
    value = funct(valeur{:});
end