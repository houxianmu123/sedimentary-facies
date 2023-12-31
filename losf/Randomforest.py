# -*- coding: utf-8 -*-
"""

"""
import pandas as pd
import numpy as np
import sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import re
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import cross_val_score
from sklearn.utils.multiclass import unique_labels
from sklearn.model_selection import train_test_split

data1=pd.read_excel('D:\****') #或者加上r，声明字符串，不用转义处理

Ytr=data1['face']
Xtr=data1.drop('face',1)
X_train=Xtr
y_train=Ytr

# feature selection
RF=RandomForestClassifier(n_estimators=300)
RF.fit(Xtr,Ytr)
RF.feature_importances_

# 使用pd.Series进行组合，值是特征重要性的值，index是样本特征，.sort_value 进行排序操作
feature_important = pd.Series(RF.feature_importances_, index = Xtr.columns).sort_values(ascending=False)
print(feature_important)

import matplotlib.pyplot as plt
#%matplotlib inline
feature_important.plot.bar()

data2=pd.read_excel('D:\******') #或者加上r，声明字符串，不用转义处理

Yte=data2['face']
Xte=data2.drop('face',1)

X_test=Xte
y_test=Yte

from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import make_classification
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
clf=RandomForestClassifier(n_estimators=190,max_features=2)
clf.fit(X_train,y_train)
y_pred = clf.predict(X_test)
print(confusion_matrix(y_test,y_pred))
accuracy=accuracy_score(y_test,y_pred)
print(str(round(accuracy*100,1))+'%accuracy')


# 绘图


# 混淆矩阵

def plot_confusion_matrix(y_true, y_pred, classes,
                          normalize=False,
                          title=None,
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if not title:
        if normalize:
            title = 'Normalized confusion matrix'
        else:
            title = 'Confusion matrix, without normalization'

    # Compute confusion matrix
    cm = confusion_matrix(y_true, y_pred)
    # Only use the labels that appear in the data
    classes = unique_labels(y_true, y_pred)
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    fig, ax = plt.subplots()
    im = ax.imshow(cm, interpolation='nearest', cmap=cmap)
    ax.figure.colorbar(im, ax=ax)
    # We want to show all ticks...
    ax.set(xticks=np.arange(cm.shape[1]),
           yticks=np.arange(cm.shape[0]),
           # ... and label them with the respective list entries
           xticklabels=classes, yticklabels=classes,
           title=title,
           ylabel='True label',
           xlabel='Predicted label')

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation=45, ha="right",
             rotation_mode="anchor")

    # Loop over data dimensions and create text annotations.
    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i in range(cm.shape[0]):
        for j in range(cm.shape[1]):
            ax.text(j, i, format(cm[i, j], fmt),
                    ha="center", va="center",
                    color="white" if cm[i, j] > thresh else "black")
    fig.tight_layout()
    return ax

class_names = unique_labels(y_train)
mat = confusion_matrix(y_test, y_pred)
plot_confusion_matrix(y_test, y_pred, classes=class_names,
                      title='Confusion matrix, without normalization')
plt.show()
