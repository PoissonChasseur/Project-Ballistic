%% get_new_latitude
%Description:
%   Fonction qui, � l'aide de la valeur du d�placement en X et Y
%   (X+ = Est; X- = Ouest)(Y+ = Nord; Y- = Sud: Effet de Coriolis)
%   et de la position initiale, d�termine la nouvelle valeur de latitude.
%   
%Note:
%   Par le fait qu'on prend en compte la latitude dans les calculs,
%   de certaines fonction, il est important qu'on mettent � jour cette
%   valeur suite au d�placement du projectile. Cela n'est pas vraiment
%   n�cessaire en cas de courte distance, mais cela le sera pour de grande
%   distance.
%   
%   De plus, il semble qu'il soit possible de le faire. Cela est en lien
%   avec les arcs m�ridien.
%
%
%Source:
%   - Latitude: https://fr.wikipedia.org/wiki/Latitude (consult� le 4 janvier 2017)
%
%   - Arc m�ridien: https://fr.wikipedia.org/wiki/Arc_de_m%C3%A9ridien
%   (consult� le 4 janvier 2017)
%
%   - Arc (g�om�trie):
%   https://fr.wikipedia.org/wiki/Arc_(g%C3%A9om%C3%A9trie) (consult� le 4
%   janvier 2017)
%
%   - Calcule distane entre 2 lieu via position satellite:
%   http://www.lexilogos.com/calcul_distances.htm (consult� le 4 janvier
%   2017)
%
%   - 
function get_new_latitude()
    %� faire, car pas aussi simple � trouv� que ce que je pensais.
end