function [params,H] = minsnap(x0,xf,fixed0,fixedf)

%here we will compute the minsnap trajectory with fixed and free
%constraints on pos, vel, acc, and jerk

%Here we plan a trajectory from t0=0 to tf=1, this solution can be
%shifted and scaled to the real one.  This is done to avoid numerical
%issues that are caused by using large times since the times are raised to
%large powers in the matrix A.

%For details see the paper:

%Daniel Mellinger and Vijay Kumar. Minimum Snap Trajectory Generation 
%and Control for Quadrotors. Int. Conf. on Robotics and Automation, 
%Shanghai, China, May 2011.

if(nargin<3)
    fixed0 = ones(4,1);
    fixedf = ones(4,1);
end

%the cost function is the integral from t0 to tf of the snap squared
coeff = [840,360,120,24]';
mat = [6,5,4,3;5,4,3,2;4,3,2,1;3,2,1,0];
intmat = zeros(4,4);
t0=0;
tf=1;
for i=1:4
    for j=1:4
        intmat(i,j) = 1/(mat(i,j)+1)*(tf^(mat(i,j)+1)-t0^(mat(i,j)+1));
    end
end
Q = diag(coeff)*intmat*diag(coeff);

H = [Q,zeros(4,4);zeros(4,8)];

H = (H+H')/2; %for numerical issues

A = [t0^7,    t0^6,     t0^5,    t0^4,    t0^3,   t0^2, t0, 1;...
    7*t0^6,  6*t0^5,   5*t0^4,  4*t0^3,  3*t0^2, 2*t0, 1,  0;...
    42*t0^5, 30*t0^4,  20*t0^3, 12*t0^2, 6*t0,   2,    0,  0;...
    210*t0^4,120*t0^3, 60*t0^2, 24*t0,   6,      0,    0,  0;...
    tf^7,    tf^6,     tf^5,    tf^4,    tf^3,   tf^2, tf, 1;...
    7*tf^6,  6*tf^5,   5*tf^4,  4*tf^3,  3*tf^2, 2*tf, 1,  0;...
    42*tf^5, 30*tf^4,  20*tf^3, 12*tf^2, 6*tf,   2,    0,  0;...
    210*tf^4,120*tf^3, 60*tf^2, 24*tf,   6,      0,    0,  0];

B = [x0; xf];
fixed = [fixed0;fixedf]~=0;

params = quadprog(H,[],[],[],A(fixed,:),B(fixed));
