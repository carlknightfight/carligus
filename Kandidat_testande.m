clear;
tic


D=readtable('broen_c_090518','Delimiter','\t','ReadVariableNames',false);

tid = [D.Var1];
mac = [D.Var2];
corp = [D.Var3];
ssid = [D.Var4];
rssi = [D.Var5];

% jï¿½mfï¿½r om samma macadress tf = strcmp(mac(5),mac(6))
% ta bort cell: tid1(1) = [];

i = 1;
while(i <= length(tid))
    %Behï¿½ll endast en av varje probesekvens
    j=1;
    while(j<=length(tid)) %
        if i+j <= length(tid)
            if strcmp(mac(i),mac(i+j))&& tid(i+j)-tid(i)< 60  %////////////////////////
                tid(i+j) =[];
                mac(i+j)=[];
                corp(i+j)=[];
                ssid(i+j)=[];
                rssi(i+j)=[];
            else
                j=j+1;
            end
        else
            j=j+1;
        end
    end
    i=i+1;
    %Stoppa loopen efter sista cell
    if i==length(tid)
        break
    end
end

%Eliminera m.a.p. vilken frekvens enheter ï¿½terkommer:
count=tabulate(mac);
%////////////////////////////////////////////////////////////////////////
tot_time = tid(length(tid))-tid(1);
fp = 0.007; %max arrivals/s
max_arrivals = tot_time*fp;
%///////////////////////////////////////////////////////////////////////
i = 1;
while(i < length(count(:,2)))
    
    if cell2mat(count(i,2)) > max_arrivals
        j =1;
        while(j < length(tid))
            if strcmp(mac(j),count(i,1))
                tid(j) =[];
                mac(j)=[];
                corp(j)=[];
                ssid(j)=[];
                rssi(j)=[];
            else
                j=j+1;
            end
        end
    else
    end
    i=i+1;
end

tid=datetime(tid,'ConvertFrom','posixtime', 'TimeZone', 'Europe/Amsterdam');
%tid.TimeZone ='Europe/London';

bin = discretize(tid,'Minute');
bins = histcounts(bin);
bins(length(bins))=[];

%/////////////////////
% Dela in i tio.
%////////////////////
% bins10 = zeros(round(length(bins)/10),1);
% bin(end:numel(bins))=0; 
% for i=1:1:(length(bins10))
%    if i < length(bins10)
%     bins10(i) = sum(bins(1+(10*(i-1)):10*i));
%   
%    else
%       bins10(i) = sum(bins(1+(10*(i-1)):(10*length(bins)/10))); 
%    end
% end


% fyll i tid(1) hï¿½rdkodad. Sï¿½ att vi fï¿½r tiden dï¿½ vi bï¿½rjar probea. inte
% fï¿½rsta proben. 
tidsplot = tid(1) + minutes(0:(length(bins)-1));
 y = [28 27 14 49 26 27 26 37 33 15 23 27 19 36 35 18 34 22 32 28 35 37 26 24 24 25 38 22 30 20]; % 09-05-2018 kl 16:17-16:46

 %relay = relation mellan signal och trafikanter
relay = [length(y)];
i=1;
while(i <= length(y))
   relay(i) = y(i)/bins(i); 
   i = i+1;
end

figure
plot(tidsplot,bins);
hold on
title('Gåendetrafikanter resecentrum, 18/4 (14:25-14:55)')
xlabel('Tidpunkt') 
ylabel({'Antal uppfattade'; 'enheter/minut'})


%set(get(gca,'ylabel'),'rotation',0, 'Position', [-0.1, 0.5, 0])
set(get(gca,'ylabel'),'rotation',0, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on
plot(tidsplot,y);

tid = num2cell(tid);
rssi = num2cell(rssi);
T = cell2table([tid mac corp ssid rssi]);

%Spara ny textfil
writetable(T,'myData.txt', 'Delimiter', '\t')
toc
