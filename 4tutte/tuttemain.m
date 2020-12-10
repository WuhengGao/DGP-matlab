%%load mesh
[x,t] = readObj('D:\mesh\cathead.obj');

uv=tutte(x,t);

%%draw mesh and parameter coordinates
drawparameter(x,t,uv);

