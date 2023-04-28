%anpr1=load("C:\Users\user\Downloads\cnnanpr220.mat");
%anpi1=load("C:\Users\user\Downloads\cnnanpi220.mat"); 
%dr1=load("C:\Users\user\Downloads\cnndr220.mat");
%di1=load("C:\Users\user\Downloads\cnndi220.mat");
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
HBF11 = (abs(hbfs) - mn) ./ (mx - mn);
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
H = H1 ./ mag_h;
%[x,y] = pol2cart(t,r);
%[x,y] = pol2cart(wr,wi);
%P = peaks(x,y);
% Define some angular and radial range vectors for example plots
t1 = 2*pi;
t2 = [30 270]*pi/180;
r1 = 4;
r2 = [.8 4];
t3 = fliplr(t2);
r3 = fliplr(r2);
t4 = [30 35 45 60 90 135 200 270]*pi/180;
r4 = [0.8:0.4:2.8 3:0.2:4];
% Axis property cell array
axprop = {'DataAspectRatio',[1 1 8],'View', [-12 38],...
          'Xlim', [-4.5 4.5],       'Ylim', [-4.5 4.5],...
          'XTick',[-4 -2 0 2 4],    'YTick',[-4 -2 0 2 4]};
%xwr = pwr(1:256);
%ywi = qwi(1:256);
%xar = par(1:256);
%yai = qai(1:256);
%zar=reshape(xwr,16,16);
%zai=reshape(ywi,16,16);
%z = xwr+ywi;
%e= xar+yai;

%zw1=reshape(z,16,16);
%za1=reshape(e,16,16);
%[x,y] = pol2cart(zw1,za1);
[x,y] = pol2cart(HBF,H);
P = peaks(x,y);
figure('color','white');
polarplot3d(abs(P),'plottype','surfcn','angularrange',t2,'radialrange',r2,...
              'polargrid',{10 24},'tickspacing',15);
set(gca,axprop{:});
%figure('color','white');
%polarplot3d(P,'plottype','surfn','radialrange',[min(r4) max(r4)],...
              %'angularrange',[min(t4) max(t4)],'polargrid',{r4 t4},'tickspacing',15);
%set(gca,axprop{:});
%figure('color','white');
%polarplot3d(P,'plottype','surfn','angularrange',t2,...
              %'radialrange',r2,'tickspacing',15,...
             % 'polardirection','cw','colordata',gradient(P.').');
%set(gca,axprop{:});
%figure('color','white');
%polarplot3d(P,'plottype','mesh','angularrange',t3,'radialrange',r2,...
             % 'meshscale',2,'polargrid',{1 1},'axislocation','mean');
%set(gca,axprop{:});
%% Mesh plot with polar axis along edge of surface
figure('color','white');
polarplot3d(P,'plottype','mesh','angularrange',t2,'radialrange',r2,...
              'polargrid',{10 24},'tickspacing',8,...
              'plotprops',{'Linestyle','none'});
set(gca,axprop{:});
%% Mesh plot with contours, overlay 8 by 8 polar grid
figure('color','white');
polarplot3d(P,'plottype','meshc','angularrange',t2,'radialrange',r3,...
              'meshscale',2,'polargrid',{8 8});
set(gca,axprop{:});
%% Wireframe plot
%figure('color','white');
%polarplot3d(P,'plottype','wire','angularrange',t2,'radialrange',r2,...
             % 'polargrid',{24 24});
%set(gca,axprop{:});
%% Surface and contour plot, reversed radial sense
cl = round(min(P(:))-1):0.4:round(max(P(:))+1);
figure('color','white');
polarplot3d(P,'plottype','contour','polargrid',{6 4},'contourlines',cl);
set(gca,'dataaspectratio',[1 1 1],'view',[0 90]);
