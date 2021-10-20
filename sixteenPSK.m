clear all;
clf;
grayCode  = [0 1 3 2 6 7 5 4 12 13 15 14 10 11 9 8];
angle = grayCode*2*pi/16 + 2*pi/32;

for i = 1:1:16
    cont(i,1) = cos(angle(i));
    cont(i,2) = sin(angle(i));
end

N = 50000;
EbN0list = 0:5:20;

for EbN0Index = 1:length(EbN0list)
    ber(EbN0Index) = 0;
    EbN0 = 10^(EbN0list(EbN0Index)/10);
    N0 = 10^(-EbN0list(EbN0Index)/20);
    nominal(EbN0Index) = erfc(sqrt(4*EbN0)*sin(pi/16));
for i = 1:1:N
    %generate input
    b = randi([1,16]);
    sb = cont(b,:);
    %noise
    w1 = (normrnd(0, N0 / 2)) / sqrt(2);
    w2 = (normrnd(0, N0 / 2)) / sqrt(2);
    s(1) = sb(1) + w1;
    s(2) = sb(2) + w2;
    
%     theta = atan2(s(2),s(1)) / (2 * pi);
%     an = grayCode(mod(round(theta * 16), 16) + 1)+1;
    
    phi = atan2(s(2),s(1));
    phi = phi + (phi < 0)*2*pi;
    
    for k = 1:1:16
        if(phi <= angle(k)+2*pi/32 && phi > angle(k)-2*pi/32)
            an = k;
        end
    end
    
    sw(i,1) = s(1);
    sw(i,2) = s(2);
    
    if(an ~= b)
        ber(EbN0Index) = ber(EbN0Index)+1;%sum(abs(dec2bin(an - 1,4) - dec2bin(b - 1,4)));
    end
    
end

end

% figure;
% hold on;
% for k = 1:1:300
%     scatter(sw(k,1),sw(k,2));
% end

ber = ber/(N);
figure;
semilogy(EbN0list,ber);
hold on;
semilogy(EbN0list,nominal, 'm');
% axis([0 15 10^-5 1]);
xlim([0 20]);
ylim([10^-5 1]);
legend("simulated","nominal");





