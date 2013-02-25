function [  ] = beautify(  )
set(gca,'FontSize',15);
set( gca,'FontName','Helvetica');
th=get(gca,'Title'); 
set(th,'FontSize',19); 
lhx=get(gca,'xlabel'); 
set(lhx,'FontSize',15); 
lhy=get(gca,'ylabel'); 
set(lhy,'FontSize',15);


end

