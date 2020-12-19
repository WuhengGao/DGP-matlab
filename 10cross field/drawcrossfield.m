function  drawcrossfield(x,t,Constrain,vector1,vector2)
nf = size(t, 1);
%Samples=randperm(nf);
%Samples=Samples(1:(nf/10));
Samples=textread('lilium.samples.txt','%f');
l=0.5*AverageEdgeLen(x,t);
vector1=l*vector1;
vector2=l*vector2;
center= FaceCenter(x,t);

figure(1);
patch('Faces',t,'Vertices',x,'FaceColor','white');
hold on;
quiver3(repmat(center(Samples,1),1,4),repmat(center(Samples,2),1,4),repmat(center(Samples,3),1,4),[vector1(Samples,1)*[1,-1],vector2(Samples,1)*[1,-1]],[vector1(Samples,2)*[1,-1],vector2(Samples,2)*[1,-1]],[vector1(Samples,3)*[1,-1],vector2(Samples,3)*[1,-1]],0,'-b','maxheadsize',0);
hold on;
quiver3(repmat(center(Constrain,1),1,4),repmat(center(Constrain,2),1,4),repmat(center(Constrain,3),1,4),2*[vector1(Constrain,1)*[1,-1],vector2(Constrain,1)*[1,-1]],2*[vector1(Constrain,2)*[1,-1],vector2(Constrain,2)*[1,-1]],2*[vector1(Constrain,3)*[1,-1],vector2(Constrain,3)*[1,-1]],0,'-r','maxheadsize',0);

axis equal;
hold off;

end

