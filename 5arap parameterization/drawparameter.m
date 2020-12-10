function [] = drawparameter(x,t,uv)
%%draw mesh and parameter coordinates
subplot(1,2,1)
patch('Faces',t,'Vertices',x,'FaceColor','green');
tex equal;
title('Real mesh');
subplot(1,2,2)
patch('Faces',t,'Vertices',uv,'FaceColor','green');
tex equal;
title('Parameter coordinates');
end

