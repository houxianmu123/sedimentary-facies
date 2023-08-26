clear
clc
tic
%% ��ȡ����������
inputdata=readtable('C:\Users\dell\Desktop\wl.xlsx');
% load WelllogData_FS10_5face.mat
% inputdata = WelllogData;
% inds = randperm(size(inputdata,1));
% n = fix(length(inds)*0.9);
% Inputdata = inputdata(inds(1:n),:);
Inputdata =inputdata;
% Validitiondata = inputdata(inds(n+1:end),:);
name = categorical(table2array(unique(inputdata(:,4))));
% prediction_01 = readtable('D:\��Ŀ\��ʯ��-���ѧϰ\�⾮����\���ܹ�һ��8�� - ����.xlsx','Sheet','APP1');
% prediction_data01 = table2array(prediction_01(:,17:25));
% prediction_label01 = categorical(table2array(prediction_01(:,4)));
% prediction_02 = readtable('D:\��Ŀ\��ʯ��-���ѧϰ\�⾮����\���ܹ�һ��8�� - ����.xlsx','Sheet','F9');
% prediction_data02 = table2array(prediction_02(:,17:25));
% prediction_label02 = categorical(table2array(prediction_02(:,4)));
%load WelllogData1.mat
%��һ��
% inputdata=normalize(Inputdata(:,2:9),1,'range');
% inputdata=[Inputdata(:,1) inputdata];
% ������inputdataת��Ϊ�������⾮��������
inputTable = Inputdata;
% predictionTable=Validitiondata;
predictors1 = inputTable(:,15:17);
predictors2 = inputTable(:,22:23);
predictors = [predictors1  predictors2];
% predictors = predictors';
% m1 = mean(predictors,2);
% S1 = std(predictors,0,2);
% predictors = (predictors -m1)./S1;

response = inputTable(:,4);
%% ���ݷ�Ϊѵ������Ԥ�⼯
train_predictors=predictors;
train_response=response;
% test_predictors=predictionTable(:,15:23);
% test_response=predictionTable(:,4);
% Y = tsne(X) returns a matrix of two-dimensional embeddings of the high-dimensional rows of X.
% Y = tsne(table2array(train_predictors));
% gscatter(Y(:,1),Y(:,2),categorical(table2array(train_response)))
%% ѵ��������
template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder',3,...
    'KernelScale', 'auto', ...
    'BoxConstraint',1000, ...
    'Verbose',0,...
    'Standardize', true);

classificationSVM = fitcecoc(...
    train_predictors, ...
    train_response,...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames',name,...
    'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus'),...
    'Options',statset('UseParallel',true));
%% ��֤
Label = predict(classificationSVM,train_predictors,'Options',statset('UseParallel',true));
%Ԥ�⾫��
inds = Label == table2array(train_response);
Accuracy_Validition = mean(inds);
inds1 = ~eq(Label,table2array(train_response));
wrongpredictedpoint=Label(inds1);
x=find(inds1==1);

%% ����
% predictionData(:,4)=table(Label);
% predictionData = [predictionTable(:,1:3),predictionData(:,4),predictionTable(:,5:end)];
% B = sortrows(predictionData,3);
figure
cm = confusionchart(categorical(table2array(train_response)),Label,'RowSummary','row-normalized','ColumnSummary','column-normalized','FontSize',8);
% figure
% plot(Label,'bo',categorical(table2array(train_response)),'ro');
% xlabel('Deepth');
% ylabel('Face');
% legend('Ԥ��','ʵ��')
%%
welllogdata = readtable('C:\Users\dell\Desktop\Ԥ�⼯f��.xlsx');
app = table2array(welllogdata(:,2:6));
[Label, TR]= predict(classificationSVM,app,'Options',statset('UseParallel',true));
inds = Label == table2array(welllogdata(:,9));
Accuracy_Predition = mean(inds)
figure
cm = confusionchart(categorical(table2array(welllogdata(:,9))),Label,'RowSummary','row-normalized','ColumnSummary','column-normalized','FontSize',8);
figure
plot(categorical(table2array(welllogdata(:,9))))
hold on
plot(Label)
% xlswrite('C:\Users\Administrator\Desktop\�½� Microsoft Excel ������.xlsx',table2cell(welllogdata),'sheet1')
% xlswrite('C:\Users\Administrator\Desktop\�½� Microsoft Excel ������.xlsx',cellstr(Label),'sheet2')
toc          %��ʱ��