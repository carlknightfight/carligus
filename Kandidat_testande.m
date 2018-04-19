clear;
tic

D=readtable('tag1_c','Delimiter','\t','ReadVariableNames',false);

tid = [D.Var1];
mac = [D.Var2];
corp = [D.Var3];
ssid = [D.Var4];
rssi = [D.Var5];

% j�mf�r om samma macadress tf = strcmp(mac(5),mac(6))
% ta bort cell: tid1(1) = [];

i = 1;
while(i <= length(tid))
    %Beh�ll endast en av varje probesekvens
    j=1;
    while(j<=length(tid)) %
        if i+j <= length(tid)
            if strcmp(mac(i),mac(i+j))&& tid(i+j)-tid(i)< 3  %////////////////////////
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

%Eliminera m.a.p. vilken frekvens enheter �terkommer:
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
tidsplot = tid(1) + minutes(0:(length(bins)-1));
plot(tidsplot,bins);


tid = num2cell(tid);
rssi = num2cell(rssi);
T = cell2table([tid mac corp ssid rssi]);

%Spara ny textfil
writetable(T,'myData.txt', 'Delimiter', '\t')
toc