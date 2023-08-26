clear 
clc
%%  LSTN
% load WelllogData_FS10_5face.mat
WelllogData = readtable('C:\Users\dell\Desktop\wl.xlsx');
Inputs1 = table2array(WelllogData(:,15:17));
Inputs2 = table2array(WelllogData(:,22:23));
Inputs = [Inputs1  Inputs2];
% Inputs = (Inputs - mean(Inputs,1))./ std(Inputs,0,1);
Targets = categorical(table2array(WelllogData(:,4)));
XTrain = Inputs';
YTrain = Targets';
%归一化
m1 = mean(XTrain,2);
S1= std(XTrain,0,2);
XTrain = (XTrain-m1)./S1;

featureDimension = 5;
numHiddenUnits1 = 70;
numHiddenUnits2 = 65;
% numHiddenUnits3 = 60;
% numHiddenUnits4 = 70;

numClasses = 5;
layers = [ ...
    sequenceInputLayer(featureDimension)
    lstmLayer(numHiddenUnits1,'OutputMode','sequence')
%     dropoutLayer(0.2)
    lstmLayer(numHiddenUnits2,'OutputMode','sequence')
%     dropoutLayer(0.2)
%     lstmLayer(numHiddenUnits3,'OutputMode','sequence')
%     dropoutLayer(0.2)
%     lstmLayer(numHiddenUnits4,'OutputMode','sequence')
%     dropoutLayer(0.2)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
options = trainingOptions('adam', ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',15, ...
    'MaxEpochs',100, ...
    'MiniBatchSize',80, ...
    'Verbose',0, ...
    'Plots','training-progress');
%     'ValidationData',{XTrain,YTrain}, ...
%     'ValidationFrequency',10, ...

[net, tr]= trainNetwork(XTrain,YTrain,layers,options);
YTrainPred = classify(net,XTrain);
figure
% classLabels = ['qiangtang','qiangtang','qiangtang','qiangtang','qiangtang','qiangtang';'fdg','qiangtang','qiangtang','qiangtang','qiangtang';
%     'qiangtang','qiangtang','qiangtang','qiangtang','qiangtang','qiangtang';'fdg','qiangtang','qiangtang','qiangtang','qiangtang';'fdg','qiangtang','qiangtang','qiangtang','qiangtang']
cm = confusionchart(YTrain,YTrainPred,'RowSummary','row-normalized','ColumnSummary','column-normalized','FontSize',8);
% cm = confusionchart(YTrain,YTrainPred,'RowSummary','row-normalized');

%% 预测
welllogdata = readtable('C:\Users\dell\Desktop\预测集s层.xlsx');
logdataSingle = table2array(welllogdata(:,2:6));
% logdataSingle = (logdataSingle - mean(logdataSingle,1))./ std(logdataSingle,0,1);
TargetsSingle = categorical(table2array(welllogdata(:,9)));
XTest = logdataSingle';
YTest = TargetsSingle';
% m3 = mean(XTest,2);
% S3 = std(XTest,0,2);
XTest = (XTest-m1)./S1;
YPred = classify(net,XTest);
acc = sum(YPred == YTest)./numel(YTest)

figure
cm = confusionchart(YTest,YPred,'RowSummary','row-normalized','ColumnSummary','column-normalized','FontSize',8);
% cm = confusionchart(YTest,YPred,'RowSummary','row-normalized');

% xlswrite('C:\Users\Administrator\Desktop\新建 Microsoft Excel 工作表.xlsx',table2cell(welllogdata),'sheet1')
% xlswrite('C:\Users\Administrator\Desktop\新建 Microsoft Excel 工作表.xlsx',cellstr(YPred'),'sheet2')
figure
plot(YPred,'DisplayName','YPred')
hold on
plot(YTest,'DisplayName','YTest')
figure
plot(tr.TrainingLoss);hold on
yyaxis right
plot([1:100],[tr.TrainingAccuracy])
legend('TrainingLoss','TrainingAccuracy')
% plotroc(YTest,YPred)
%plottrainstate
% filename = 'LSTMclassify.onnx';
% exportONNXNetwork(net,filename)




