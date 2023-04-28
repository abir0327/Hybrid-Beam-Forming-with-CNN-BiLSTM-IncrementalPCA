cnlr1=load("C:\Users\user\Desktop\Generated beamforming matrix\cnntcnlr220.mat");

cnli1=load("C:\Users\user\Desktop\Generated beamforming matrix\cnntcnli220.mat");

hbfr1=load("C:\Users\user\Desktop\Generated beamforming matrix\lstmhbfr.mat");
hbfi1=load("C:\Users\user\Desktop\Generated beamforming matrix\lstmhbfi.mat"); 

hbfr4=cell2mat(struct2cell(hbfr1));
hbfi4=cell2mat(struct2cell(hbfi1));

%anpr=cell2mat(struct2cell(anpr1));
%anpi=cell2mat(struct2cell(anpi1));
%dr4=cell2mat(struct2cell(dr1));
%di4=cell2mat(struct2cell(di1));
cnlr4=cell2mat(struct2cell(cnlr1));
cnli4=cell2mat(struct2cell(cnli1));
%dr=reshape(dr4,12,32);
%di=reshape(di4,12,32);
cnlr=reshape(cnlr4,12,256);
cnli=reshape(cnli4,12,256);
hbfr=reshape(hbfr4,12,256);
hbfi=reshape(hbfi4,12,256);
%F1=complex(anpr,anpi);
%W1=complex(dr,di);
H1=complex(cnlr,cnli);
hbfs=complex(hbfr,hbfi);
mx = max(hbfs(:));
mn = min(hbfs(:));


% Scale hbf matrix between 0 and 1
HBF11 = (abs(hbfs) - mn) / (mx - mn);
% Loop over the matrix to find the maximum and minimum values
for i = 1:size(hbfs,1)
    for j = 1:size(hbfs,2)
        if hbfs(i,j) > mx
            mx = hbfs(i,j);
        end
        if hbfs(i,j) < mn
            mn = hbfs(i,j);
        end
    end
end

% Loop over the matrix again to perform the scaling operation
HBF = zeros(size(hbfs));
for i = 1:size(hbfs,1)
    for j = 1:size(hbfs,2)
        HBF(i,j) = (hbfs(i,j) - mn)/(mx - mn);
    end
end
[t,r] = meshgrid(linspace(0,2*pi,361),linspace(-4,4,101));
mag_h = abs(H1);

% Normalize the complex number
H = H1 / mag_h;%M=z1;
q = HBF(:,1:12);
%qn = q';
plot_pattern(abs(q))
%saveas(gcf,'H:\m6im6o\data\fig\dftcb.png')
%patternCustom(M(:,3),M(:,2),M(:,1));
%patternCustom(M(:,3),M(:,2),M(:,1),'CoordinateSystem','rectangular');
%patternCustom(M(:,3),M(:,2),M(:,1),'CoordinateSystem','polar','Slice',  ...
   % 'phi','SliceValue',[45 90 180 360]);
%p = polarpattern(ang, M);
%load polardata

%p = polarpattern(ang, D);
% Initialize system constants
%prm.fc = 28e9;
%mFrf = permute(mean(q,1),[2 3 1]);
%prm.cLight = physconst('LightSpeed');
    %pattern(q,prm.fc,-180:180,-90:90,'Type','efield', ...
           % 'Element0Weights',mFrf.'*squeeze(n(1,:,:)), ...
            %'PropagationSpeed',prm.cLight);