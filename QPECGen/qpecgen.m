function qpecgen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Houyuan Jiang, Daniel Ralph, copyright 1997
% Code accompanying the paper: 
%   Jiang, H., Ralph D. 
%   QPECgen, a MATLAB generator for mathematical programs with 
%   quadratic objectives and affine variational inequality constraints.
%   Computational Optimization and Applications 13 (1999), 25?59.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This MATLAB program generates random test problems of MPEC
% with the  quadratic objective function and affine variational
% inequality constraints, and its special cases. See ......
% The MPEC problem is defined as:
                
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %   min     f(x,y)                                          %
          %   s.t.    (x,y) in Z                                      %
          %           y in S(x), S(x) solves AVI(F(x,y), C(x))        %
          %           F(x,y) is linear with respect to both x and y   %
          %           C(x) is polyhedral in y-space                   % 
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% f(x,y): f(x,y)=0.5.*x'*Px*x+x'*Pxy*y+0.5.*y'*Py*y+c'*x+d'*y; it is
%         the first level objective function or objective function.
% x:      n dimensional first level variable.
% y:      m dimensional second level variable.
% Px:     n by n matrix with respect to the variable x.
% Py:     m by m matrix with respect to the variable y.
% Pxy:    n by m matrix with respect to the variables x and y.
% P:      P=[Px Pxy';Pxy Py] -- Hessian of the objective function.
% c:      n dimensional vector associated with the variable x.
% d:      m dimensional vector associated with the variable y. 
% Z:      Z={(x,y): A*[x;y]+a<=0}.
% A:      l by (m+n) matrix.
% a:      l dimensional vector.
% F:      F=N*x+M*y+q.
% N:      m by n matrix.
% M:      m by m matrix.
% q:      m dimensional vector.
% C(x):   C(x)={y: g(x,y)=D*x+E*y+b<=0}.
% D:      p by n matrix.
% E:      p by m matrix.
% b:      p dimensional vector.
% u:      m dimensional vector.


% The above MPEC is very general. We define some special MPEC problems
% by specifying the second level constraints set in the following.

	  %%%%%%%%%%%%%%%%%%%%%%%%%%
	  %      BOX-MPEC          %
          %%%%%%%%%%%%%%%%%%%%%%%%%%

% C(x):   C(x)={y: 0<= y <=u}.
% u:      m dimensional vector; it is the upper bound of y. u>=0 or Inf.
% The special cases are considered in this code. See comments in BOX-MPEC.

% One of special cases of BOX-MPEC is LCP-MPEC.

	  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	  %       LCP-MPEC                  %
	  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% C(x):   C(x)={y: y>=0}.

% The end of descriptions of problems.

          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %  Hints for running this program %
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In order to run this program in MATLAB environment, the user needs to
% creat a file called   parameter.m, which supplies values for parameters
% used in this program to determine the different features of this program.
% The roles of these parameters can be found in the following.


clear all;
fprintf('--------------------------------------------------------\n')
fprintf('          =================================\n')
fprintf('          ||      Start of qpecgen.m      ||\n')
fprintf('          =================================\n')

% Load all parameters in parameter.m. 
[qpec_type,n,m,l,p,cond_P,scale_P,convex_f,symm_M,mono_M,cond_M,...
     scale_M,second_deg,first_deg,mix_deg,tol_deg,constraint,random]=parameter;
rand('seed',random);

% qpec_type:  Indicate the type of MPEC.
%             if qpec_type=100, it is the general AVI-MPEC problem.
%             if qpec_type=200, it is BOX-MPEC.
%             if qpec_type=300, it is LCP-MPEC.
%             if qpec_type=800, it is a special LCP-MPEC having good behaviour.
%             if qpec_type=900, it is a special LCP-MPEC having bad behaviour.
% n:          The dimension of the first level variables.
% m:          The dimension of the second level variables.
% l:          The number of the first level inequality constraints.
% p:          The number of the second level inequality constraints for
%             the AVI-MPEC problem. In the case of BOX-MPEC,
%             p=m. In the case of LCP-MPEC, p=m.
% cond_P:     The condition number of the Hessian of the objective function.
%             cond_P can be any number not less than 1.
% scale_P:    Positive scaling constant to roughly control the magnitude 
%             of the largest singular value of P.
% convex_f:   This is a binary element. If convex_f=0, f(x,y) is not
%             necessarily convex; if convex_f=1, f(x,y) is convex.
% symm_M:     This is a binary element. If symm_M=0, M is not necessarily
%             symmetric; if symm_M=1, M is symmetric.
% mono_M:     This is a binary element. If mono_M=0, M is not necessarily
%             monotone; if mono_M=1, M is monotone.
% cond_M:     The condition number of the matrix M. cond_M can be
%             any number not less than 1.
% scale_M:    Positive scaling constant to roughly control the magnitude 
%             of the largest singular value of M.
% second_deg: The cardinality of the second level degenerate index set.
%             second_deg must not be greater than p for AVI-MPEC,
%             than m for BOX-MPEC, and than m for LCP-MPEC.
% first_deg:  The cardinality of the first level degenerate constraints
%             index set. first_deg must not be greater than l.
% mix_deg:    The cardinality of the degenerate set associated with 
%             inequality constraints coming from the second level problem
%             in the relaxed nonlinear program of MPEC.
%             mix_deg <= second_deg must be satisfied.
% tol_deg:    a small positive tolerance to measure degeneracy.
% constraint: Numbers of variables involved in the first level constraints.
%             If the first level constraints are not associated with
%             the second level variable y, then constraint=1.
%             Otherwise, constraint=2. 
% random:     Indicates the random 'seed' in Matlab. 

% The end of loading   parameters.

	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	    % Check consistency of parameter data  %
	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

check=1;   % Redefine check=0 if the user does not want to check
%            consistency of data.
if check==1
if qpec_type ~= 100 & qpec_type ~= 200 & qpec_type ~= 300 ...
   & qpec_type ~=800 & qpec_type ~=900
   fprintf('Warning: Wrong data for qpec_type. \n')
   qpec_type=100;
   fprintf('qpec_type = 100\n')
end
if cond_P < 1
   fprintf('Warning: Wrong data for cond_P. cond_P should not be less than 1. \n')
   cond_P=20;
   fprintf('cond_P = 20\n')
end
if scale_P <= 0
   fprintf('Warning: Wrong data for scale_P.')
   scale_P=cond_P;
end
if convex_f ~= 0 & convex_f ~= 1
   fprintf('Warning: Wrong data for convex_f.\n')
   convex_f =1;
   fprintf('convex_f=1\n')
end
if symm_M ~= 0 & symm_M ~= 1
   fprintf('Warning: Wrong data for symm_M.\n')
   symm_M=1;
   fprintf('symm_M = 1\n')
end
if mono_M ~= 0 & mono_M ~= 1
   fprintf('Warning: Wrong data for mono_M \n')
   mono_M=1;
   fprintf('momo_M = 1\n')
end
if cond_M < 1
   fprintf('Warning: Wrong data for cond_M. cond_M should not be less than 1.\n')
   cond_M=10;
   fprintf('cond_M = 10\n')
end
if scale_M <= 0
   fprintf('Warning: Wrong data for scale_P.')
   scale_M=cond_M;
end
if qpec_type == 100
   if second_deg > p
      fprintf('Warning: Wrong data for second_deg. second_deg should not be greater than p.\n')
      second_deg=p;
      fprintf('second_deg = p\n')
   end
elseif qpec_type == 200
   if second_deg > m
      fprintf('Warning: Wrong data for second_deg. second_deg should not be greater than m.\n')
      second_deg=m;
      fprintf('second_deg = m\n')
   end
elseif qpec_type == 300
   if second_deg > m
      fprintf('Warning: Wrong data for second_deg. second_deg should not be greater than m \n')
      second_deg=m;
      fprintf('second_deg = m\n')
   end
end
if first_deg > l
   fprintf('Warning: Wrong data for first_deg. first_deg should not be greater than l.\n')
   first_deg=l;
   fprintf('first_deg = l\n')
end
if mix_deg > second_deg
   fprintf('Warning: Wrong data for mix_deg. mix_deg should not be greater than second_deg \n')
   mix_deg=second_deg;
   fprintf('mix_deg = second_deg\n')
end
if constraint ~=1 & constraint ~=2
   fprintf('Warning: Wrong data for constraint. constraint should be 1 or 2\n')
   constraint=2;
   fprintf('constraint=2\n')
end
end

% The end of checking for consistency of parameter data.

	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	    %       The Main Program           %
	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% xgen:   n dimensional vector. The x-part of the presumed optimal solution.
% ygen:   m dimensional vector. The y-part of the presumed optimal solution.
%
% Generate the quadratic terms of objective function.
%
P=rand(m+n,m+n)-rand(m+n,m+n);
P=P+P';            % P is symmetric.
%  Consider the monotonicity property and the condition number of P.
if convex_f==1              % Convex case.
   [PU,PT]=schur(P);    % Schur decomposition. PT is diagonal since P
%                         is symmetric.
   PTT=-min(diag(PT)).*ones(m+n,1)+rand(m+n,1); % Generate
%                          positive diagonal matrix.
   PT=diag(PTT)+PT;   % New diagonal matrix with positive
%                       diagonal entries.
%  Determine the condition number of P.
   PT=diag(PT);
   ccond_P=(cond_P-1).*min(PT)./(max(PT)-min(PT));
   PT=min(PT).*ones(m+n,1)+ ccond_P.*(PT-min(PT).*ones(m+n,1));
   P=PU*diag(PT)*PU';  %  Generate a matrix with the required condition
%                      number   cond_P.
elseif convex_f==0     % Noncovex case.
   [PU,PD,PV]=svd(P);  % Singular value decomposition.
   PD=diag(PD);
   ccond_P=(cond_P-1).*min(PD)./(max(PD)-min(PD));
   PD=min(PD).*ones(m+n,1)+ ccond_P.*(PD-min(PD).*ones(m+n,1));
   P=PU*diag(PD)*PV';  %  Generate a matrix with the required condition
%                      number   cond_P.
end
P=(scale_P/cond_P)*P;   % Rescale P when cond_P is large.

Px=P(1:n,1:n);
Py=P(n+1:m+n,n+1:m+n);
Pxy=P(1:n,n+1:m+n);
%
% Generate coefficients of the first level constraints A*[x;y]+a<=0. 
%
if constraint==2
   A=rand(l,n+m)-rand(l,n+m);
else
   A=[rand(l,n)-rand(l,n) zeros(l,m)];
end
if l==0
   A=zeros(l,m+n);
end
%
% Generate matrices of the second level objective function.
%
M=rand(m)-rand(m);
%  Consider the symmetric property of M.
if symm_M==1
   M=M+M';
end
%  Consider the monotonicity property and the condition number of M.
if mono_M==1 & symm_M==1           % Monotone and symmetric case.
   [MU,MT]=schur(M);    % Schur decomposition. MT is diagonal since M
%                         is symmetric.
   MTT=-min(diag(MT)).*ones(m,1)+rand(m,1); % Generate
%                          positive diagonal matrix.
   MT=diag(MTT)+MT;   % New diagonal matrix with positive
%                       diagonal entries.
%  Determine the condition number of M.
   MT=diag(MT);
   ccond_M=(cond_M-1).*min(MT)./(max(MT)-min(MT));
   MT=min(MT).*ones(m,1)+ ccond_M.*(MT-min(MT).*ones(m,1));
   M=MU*diag(MT)*MU';  %  Generate a matrix with the required condition
%                      number   cond_M.
elseif mono_M==0 & symm_M==1         % Nonmonotone and symmetric case.
   [MU,MD,MV]=svd(M);  % Singular value decomposition.
   MD=diag(MD);
   ccond_M=(cond_M-1).*min(MD)./(max(MD)-min(MD));
   MD=min(MD).*ones(m,1)+ ccond_M.*(MD-min(MD).*ones(m,1));
   M=MU*diag(MD)*MV';  %  Generate a matrix with the required condition
%                      number   cond_M.
elseif mono_M==1 & symm_M==0         % Monotone and asymmetric case.
   [MU,MT]=schur(M);    % Schur decomposition. 
   for i=1:m-1
       MT(i+1,i)=-MT(i+1,i);     % Make real eigenvalues for MT.
   end
   M=MU*MT*MU';                  % New asymmetric matrix with real eigenvalues.
   [MU,MT]=schur(M);    % Schur decomposition. MT is upper triangular since M
%                         has real eigenvalues.
   MTT=-min(diag(MT)).*ones(m,1)+rand(m,1); % Generate
%                          positive diagonal matrix.
   MT=diag(MTT)+MT;   % New upper triangular matrix with positive
%                       diagonal entries.
%  Determine the condition number of M or MT.
   MTM=MT'*MT;        % Form a symmetric and positive definite matrix.
   [MTMU,MTMT]=schur(MTM);  % MTMT is diagonal.
   ccond_MTMT=(cond_M^2-1).*min(diag(MTMT))./(max(diag(MTMT))-min(diag(MTMT)));
   MTMT=min(diag(MTMT)).*ones(m,1)+...
        ccond_MTMT.*(diag(MTMT)-min(diag(MTMT)).*ones(m,1));
   MTM=MTMU*diag(MTMT)*MTMU';
   MT=chol(MTM);   % Use the relation of condition numbers for MT and MT'*MT.
   M=MU*MT*MU';    %  Generate a matrix with the required condition
%                      number   cond_M.
elseif mono_M==0 & symm_M==0         % Nonmonotone and asymmetric case.
   [MU,MD,MV]=svd(M);  % Singular value decomposition.
   MD=diag(MD);
   ccond_M=(cond_M-1).*min(MD)./(max(MD)-min(MD));
   MD=min(MD).*ones(m,1)+ ccond_M.*(MD-min(MD).*ones(m,1));
   M=MU*diag(MD)*MV';  %  Generate a matrix with the required condition
end
M=(scale_M/cond_M)*M;   % Rescale M when cond_M is large.
%
N=rand(m,n)-rand(m,n);
%   
% Generate other data for different MPEC problems. 

         %%%%%%%%%%%%%%%%%%%%%%%%%%
         %         AVI-MPEC       %
         %%%%%%%%%%%%%%%%%%%%%%%%%%

if qpec_type == 100  % In the case of AVI-MPEC.
%  
%  Generate the optimal solution of AVI-MPEC.
%
   xgen=rand(n,1)-rand(n,1);
   ygen=rand(m,1)-rand(m,1);
%
%  Generate matrices in the second level constraints set.
%
   D=rand(p,n)-rand(p,n);
   E=rand(p,m)-rand(p,m);
%
%  Generate multipliers  lambda   of the second level problem.
%
   p_nonactive=ceil((p-second_deg).*rand(1,1));   % The number of nonactive
%                  second level constraints at (xgen, ygen).
   lambda=[zeros(second_deg+p_nonactive,1);rand(p-second_deg-p_nonactive,1)]; 
%
%  Generate the vector in the second level constraints set.
%
   b=-D*xgen-E*ygen-[zeros(second_deg,1);rand(p_nonactive,1); ...
     zeros(p-second_deg-p_nonactive,1)];   % The first second_deg constraints
%       are degenerate, the next p_nonative constraints are not active,
%       and the last p-second_deg-p_nonactive constraints are active
%       but nondegenerate at (xgen, ygen).
%
%  Generate the vector in the second level objective function.
%
   q=-N*xgen-M*ygen-E'*lambda; % KKT conditions of the second level problem.
   F=N*xgen+M*ygen+q;      % The introduction of F is for later convienience.
%
%  Generate the first level multipliers  xi  associated with A*[x;y]+a<=0.
%
   l_nonactive=ceil((l-first_deg).*rand(1,1)); % The number of nonactive
%               first level constraints at (xgen, ygen).
   xi=[zeros(first_deg+l_nonactive,1);rand(l-first_deg-l_nonactive,1)];
%
%  Generate the vector in the first level constraints set.
%
   a=-A*[xgen;ygen]-[zeros(first_deg,1);rand(l_nonactive,1); ...
     zeros(l-first_deg-l_nonactive,1)];   % The first first_deg constraints
%       are degenerate, the next l_nonative constraints are not active,
%       and the last l-first_deg-l_nonactive constraints are active
%       but nondegenerate at (xgen, ygen).  
%
%  Calculate three index sets alpha, beta and gamma at (xgen, ygen).
%
   g=D*xgen+E*ygen+b;   % The introdunction of   g  is for later convenience.
   indexalpha=(lambda+g<-tol_deg.*ones(p,1));
   indexgamma=-(lambda+g>tol_deg.*ones(p,1));
   index=indexalpha+indexgamma;  % index(i)=1  iff g(i)+lambda(i)<-tol_deg,
%                                  index(i)=0   iff |g(i)+lambda(i)|<=tol_deg,
%                                  index(i)=-1  iff g(i)+lambda(i)>tol_deg.
%
% Generate the first level multipliers   eta    pi    sigma
% associated with other constraints other than the first level constraints 
% A*[x;y]+a<=0   in the relaxed nonlinear program. In particular,
% eta  is associated with  N*x+M*y+q+E'*lambda=0,
% pi                 with  D*x+E*y+b,
% sigma              with  lambda.
%
   k_mix=0;
   for i=1:p
       if index(i,1)==1
          pi(i,1)=0;       
	  sigma(i,1)=rand(1,1)-rand(1,1);
       elseif index(i,1)==0 
          if k_mix<mix_deg
             pi(i,1)=zeros(1,1);    % The first mix_deg constraints associated
%                        with D*x+E*y+b<=0 in the set beta are degenerate. 
             sigma(i,1)=zeros(1,1); % The first mix_deg constraints associated
%                        with lambda>=0 in the set beta are degenerate.
             k_mix=k_mix+1;
          else
             pi(i,1)=rand(1,1);  
             sigma(i,1)=rand(1,1);
          end
       else
          pi(i,1)=rand(1,1)-rand(1,1);
	  sigma(i,1)=0;
       end
   end
   eta=E\sigma;    
%
%  Generate the coefficients of linear terms of objective function
%  such that (xgen, ygen) satisfies KKT conditions of AVI-MPEC as
%  well as the first level degeneracy.
%
   if l==0
      c=Px*xgen+Pxy*ygen+N'*eta+D'*pi;
   else 
      c=Px*xgen+Pxy*ygen+A(:,1:n)'*xi+N'*eta+D'*pi;
   end
   c=-c;
   if l==0
      d=Py*ygen+Pxy'*xgen+M'*eta+E'*pi;
   else 
      d=Py*ygen+Pxy'*xgen+A(:,n+1:m+n)'*xi+M'*eta+E'*pi;
   end
   d=-d;
%
%  The end of AVI-MPEC.

             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %         BOX-MPEC          %
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif qpec_type == 200  % In the case of BOX-MPEC.
%
% Note that we only consider the following two cases of box constraints:
% y(i) in [0, +Inf) or  [0, u] where u is a nonnegative scalar.
% Clearly, any other interval can be obtained by using the mapping
% y <--- c1+c2*y. 
% It is assumed that the last m_Inf constraints are of the form [0, Inf).
%  
%  Generate the box constraints and the optimal solution of BOX-MPEC.
%
   xgen=rand(n,1)-rand(n,1);
   m_Inf=min(m-1,ceil(m*rand(1,1)));  % The number of the constraints [0, Inf).
   u=10.*rand(m-m_Inf,1);   % The upper bound of the constraints [0, u].
   m_Inf_deg=max(second_deg-m+m_Inf, ...
                ceil(min(m_Inf,second_deg)*rand(1,1)));
%  The number of constraints which are degenerate for the constraints [0, Inf).
   m_upp_deg=ceil((second_deg-m_Inf_deg)*rand(1,1));
%  The number of constraints which are degenerate at the upper end point.
   m_low_deg=second_deg-m_Inf_deg-m_upp_deg;
%  The number of constraints which are degenerate at the lower end point.
   upp_nonactive=ceil((m-m_Inf-m_upp_deg-m_low_deg)*rand(1,1));
   low_nonactive=ceil((m-m_Inf-m_upp_deg-m_low_deg-upp_nonactive)*rand(1,1));
   Inf_nonactive=ceil((m_Inf-m_Inf_deg)*rand(1,1));
   ygen=[u(1:m_upp_deg+upp_nonactive);zeros(m_low_deg+low_nonactive,1);...
        rand(m-m_Inf-m_upp_deg-upp_nonactive-m_low_deg-low_nonactive,1).*...
        u(m_upp_deg+upp_nonactive+m_low_deg+low_nonactive+1:m-m_Inf);...
        zeros(m_Inf_deg+Inf_nonactive,1);...
        rand(m_Inf-m_Inf_deg-Inf_nonactive,1)];
%  m_upp_deg (F=0, y=u)
%  upp_nonactive (F<0, y=u)
%  m_low_deg (F=0, y=0)
%  low_nonactive (F>0, y=0)
%  m-m_Inf-m_upp_deg-upp_nonactive-m_low_deg-low_nonactive (F=0, 0<y<u)
%  m_Inf_deg (F=0, y=0)
%  Inf_nonactive (F>0, y=0)
%  m_Inf-m_Inf_deg-Inf_nonactive (F=0, y>0)
%
%  Generate the vector in the second level objective fucntion.
%
   q=-N*xgen-M*ygen;
   q=q+[zeros(m_upp_deg,1);-rand(upp_nonactive,1);zeros(m_low_deg,1);...
        rand(low_nonactive,1);...
        zeros(m-m_Inf-m_upp_deg-upp_nonactive-m_low_deg-low_nonactive,1);...
        zeros(m_Inf_deg,1);...
        rand(Inf_nonactive,1);zeros(m_Inf-m_Inf_deg-Inf_nonactive,1)];
   F=N*xgen+M*ygen+q;      % The introduction of F is for later convienience.
%
%  Generate the first level multipliers  xi  associated with A*[x;y]+a<=0.
%
   l_nonactive=ceil((l-first_deg).*rand(1,1)); % The number of nonactive
%               first level constraints at (xgen, ygen).
   xi=[zeros(first_deg+l_nonactive,1);rand(l-first_deg-l_nonactive,1)];
%
%  Generate the vector in the first level constraints set.
%
   a=-A*[xgen;ygen]-[zeros(first_deg,1);rand(l_nonactive,1); ...
     zeros(l-first_deg-l_nonactive,1)];   % The first first_deg constraints
%       are degenerate, the next l_nonative constraints are not active,
%       and the last l-first_deg-l_nonactive constraints are active
%       but nondegenerate at (xgen, ygen).  
%
%  Calculate three index sets alpha, beta and gamma at (xgen, ygen).
%  alpha denotes the index set of i at which F(i) is active, but y(i) not.
%  beta_upp and beta_low denote the index sets of i at which F(i) is
%  active, and y(i) is active at the upper and the lower end point of
%  the finite interval [0, u] respectively.
%  beta_Inf denotes the index set of i at which both F(i) and y(i) are
%  active for the infinite interval [0, Inf).
%  gamma_upp and gamma_low denote the index sets of i at which F(i) is
%  not active, but y(i) is active at the upper and the lower point of
%  the finite interval [0, u] respectively.
%  gamma_Inf denotes the index set of i at which F(i) is not active, but y(i)
%  is active for the infinite interval [0, Inf).
%
   for i=1:m-m_Inf
       if abs(F(i))<=tol_deg & ygen(i)>tol_deg & ygen(i)+tol_deg<u(i)
          index(i,1)=1;      % For the index set alpha.
       elseif abs(F(i))<=tol_deg & abs(ygen(i)-u(i))<=tol_deg
          index(i,1)=02;     % For the index set beta_upp.
       elseif abs(F(i))<=tol_deg & abs(ygen(i))<=tol_deg
          index(i,1)=03;     % For the index set beta_low.
       elseif F(i)<-tol_deg & abs(ygen(i)-u(i))<=tol_deg
          index(i,1)=-1;     % For the index set gamma_upp.
       elseif F(i)>tol_deg & abs(ygen(i))<=tol_deg
          index(i,1)=-1;     % For the index set gamma_low.
       end
    end
    for i=m-m_Inf+1:m
        if ygen(i)>F(i)+tol_deg
           index(i,1)=1;     % For the index set alpha.
        elseif abs(ygen(i)-F(i))<=tol_deg
           index(i,1)=04;    % For the index set beta_Inf.
        else
           index(i,1)=-1;    % For the index set gamma_Inf.
        end
     end
%
% Generate the first level multipliers   pi    sigma
% associated with other constraints other than the first level constraints 
% A*[x;y]+a<=0   in the relaxed nonlinear program. In particular,
% pi            is associated with  F(x, y)=N*x+M*y+q, and
% sigma                       with  y.
%
   mix_upp_deg=max(mix_deg-m_low_deg-m_Inf_deg, ...
                   ceil(m_upp_deg.*rand(1,1)));
   mix_low_deg=max(mix_deg-mix_upp_deg-m_Inf_deg, ...
                   ceil(m_low_deg.*rand(1,1)));
   mix_Inf_deg=mix_deg-mix_upp_deg-mix_low_deg;
   k_mix_Inf=0;
   k_mix_upp=0;
   k_mix_low=0;
   for i=1:m
       if index(i,1)==1
          pi(i,1)=rand(1,1)-rand(1,1);
	  sigma(i,1)=zeros(1,1);
       elseif index(i,1)==02 
          if k_mix_upp<mix_upp_deg
             pi(i,1)=zeros(1,1);    % The first mix_upp_deg constraints 
%                associated with F(i)<=0 in the set beta_upp are degenerate. 
             sigma(i,1)=zeros(1,1); % The first mix_upp_deg constraints 
%                associated with y(i)<=u(i) in the set beta_upp are degenerate.
             k_mix_upp=k_mix_upp+1;
          else
             pi(i,1)=rand(1,1);  
             sigma(i,1)=rand(1,1);
          end
       elseif index(i,1)==03
          if k_mix_low<mix_low_deg
             pi(i,1)=zeros(1,1);    % The first mix_low_deg constraints
%                associated with F(i)>=0 in the set beta_low are degenerate.
             sigma(i,1)=zeros(1,1); % The first mix_low_deg constraints
%                associated with y(i)>=0 in the set beta_low are degenerate.
             k_mix_low=k_mix_low+1;
          else
             pi(i,1)=-rand(1,1);
             sigma(i,1)=-rand(1,1);
          end
       elseif index(i,1)==04
          if k_mix_Inf<mix_Inf_deg
             pi(i,1)=zeros(1,1);    % The first mix_Inf_deg constraints
%                associated with F(i)>=0 in the set beta_Inf are degenerate.
             sigma(i,1)=zeros(1,1); % The first mix_Inf_deg constraints
%                associated with y(i)>=0 in the set beta_Inf are degenerate.
             k_mix_Inf=k_mix_Inf+1;
          else
             pi(i,1)=-rand(1,1);
             sigma(i,1)=-rand(1,1);
          end
       else
          pi(i,1)=zeros(1,1);
          sigma(i,1)=rand(1,1)-rand(1,1);
       end
   end
%
%  Generate the coefficients of linear terms of objective function
%  such that (xgen, ygen) satisfies KKT conditions of BOX-MPEC as
%  well as the first level degeneracy.
%
   if l==0
      c=Px*xgen+Pxy*ygen+N'*pi;
   else 
      c=Px*xgen+Pxy*ygen+A(:,1:n)'*xi+N'*pi;
   end
   c=-c;
   if l==0
      d=Py*ygen+Pxy'*xgen+M'*pi+sigma;
   else
      d=Py*ygen+Pxy'*xgen+A(:,n+1:m+n)'*xi+M'*pi+sigma;
   end
   d=-d;
%
%  The end of BOX-MPEC.

               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %         LCP-MPEC          %
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

elseif qpec_type==300            % In the case of LCP-MPEC.
%
%  Generate the optimal solution of LCP-MPEC.
%
   xgen=rand(n,1)-rand(n,1);
   m_nonactive=ceil((m-second_deg).*rand(1,1));   % The number of indices
%    where the second level objective function is not active at (xgen, ygen).
   ygen=[zeros(second_deg+m_nonactive,1);rand(m-second_deg-m_nonactive,1)];
%       The first second_deg+m_nonactive elements of ygen are active.
%
%  Generate the vector in the second level objective function.
%
   q=-N*xgen-M*ygen+[zeros(second_deg,1);rand(m_nonactive,1); ...
     zeros(m-second_deg-m_nonactive,1)]; 
%          The first second_deg indices are degenerate at (xgen, ygen).
   F=N*xgen+M*ygen+q;       % The introduction of F is for later convenience.
%
%  Generate the first level multipliers  xi  associated with   A*[x;y]+a<=0.
%
   l_nonactive=ceil((l-first_deg).*rand(1,1)); % The number of nonactive
%               first level constraints at (xgen, ygen).
   xi=[zeros(first_deg+l_nonactive,1);rand(l-first_deg-l_nonactive,1)];
%
%  Generate the vector in the first level constraints set.
%
   a=-A*[xgen;ygen]-[zeros(first_deg,1);rand(l_nonactive,1); ...
     zeros(l-first_deg-l_nonactive,1)];   % The first first_deg constraints
%       are degenerate, the next l_nonative constraints are not active,
%       and the last l-first_deg-l_nonactive constraints are active
%       but nondegenerate at (xgen, ygen).
%
%  Calculate three index set alpha, beta and gamma at (xgen, ygen).
%
   indexalpha=(F+tol_deg.*ones(m,1)<ygen);
   indexgamma=-(F>ygen+tol_deg.*ones(m,1));
   index=indexalpha+indexgamma;   % index(i)=1 iff F(i)+tol_deg<ygen(i),
%                                   index(i)=0 iff |F(i)-ygen(i)|<=tol_deg,
%                                   index(i)=-1 iff F(i)>ygen(i)+tol_deg.
%
% Generate the first level multipliers associated with other constraints
% other than the first level constraints   A*[x;y]+a<=0   in the relaxed
% nonlinear program. In particular,   pi  and  sigma  are associated with  
% F(x, y)=N*x+M*y+q   and    y   in the relaxed nonlinear program.
%
   k_mix=0;
   for i=1:m
       if index(i,1)==-1
          pi(i,1)=zeros(1,1);
          sigma(i,1)=rand(1,1)-rand(1,1);
       elseif index(i,1)==0 
          if k_mix<mix_deg
             pi(i,1)=zeros(1,1);  % The first mix_deg constraints associated
%                    with F(x, y)>=0 in the set beta are degenerate.
             sigma(i,1)=zeros(1,1);  % The first mix_deg constraints
%                     associated with y>=0 in the set beta are degenerate.
             k_mix=k_mix+1; 
          else
             pi(i,1)=rand(1,1);    
             sigma(i,1)=rand(1,1);
          end
       else
          pi(i,1)=rand(1,1)-rand(1,1);
          sigma(i,1)=zeros(1,1);
       end
   end
%
%  Generate the coefficients of linear terms of objective function
%  such that (xgen, ygen) satisfies KKT conditions of LCP-MPEC as
%  well as the first level degeneracy. 
%
   if l==0
      c=N'*pi-Px*xgen-Pxy*ygen;
   else
      c=N'*pi-Px*xgen-Pxy*ygen-A(:,1:n)'*xi;
   end
   if l==0
      d=M'*pi+sigma-Py*ygen-Pxy'*xgen;
   else
      d=M'*pi+sigma-Py*ygen-Pxy'*xgen-A(:,n+1:n+m)'*xi;
   end
%
%  The end of LCP-MPEC.

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %       Good and bad LCP-MPEC        %
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif qpec_type==800         % The start of Good LCP-MPEC.
       l=0;
       if n>m
          n=m;
          fprintf('\n The dimensions have been changed: n=m\n')
       end
       P=2.*eye(n+m);
       c=-2.*ones(n,1);
       d=4.*ones(m,1);
       A=zeros(l,n+m);
       a=zeros(l,1);
       N=-eye(m,n);
       M=eye(m);
       q=zeros(m,1);
       xgen=zeros(n,1);
       ygen=zeros(m,1);
%
%                             The end of Good LCP-MPEC.
%
elseif qpec_type==900         % The start of Bad LCP-MPEC. 
       l=0;
       if n>m
          n=m;
          fprintf('\n The dimensions have been changed: n=m\n')
       end
       P=2.*eye(n+m);
       c=2.*ones(n,1);
       d=-4.*ones(m,1);
       A=zeros(l,n+m);
       a=zeros(l,1);
       N=-eye(m,n);
       M=eye(m);
       q=zeros(m,1);
       xgen=-ones(n,1);
       ygen=zeros(m,1);
%                               The end of Bad example.
end
%
%  The end of the Main Program.

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %       Output             %
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('  \n')
if qpec_type==100
   fprintf('************ An example of AVI-MPEC *************\n\n')
elseif qpec_type==200
   fprintf('************ An example of BOX-MPEC *************\n\n')
elseif qpec_type==300
   fprintf('************ An example of LCP-MPEC *************\n\n')
elseif qpec_type==800
   fprintf('************ A good example of LCP-MPEC *************\n\n')
elseif qpec_type==900
   fprintf('************ A bad example of LCP-MPEC *************\n\n')
end

data=0;        % A logical variable. If the user wants to see his
%                parameter data, set data=1. Otherwise, set data=0.
if data==1
   fprintf('\n\n')
   fprintf('qpec_type=%g\n',qpec_type)
   fprintf('n=%g\n',n)
   fprintf('m=%g\n',m)
   fprintf('l=%g\n',l)
   fprintf('p=%g\n',p)
   fprintf('cond_P=%g\n',cond_P)
   fprintf('convex_f=%g\n',convex_f)
   fprintf('symm_M=%g\n',symm_M)
   fprintf('mono_M=%g\n',mono_M)
   fprintf('cond_M=%g\n',cond_M)
   fprintf('second_deg=%g\n',second_deg)
   fprintf('first_deg=%g\n',first_deg)
   fprintf('mix_deg=%g\n',mix_deg)
   fprintf('tol_deg=%g\n',tol_deg)
   fprintf('constraint=%g\n',constraint)
   fprintf('random=%g\n',random)
end
P=0.5*(P+P');   % To avoid rounding errors during computation.
if qpec_type==100
  save qpecgen_data P c d A a N M q D E b xgen ygen
elseif qpec_type==200
  save qpecgen_data P c d A a N M q u xgen ygen
elseif qpec_type==300
  save qpecgen_data P c d A a N M q xgen ygen
elseif qpec_type==800
  save qpecgen_data P c d A a N M q xgen ygen
elseif qpec_type==900
  save qpecgen_data P c d A a N M q xgen ygen
end
fgen=0.5.*[xgen;ygen]'*P*[xgen;ygen]+[c;d]'*[xgen;ygen];

% The end of ouput.

% The end of Program.

