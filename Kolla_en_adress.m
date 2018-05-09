%% kolla efter en adress
clear

D=readtable('tag1_c','Delimiter','\t','ReadVariableNames',false);

tid = [D.Var1];
mac = [D.Var2];
corp = [D.Var3];
ssid = [D.Var4];
rssi = [D.Var5];

calle = 'c0:ee:fb:9a:69:85';

i=1;
while ( i<=length(tid))
    if strcmp(mac(i),calle)==0  %////////////////////////
        tid(i) =[];
        corp(i)=[];
        ssid(i)=[];
        rssi(i)=[];
        mac(i) =[];
        
    else
        i=i+1;
    end
    
    
    %Stoppa loopen efter sista cell
    if i==length(tid)+1
        break
    end
end

tid=datetime(tid,'ConvertFrom','posixtime');

tid = num2cell(tid);
rssi = num2cell(rssi);
T = cell2table([tid mac corp ssid rssi]);

%Spara ny textfil
writetable(T,'kuk_klar.txt', 'Delimiter', '\t')

