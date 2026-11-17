% Numeric reconstruction of ENVE 404 Term Project 1, Part B (2020).
% Uses the original assignment numeric convention.
% WARNING: year/day labels are not reconciled; do not use as a field model.
% Four calibration observations; three holdout observations at one distance.

years = 1:7;
observed = [2.05 5.15 4.20 3.95 3.00 2.70 2.10];

porosity = 0.30;
decay = 0.20;
velocity = 12;
retardation = 3;
sourceMass = 500;
distance = 60;
dispersion = (365:60:1825)';

spread = dispersion .* years ./ retardation;
offset = distance - velocity .* years ./ retardation;
candidates = sourceMass .* exp(-decay .* years) ./ ...
    (2 .* porosity .* sqrt(pi .* spread)) .* ...
    exp(-(offset .^ 2) ./ (4 .* spread));

calibration = 1:4;
holdout = 5:7;
errors = candidates(:, calibration) - observed(calibration);
[calibrationRMSE, best] = min(sqrt(mean(errors .^ 2, 2)));
modeled = candidates(best, :);
holdoutRMSE = sqrt(mean((modeled(holdout) - observed(holdout)) .^ 2));
fprintf('Calibration RMSE: %.3f\n', calibrationRMSE);
fprintf('Holdout RMSE: %.3f\n', holdoutRMSE);
