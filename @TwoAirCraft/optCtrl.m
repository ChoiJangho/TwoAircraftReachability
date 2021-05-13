function uOpt = optCtrl(obj, t, y, deriv, uMode)

if nargin < 5
    uMode = 'max';
end

if ~(strcmp(uMode, 'max') || strcmp(uMode, 'min'))
  error('uMode must be ''max'' or ''min''!')
end

convertback = false;
if ~iscell(deriv)
  deriv = num2cell(deriv);
  convertback = true;
end

det = -deriv{1};
if strcmp(uMode, 'max')
    uOpt = (det>=0)*obj.uRange(2) + (det<0)*obj.uRange(1);
else
    uOpt = (det>=0)*obj.uRange(1) + (det<0)*obj.uRange(2);
end

if convertback
    uOpt = cell2mat(uOpt)
end
