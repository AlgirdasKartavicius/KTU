[x,t] = crab_dataset;
size(x)
size(t)

% Reikalinga, kad iðvengtumëm atsitiktiniø rezultatø vykdymo metu
setdemorandstream(491218382)

% Sukuriamas 2 sluoksniø tinklas su 10 neuronø paslëptam sluoksny
net = patternnet(10);
view(net)

% Vykdomas apmokymas (kol tinklas tobulëja, remiantis validacijos rinkiniu)
[net,tr] = train(net,x,t);
nntraintool

% Reikalingas perþiûrëti, kaip tinklas tobulëjo apmokymo metu
plotperform(tr)

% testavimas
testX = x(:,tr.testInd);
testT = t(:,tr.testInd);

testY = net(testX);
testIndices = vec2ind(testY)

% Braiþo, kiek klasifikacijø atlikta sëkmingai
plotconfusion(testT,testY)

% Bendras teisingai ir neteisingai suklasifikuotø reikðmiø procentas
[c,cm] = confusion(testT,testY)

fprintf('Teisingai suklasifikuota: %f%%\n', 100*(1-c));
fprintf('Neteisingai suklasifikuota: %f%%\n', 100*c);

% Kitas teisingumo grafikas
plotroc(testT,testY)
