%% get_coefficient_runge_kutta
%Description:
%   Pour la m�thode de Runge-Kutta, cette fonction donne les vecteurs des
%   co�fficient a,b et c � utilis� pour le nom d'une m�thode bien pr�cise.
%   Les valeurs des co�fficients viennent du manuel d'ELE735.
%   
%   Retourne NaN pour les 3 coefficient + message d'erreur si le nom ne
%   correspond pas ou s'il n'y a pas de valeur pr�-d�finit de coefficient
%   pour cet ordre d'�quation de Runge-Kutta.
%
%Note:
%   - Euler Explit et Runge-Kutta ordre 2 en Euler Explicit = m�me r�sultat.
%   - MidPt et Runge-Kutta ordre 2 en Midpt = m�me r�sultat.
%
function [a,b,c] = get_coefficient_runge_kutta(name_methode, order)
    a = NaN;
    b = NaN;
    c = NaN;
    switch(order)
        %Ordre 2:
        case 2 
            switch(name_methode)
                case 'Euler'
                    c = [1/2, 1/2];
                    a = 1;
                    b = 1;
                    
                case 'Midpt'
                    c = [0, 1];
                    a = 1/2;
                    b = 1/2;
                    
                case 'Heun'
                    c = [1/4, 3/4];
                    a = 2/3;
                    b = 2/3;
                    
                otherwise
                    disp('get_coefficient_runge_kutta: this name is not in the list')
            end
            
        %Ordre 3:
        case 3
            switch(name_methode)
                case 'Classical'
                    c = [1/6, 4/6, 1/6];
                    a = [1/2, 1];
                    b = [1/2, -1, 2];
                    
                case 'Nystrom'
                    c = [2/8, 3/8, 3/8];
                    a = [2/3, 2/3];
                    b = [2/3, 0, 2/3];
                    
                case 'Nearly Optimal'
                    c = [2/9, 3/9, 4/9];
                    a = [1/2, 3/4];
                    b = [1/2, 0, 3/4];
                    
                case 'Heun'
                    c = [1/4, 0, 3/4];
                    a = [1/3, 2/3];
                    b = [1/3, 0, 2/3];
                    
                otherwise
                    disp('get_coefficient_runge_kutta: this name is not in the list')
            end
           
        %Ordre 4:
        case 4
            switch(name_methode)
                case 'Classical'
                    c = [1/6, 2/6, 2/6, 1/6];
                    a = [1/2, 1/2, 1];
                    b = [1/2, 0, 1/2, 0, 0, 1];
                otherwise
                    disp('get_coefficient_runge_kutta: this name is not in the list')
            end
           
        otherwise
            disp('get_coefficient_runge_kutta: no predefined coeff for this order');
    end
end