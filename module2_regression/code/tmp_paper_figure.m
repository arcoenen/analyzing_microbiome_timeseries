% NOT UPDATED, WILL NOT WORK

clear;
load('module2_regression/data/aloha_clean_3D');
show_figs = 1;
make_latex_fig = 1;
if make_latex_fig == 1
    FIG = figure();
    fs = 7;
end

d = 1; % depth 1
present = 0; % contig should be present for at least p fraction of the time



%% partial autocorrelation

Nlag = Ncruise-1;
pac = zeros(Nlag+1,n);
for i = 1:n
    pac(:,i) = parcorr(x(:,i),'NumLags',Nlag);
end

% any bad results?
tmpID = ~isfinite(sum(pac));
if sum(tmpID)>0
    fprintf('WARNING: pac for %d of %d contigs is not finite\n',sum(tmpID),n);
end

% threshold for 'importance'
threshold = 0.4;
tmpID = isfinite(pac) & abs(pac)>threshold;

if show_figs==1
    if make_latex_fig==1
        subplot(2,2,3);
        stem(0:Nlag,pac(:,1));
        tmpx = [-1 Nlag]+0.5;
        hold on;
        plot(tmpx,[1 1]*threshold,'r-');
        plot(tmpx,-[1 1]*threshold,'r-');
        hold off;
        xlim(tmpx);
        xlabel('lag');
        ylabel(sprintf('partial\nautocorrelation'));
        title(sprintf('Contig %d autocorrelation',1));
        set(gca,'FontSize',fs);
    else
        figure();
        for i = 1:n
            subplot(7,7,i);
            tmpx = (1:Nlag+1)';
            tmpy = pac(:,i);
            tmpID = abs(tmpy)<threshold;
            stem(tmpx(tmpID),tmpy(tmpID));
            hold on;
            stem(tmpx(~tmpID),tmpy(~tmpID),'r');
            tmpx = [0 Nlag+1]+0.5;
            plot(tmpx,[1 1]*threshold,'b-');
            plot(tmpx,-[1 1]*threshold,'b-');
            xlim(tmpx);
            hold off;
            ylim([-1.5 1.5]);
            title(sprintf('c%d',i));
            set(gca,'XTickLabel',[],'YTickLabel',[]);
        end
        resize_figure(3,3);
        clear tmpx tmpy
    end
end




%% autoregression

xres_desc = {'original','differences','AR(1) residuals','AR(p) residuals'};

x1 = x(1:end-1,:);
x2 = x(2:end,:);

% control case - the original timeseries
xres{1} = x;

% simple take 1 - differences
xres{2} = x2-x1;

% simple take 2 - autoregression with maximum lag p=1
phi = sum((x1-mean(x1)).*(x2-mean(x2)))./sum(x1.^2-mean(x1).^2);
xres{3} = x2-phi.*x1;

% take 3 - autoregression with maximum lag determined by partial
% autocorrelation






if show_figs==1 && make_latex_fig~=1
    figure();
    for i = 1:min(n,49)
        subplot(7,7,i);
        hold on;
        for k = 1:length(xres)
            plot(xres{k}(:,i));
        end
        hold off
        box on;
        title(sprintf('c%d',i));
    end
    resize_figure(3,3);
end



%% is the problem underdetermined for simple linear regression?

Ntrain = round(Ncruise*0.7);

for k = 1:length(xres)
    
    ytrain = xres{k}(1:Ntrain,:);
    ytest = xres{k}(Ntrain+1:end,:);
    x0train = [ones(size(ytrain,1),1) ytrain];
    x0test = [ones(size(ytest,1),1) ytest];
    beta = pinv(x0train)*ytrain;
    mse_train(k) = 1/Ncruise*sum(sum((ytrain-x0train*beta).^2));
    mse_test(k) = 1/Ncruise*sum(sum((ytest-x0test*beta).^2));
    
end
clear ytrain ytest x0train x0test beta;

disp('training error:');
disp(mse_train);
disp('testing error:');
disp(mse_test);




%% regression analysis

for k = 1:length(xres)
    
     % simple pearson correlation
    [rho{k}, pval{k}] = corr(xres{k});
    
    % simple linear regression
    y = xres{k};
    x0 = [ones(size(y,1),1) xres{k}];
    beta{k} = pinv(x0)*y;

    % linear regression with L1 regularization
    for c = 1:n
        y = xres{k}(:,c);
        [tmpbeta, tmpstat] = lasso(xres{k},y);
        betalasso{k}(:,c) = [tmpstat.Intercept(1); tmpbeta(:,1)];
    end
    
end

% thresholding and significance
threshold_rho = 0.2;
threshold_pval = 0.05;
threshold_beta = 0.2;
for k = 1:length(xres)
    tmprho = rho{k};
    tmprho(abs(tmprho)<threshold_rho) = 0;
    %tmprho(pval{k}>threshold_pval) = 0;
    rho_thresh{k} = tmprho;
    tmpbeta = beta{k};
    tmpbeta(abs(tmpbeta)<threshold_beta) = 0;
    beta_thresh{k} = tmpbeta;
end
clear tmp*;

if show_figs==1
    if make_latex_fig==1
        subplot(2,2,4);
        imagesc(beta{3},[-1 +1]);
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        xlabel('contigs');
        ylabel('contigs');
        title(sprintf('Regression on residuals'));
        set(gca,'FontSize',fs);
        cbar = colorbar();
        load('redbluecmap');
        colormap(gca,flip(redbluecmap));
    else
        ncol = length(xres);
        nrow = 3;
        figure();
        for k = 1:length(xres)
            subplot(nrow,ncol,k);
            plot_correlation(rho_thresh{k},[],0);
            title(sprintf('Correlation on %s',xres_desc{k}));
        end
        for k = 1:length(xres)
            subplot(nrow,ncol,k+ncol);
            plot_correlation(beta_thresh{k},[],0);
            title(sprintf('Simple regression on %s',xres_desc{k}));
        end
        for k = 1:length(xres)
            subplot(nrow,ncol,k+2*ncol);
            plot_correlation(betalasso{k},[],0);
            title(sprintf('Regularized regression on %s',xres_desc{k}));
        end
        resize_figure(nrow,ncol);
    end
end


if make_latex_fig==1
    FIG.Units = 'inches';
    FIG.Position(3:4) = [6 4];
    print('module2_regression/figures/regression','-dpng');
end