
clf;

cont = [-3 -3; -3 -1; -3 3; -3 1; -1 -3; -1 -1; -1 3; -1 1;...
    3 -3; 3 -1; 3 3; 3 1; 1 -3; 1 -1; 1 3; 1 1]/sqrt(10);
ber = 0;
EbN0 = 0;
two = 2/sqrt(10);

EbN0list = 0:2:20;
N = 20000;

for EbN0Index = 1:length(EbN0list)
    ber(EbN0Index) = 0;
%   EbN0Index = 20;
    EbN0 = 10^(EbN0list(EbN0Index)/10);
    N0 = 10^(-EbN0list(EbN0Index)/20);
%     nominal(EbN0Index) = (3*qfunc(0.8*EbN0)-(1.5*qfunc(0.8*EbN0))^2)/4;
    nominal(EbN0Index) = (3/8)*erfc(sqrt(4*EbN0/10));
for i = 1:1:N
    %generate input
    b = randi([1,16]);
    s = cont(b,:);
    %noise
    w1 = (normrnd(0, N0 / 2))/sqrt(2);
    w2 = (normrnd(0, N0 / 2))/sqrt(2);
    s(1) = s(1) + w1;
    s(2) = s(2) + w2;
    
    sa(i,1) = s(1);
    sa(i,2) = s(2);
    
    %demodulation
    %bottom row
    if(s(1) < -two && s(2) < -two)
        an = 1;
    end
    
    if(s(1) < -two && s(2) > -two && s(2) < 0)
        an = 2;
    end
    
    if(s(1) < -two && s(2) > 0 && s(2) < two)
        an = 4;
    end
    
    if(s(1) < -two && s(2) > two)
        an = 3;
    end
    
    
    %second from bottom row
    if(s(1) > -two && s(1) < 0 && s(2) < -two)
        an = 5;
    end
    
    if(s(1) > -two && s(1) < 0 && s(2) > -two && s(2) < 0)
        an = 6;
    end
    
    if(s(1) > -two && s(1) < 0 && s(2) > 0 && s(2) < two)
        an = 8;
    end
    
    if(s(1) > -two && s(1) < 0 && s(2) > two)
        an = 7;
    end
    
    
    %third from bottom row
    if(s(1) > 0 && s(1) < two && s(2) < -two)
        an = 13;
    end
    
    if(s(1) > 0 && s(1) < two && s(2) > -two && s(2) < 0)
        an = 14;
    end
    
    if(s(1) > 0 && s(1) < two && s(2) > 0 && s(2) < two)
        an = 16;
    end
    
    if(s(1) > 0 && s(1) < two && s(2) > two)
        an = 15;
    end
    
    %top row
    if(s(1) > two && s(2) < -two)
        an = 9;
    end
    
    if(s(1) > two && s(2) > -two && s(2) < 0)
        an = 10;
    end
    
    if(s(1) > two && s(2) > 0 && s(2) < two)
        an = 12;
    end
    
    if(s(1) > two && s(2) > two)
        an = 11;
    end
    
    if(an ~= b)
       ber(EbN0Index) = ber(EbN0Index)+sum(abs(dec2bin(an - 1,4) - dec2bin(b - 1,4)));
%     ber = ber+sum(abs(dec2bin(an - 1,4) - dec2bin(b - 1,4)));

    end
    
end
end

ber = ber/(4*N);

figure;
semilogy(EbN0list,ber);
hold on;
semilogy(EbN0list,nominal, 'm');
% axis([0 15 10^-5 1]);
xlim([0 15]);
ylim([10^-5 1]);
legend("simulated","nominal");

% figure;
% hold on;
% for i=1:1:1000
%     scatter(sa(i,1),sa(i,2));
%     disp(i)
% end
% sa_20 = sa;
% 
% save("451_project.m", "sa_20");




