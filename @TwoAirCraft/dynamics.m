function dx = dynamics(obj, t, x, u, d)
if (obj.mode == 1 || obj.mode == 3)
    if iscell(x)
        dx = cell(obj.nx, 1);
        for i = obj.dims
            switch i
                case 1
                    dx{i} = -u + d * cos(obj.psir);     
                case 2
                    dx{i} = d * sin(obj.psir);
                case 3
                    dx{i} = 0;
                otherwise
                    error("Only dimension 1-3 are defined.")
            end
        end
    elseif isnumeric(x)
        dx = zeros(3, 1);
        dx(1) = -u + d * cos(obj.psir);
        dx(2) = d * sin(obj.psir);
        dx(3) = 0;
    end    
elseif obj.mode == 2
    if iscell(x)
        dx = cell(obj.nx, 1);
        for i = obj.dims
            switch i
                case 1
                    dx{i} = (x{3} >= pi) * 0 + (x{3} < pi) .* (-u + d * cos(obj.psir) + x{2});     
                case 2
                    dx{i} = (x{3} >= pi) * 0 + (x{3} < pi) .* (d * sin(obj.psir) - x{1});
                case 3
                    dx{i} = (x{3} >= pi) * 0 + (x{3} < pi) * obj.omega;
                otherwise
                    error("Only dimension 1-3 are defined.")
            end
        end
    elseif isnumeric(x)
        dx = zeros(3, 1);
        dx(1) = (x(3) >= pi) * 0 + (x(3) < pi) * (-u + d * cos(obj.psir) + x(2));
        dx(2) = (x(3) >= pi) * 0 + (x(3) < pi) * (d * sin(obj.psir) - x(1));
        dx(3) = (x(3) >= pi) * 0 + (x(3) < pi) * obj.omega;
    end
else
    error("Undefined aircraft maneuver mode.");
end