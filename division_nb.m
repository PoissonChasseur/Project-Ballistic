%% division_nb
%Description:
%   Peut-�tre utile pour �viter d'avoir une division par 0.
%   Va retourner 0 si division par 0, sinon retourne
%   numerateur/denominateur.
function [result] = division_nb(numerateur, denominateur)
    if(denominateur == 0)
        result = 0;
    else
        result = numerateur/denominateur;
    end
end