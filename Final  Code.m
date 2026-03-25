pwd
cd 'C:\Users\Gautam\Desktop\Empirical Data 1\US Yield'
us3m  = readtable('US_3M.csv');
us2y  = readtable('US_2Y.csv');
us10y = readtable('US_10Y.csv');
us3m.Date  = datetime(us3m.Date);
us2y.Date  = datetime(us2y.Date);
us10y.Date = datetime(us10y.Date);
tt3m  = table2timetable(us3m,  'RowTimes', 'Date');
tt2y  = table2timetable(us2y,  'RowTimes', 'Date');
tt10y = table2timetable(us10y, 'RowTimes', 'Date');
US_daily = synchronize(tt3m, tt2y, tt10y, 'intersection');
US_weekly = retime(US_daily, 'weekly', 'lastvalue');

cd 'C:\Users\Gautam\Desktop\Empirical Data 1\Foreign Exchange rate'

opts = detectImportOptions('USD_INR Historical Data (1).csv');
opts = setvaropts(opts, 'Date', 'InputFormat', 'MM/dd/uuuu');
fx1 = readtable('USD_INR Historical Data (1).csv', opts);

opts2 = detectImportOptions('USD_INR Historical Data (2).csv');
opts2 = setvaropts(opts2, 'Date', 'InputFormat', 'MM/dd/uuuu');
fx2 = readtable('USD_INR Historical Data (2).csv', opts2);

fx1.Date = datetime(fx1.Date, 'InputFormat', 'MM/dd/uuuu');
fx2.Date = datetime(fx2.Date, 'InputFormat', 'MM/dd/uuuu');
fx1 = rmmissing(fx1, 'DataVariables', 'Date');

fx1 = sortrows(fx1, 'Date');
fx2 = sortrows(fx2, 'Date');
tt_fx1 = table2timetable(fx1, 'RowTimes', 'Date');
tt_fx2 = table2timetable(fx2, 'RowTimes', 'Date');
FX_daily = synchronize(tt_fx1, tt_fx2, 'union');
FX_daily.Price = FX_daily.Price_tt_fx1;
FX_daily.Price(isnan(FX_daily.Price)) = FX_daily.Price_tt_fx2(isnan(FX_daily.Price));

FX_daily.Price_tt_fx1 = [];
FX_daily.Price_tt_fx2 = [];

FX_weekly = retime(FX_daily, 'weekly', 'lastvalue');
FX_weekly.Price = fillmissing(FX_weekly.Price, 'previous');

cd 'C:\Users\Gautam\Desktop\Empirical Data 1\Nifty 50'
opts = detectImportOptions('Nifty 50 Historical Data.csv');
opts = setvartype(opts, 'Date', 'char');
nifty = readtable('Nifty 50 Historical Data.csv', opts);
nifty.Date = datetime(nifty.Date, 'InputFormat', 'dd-MM-uuuu');
nifty = sortrows(nifty, 'Date');
nifty = rmmissing(nifty, 'DataVariables', 'Date');
tt_nifty = table2timetable(nifty, 'RowTimes', 'Date');
NIFTY_weekly = retime(tt_nifty, 'weekly', 'lastvalue');
NIFTY_weekly.Price = fillmissing(NIFTY_weekly.Price, 'previous');
% Remove commas if they still exist (extra safety)
NIFTY_weekly.Price = erase(NIFTY_weekly.Price, ',');

% Convert cell array of chars to numeric
NIFTY_weekly.Price = str2double(NIFTY_weekly.Price);

cd 'C:\Users\Gautam\Desktop\Empirical Data 1\S&P 500'
opts = detectImportOptions('S&P 500 Historical Data.csv');
opts = setvartype(opts, {'Date','Price'}, 'char');
sp = readtable('S&P 500 Historical Data.csv', opts);
sp.Date = datetime(sp.Date, 'InputFormat','MM/dd/uuuu');
sp.Price = erase(sp.Price, ',');        % remove any commas
sp.Price = str2double(sp.Price);        % convert to numeric
sp = sortrows(sp,'Date');
sp = rmmissing(sp,'DataVariables','Date');
tt_sp = table2timetable(sp,'RowTimes','Date');
SP_weekly = retime(tt_sp,'weekly','lastvalue');
SP_weekly.Price = fillmissing(SP_weekly.Price,'previous');

cd 'C:\Users\Gautam\Desktop\Empirical Data 1\Indian Yield'

%% INDIA 3M YIELD
opts = detectImportOptions('India 3M.csv');
opts = setvartype(opts, {'Date','Price'}, 'char');   % import both as text
ind3 = readtable('India 3M.csv', opts);

% Convert Date (dd-MM-yyyy)
ind3.Date = datetime(ind3.Date, 'InputFormat', 'dd-MM-uuuu');

% Convert Price to numeric
ind3.Price = str2double(ind3.Price);

% Sort by date
ind3 = sortrows(ind3, 'Date');

% Remove missing rows
ind3 = rmmissing(ind3, 'DataVariables', 'Date');

% Convert to timetable
tt_ind3 = table2timetable(ind3, 'RowTimes', 'Date');

% Convert to weekly data
IND3M_weekly = retime(tt_ind3, 'weekly', 'lastvalue');

% Fix missing weekly values
IND3M_weekly.Price = fillmissing(IND3M_weekly.Price,'previous');


%% INDIA 2Y YIELD
opts = detectImportOptions('India 2Y.csv');
opts = setvartype(opts, {'Date','Price'}, 'char');
ind2 = readtable('India 2Y.csv', opts);

ind2.Date = datetime(ind2.Date, 'InputFormat', 'dd-MM-uuuu');
ind2.Price = str2double(ind2.Price);

ind2 = sortrows(ind2,'Date');
ind2 = rmmissing(ind2,'DataVariables','Date');

tt_ind2 = table2timetable(ind2,'RowTimes','Date');
IND2Y_weekly = retime(tt_ind2,'weekly','lastvalue');

IND2Y_weekly.Price = fillmissing(IND2Y_weekly.Price,'previous');

%% INDIA 10Y YIELD
opts = detectImportOptions('India 10Y.csv');
opts = setvartype(opts, {'Date','Price'}, 'char');
ind10 = readtable('India 10Y.csv', opts);

ind10.Date = datetime(ind10.Date, 'InputFormat', 'dd-MM-uuuu');
ind10.Price = str2double(ind10.Price);

ind10 = sortrows(ind10,'Date');
ind10 = rmmissing(ind10,'DataVariables','Date');

tt_ind10 = table2timetable(ind10,'RowTimes','Date');
IND10Y_weekly = retime(tt_ind10,'weekly','lastvalue');

IND10Y_weekly.Price = fillmissing(IND10Y_weekly.Price,'previous');

US_weekly.Properties.VariableNames = {'US3M','US2Y','US10Y'};
IND3M_weekly.Properties.VariableNames = {'IND3M'};
IND2Y_weekly.Properties.VariableNames = {'IND2Y'};
IND10Y_weekly.Properties.VariableNames = {'IND10Y'};
FX_weekly.Properties.VariableNames = {'FX'};
NIFTY_weekly.Properties.VariableNames = {'NIFTY'};
SP_weekly.Properties.VariableNames = {'SPX'};

AllData = synchronize(US_weekly, IND3M_weekly, IND2Y_weekly, IND10Y_weekly, ...
                      FX_weekly, NIFTY_weekly, SP_weekly, 'intersection');

AllData.US3M_chg  = [NaN; diff(AllData.US3M)];
AllData.US2Y_chg  = [NaN; diff(AllData.US2Y)];
AllData.US10Y_chg = [NaN; diff(AllData.US10Y)];

AllData.IND3M_chg  = [NaN; diff(AllData.IND3M)];
AllData.IND2Y_chg  = [NaN; diff(AllData.IND2Y)];
AllData.IND10Y_chg = [NaN; diff(AllData.IND10Y)];
AllData.FX_ret = [NaN; diff(log(AllData.FX))];
AllData.NIFTY_ret = [NaN; diff(log(AllData.NIFTY))];
AllData.SPX_ret = [NaN; diff(log(AllData.SPX))];

AllData.US_spread_10Y_3M = AllData.US10Y - AllData.US3M;
AllData.US_spread_10Y_2Y = AllData.US10Y - AllData.US2Y;
AllData.US_spread_2Y_3M  = AllData.US2Y  - AllData.US3M;

AllData.IND_spread_10Y_3M = AllData.IND10Y - AllData.IND3M;
AllData.IND_spread_10Y_2Y = AllData.IND10Y - AllData.IND2Y;
AllData.IND_spread_2Y_3M  = AllData.IND2Y  - AllData.IND3M;

function [trend, gap] = hp_trend(y, lambda)
% HP trend for a column vector y using lambda smoothing

y = y(:);                      % ensure column
T = length(y);
I = speye(T);

% Second-difference matrix D (size (T-2) x T)
e = ones(T-2,1);
D = spdiags([e -2*e e], 0:2, T-2, T);

% Solve (I + lambda * D'D) * trend = y
A = I + lambda * (D' * D);
trend = A \ y;

% Gap (cycle)
gap = y - trend;
end


lambda = 1600;

% -------- US Yields --------
[AllData.US3M_trend, AllData.US3M_gap]   = hp_trend(AllData.US3M,  lambda);
[AllData.US2Y_trend, AllData.US2Y_gap]   = hp_trend(AllData.US2Y,  lambda);
[AllData.US10Y_trend, AllData.US10Y_gap] = hp_trend(AllData.US10Y, lambda);

% -------- India Yields --------
[AllData.IND3M_trend, AllData.IND3M_gap]   = hp_trend(AllData.IND3M,  lambda);
[AllData.IND2Y_trend, AllData.IND2Y_gap]   = hp_trend(AllData.IND2Y,  lambda);
[AllData.IND10Y_trend, AllData.IND10Y_gap] = hp_trend(AllData.IND10Y, lambda);

% Construct India VAR vector yt = [rS, rM, rL, fx, eq]'
Y_IND = [AllData.IND3M_chg, ...   % short-rate change
         AllData.IND2Y_chg, ...   % medium-rate change
         AllData.IND10Y_chg, ...  % long-rate change
         AllData.FX_ret, ...      % FX log return
         AllData.NIFTY_ret];      % equity log return

% Remove any initial rows with NaN (from first differences)
Y_IND = rmmissing(Y_IND);

% Construct US VAR vector yt = [rS, rM, rL, fx, eq]'
Y_US = [AllData.US3M_chg, ...    % short-rate change
        AllData.US2Y_chg, ...    % medium-rate change
        AllData.US10Y_chg, ...   % long-rate change
        AllData.FX_ret, ...      % FX log return
        AllData.SPX_ret];        % equity log return

% Remove any initial rows with NaN
Y_US = rmmissing(Y_US);

%% STEP 3: Mean reversion & volatility for Indian yields

yieldVars_IND = {'IND3M','IND2Y','IND10Y'};

for i = 1:length(yieldVars_IND)

    y = AllData.(yieldVars_IND{i});   % yield level series, weekly

    % ---- AR(1) mean reversion model ----
    % r_t = mu + kappa (r_{t-1} - mu) + eps_t
    Mdl_AR = arima(1,0,0);            % AR(1) with constant
    Est_AR = estimate(Mdl_AR, y, 'Display','off');

    % Extract residuals eps_t (innovations)
    eps = infer(Est_AR, y);

    % ---- GARCH(1,1) volatility model ----
    % eps_t = sigma_t * z_t,  sigma_t^2 = omega + alpha eps_{t-1}^2 + beta sigma_{t-1}^2
    Mdl_GARCH = garch(1,1);
    Est_GARCH = estimate(Mdl_GARCH, eps, 'Display','off');

    % Conditional variance sigma_t^2 (volatility)
    [condVar, ~] = infer(Est_GARCH, eps);

    % Store volatility in AllData
    volName = sprintf('%s_vol', yieldVars_IND{i});
    AllData.(volName) = condVar;
end




yieldVars = {'US3M','US2Y','US10Y','IND3M','IND2Y','IND10Y'};

for i = 1:length(yieldVars)

    y = AllData.(yieldVars{i});

    % --- AR(1) estimation ---
    Mdl_AR = arima(1,0,0);
    Est_AR = estimate(Mdl_AR, y, 'Display','off');

    % Residuals ε_t
    res = infer(Est_AR, y);

    % --- GARCH(1,1) estimation ---
    Mdl_GARCH = garch(1,1);
    Est_GARCH = estimate(Mdl_GARCH, res, 'Display','off');

    % Conditional volatility σ²_t
    [v,~] = infer(Est_GARCH, res);

    volName = sprintf('%s_vol', yieldVars{i});
    AllData.(volName) = v;

end
set(0,'DefaultFigureVisible','on');  % Force external figure windows
% Open a new figure window (separate from Live Editor output)
figure('Color','w','Position',[100 100 900 400]);

plot(AllData.Date, AllData.IND3M_vol,  'LineWidth', 1.5); hold on;
plot(AllData.Date, AllData.IND2Y_vol,  'LineWidth', 1.5);
plot(AllData.Date, AllData.IND10Y_vol, 'LineWidth', 1.5);
hold off;

title('Conditional Volatility from GARCH(1,1)', 'FontSize', 14);
xlabel('Date',   'FontSize', 12);
ylabel('Variance','FontSize', 12);

legend({'IND3M','IND2Y','IND10Y'}, ...
       'Location','best', ...
       'Box','off', ...
       'FontSize',10);

grid on;
box on;
set(gca,'FontSize',11,'LineWidth',1);

% If AllData.Date is numeric serial dates, uncomment this:
% datetick('x','yyyy','keeplimits');

%  Save as 
exportgraphics(gcf,'GARCH_volatility.png','Resolution',300);



figure;

plot(AllData.Date, AllData.US3M_vol, 'LineWidth', 1.2); hold on;
plot(AllData.Date, AllData.US2Y_vol, 'LineWidth', 1.2);
plot(AllData.Date, AllData.US10Y_vol, 'LineWidth', 1.2);

hold off;

legend('US 3M','US 2Y','US 10Y', 'Location', 'best');
title('US Yield Conditional Volatility from GARCH(1,1)');
xlabel('Date');
ylabel('Variance');

figure('Color','w','Position',[200 100 900 500]);
tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

%% ======================
%       INDIA PANEL
%% ======================
nexttile;
plot(Y_IND, 'LineWidth', 1.2);
title('India VAR Variables (Changes / Returns)','FontSize',13);
xlabel('Time');
ylabel('Value');

legend({'IND3M\_chg','IND2Y\_chg','IND10Y\_chg','FX\_ret','NIFTY\_ret'}, ...
       'Location','bestoutside','FontSize',9);

grid on;
box on;
set(gca,'FontSize',11);

%% ======================
%         US PANEL
%% ======================
nexttile;
plot(Y_US, 'LineWidth', 1.2);
title('US VAR Variables (Changes / Returns)','FontSize',13);
xlabel('Time');
ylabel('Value');

legend({'US3M\_chg','US2Y\_chg','US10Y\_chg','FX\_ret','SPX\_ret'}, ...
       'Location','bestoutside','FontSize',9);

grid on;
box on;
set(gca,'FontSize',11);


%% STEP 4.2: Lag length selection by BIC

maxLags = 8;
bic_IND = nan(maxLags,1);
bic_US  = nan(maxLags,1);

T_IND = size(Y_IND,1);
T_US  = size(Y_US,1);

for p = 1:maxLags
    % ----- India VAR(5, p) -----
    try
        model_IND = varm(5, p);
        [~,~,logL_IND] = estimate(model_IND, Y_IND, 'Display','off');
        k_IND = (5^2)*p;   % approx number of parameters
        bic_IND(p) = -2*logL_IND + k_IND*log(T_IND);
    catch
        bic_IND(p) = NaN;
    end

    % ----- US VAR(5, p) -----
    try
        model_US = varm(5, p);
        [~,~,logL_US] = estimate(model_US, Y_US, 'Display','off');
        k_US = (5^2)*p;
        bic_US(p) = -2*logL_US + k_US*log(T_US);
    catch
        bic_US(p) = NaN;
    end
end

% Optimal lags
[~, p_opt_IND] = min(bic_IND);
[~, p_opt_US]  = min(bic_US);

fprintf('Optimal lag length (BIC): India = %d, US = %d\n', p_opt_IND, p_opt_US);

figure;
plot(1:maxLags, bic_IND, '-o', 'LineWidth', 1.2); hold on;
plot(1:maxLags, bic_US,  '-s', 'LineWidth', 1.2);
xlabel('Number of lags p');
ylabel('BIC');
legend('India VAR','US VAR', 'Location','best');
title('Lag length selection by BIC');
grid on;
hold off;

%% STEP 4.3: Estimate VAR and compute residuals and Sigma_u

% ---------------------- INDIA VAR ----------------------
VAR_IND = varm(5, p_opt_IND);

% Estimate VAR coefficients
[EstModel_IND, EstSE_IND, logL_IND] = estimate(VAR_IND, Y_IND, 'Display','off');

% Compute reduced-form residuals u_t
u_IND = infer(EstModel_IND, Y_IND);     % T x 5 matrix

% Covariance matrix Σu for India
Sigma_u_IND = cov(u_IND);


% ---------------------- US VAR -------------------------
VAR_US = varm(5, p_opt_US);

[EstModel_US, EstSE_US, logL_US] = estimate(VAR_US, Y_US, 'Display','off');

u_US = infer(EstModel_US, Y_US);        % T x 5 matrix

Sigma_u_US = cov(u_US);


figure;
tiledlayout(3,2);
names_IND = {'ΔIND3M','ΔIND2Y','ΔIND10Y','FX\_ret','NIFTY\_ret'};

for i = 1:5
    nexttile;
    plot(u_IND(:,i));
    title(['India residual: ', names_IND{i}]);
end

%% Step 5 Start 

%% ============================================================
% STEP 5: Structural Identification (Non-Cholesky, Sign Restrictions Only)
%% ============================================================

nVars    = 5;           % number of variables: [short, medium, long, FX, equity]
nKeep    = 500;         % how many accepted matrices we want
maxDraws = 200000;      % total attempts (increase for more accepted draws)
signTol  = -0.02;       % allow small negative spillovers

% Storage for India and US accepted impact matrices
B0_IND_all = zeros(nVars, nVars, nKeep);
B0_US_all  = zeros(nVars, nVars, nKeep);

nAccept_IND = 0;
nAccept_US  = 0;

%% ============================================================
% 5.1 Symmetric square root of Sigma_u (NO Cholesky)
%% ============================================================

% India
[V_IND, D_IND] = eig(Sigma_u_IND);
D_IND(D_IND < 0) = 0;                       % numerical fix
P_IND = V_IND * sqrt(D_IND) * V_IND';        % P_IND * P_IND' = Sigma_u_IND

% US
[V_US, D_US] = eig(Sigma_u_US);
D_US(D_US < 0) = 0;
P_US = V_US * sqrt(D_US) * V_US';            % P_US * P_US' = Sigma_u_US

%% ============================================================
% 5.2 Sign Restrictions Function (IMPACT matrix B0)
%% ============================================================

% Variable ordering:
% 1 = short rate
% 2 = medium rate
% 3 = long rate
% 4 = FX return
% 5 = equity return

checkSigns = @(B0) ( ...
    B0(1,1) > 0   && B0(2,1) > signTol && B0(3,1) > signTol && ...   % short-rate shock
    B0(2,2) > 0   && B0(3,2) > signTol && ...                        % medium-rate shock
    B0(3,3) > 0                                                     ... % long-rate shock
);

%% ============================================================
% 5.3 Random Q rotations + Acceptance
%% ============================================================

drawCount = 0;

while (nAccept_IND < nKeep || nAccept_US < nKeep) && drawCount < maxDraws
    drawCount = drawCount + 1;

    % -------- generate random orthonormal matrix Q ---------
    [Q_raw, ~] = qr(randn(nVars));
    if det(Q_raw) < 0
        Q_raw(:,1) = -Q_raw(:,1);   % enforce det = +1 (proper rotation)
    end
    Q = Q_raw;

    % =======================================================
    % INDIA
    % =======================================================
    if nAccept_IND < nKeep
        B0_IND = P_IND * Q;   % structural impact matrix

        if checkSigns(B0_IND)
            nAccept_IND = nAccept_IND + 1;
            B0_IND_all(:,:,nAccept_IND) = B0_IND;
        end
    end

    % =======================================================
    % US
    % =======================================================
    if nAccept_US < nKeep
        B0_US = P_US * Q;

        if checkSigns(B0_US)
            nAccept_US = nAccept_US + 1;
            B0_US_all(:,:,nAccept_US) = B0_US;
        end
    end
end

fprintf('Accepted India draws: %d  |  Accepted US draws: %d  (out of %d attempts)\n', ...
        nAccept_IND, nAccept_US, drawCount);
%% Step 6


%% ============================================================
% STEP 6: Recover Structural Shocks  (eps_t = A0 * u_t)
%% ============================================================

% Number of accepted draws
nDraws_IND = nAccept_IND;
nDraws_US  = nAccept_US;

% Number of time periods in VAR residuals
T_IND = size(u_IND, 1);
T_US  = size(u_US, 1);

% Allocate storage (T x 5 x nDraws)
eps_IND_all = zeros(T_IND, 5, nDraws_IND);
eps_US_all  = zeros(T_US,  5, nDraws_US);

%% ============================
% INDIA: Structural Shocks
%% ============================
for k = 1:nDraws_IND
    
    B0 = B0_IND_all(:,:,k);   % 5 × 5 impact matrix
    A0 = inv(B0);             % Contemporaneous matrix A0 = B0^{-1}

    % eps_t = A0 * u_t   → output is T × 5
    eps_IND_all(:,:,k) = (A0 * u_IND')';

end

%% ============================
% US: Structural Shocks
%% ============================
for k = 1:nDraws_US
    
    B0 = B0_US_all(:,:,k);
    A0 = inv(B0);

    eps_US_all(:,:,k) = (A0 * u_US')';

end

disp('Structural shocks computed successfully for all accepted draws.');

%% ============================================================
% SAFE PLOTTING (Fixes the size mismatch error)
%% ============================================================

% Structural shocks have length T_IND = 566 (in your case)
T_shock = size(eps_IND_all, 1);

% Match correct dates to shocks
dates_shock = AllData.Date(end - T_shock + 1 : end);

figure;
plot(dates_shock, eps_IND_all(:,1,1), 'LineWidth', 1.2);
title('India Short-Rate Structural Shock (Draw 1)');
xlabel('Date'); ylabel('\epsilon^{short}_t');
grid on;


shockNames = ["Short", "Medium", "Long", "FX", "Equity"];

figure;
for i = 1:5
    subplot(5,1,i);
    plot(dates_shock, eps_IND_all(:,i,1), 'LineWidth', 1.2);
    title("India " + shockNames(i) + " Structural Shock (Draw 1)");
    ylabel("\epsilon_t");
    grid on;
end
sgtitle('India Structural Shocks (Draw 1)');

%% ============================
% Dates for plotting US shocks
%% ============================

T_shock_US = size(eps_US_all, 1);
dates_shock_US = AllData.Date(end - T_shock_US + 1 : end);


figure;
for i = 1:5
    subplot(5,1,i);
    plot(dates_shock_US, eps_US_all(:,i,1), 'LineWidth', 1.2);
    title("US " + shockNames(i) + " Structural Shock (Draw 1)");
    ylabel("\epsilon_t");
    grid on;
end
sgtitle('US Structural Shocks (Draw 1)');

%% Step 7

%% ============================================================
% STEP 7: IRF Computation
%% ============================================================

H = 20;  % IRF Horizon
n = 5;   % number of variables

%% -------- India Lag Matrix A_IND --------
p = p_opt_IND;
A_IND = zeros(n*p, n);  % 15 x 5 (for p=3)

for i = 1:p
    A_IND((i-1)*n+1:i*n, :) = EstModel_IND.AR{i};
end

%% -------- US Lag Matrix A_US --------
p = p_opt_US;
A_US = zeros(n*p, n);   % 15 x 5

for i = 1:p
    A_US((i-1)*n+1:i*n, :) = EstModel_US.AR{i};
end

%% India Companion Matrix
n = 5;
p = p_opt_IND;

Phi_IND = zeros(n*p);

% Fill top block row with AR matrices
Phi_IND(1:n, 1:n*p) = [EstModel_IND.AR{1}, EstModel_IND.AR{2}, EstModel_IND.AR{3}];

% Fill subdiagonal identity matrices
Phi_IND(n+1:n*p, 1:n*(p-1)) = eye(n*(p-1));

%% US Companion Matrix
p = p_opt_US;

Phi_US = zeros(n*p);

Phi_US(1:n, 1:n*p) = [EstModel_US.AR{1}, EstModel_US.AR{2}, EstModel_US.AR{3}];
Phi_US(n+1:n*p, 1:n*(p-1)) = eye(n*(p-1));

IRF_IND = zeros(n, n, H+1, nAccept_IND);   % India IRFs
IRF_US  = zeros(n, n, H+1, nAccept_US);    % US IRFs

%% =============================
% IRFs for India
%% =============================

for k = 1:nAccept_IND
    
    B0 = B0_IND_all(:,:,k);     % Impact matrix for draw k
    
    % Horizon 0 IRF
    IRF_IND(:,:,1,k) = B0;
    
    % Phi^0
    PhiPow = eye(size(Phi_IND));
    
    % Horizon 1..H
    for h = 1:H
        
        PhiPow = PhiPow * Phi_IND;        % Phi^h
        IRF_IND(:,:,h+1,k) = PhiPow(1:n, 1:n) * B0;
        
    end
end

%% =============================
% IRFs for US
%% =============================

for k = 1:nAccept_US
    
    B0 = B0_US_all(:,:,k);
    
    IRF_US(:,:,1,k) = B0;
    
    PhiPow = eye(size(Phi_US));
    
    for h = 1:H
        PhiPow = PhiPow * Phi_US;
        IRF_US(:,:,h+1,k) = PhiPow(1:n, 1:n) * B0;
    end
end

%% India IRFs summary
IRF_IND_med  = median(IRF_IND, 4);
IRF_IND_low  = prctile(IRF_IND, 16, 4);
IRF_IND_high = prctile(IRF_IND, 84, 4);

%% US IRFs summary
IRF_US_med   = median(IRF_US, 4);
IRF_US_low   = prctile(IRF_US, 16, 4);
IRF_US_high  = prctile(IRF_US, 84, 4);

disp('IRF computation completed successfully.');


shock = 1;  % short-rate shock
t = 0:H;

figure;
for v = 1:n
    subplot(3,2,v);
    
    plot(t, squeeze(IRF_IND_med(v,shock,:)), 'b', 'LineWidth', 2); hold on;
    plot(t, squeeze(IRF_IND_low(v,shock,:)), '--r');
    plot(t, squeeze(IRF_IND_high(v,shock,:)), '--r');
    
    title(['Response of Variable ' num2str(v) ' to Short-Rate Shock']);
    xlabel('Horizon'); grid on;
end

sgtitle('India IRFs to Short-Rate Shock (Median + 16–84% Bands)');


%% Step 8


%% ============================================================
% STEP 8: Forecast Error Variance Decomposition (FEVD)
%% ============================================================

% IRF dimensions:
% IRF_IND: [nVariables x nShocks x (H+1) x nAccept_IND]
[n, ~, H1, K_IND] = size(IRF_IND);   % H1 = H+1
[~, ~, ~, K_US ]  = size(IRF_US);

% Preallocate FEVD arrays (same size as IRFs)
VD_IND = zeros(size(IRF_IND));   % India: n x n x H1 x K_IND
VD_US  = zeros(size(IRF_US));    % US:    n x n x H1 x K_US


%% =============================
% FEVD for India
%% =============================

IRF2_IND = IRF_IND.^2;   % square of IRFs

for k = 1:K_IND
    
    % cumulative sum over horizons: sum_{s=0}^h IRF^2
    num = cumsum(IRF2_IND(:,:,:,k), 3);   % n x n x H1
    
    % denominator: sum over shocks for each variable and horizon
    % den(i,1,h) = sum_j num(i,j,h)
    den = sum(num, 2);                    % n x 1 x H1
    
    % Broadcast division: VD(i,j,h) = num(i,j,h) / den(i,1,h)
    VD_IND(:,:,:,k) = num ./ den;
end


%% =============================
% FEVD for US
%% =============================

IRF2_US = IRF_US.^2;

for k = 1:K_US
    
    num = cumsum(IRF2_US(:,:,:,k), 3);   % n x n x H1
    den = sum(num, 2);                   % n x 1 x H1
    
    VD_US(:,:,:,k) = num ./ den;
end


%% =============================
% Median and Percentile Bands
%% =============================

VD_IND_med  = median(VD_IND, 4);          % median over draws
VD_IND_low  = prctile(VD_IND, 16, 4);     % 16th percentile
VD_IND_high = prctile(VD_IND, 84, 4);     % 84th percentile

VD_US_med   = median(VD_US, 4);
VD_US_low   = prctile(VD_US, 16, 4);
VD_US_high  = prctile(VD_US, 84, 4);

disp('FEVD computation completed.');


% Variable index for long-term yield (rL)
varIdx = 3;
t = 0:(H1-1);   % horizons 0..H

figure;
hold on;
for j = 1:n
    plot(t, squeeze(VD_IND_med(varIdx, j, :)), 'LineWidth', 2);
end
hold off;
xlabel('Horizon (weeks)');
ylabel('Variance Share');
title('India: FEVD of Long-Term Yield');
legend({'Short shock','Medium shock','Long shock','FX shock','Equity shock'}, ...
        'Location','best');
grid on;

shock = 1;      % short-rate shock
vars  = [4 5];  % 4 = FX, 5 = equity
t = 0:H;

figure;
for idx = 1:length(vars)
    v = vars(idx);
    subplot(2,1,idx);
    plot(t, squeeze(IRF_IND_med(v,shock,:)), 'b', 'LineWidth', 2); hold on;
    plot(t, squeeze(IRF_IND_low(v,shock,:)), '--r');
    plot(t, squeeze(IRF_IND_high(v,shock,:)), '--r');
    grid on;
    xlabel('Horizon');
    if v == 4
        title('India: FX Response to Short-Rate Shock');
    else
        title('India: Equity Response to Short-Rate Shock');
    end
end
sgtitle('India: Asset-Market Responses to Short-Rate Shock');

%% Step 9

%% ============================================================
% STEP 9 (MINI): Bootstrap IRFs for INDIA only (no helper function)
%% ============================================================

B_boot = 50;           % small number just to test (you can later increase to 200)
H1 = H + 1;
[nT_IND, n] = size(Y_IND);
p = p_opt_IND;

IRF_BOOT_IND = zeros(n,n,H1,B_boot);
success_IND  = false(B_boot,1);

A_IND_AR   = EstModel_IND.AR;           % AR{1}, AR{2}, AR{3}
const_IND  = EstModel_IND.Constant(:)'; % force 1×5 row


for b = 1:B_boot
    fprintf('India: Bootstrap %d / %d\n', b, B_boot);

    % 1. Resample residuals with replacement
    T = size(u_IND,1);
    idx = randi(T, T, 1);
    u_star = u_IND(idx,:);      % T×5

    % 2. Initial conditions: use first p actual observations
    Y_star = zeros(T, n);
    Y_star(1:p,:) = Y_IND(1:p,:);

    % 3. MANUAL VAR SIMULATION (no function)
    for t = p+1:T
        Yt = const_IND;           % 1×5

        for lag = 1:p
            % Y_star(t-lag,:) is 1×5, A_IND_AR{lag} is 5×5
            Yt = Yt + Y_star(t-lag,:) * A_IND_AR{lag};
        end

        % Add bootstrap innovation (1×5)
        Y_star(t,:) = Yt + u_star(t,:);
    end

    % 4. Re-estimate VAR on bootstrap sample
    VAR_boot = varm(n,p);
    [EstModel_boot,~,~] = estimate(VAR_boot, Y_star, 'Display','off');
    u_boot = infer(EstModel_boot, Y_star);
    Sigma_boot = cov(u_boot);

    % 5. Identification with sign restrictions (one B0 per bootstrap)
    [Vb,Db] = eig(Sigma_boot);
    Db(Db<0) = 0;
    P_b = Vb * sqrt(Db) * Vb';

    maxRot = 5000;
    found  = false;
    signTol = -0.02;

    for r = 1:maxRot
        [Q_raw,~] = qr(randn(n));
        if det(Q_raw) < 0, Q_raw(:,1) = -Q_raw(:,1); end

        B0 = P_b * Q_raw;

        % sign restrictions:
        if (B0(1,1) > 0 && B0(2,1) > signTol && B0(3,1) > signTol && ...
            B0(2,2) > 0 && B0(3,2) > signTol && B0(3,3) > 0)
            found = true;
            break;
        end
    end

    if ~found
        fprintf('  India bootstrap %d failed restrictions, skipping.\n', b);
        continue;
    end

    success_IND(b) = true;

    % 6. Build companion matrix for this bootstrap VAR
    A1b = EstModel_boot.AR{1};
    A2b = EstModel_boot.AR{2};
    A3b = EstModel_boot.AR{3};

    Phi_b = zeros(n*p);
    Phi_b(1:n,1:n*p) = [A1b A2b A3b];
    Phi_b(n+1:n*p, 1:n*(p-1)) = eye(n*(p-1));

    % 7. IRFs for this bootstrap draw
    IRF_b = zeros(n,n,H1);
    IRF_b(:,:,1) = B0;

    PhiPow = eye(size(Phi_b));
    for h = 1:H
        PhiPow = PhiPow * Phi_b;
        IRF_b(:,:,h+1) = PhiPow(1:n,1:n) * B0;
    end


    IRF_BOOT_IND(:,:,:,b) = IRF_b;
end

% Keep only successful bootstraps
valid_IND = find(success_IND);
IRF_BOOT_IND = IRF_BOOT_IND(:,:,:,valid_IND);
fprintf('India: %d valid bootstrap replications out of %d.\n', numel(valid_IND), B_boot);

% Bootstrap bands for India IRFs
IRF_boot_low_IND  = prctile(IRF_BOOT_IND, 16, 4);
IRF_boot_high_IND = prctile(IRF_BOOT_IND, 84, 4);


shock = 1;  % short-rate shock
t = 0:H;

figure;
for v = 1:n
    subplot(3,2,v);
    plot(t, squeeze(IRF_IND_med(v,shock,:)), 'b', 'LineWidth', 2); hold on;
    plot(t, squeeze(IRF_boot_low_IND(v,shock,:)), '--k');
    plot(t, squeeze(IRF_boot_high_IND(v,shock,:)), '--k');
    grid on;
    xlabel('Horizon');
    title(['India: Var ' num2str(v) ' response to short-rate shock']);
end
sgtitle('India: IRFs to short-rate shock with bootstrap bands (16–84%)');


%% ============================================================
% STEP 9 (MINI): Bootstrap IRFs for US only (no helper function)
%% ============================================================

B_boot_US = 50;       % small number to test (later increase to 200)
[nT_US, n] = size(Y_US);
p_US = p_opt_US;
H1 = H + 1;

IRF_BOOT_US = zeros(n,n,H1,B_boot_US);
success_US  = false(B_boot_US,1);

A_US_AR  = EstModel_US.AR;           % AR{1},AR{2},AR{3}
const_US = EstModel_US.Constant(:)'; % force row 1×5


for b = 1:B_boot_US
    fprintf('US Bootstrap %d / %d\n', b, B_boot_US);

    % 1. Resample residuals with replacement
    T = size(u_US,1);
    idx = randi(T, T, 1);
    u_star = u_US(idx,:);            % T × 5

    % 2. Initial conditions (first p real obs)
    Y_star = zeros(T,n);
    Y_star(1:p_US,:) = Y_US(1:p_US,:);

    % 3. MANUAL VAR SIMULATION
    for t = p_US+1:T
        Yt = const_US;               % 1×5

        for lag = 1:p_US
            Yt = Yt + Y_star(t-lag,:) * A_US_AR{lag};   % AR recursion
        end

        Y_star(t,:) = Yt + u_star(t,:);  % add bootstrap shock
    end

    % 4. Re-estimate VAR on simulated data
    VAR_boot = varm(n,p_US);
    [EstModel_boot,~,~] = estimate(VAR_boot, Y_star, 'Display','off');
    u_boot = infer(EstModel_boot, Y_star);
    Sigma_boot = cov(u_boot);

    % 5. Identification with US sign restrictions
    [Vb,Db] = eig(Sigma_boot);
    Db(Db < 0) = 0;
    P_b = Vb * sqrt(Db) * Vb';

    maxRot = 5000; 
    found = false;
    signTol = -0.02;

    for r = 1:maxRot
        [Q_raw,~] = qr(randn(n));
        if det(Q_raw) < 0, Q_raw(:,1) = -Q_raw(:,1); end

        B0 = P_b * Q_raw;

        % Same sign restrictions as India:
        if (B0(1,1) > 0 && B0(2,1) > signTol && B0(3,1) > signTol && ...
            B0(2,2) > 0 && B0(3,2) > signTol && B0(3,3) > 0)
            found = true;
            break;
        end
    end

    if ~found
        fprintf('  US bootstrap %d failed restrictions, skipping.\n', b);
        continue;
    end

    success_US(b) = true;

    % 6. Build companion matrix for US bootstrap VAR
    A1b = EstModel_boot.AR{1};
    A2b = EstModel_boot.AR{2};
    A3b = EstModel_boot.AR{3};

    Phi_b = zeros(n*p_US);
    Phi_b(1:n,1:n*p_US) = [A1b A2b A3b];
    Phi_b(n+1:n*p_US,1:n*(p_US-1)) = eye(n*(p_US-1));

    % 7. Compute IRFs
    IRF_b = zeros(n,n,H1);
    IRF_b(:,:,1) = B0;

    PhiPow = eye(size(Phi_b));
    for h = 1:H
        PhiPow = PhiPow * Phi_b;
        IRF_b(:,:,h+1) = PhiPow(1:n,1:n) * B0;
    end

    IRF_BOOT_US(:,:,:,b) = IRF_b;
end

% Keep only valid bootstrap replications
valid_US = find(success_US);
IRF_BOOT_US = IRF_BOOT_US(:,:,:,valid_US);
fprintf('US: %d valid bootstrap replications out of %d.\n', numel(valid_US), B_boot_US);

% Percentile bootstrap confidence bands
IRF_boot_low_US  = prctile(IRF_BOOT_US, 16, 4);
IRF_boot_high_US = prctile(IRF_BOOT_US, 84, 4);
%% Step 10

% 10.1 Impulse response function India
t = 0:H;
n = 5;

varNames = {'Short Rate','Medium Rate','Long Rate','FX Return','Equity Return'};
shockNames = {'Short Shock','Medium Shock','Long Shock','FX Shock','Equity Shock'};

for shock = 1:n
    figure;
    for v = 1:n
        subplot(3,2,v);
        plot(t, squeeze(IRF_IND_med(v,shock,:)), 'b', 'LineWidth', 2); hold on;
        plot(t, squeeze(IRF_boot_low_IND(v,shock,:)), '--k');
        plot(t, squeeze(IRF_boot_high_IND(v,shock,:)), '--k');
        grid on;
        title([varNames{v} ' Response to ' shockNames{shock}]);
        xlabel('Weeks'); ylabel('Response');
    end
    sgtitle(['India IRFs to ' shockNames{shock}]);

    saveas(gcf, ['IRF_IND_' shockNames{shock} '.png']);
end

% 10.2 Impulse Response Function US

for shock = 1:n
    figure;
    for v = 1:n
        subplot(3,2,v);
        plot(t, squeeze(IRF_US_med(v,shock,:)), 'r', 'LineWidth', 2); hold on;
        plot(t, squeeze(IRF_boot_low_US(v,shock,:)), '--k');
        plot(t, squeeze(IRF_boot_high_US(v,shock,:)), '--k');
        grid on;
        title([varNames{v} ' Response to ' shockNames{shock} ' (US)']);
        xlabel('Weeks'); ylabel('Response');
    end
    sgtitle(['US IRFs to ' shockNames{shock}]);

    saveas(gcf, ['IRF_US_' shockNames{shock} '.png']);
end

% 10.3 FEVD Plots (India US)

% Horizons
t = 0:(size(VD_IND_med,3)-1);
n = 5;

varNames   = {'Short Rate','Medium Rate','Long Rate','FX Return','Equity Return'};
shockNames = {'Short Shock','Medium Shock','Long Shock','FX Shock','Equity Shock'};

%% -------- FEVD: India --------
for v = 1:n
    figure;
    
    % VD_IND_med: [var × shock × horizon]
    % squeeze → [shock × horizon], transpose → [horizon × shock] for plot
    plot(t, squeeze(VD_IND_med(v,:,:))', 'LineWidth', 2);
    
    legend(shockNames, 'Location','best');
    title(['India FEVD: ' varNames{v}]);
    xlabel('Horizon (weeks)');
    ylabel('Share of variance');
    grid on;
    
    % Safe filename (remove spaces)
    safeVarName = strrep(varNames{v}, ' ', '_');
    saveas(gcf, ['FEVD_IND_' safeVarName '.png']);
end

%% -------- FEVD: US --------
for v = 1:n
    figure;
    
    plot(t, squeeze(VD_US_med(v,:,:))', 'LineWidth', 2);
    
    legend(shockNames, 'Location','best');
    title(['US FEVD: ' varNames{v}]);
    xlabel('Horizon (weeks)');
    ylabel('Share of variance');
    grid on;

    safeVarName = strrep(varNames{v}, ' ', '_');
    saveas(gcf, ['FEVD_US_' safeVarName '.png']);
end


% 10.4 Structural Shock Distribution Histograms

% Pick one accepted draw (e.g., k=1)
k = 1;

figure;
for i = 1:n
    subplot(3,2,i)
    histogram(eps_IND_all(:,i,k),40,'Normalization','pdf');
    title(['India Structural Shock PDF: ' shockNames{i}]);
    grid on;
end
saveas(gcf,'India_Shock_Distributions.png');

figure;
for i = 1:n
    subplot(3,2,i)
    histogram(eps_US_all(:,i,k),40,'Normalization','pdf');
    title(['US Structural Shock PDF: ' shockNames{i}]);
    grid on;
end
saveas(gcf,'US_Shock_Distributions.png');

% 10.5 Yield level 
figure;
plot(AllData.Date, AllData.IND3M, 'LineWidth', 1.5); hold on;
plot(AllData.Date, AllData.IND2Y, 'LineWidth', 1.5);
plot(AllData.Date, AllData.IND10Y,'LineWidth', 1.5);
grid on;
title('India Yield Curve Levels');
legend('3M','2Y','10Y');
saveas(gcf,'India_Yield_Levels.png');

figure;
plot(AllData.Date, AllData.US3M, 'LineWidth', 1.5); hold on;
plot(AllData.Date, AllData.US2Y, 'LineWidth', 1.5);
plot(AllData.Date, AllData.US10Y,'LineWidth', 1.5);
grid on;
title('US Yield Curve Levels');
legend('3M','2Y','10Y');
saveas(gcf,'US_Yield_Levels.png');

% 10.6 Yield Changes

figure;
plot(AllData.Date, AllData.IND3M_chg); hold on;
plot(AllData.Date, AllData.IND2Y_chg);
plot(AllData.Date, AllData.IND10Y_chg);
title('India Yield Changes (Weekly)');
legend('3M','2Y','10Y');
saveas(gcf,'India_Yield_Changes.png');

figure;
plot(AllData.Date, AllData.US3M_chg); hold on;
plot(AllData.Date, AllData.US2Y_chg);
plot(AllData.Date, AllData.US10Y_chg);
title('US Yield Changes (Weekly)');
legend('3M','2Y','10Y');
saveas(gcf,'US_Yield_Changes.png');

%10.7 Garch Volatilities

figure;
plot(AllData.Date, AllData.IND3M_vol); hold on;
plot(AllData.Date, AllData.IND2Y_vol);
plot(AllData.Date, AllData.IND10Y_vol);
title('India Yield Volatility (GARCH)');
legend('3M','2Y','10Y');
grid on;
saveas(gcf,'India_GARCH_Volatility.png');

figure;
plot(AllData.Date, AllData.US3M_vol); hold on;
plot(AllData.Date, AllData.US2Y_vol);
plot(AllData.Date, AllData.US10Y_vol);
title('US Yield Volatility (GARCH)');
legend('3M','2Y','10Y');
grid on;
saveas(gcf,'US_GARCH_Volatility.png');

%% Descriptive Statistics


%% ============================================================
% DESCRIPTIVE STATISTICS FOR WEEKLY FINANCIAL VARIABLES
% Outputs one CSV file: "Descriptive_Statistics.csv"
%% ============================================================

% List of variables to include in descriptive statistics
vars = {
    'IND3M_chg', 'IND2Y_chg', 'IND10Y_chg', ...       % India yield changes
    'US3M_chg',  'US2Y_chg',  'US10Y_chg',  ...       % US yield changes
    'FX_ret', 'NIFTY_ret', 'SPX_ret'                  % FX & Equity returns
};

N = numel(vars);

% Initialize matrix for: Mean, StdDev, Min, Max, Skew, Kurtosis, Obs
Stats = zeros(N, 7);

for i = 1:N
    x = AllData.(vars{i});
    x = x(~isnan(x));     % remove NaN observations
    
    Stats(i,1) = mean(x);        % Mean
    Stats(i,2) = std(x);         % Std. deviation
    Stats(i,3) = min(x);         % Minimum
    Stats(i,4) = max(x);         % Maximum
    Stats(i,5) = skewness(x);    % Skewness
    Stats(i,6) = kurtosis(x);    % Kurtosis
    Stats(i,7) = length(x);      % Number of observations
end

N_values = uint32(Stats(:,7));    % convert to integer
Stats(:,7) = N_values;            % replace column


% Convert to table
StatsTable = array2table(Stats, ...
    'VariableNames', {'Mean','StdDev','Min','Max','Skew','Kurtosis','N'}, ...
    'RowNames', vars);

% Display in MATLAB
disp(StatsTable);

% Save as CSV
writetable(StatsTable, 'Descriptive_Statistics.csv', ...
           'WriteRowNames', true);

fprintf('\nDescriptive_Statistics.csv has been created in your current folder.\n');


%% Save Descriptive Statistics Table as PNG 

% Create a UI figure (required)
f = uifigure('Position',[200 200 1000 400]);

% Display the table
uitable(f, ...
    'Data', StatsTable{:,:}, ...
    'ColumnName', StatsTable.Properties.VariableNames, ...
    'RowName', StatsTable.Properties.RowNames, ...
    'Units','normalized', ...
    'Position',[0 0 1 1]);

% Save as PNG including UI components
exportapp(f, 'Descriptive_Statistics_Table1.png');

fprintf('PNG saved as Descriptive_Statistics_Table.png\n');


writetimetable(AllData, 'Final_Empirical_Data.xlsx');