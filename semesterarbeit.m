% Semesterarbeit

clear all
close all
clc

mode='2d';


% NUMERIC

N = 20;  % number of edges 
L = 20;  % L/2 = number of layers 

step=1000;
extension=200000;

l_conduit = 10;         % number of layers in conduit



% magma chamber
% ellipsoid
% position
x_chamber = extension/2;    % chamber at the center of research area
y_chamber = extension/2;


z_chamber = 13000;       % depth
H_chamber = 300;        % radius
e = 5;                   % ellipticity
rho_chamber = -200;      % density contrast



x_conduit = extension/2;
y_conduit = extension/2;

z_conduit = z_chamber-H_chamber;
R_conduit = 100;


H_conduit = z_chamber-H_chamber; % till the surface
rho_surf = -600; % density contrast 

rho_layer = 1:l_conduit;
rho_conduit = linspace(rho_chamber,rho_surf,l_conduit);

% plot density
figure
plot(rho_conduit,rho_layer);
ylabel('Layer')
xlabel('Dichteunterschied \rho  in kg/m^3')

beautify();
% save
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 ./figures/rho_model.eps


% 2d profiles

if mode == '2d'
for x_obs = step:step:extension
    for y_obs = step:step:extension
        
        
        
        % MAGMA CHAMBER
        chamber = make_sphere(x_obs-x_chamber,y_obs-y_chamber,z_chamber,N,L,H_chamber,e);
        G = 0;
        for i = 1 : length(chamber)
            G = G + gravity(chamber(i), rho_chamber);
        end
        
        Grav_chamber(x_obs/step,y_obs/step) = G;
        
        % conduit
        G = 0;
        conduit = make_conduit(x_obs-x_conduit,y_obs-y_conduit,z_conduit,N,l_conduit,R_conduit,H_conduit);
        
        % loop over conduit layers
        for i = 1 : length(conduit)
            G = G + gravity(conduit(i), rho_conduit(i));
            if isnan(G) == 1
                %disp(x_obs-x)
                %disp(y_obs-y)
            end
        end
        
        Grav_conduit(x_obs/step,y_obs/step) = G;
        
        
        
    end
end

Grav_gesamt = Grav_chamber + Grav_conduit;

% plot
% 10^8 ugal
figure;
imagesc(Grav_chamber*10^8);
colorbar
set(get(colorbar,'Ylabel'),'String','\fontsize{14}Schwereanomalie in  \muGal')
title('chamber')

figure;
imagesc(Grav_conduit*10^8);
colorbar
set(get(colorbar,'Ylabel'),'String','\fontsize{14}Schwereanomalie in  \muGal')
title('conduit')

figure
imagesc(Grav_gesamt*10^8);
colorbar
set(get(colorbar,'Ylabel'),'String','\fontsize{14}Schwereanomalie in  \muGal')
title('gesamt');
    



end % if mode==2d
 



% 1d Profile line for different conduit heights
if mode=='1d'
    
H_conduit=1000:1000:z_chamber-H_chamber; %


y_obs = y_chamber; % y_obs is constant
for o = 1:length(H_conduit)  % loop over conduit heights
    for x_obs = step:step:extension
    

        
        % conduit
        G = 0;
        conduit = make_conduit(x_obs-x_conduit,y_obs-y_conduit,z_conduit,N,l_conduit,R_conduit,H_conduit(o));
        
        % loop over conduit layers
        for i = 1 : length(conduit)
            G = G + gravity(conduit(i), rho_conduit(i));
            if isnan(G) == 1
                %disp(x_obs-x)
                %disp(y_obs-y)
            end
        end
        
        Grav_conduit_1d(o,x_obs/step) = G;
        
    end
end

% plot
xaxis=1:step:extension;
figure
hold on
cc=hsv(12);
for i=1:length(Grav_conduit_1d(:,1))
    plot(xaxis/1000,Grav_conduit_1d(i,:)*10^8,'color',cc(i,:),'LineWidth',2)
end
ylabel('Schwereanomalie in  \muGal');
xlabel('Position entlang des Profils in [km]');
h = legend(cellstr(num2str((H_conduit)')),'Location','SE');
v = get(h,'title');
set(v,'string','\fontsize{14}Höhe des Schlotes in [m]');
set(gca,'YGrid','on')
beautify();

% save
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 ./figures/var_height.eps


end %if mode==1d
