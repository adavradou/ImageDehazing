function [est_t est_l est_eta] = estimate(A, I)

% Agapi 26092018 avoid negative numbers in division
epsilon = 1e-6;
IA = I * A / norm(A) ;

% Agapi 26092018 avoid negative numbers inside the square root
solution = 1;
if((sum(I.^2,2) - IA.^2)<0)
   if(solution ==1)
       factor = abs(sum(I.^2,2) - IA.^2);
   else
       factor = 0.0;
   end
else
   factor = abs(sum(I.^2,2) - IA.^2);    
end

IR = sqrt(factor);
% Agapi 26092018 avoid negative numbers in division
H = (norm(A) - IA) ./ (IR + epsilon);

C = cov(IA, H) ./ (cov(IR, H) + epsilon);
est_eta = C(1,2) ;

est_t = 1 - (IA - est_eta * IR) / (norm(A) + epsilon);
est_l = IR ./ (est_t + epsilon);