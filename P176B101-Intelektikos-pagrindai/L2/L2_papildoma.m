[x,t] = crab_dataset;
size(x)
size(t)

% Reikalinga, kad i�vengtum�m atsitiktini� rezultat� vykdymo metu
setdemorandstream(491218382)

% Sukuriamas 2 sluoksni� tinklas su 10 neuron� pasl�ptam sluoksny
net = patternnet(10);
view(net)

% Vykdomas apmokymas (kol tinklas tobul�ja, remiantis validacijos rinkiniu)
[net,tr] = train(net,x,t);
nntraintool

% Reikalingas per�i�r�ti, kaip tinklas tobul�jo apmokymo metu
plotperform(tr)

% testavimas
testX = x(:,tr.testInd);
testT = t(:,tr.testInd);

testY = net(testX);
testIndices = vec2ind(testY)

% Brai�o, kiek klasifikacij� atlikta s�kmingai
plotconfusion(testT,testY)

% Bendras teisingai ir neteisingai suklasifikuot� reik�mi� procentas
[c,cm] = confusion(testT,testY)

fprintf('Teisingai suklasifikuota: %f%%\n', 100*(1-c));
fprintf('Neteisingai suklasifikuota: %f%%\n', 100*c);

% Kitas teisingumo grafikas
plotroc(testT,testY)
