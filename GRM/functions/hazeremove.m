function [J, E] = hazeremove(I, transmission, A, alpha, beta)

S = size(I);

J = zeros(S);
E = zeros(S);


maxiter = 500;
trans3 = repmat(transmission,[1,1,3]);

for c = 1:3
    At(:,:,c) = (1 - transmission)*A(c);
end

pars.MAXITER = 1;
disp(['Number of iterations:' num2str(maxiter) '. Start dehazing...']);

for i = 1: maxiter
    if mod(i,100) == 0
        disp(i);
    end
%     Jold = J;
    
    J_b = -(At - I - E)./trans3;
    
    if i == 1
        [J, P1, P2] = denoise_TV_MT(J_b -I ,beta,-1,1,[], [],pars);
    else
        [J, P1, P2] = denoise_TV_MT(J_b -I ,beta,-1,1,P1, P2,pars);
    end
    J = J + I;
    
    E_b = J.*trans3 + At - I;
    
    E = sign(E_b) .* max(abs(E_b) - alpha, 0);

%     f(i) = funv(E_b,E,J,I,alpha,beta);
end


function f = funv(E_b,E,J,I,alpha,beta)

v1 = E_b - E; 
v1 = 0.5*sum(v1(:).^2);

v2 = alpha*sum(abs(E(:)));

JI = J - I;

df1 = diff(JI,1,1);
df2 = diff(JI,1,2);

v3 = beta*sum(abs(df1(:))) + beta*sum(abs(df2(:)));

f = v1 + v2 + v3;

