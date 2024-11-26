t=[0:20];
y=t+randn(size(t))*5+10;
E=[t',ones(size(t))'];
covmat=inv(E'*E);
model=covmat*E'*y';
res=E*model-y';
chisqr=sum(res.^2)/(size(E,1)-size(E,2));
model_err=sqrt(diag(covmat)*chisqr);
y_model=t*model(1)+model(2);
y_model_err_95=student(size(E,1)-size(E,2))*sqrt(model_err(2)+((t- mean(t))*model_err(1)).^2);
plot(t,y,'r.',t,y_model,'b-',t,y_model+y_model_err_95,'m--',t,y_model- y_model_err_95,'m--')

