function dark = darkchannel(im,win_size)

im = min(im, [], 3);

dark = ordfilt2(im,1,ones(win_size,win_size),'symmetric');
