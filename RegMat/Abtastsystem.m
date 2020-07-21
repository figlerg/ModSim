% system model
A = [-1 0; 1 0];
B = [1;0];
C = [0 1];
D = 0;
h = 0.1;
time = 10; % simulation time in seconds

% case 1
[u1,t] = gensig('sin', 2*pi, time , h);
x0 = [0.1; 0.1];
sys = ss(A,B,C,D); % construct system model automatically

figure(1);
[y_lsim_sin,~,~] = lsim(sys, u1, t, x0) % simulation of response
plot(t,y_lsim_sin);
title('Response y for u = sin(x), x(0) = (' + strjoin(string(x0),',')+')')

% case 2
U_2 = zeros(size(t));
X_0_2 = [5;5];
figure(2);
lsim(sys, U_2, t, X_0_2);
title('Response y to u = 0, x(0) = (' + strjoin(string(X_0_2),',')+')')

% Task 2
% [t,y] = forward_euler(h, time, X_0,U);
[t,y_euler_sin] = forward_euler(h, time, x0,u1);
figure(3);
y_lsim_sin = y_lsim_sin'
plot(t,y_euler_sin,t,y_lsim_sin);
title('Explicit euler vs. lsim')

% implicit euler- how to get x_k?
[t,y2] = backward_euler(h, time, x0,u1);
figure(4);
plot(t,y2,t,y_lsim_sin);
title('Implicit euler vs. lsim')


figure(5)
sysd = c2d(sys, h);
[Ysind,~,~] = lsim(sysd, u1, t, x0);
plot(t,Ysind,t,y_lsim_sin,t,y_euler_sin, t, y2);
title('explicit euler vs. c2d vs. lsim vs. implicit euler');
legend('c2d','lsim','explicit euler', 'implicit euler');



function [t,y] = forward_euler(h,time,x_0,u)
    k_max = int16(time/h)+1;
    assert(length(u) == k_max);
    t = 0:h:time;
    n = size(x_0,1);
    x = zeros(n,length(u));
    
    for i = 0:k_max-1
        if i == 0
            x(:,i+1) = x_0; % matlab indices start at 1
        else
%             x(:,i+1) = x(:,i) + h*([-1 0; 1 0] * x(:,i) + [u(i);0]);
            x(:,i+1) = x(:,i) + h * ([-x(1,i) + u(i); x(1,i)]);
        end
    end
    y = x(2,:);
end
        

function [t,y] = backward_euler(h,time,x_0,u)
    k_max = int16(time/h)+1;
    assert(length(u) == k_max);
    t = 0:h:time;
    n = size(x_0,1);
    x = zeros(n,length(u));
    
    for i = 0:k_max-1
        if i == 0
            x(:,i+1) = x_0; % matlab indices start at 1
        else
%             x(:,i+1) = x(:,i) + h*([-1 0; 1 0] * x(:,i) + [u(i);0]);
%             x(:,i+1) = x(:,i) + h * ([-x(1,i) + u(i); x(1,i)]);
           x(1,i+1) = (x(1,i) + h*u(i+1))/(1+h);
           x(2,i+1) = x(2,i) + h*x(1,i+1);
    end
    y = x(2,:);
    end

end