classdef TwoAirCraft < DynSys
    properties
        % Control bounds
        uRange
        dRange

        mode
        omega
        psir
        
        % Active dimensions
        dims
    end
    
    methods
        function obj = TwoAirCraft(x, mode, uRange, dRange, omega, psir, dims)
            if nargin < 1                
                x = [0;0;0];
            elseif isempty(x)
                x = [0;0;0];
            end
            
            if nargin < 2
                mode = 1; % 1, 2, 3
            elseif isempty(mode)
                mode = 1;
            end            
            if nargin < 3
                % Control(speed) bound of the ego aircraft (in Mode 1)
                uRange = [5, 5];
            end
            if nargin < 4                
                % Control(speed) bound of the opponent aircraft (in Mode 1)
                dRange = [5, 5];
            end
            if nargin < 5
                % Angular rate of the aircrafts in mode 2
               omega = 1;
            elseif isempty(omega)
                omega = 1;
            end
            if nargin < 6
                % Relative heading between the two aircraft
                psir = 2*pi/3;
            end
            if nargin < 7
                if mode == 1 || mode == 3
                    dims = 1:2;
                elseif mode == 2
                    dims = 1:3;
                else
                    error("Unknown maneuver mode.")
                end
            end
            obj.x = x;
            obj.mode = mode;
            obj.uRange = uRange;
            obj.dRange = dRange;
            obj.omega = omega;
            obj.psir = psir;
            
            obj.dims = dims;            
            obj.nx = length(dims);
            obj.nu = 1;
            obj.nd = 1;
        end
    end
end