clear all
close all
clc

T = 10e-3;
a = 5;
C = 1;
sigv = 10;
sigws = 5;
sigvs = 2 ;

A = [1 T; 0 1];
U = a*T*[0.5*T;1];
X =[0, 0];
X_Hat = [0, 0];
P = [1 0 ;0 1];

for count = 1:250
    X(count+1,:) = (A*X(count,:)'+ U + [sqrt(sigws) * randn ; sqrt(sigvs) * randn])';
    Y(count) = [1 0] * X(count,:)' + sqrt(10) * randn;
    X_Hat(count+1,:) = (A * X_Hat(count,:)' + U)';
    Q = [sigws 0;0 sigws];
    P = A*P*A' + Q;
    K = P*C *inv(C*P*C' + sigv);
    X_Hat(count+1,:) = (X_Hat(count+1,:)'  + K*(Y(count) - C.*X_Hat(count+1,:)'))';
    P = (eye(2) - K*C)*P;
    err(count)=X_Hat(count+1,1) - Y(count);
end

figure
plot(Y,'r-')
hold on
plot(X_Hat,'b-')
xlabel('Steps')
ylabel('Position')
title('Kalman filter simulation')
legend('Actual','Predicted')
grid on

figure
plot(err)
xlabel('Steps')
ylabel('Error')
title('Error plot between Actual and Predicted positions')
grid on
