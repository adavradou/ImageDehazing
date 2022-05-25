
% Artusi 25/10/208:
% Created function and modified the reading of images

function dh_img = bccr(h_img)

    % Reading the hazing image
    %h_img = imread(filename);
    
    % estimating the global airlight
    % method = 'our'; 
    % method = 'he'; 
    method = 'manual'; 
    wsz = 15; % window size
    
    A = airlight(h_img, method, wsz);
    A = double(A(:)); %15/10/2018: Agapi changed, because the class would remain uint8. There is the command in estimaet function.

    % calculating boundary constraints
    wsz = 3; % window size
    ts = Boundcon(h_img, A, 30, 300, wsz);

    % refining the estimation of transmission
    lambda = 2;  % regularization parameter, the more this parameter, the closer to the original patch-wise transmission
    t = CalTransmission(h_img, ts, lambda, 0.5); % using contextual information

    % dehazed image
    dh_img = Dehazefun(h_img, t, A, 0.85); 

