%type test4.txt; %%Skriver ut filen i command window
clear;

D=readtable('test4.txt','Delimiter','\t','ReadVariableNames',false);

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
 if strcmp(mac(i),mac(i+1))&& tid(i+1)-tid(i)<2 
       tid(i+1) =[];
       mac(i+1)=[];
       corp(i+1)=[];
       ssid(i+1)=[];
       rssi(i+1)=[];
    else 
     i=i+1;
 end
 %Stoppa loopen efter sista cell
 if i==length(tid)
     break
 end
end

%Frekvenseliminering:
count=tabulate(mac);

tot_time = tid(length(tid))-tid(1);
fp = 0.03; %max arrivals/s
max_arrivals = tot_time*fp;
%%
%eliminera adresser med h�nsyn till maxfrekvens 
%F�LJANDE �R INTE KLART:
i = 1;
while(i <= length(tid))
    %Beh�ll endast en av varje probesekvens
 if cell2mat(count(i,2)) > max_arrivals 
     i
 else
     
 end
 i=i+1;
 %Stoppa loopen efter sista cell
 if i==length(tid)
     break
 end
end



%%
i=1;
while(i <= length(tid)) 
    %Beh�ll endast en av varje probesekvens
 if cell2mat(count(i,2)) > max_arrivals  % cell2mat turns cell into int/double
     flag = count(i,1);
     j=1;
     while(j<=length(tid)) %tar bort alla rader med identifierad mac-adress
         j
         i
         if strcmp((flag),(count(j,1))) 
        tid(j) =[];
        mac(j)=[];
        corp(j)=[];
        ssid(j)=[];
        rssi(j)=[];
         else
             j=j+1;
         end
            if j==length(tid)
                break
            end
     end
     
    else 
     i=i+1;
 end
        if i==length(tid)
                break
        end 
end

%count(3,2) = tredje countern


     







