% Semesterarbeit

clear all
close all
clc

mode='1d';


% NUMERIC

N = 10;  % number of edges 
L = 10;  % L/2 = number of layers 

step=100;
extension=10000;

l_conduit = 10;         % number of layers in conduit



% magma chamber
% ellipsoid
% position
x_chamber = extension/2;    % chamber at the center of research area
y_chamber = extension/2;


z_chamber = 13000;       % depth
H_chamber = 300;        % radius
e = 5;                   % ellipticity
rho_chamber = 200;      % density contrast



x_conduit = extension/2;
y_conduit = extension/2;

z_conduit = z_chamber-H_chamber;
R_conduit = 100;


H_conduit = z_chamber-H_chamber-1000; % till beinah the surface
rho_surf = 400; % density contrast 

rho_layer = 1:l_conduit;
rho_conduit = linspace(rho_chamber,rho_surf,l_conduit);

% plot density
figure
plot(rho_conduit,rho_layer,'LineWidth',2);
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
            G = G + gravity(chamber(i), -rho_chamber);
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
xaxis=1:step:extension;
figure;
contour(xaxis/1000,xaxis/1000,real(Grav_chamber)*10^8,30,'LineWidth',2);
colorbar
set(get(colorbar,'Ylabel'),'String','\fontsize{14}Schwereanomalie in  \muGal')
xlabel('Y-Position in [km]')
ylabel('X-Position in [km]')
%title('chamber')
beautify();
% save
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 ./figures/2dchamber_contour.eps


figure;
contour(xaxis/1000,xaxis/1000,real(Grav_conduit)*10^8,30,'LineWidth',2);
colorbar
set(get(colorbar,'Ylabel'),'String','\fontsize{14}Schwereanomalie in  \muGal')
%title('conduit')
xlabel('Y-Position in [km]')
ylabel('X-Position in [km]')
beautify();
% save
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 ./figures/2dconduit_contour.eps


figure
contour(xaxis/1000,xaxis/1000,real(Grav_gesamt)*10^8,30,'LineWidth',2);
colorbar
set(get(colorbar,'Ylabel'),'String','\fontsize{14}Schwereanomalie in  \muGal')
%title('gesamt');
xlabel('Y-Position in [km]')
ylabel('X-Position in [km]')
beautify();
% save
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 ./figures/2dwhole_contour.eps
    
figure
surfc(xaxis/1000,xaxis/1000,real(Grav_gesamt)*10^8);
colorbar
set(get(colorbar,'Ylabel'),'String','\fontsize{14}Schwereanomalie in  \muGal')
%title('gesamt');
xlabel('Y-Position in [km]')
ylabel('X-Position in [km]')
beautify();
% save
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 ./figures/2dwhole_surfc.eps


end % if mode==2d
 



% 1d Profile line for different conduit heights
if mode=='1d'
    
H_conduit=1000:1000:z_chamber-H_chamber; %


y_obs = y_conduit; % y_obs is constant
for o = 1:length(H_conduit)  % loop over conduit heights
    for x_obs = step:step:extension
    

        
        % conduit
        G = 0;
        conduit = make_conduit(x_obs-x_conduit,y_obs-y_conduit,z_conduit,N,l_conduit,R_conduit,H_conduit(o));
        
        % loop over conduit layers
        for i = 1 : length(conduit)
            G = G + gravity(conduit(i), rho_conduit(i));
            if isnan(G) == 1
%                 disp(G)
%                 disp(x_obs-x_conduit)
%                 disp(y_obs-y_conduit)
%                 disp(z_conduit)
%                 disp(N)
%                 disp(l_conduit)
%                 disp(R_conduit)
%                 disp(H_conduit(o))
%                 disp(i)
%                 disp(rho_conduit(i))
            end
        end
        
        Grav_conduit_1d(o,x_obs/step) = G;
        
    end
end

% remove NaNs
nan = any(isnan(Grav_conduit_1d), 1);
Grav_conduit_1d(:, nan) = [];

% plot
xaxis=1:step:extension;
figure
hold on
cc=hsv(12);
for i=1:length(Grav_conduit_1d(:,1))
    plot(Grav_conduit_1d(i,:)*10^8,'color',cc(i,:),'LineWidth',2)
end
ylabel('Schwereanomalie in  \muGal');
xlabel('Position entlang des Profils in [km]');
h = legend(cellstr(num2str((H_conduit)')),'Location','SE');
v = get(h,'title');
set(v,'string','\fontsize{14}H�he des Schlotes in [m]');
set(gca,'YGrid','on')
beautify();

% save
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 ./figures/var_height.eps


end %if mode==1d
