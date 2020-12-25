function [] = drawDelaunay(x,t,x2,t2)
%%draw mesh and Optimal Delaunay
subplot(1,2,1)
patch('Faces',t,'Vertices',x,'FaceColor','green');
tex equal;
title('Origin mesh');
subplot(1,2,2)
patch('Faces',t2,'Vertices',x2,'FaceColor','green');
tex equal;
title('Optimal Delaunay');
end

