function [t] = Delaunay(x,t)
nf = size(t, 1);
nv = size(x, 1);
mesh=sparse(t, t(:, [2:end 1]), repmat(1:nf, 1, 3), nv, nv);
e = unique( sort( [reshape(t,3*nf, 1), reshape(t(:,[2 3 1]), 3*nf, 1)], 2 ), 'rows' );
ne = size(e, 1);
theta=meshAngles(x, t);
for i=1:ne
    f1=mesh(e(i,1),e(i,2));
    f2=mesh(e(i,2),e(i,1));
    if f1==0||f2==0
        continue
    end
   % [xk1,k1]=setdiff(t(f1,:),e(i,:));
   % [xk2,k2]=setdiff(t(f2,:),e(i,:));
    for j=1:3
         if t(f1,j)~=e(i,1)&&t(f1,j)~=e(i,2)
            k1=j;
             xk1=t(f1,j);
         end
         if t(f2,j)~=e(i,1)&&t(f2,j)~=e(i,2)
             k2=j;
             xk2=t(f2,j);
         end
     end
    Q = [e(i,:),xk1,xk2];   
    if theta(f1,k1)+theta(f2,k2)>pi
       t(f1, :) = Q([3,4,2]);
       t(f2, :) = Q([4,3,1]);
       %mesh=sparse(t, t(:, [2:end 1]), repmat(1:nf, 1, 3), nv, nv);
       mesh(e(i,:),e(i,:))=0;
       mesh(Q(3),Q(4))=f1;
       mesh(Q(4),Q(2))=f1;
       mesh(Q(4),Q(3))=f2;
       mesh(Q(3),Q(1))=f2;
       theta([f1,f2],:)=meshAngles(x, t([f1,f2],:));
    end
end
end

