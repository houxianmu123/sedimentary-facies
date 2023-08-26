clear
clc
%% 加载、预处理数据
load  WelllogData_FS10_5face.mat
% WelllogData = welllogdata;
% WelllogData = readtable('C:\****\***.***');
Targets = categorical(table2array(WelllogData(:,4)));
inds=unique(Targets);
for i=1:length(Targets)
    if Targets(i) == categorical(inds(1))
        target(i,:)=[1 0 0 0 0];
        target_t(i) =1;
    elseif Targets(i) == categorical(inds(2))
        target(i,:)=[0 1 0 0 0];
        target_t(i) =2;
    elseif Targets(i) == categorical(inds(3))
        target(i,:)=[0 0 1 0 0];
        target_t(i) =3;
    elseif Targets(i) == categorical(inds(4))
        target(i,:)=[0 0 0 1 0];
        target_t(i) =4;
    elseif Targets(i) == categorical(inds(5))
        target(i,:)=[0 0 0 0 1];
        target_t(i) =5;

    end 
end

%     elseif Targets(i) == categorical(inds(6))
%         target(i,:)=[0 0 0 0 0 1];
%         target_t(i) =6;

WelllogData=[WelllogData array2table(target_t') array2table(target)];


% inds = randperm(size(WelllogData,1));
% n = fix(length(inds)*0.9);
% Inputdata = WelllogData(inds(1:n),:);
Inputdata = WelllogData;
% predictiondata = WelllogData(inds(n+1:end),:);
% name = categorical(table2array(unique(Inputdata(:,4))));
%输入数据测井数据
Inputs1 = table2array(Inputdata(:,15:17));
Inputs2 = table2array(WelllogData(:,22:23));
Inputs = [Inputs1  Inputs2];
Inputs = Inputs'
m1 = mean(Inputs,2);
S1 = std(Inputs,0,2);
Inputs = (Inputs-m1)./S1;

% Inputs = (Inputs-min(Inputs))/(max(Inputs)-min(Inputs));
%输入测井相矩阵
Inputs_test =table2array(Inputdata(:,25:29));
Inputs_test = Inputs_test'
%输入预测测井数据
% pred = table2array(predictiondata(:,15:17));
% av = mean(pred,1);
% S = std(pred,0,1);
% pred = (pred-av.*(ones(length(pred),9)))./S;
%输入测井相
% Targets_p = table2array(predictiondata(:,24));
%% 构建分类网络
netdnn =patternnet([8 16 32 16 8]);
[netdnn_train tr] = train(netdnn,Inputs,Inputs_test);
view(netdnn_train)
%预测
y_dnn = netdnn_train(Inputs);
y_dnn = vec2ind(y_dnn);
Inputs_test = vec2ind(Inputs_test);
figure
cm = confusionchart(Inputs_test,y_dnn,'RowSummary','row-normalized','ColumnSummary','column-normalized');

%% 单井预测
% 预测井
welllogdata = readtable('*****');
TargetsSingle = categorical(table2array(welllogdata(:,7)));
inds=unique(TargetsSingle);
for i=1:length(TargetsSingle)
    if TargetsSingle(i) == categorical(inds(1))
        targetSingle(i,:)=[1 0 0 0];
        target_t1(i) =1;
    elseif TargetsSingle(i) == categorical(inds(2))
        targetSingle(i,:)=[0 1 0 0];
        target_t1(i) =2;
    elseif TargetsSingle(i) == categorical(inds(3))
        targetSingle(i,:)=[0 0 1 0];
        target_t1(i) =3;
    elseif TargetsSingle(i) == categorical(inds(4))
        targetSingle(i,:)=[0 0 0 1];
        target_t1(i) =4;
    elseif TargetsSingle(i) == categorical(inds(5))
        target(i,:)=[0 0 0 0 1 0];
        target_t(i) =5;
    end   
end

%     elseif TargetsSingle(i) == categorical(inds(5))
%         target(i,:)=[0 0 0 0 1 0];
%         target_t(i) =5;
%     elseif TargetsSingle(i) == categorical(inds(6))
%         target(i,:)=[0 0 0 0 0 1];
%         target_t(i) =6;       
%%
welllogdata=[welllogdata array2table(target_t1') array2table(targetSingle)];
logdataSingle = table2array(welllogdata(:,2:6));
% av = mean(logdataSingle,1);
% S = std(logdataSingle,0,1);
% logdataSingle = (logdataSingle-av.*(ones(length(logdataSingle),3)))./S;
% logdataSingle = (logdataSingle-min(logdataSingle))/(max(logdataSingle)-min(logdataSingle));
% m3 = mean(logdataSingle,2);
% S3 = std(logdataSingle,0,2);
logdataSingle = logdataSingle';
logdataSingle = (logdataSingle-m1)./S1;

y_dnn_Single = netdnn_train(logdataSingle);
classes_dnn_Single = vec2ind(y_dnn_Single);
classes_dnn_Single = classes_dnn_Single';
Targets_p_Single = table2array(welllogdata(:,7));
accuracy_dnn_Single = mean(classes_dnn_Single == Targets_p_Single);
%plotconfusion(Targets_p_Single,classes_dnn_Single)
figure
plot(classes_dnn_Single);
hold on
plot(Targets_p_Single')
xlabel('Deepth');
ylabel('Face');
legend('预测','实际')

figure
cm = confusionchart(Targets_p_Single,classes_dnn_Single,'RowSummary','row-normalized','ColumnSummary','column-normalized');

% xlswrite('C:\Users\Administrator\Desktop\新建 Microsoft Excel 工作表.xlsx',table2cell(welllogdata),'sheet1')
% xlswrite('C:\Users\Administrator\Desktop\新建 Microsoft Excel 工作表.xlsx',classes_dnn_Single,'sheet2')


%% SOM
% netsom =selforgmap([8 8]);
% [netsom_train tr] = train(netsom,Inputs');
% figure
% view(netsom_train)
% y_som = netsom_train(pred');
% perf_som = perform(netsom_train,Targets_p',y_som);
% classes_som = vec2ind(y_som);
% accuracy = mean(classes_som == Targets_p')


% filename = 'DNNclassify.onnx';
% exportONNXNetwork(netdnn,filename)


