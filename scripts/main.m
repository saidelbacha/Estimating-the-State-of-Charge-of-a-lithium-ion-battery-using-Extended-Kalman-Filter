%% ----------------------------
% Input: Work_mode: Mode of working condition 1 --> impulsed current, 2 --> constant current
%                   SOC_est_init: The initial value of estimated SOC      
%% ----------------------------
function main(Work_mode, SoC_est_init)
    if nargin == 0  % Set parameter by default
        Work_mode = 2;
        SoC_est_init = 1;
    elseif nargin == 1
        SoC_est_init = 1;
    end
    if Work_mode == 1
        sim current_generator.slx;
        I = -(current.data)' * 3 / 50;
    elseif Work_mode == 2
        N = 60000;
        I = 3 * ones(1, N);
        I(ceil(N / 9) : ceil(N * 3 / 9)) = 0;
        I(ceil(N * 5 / 9) : ceil(N * 9/10)) = 0;
    else
        disp("Input error!");
        disp("Work_mode: Mode of working condition");
        disp("           1 --> impulsed current  , 2 --> constant current ");
        disp("SOC_est_init : The initial value of estimated SOC");
        return;
    end
    tic;  % start time
    [avr_err_EKF, std_err_EKF] = EKF_Thev(SoC_est_init, I);
    toc;  % end time
    fprintf('Initial SOC : %f\nWorking Mode: %d\n', SoC_est_init, Work_mode);
    fprintf("avr_err_EKF --> %f\n", avr_err_EKF);
    fprintf("standard_err_EKF --> %f\n", std_err_EKF);
end