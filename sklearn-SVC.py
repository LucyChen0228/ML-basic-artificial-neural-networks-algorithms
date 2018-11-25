from sklearn import svm
x= [ [0,0],[1,1]]
y=[0,1]
test=svm.SVC()
test.fit(x,y)
svm.SVC(C=1.0,cache_size=200,class_weight=None,coef0=0.0,decision_function_shape='ovr',degree=3,gamma='auto',kernel='rbf'
    )

print(test.predict([[2.,2.]]))