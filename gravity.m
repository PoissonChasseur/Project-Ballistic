%% Gravity
%Description:
%   Retourne une valeur approché de l'accélération
%   de la pesanteur en fonction de la latitude
%   et pour une altitude faible devant le rayon
%   terrestre (typiquement: quelques milier de mètres).
%
%Paramètres:
%   - l'altitude en mètres
%   - la latitude (phi) en radian dans le Systeme géodésique GRS 80 (1980).
%
%Retour:
%   La valeur de "g" dans les calculs de
%   de physique qui varie selon l'altitude et la latitude
%   de la position du projectile sur Terre.
%
%Source:
%   - https://fr.wikipedia.org/wiki/Pesanteur (19 novembre 2016)
function [g]=gravity(altitude, latitude)
    g = 1+5.3024*(10^-3)*(sin(latitude))^2-5.8*(10^-6)*(sin(2*latitude))^2-3.086*(10^-7)*altitude;
    g = 9.780327*g;
end