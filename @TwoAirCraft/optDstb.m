function dOpt = optDstb(obj, t, y, deriv, dMode)

if nargin < 5
    dMode = 'min';
end

if ~(strcmp(dMode, 'max') || strcmp(dMode, 'min'))
  error('dMode must be ''max'' or ''min''!')
end

convertback = false;
if ~iscell(deriv)
    deriv = num2cell(deriv);
    convertback = true;
end

det = deriv{1} * cos(obj.psir) + deriv{2} * sin(obj.psir);

if strcmp(dMode, 'max')
    dOpt = (det>=0) * obj.dRange(2) + (det < 0) * obj.dRange(1);
else
    dOpt = (det>=0) * obj.dRange(1) + (det < 0) * obj.dRange(2);
end

if convertback
    dOpt = cell2mat(dOpt);
end
