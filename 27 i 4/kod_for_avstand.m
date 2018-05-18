clear
tic

D=readtable('avstand7','Delimiter','\t','ReadVariableNames',false);


tid = [D.Var1];
mac = [D.Var2];
corp = [D.Var3];
ssid = [D.Var4];
rssi = [D.Var5];


% OnePlus: {'c0:ee:fb:9a:69:85'}
% Huawei: {'d0:65:ca:06:97:3c'}

%Behåll samma adress
j=1;
    while(j<=length(tid)) %
            if strcmp(mac(j),'c0:ee:fb:9a:69:85')  
                j=j+1;
            else
                tid(j) =[];
                mac(j)=[];
                corp(j)=[];
                ssid(j)=[];
                rssi(j)=[];  
            end
            
    end
    
    %Tar bort test gjorda efter 3 min
    j=1;
    while(j<=length(tid)) %
            if (tid(j) - tid(1)) < 180   
                j=j+1;
                
            else
                tid(j) =[];
                mac(j)=[];
                corp(j)=[];
                ssid(j)=[];
                rssi(j)=[];  
            end
            
    end
    

    lagsta =0;
    hogsta= -100;
    j= 1;
    
   while(j<=length(tid)) %
            if rssi(j) < lagsta  
                lagsta = rssi(j);
            end  
            if rssi(j) > hogsta
                hogsta = rssi(j);
            end
            j=j+1;
    end
    
    medel = mean(rssi);
    