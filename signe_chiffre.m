%% signe_chiffre
%Description:
%   Retourne 1 si le chiffre est positif, -1 sinon.
function [signe] = signe_chiffre(chiffre)
    if(chiffre<0)
        signe = -1;
    else
        signe=1;
    end
end