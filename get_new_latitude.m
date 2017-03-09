%% get_new_latitude
%Description:
%   Fonction qui, à l'aide de la valeur du déplacement en X et Y
%   (X+ = Est; X- = Ouest)(Y+ = Nord; Y- = Sud: Effet de Coriolis)
%   et de la position initiale, détermine la nouvelle valeur de latitude.
%   
%Note:
%   Par le fait qu'on prend en compte la latitude dans les calculs,
%   de certaines fonction, il est important qu'on mettent à jour cette
%   valeur suite au déplacement du projectile. Cela n'est pas vraiment
%   nécessaire en cas de courte distance, mais cela le sera pour de grande
%   distance.
%   
%   De plus, il semble qu'il soit possible de le faire. Cela est en lien
%   avec les arcs méridien.
%
%
%Source:
%   - Latitude: https://fr.wikipedia.org/wiki/Latitude (consulté le 4 janvier 2017)
%
%   - Arc méridien: https://fr.wikipedia.org/wiki/Arc_de_m%C3%A9ridien
%   (consulté le 4 janvier 2017)
%
%   - Arc (géométrie):
%   https://fr.wikipedia.org/wiki/Arc_(g%C3%A9om%C3%A9trie) (consulté le 4
%   janvier 2017)
%
%   - Calcule distane entre 2 lieu via position satellite:
%   http://www.lexilogos.com/calcul_distances.htm (consulté le 4 janvier
%   2017)
%
%   - 
function get_new_latitude()
    %À faire, car pas aussi simple à trouvé que ce que je pensais.
end