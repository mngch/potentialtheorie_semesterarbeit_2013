% Semesterarbeit


clear all
close all
clc

%profile on




% magma chamber
% ellipsoid

% position
x_chamber = 100;
y_chamber = 100;


z_chamber = 13000;       % depth
H_chamber = 300;        % radius
e = 5;                   % ellipticity
rho_chamber = 400;      % density contrast



x_chimney = 160;
y_chimney = 160;

z_chimney = z_chamber-H_chamber;
R_chimney = 100;
rho_chimney = 400;

H_chimney = 12900;





% numeric

N = 5;  % number of edges of chamber
L = 5;  % L/2 = number of layers in chamber


l_chimney = 10;         % number of layers in chimney




% profiles

for x_obs = 1:1:200
    for y_obs = 1:1:200
        
        
        
        % MAGMA CHAMBER
        chamber = make_sphere(x_obs-x_chamber,y_obs-y_chamber,z_chamber,N,L,H_chamber,e);
        G = 0;
        for i = 1 : length(chamber)
            G = G + gravity(chamber(i), rho_chamber);
        end
        
        Grav_chamber(x_obs,y_obs) = G;
        
        % CHIMNEY
        G = 0;
        chimney = make_chimney(x_obs-x_chimney,y_obs-y_chimney,z_chimney,N,l_chimney,R_chimney,H_chimney);
        for i = 1 : length(chimney)
            G = G + gravity(chimney(i), rho_chimney);
            if isnan(G) == 1
                %disp(x_obs-x)
                %disp(y_obs-y)
            end
        end
        
        Grav_chimney(x_obs,y_obs) = G;
        
        
        
    end
end

Grav_gesamt = Grav_chamber + Grav_chimney;

% plot
figure;
imagesc(Grav_chamber);
title('chamber')

figure;
imagesc(Grav_chimney);
title('chimney')

figure
imagesc(Grav_gesamt);
title('gesamt');
        
        
 %profile viewer
        
        
