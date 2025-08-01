
function q = boutdetection(speed, timethresh, speedthresh)
normspeed = smooth(speed,30);
normspeed(1) = normspeed(2);
normspeed(end) = normspeed(end-1);
normspeednosmooth = (normspeed-min(normspeed))./(max(normspeed)-min(normspeed));
normspeed = normspeednosmooth;
for u = 1:length(normspeed)
if normspeed(u) < speedthresh
q(u) = 0;
else
q(u)=1;
end
end

boutstarts = [];
boutends = [];
for n = 1:size(speed,1)-1
    if q(n) == 1 & q(n+1) == 0
        boutstarts = [boutstarts, n+1];
    end
    if q(n) == 0 & q(n+1) == 1;
        boutends = [boutends, n];
    end
end


if length(boutstarts) < length(boutends)
    boutstarts = [1, boutstarts];
else if length(boutstarts) > length(boutends)
        boutends = [boutends, length(normspeed)];
    end
end


for k = 1:size(boutstarts,2)
    boutlength(k) = boutends(k)-boutstarts(k);
    if boutlength(k) < timethresh
        q(boutstarts(k):boutends(k)) = 1;
    end
  

end

figure; plot(normspeed)
hold on
plot(q./2)
end



