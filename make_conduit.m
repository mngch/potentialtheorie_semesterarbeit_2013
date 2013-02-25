% make_conduit
% calculates coordinates for prisms building a conduit
% X,Y,Z coordinates center of bottom
% n number of edges
% d number of layers
% H height of conduit
function [prism] = make_conduit(X,Y,Z,n,d,R,H)

d=d+1; % to really have number of layers and not surfaces(discs)

da = 2*pi/n; % increase in angle for circle


l = 1;
for i = 1:d     % all the polygon discs bottom to top
    r = R;
    
    
    for m = 1:n+1;
        z(m) = H/d*i;
        
    end
    
    
    k = 1;
    for j = 0:da:2*pi
        x(k) = cos(j)*r;
        y(k) = sin(j)*r;
        k = k+1;
    end
    disc(l) = struct('x',x,'y',y,'z',z);

    l = l+1;

end

% make prism from disc
for i = 1:length(disc)-1;
    h1 = (disc(i+1).z(1) - disc(i).z(1))/2;
    if i > 1
        h2 = (disc(i).z(1) - disc(i-1).z(1))/2;
    else
        h2 = h1;
    end
    prism(i) = struct('x',disc(i).x, 'y',disc(i).y, 'z1',disc(i).z(1)+h1, 'z2',disc(i).z(1)-h2 );
end

% move prisms to coordinates
for i = 1:length(prism)
    prism(i).x = prism(i).x + X;
    prism(i).y = prism(i).y + Y;
    prism(i).z1 = prism(i).z1 + Z;
    prism(i).z2 = prism(i).z2 + Z;
end


%plot
close all
hold on
for u = 1:length(disc)
  plot3(disc(u).x, disc(u).y, disc(u).z);
end

%remove empty prism
for i=1:length(prism)
    deviation = std(prism(i).x);
    if deviation < 0.000001
        prism(i) = [];
        break
    end
end



end