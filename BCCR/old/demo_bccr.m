
    % estimating the global airlight
    % method = 'our'; 
    % method = 'he'; 
    method = 'manual'; 
    wsz = 15; % window size
    A = airlight(img_hazy, method, wsz);
    A = double(A(:)); %15/10/2018: Agapi changed, because the class would remain uint8. There is the command in estimaet function.


    % calculating boundary constraints
    wsz = 3; % window size
    ts = Boundcon(img_hazy, A, 30, 300, wsz);

    % refining the estimation of transmission
    lambda = 2;  % regularization parameter, the more this parameter, the closer to the original patch-wise transmission
    t = CalTransmission(img_hazy, ts, lambda, 0.5); % using contextual information

    % dehazing
    r2 = Dehazefun(img_hazy, t, A, 0.85); 

%     figure; imshow(r2); title('Meng et al.');

