%clear;
tic

D=readtable('tag2_c_100518','Delimiter','\t','ReadVariableNames',false);


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
tid.TimeZone ='Europe/London';

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
tidsplot = tid(1) + minutes(0:(length(bins)-1)); % Om 30 i längd  
%y = [7 15 17 9 8 13 24 13 9 15 21 16 16 19 18 5 9 13 11 12 23 6 8 2 8 9 7 10 13];% 70-väg
%y = [28 27 14 49 26 27 26 37 33 15 23 27 19 36 35 18 34 22 32 28 35 37 26 24 24 25 38 22 30 20]; % 09-05-2018 kl 16:17-16:46
%y = [7 0 5 6 9 9 5 7 7 2 6 7 7 13 15 13 10 7 4 19 4 16 7 12 9 6 10 7 17 7]; % 10-05-2018 kl 08:42-09:12
%y= [ 8 4 7 26 38 4 11 6 5 0 1 1 0 3 3 1 3 4 2 2 5 3 6 4 6 5 10 14 31 2]; % Tåg 100518
y = [34 6 1 1 9 5 6 4 14 15 12 13 1 2 4 4 2 6 3 4 14 2 4 3 3 6 1 8 4 9]; %Tåg 100518 andra försöket 
ysave =[8 8 19 13 55 118 13 10 13 10 10 17 19 13 105 40 10 6 4 3 3 4 0 3 51 27 21 33 65 3]; % Tåg 180518 07:30-08:00
%y = [5 0 2 4 1 3 2 2 4 2 2 2 6 3 2 4 4 5 6 4 2 3 2 2 2 1 2 4 2 3];%Mellan husen 110518
 
minuter = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];
 
%relay = relation mellan signal och trafikanter
relay = [length(y)];
i=1;
while(i <= length(y))
  % relay(i) = y(i)/bins(i); 
   i = i+1;
end

%bins_save = bins;

bins09=bins;
figure
plot(minuter,bins, 'b--');
%plot(tidsplot,relay);
hold on
%title('Experimentering: Hastighetsbegränsning 70 km/h (Bravikenvägen), 27/4 kl 15:56-16:26 ','FontSize',18)
xlabel('Minut','FontSize',18) ;
ylabel('Antal','FontSize',18);

%set(get(gca,'ylabel'),'rotation',0, 'Position', [-0.1, 0.5, 0])
set(get(gca,'ylabel'),'rotation',0, 'Units', 'Normalized', 'Position', [-0.05, 0.5, 0]);
grid on
plot(minuter,y, 'b');
plot(minuter, bins_save, 'r--');
plot(minuter,ysave, 'r');
legend( {'Avlyssnade sondsignaler', 'Passerande trafikanter'},'FontSize',18)
set(gca,'FontSize',20);
%plot(minuter,y2,'--');
%plot(minuter, bins09);


tid = num2cell(tid);
rssi = num2cell(rssi);
T = cell2table([tid mac corp ssid rssi]);

%Spara ny textfil
writetable(T,'myData.txt', 'Delimiter', '\t')
cor = corrcoef(bins, y);
toc
