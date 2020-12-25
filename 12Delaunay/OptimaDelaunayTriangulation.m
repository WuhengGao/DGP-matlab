
%%load mesh
[x,t] = readObj('rectangle.obj');
nf = size(t, 1);
nv = size(x, 1);
[B,~]=findBoundary(x,t);
x2=x;
t2=t;


%%Alternating iterative
for i=1:50
    t2=Delaunay(x2,t2);
    x2=updatevertex(x2,t2,B);
end



%%draw Optimal Delaunay
figure(1);
drawDelaunay(x,t,x2,t2);





