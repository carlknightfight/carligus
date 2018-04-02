
D=readtable('21min','Delimiter','\t','ReadVariableNames',false);

tid = [D.Var1];
mac = [D.Var2];
corp = [D.Var3];
ssid = [D.Var4];
rssi = [D.Var5];

% jämför om samma macadress tf = strcmp(mac(5),mac(6))
% ta bort cell: tid1(1) = [];

i = 1;
while(i <= length(tid))
    %Behåll endast en av varje probesekvens
 if strcmp(mac(i),mac(i+1))&& tid(i+1)-tid(i)< 2 %////////////////////////
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

%Eliminera m.a.p. vilken frekvens enheter återkommer:
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

tid = num2cell(tid);
rssi = num2cell(rssi);

C = [tid mac corp ssid rssi];